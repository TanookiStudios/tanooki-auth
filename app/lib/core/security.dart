import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'account.dart';
import 'auto_backup.dart';
import 'vault.dart';
import '../l10n/l10n.dart';

// Keys in vault.settings. The real vault's settings are the only ones the lock screen reads.
const lockKey = 'lock'; // biometric lock on/off (existed before 0.2)
const lockAfterKey = 'lockAfter'; // seconds in the background before locking again
const passcodeKey = 'passcode'; // hash record, never the passcode itself
const decoyPasscodeKey = 'decoyPasscode';
const panicWipeKey = 'panicWipe';
const failedPasscodesKey = 'failedPasscodes';
const lastBackupKey = 'lastBackupAt';
const blockScreenshotsKey = 'blockScreenshots';
const kitShownKey = 'kitShown';

/// Auto-lock choices, in seconds. 30 s matches what the app did before the choice existed.
Map<int, String> get lockAfterChoices =>
    {0: l10n.securityLockImmediately, 30: l10n.securityLockAfter30s, 60: l10n.securityLockAfter1m, 300: l10n.securityLockAfter5m};
int lockAfterSeconds(Map<String, dynamic> s) => s[lockAfterKey] as int? ?? 30;

/// After coming back from the background, lock again if the app was away at least the chosen time.
bool shouldRelock(Map<String, dynamic> s, Duration away) => isLockOn(s) && away.inMilliseconds >= lockAfterSeconds(s) * 1000;

bool isLockOn(Map<String, dynamic> s) => s[lockKey] == true || s[passcodeKey] != null;

// ---------- passcode ----------

const minPasscodeLength = 6;
const _iterations = 120000;

/// Null if [pin] is acceptable, otherwise what's wrong with it in plain words.
String? passcodeProblem(String pin) {
  if (!RegExp(r'^\d+$').hasMatch(pin)) return l10n.securityNumbersOnly;
  if (pin.length < minPasscodeLength) return l10n.securityAtLeastNumbers(minPasscodeLength);
  if (RegExp(r'^(\d)\1+$').hasMatch(pin)) return l10n.securitySameNumber;
  const runs = '01234567890123456789', down = '98765432109876543210';
  if (runs.contains(pin) || down.contains(pin)) return l10n.securityNumbersInRow;
  return null;
}

/// PBKDF2-HMAC-SHA256 with a random salt. The record goes in vault.settings; the passcode never does.
Future<Map<String, Object>> hashPasscode(String pin, {int iterations = _iterations}) async {
  final r = Random.secure();
  final salt = List.generate(16, (_) => r.nextInt(256));
  return {'alg': 'pbkdf2-sha256', 'iter': iterations, 'salt': base64.encode(salt), 'hash': base64.encode(await _derive(pin, salt, iterations))};
}

Future<bool> verifyPasscode(String pin, Object? record) async {
  if (record is! Map) return false;
  final hash = await _derive(pin, base64.decode(record['salt'] as String), record['iter'] as int);
  return _sameBytes(hash, base64.decode(record['hash'] as String));
}

Future<List<int>> _derive(String pin, List<int> salt, int iterations) => Isolate.run(() async =>
    (await Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: iterations, bits: 256).deriveKeyFromPassword(password: pin, nonce: salt))
        .extractBytes());

bool _sameBytes(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

// ---------- unlocking, panic wipe, decoy ----------

/// Wrong passcodes in a row before panic wipe (when it's on) erases everything.
const panicWipeAttempts = 10;

enum Unlock { real, decoy, wrong, wiped }

int failedPasscodes(Map<String, dynamic> s) => s[failedPasscodesKey] as int? ?? 0;

/// Checks [pin] against the real vault's passcode and the decoy passcode. A wrong one is counted in the real
/// vault; with panic wipe on, the [panicWipeAttempts]th wrong one erases the real vault and calls [wipeDecoy].
/// Both hashes are always checked, so the time taken doesn't reveal whether a decoy passcode exists.
Future<Unlock> tryPasscode(Vault real, String pin, {required Future<void> Function() wipeDecoy}) async {
  final s = real.settings;
  final realRecord = s[passcodeKey];
  final decoyRecord = s[decoyPasscodeKey] ?? _dummyRecord(realRecord is Map ? realRecord['iter'] as int : 1000);
  final results = await Future.wait([verifyPasscode(pin, realRecord), verifyPasscode(pin, decoyRecord)]);
  final isReal = results[0], isDecoy = results[1] && s[decoyPasscodeKey] != null;
  if (isReal || isDecoy) {
    if (failedPasscodes(s) != 0) {
      s.remove(failedPasscodesKey);
      await real.save();
    }
    return isReal ? Unlock.real : Unlock.decoy;
  }
  final failed = failedPasscodes(s) + 1;
  if (s[panicWipeKey] == true && failed >= panicWipeAttempts) {
    await real.resetToEmpty();
    await wipeDecoy();
    return Unlock.wiped;
  }
  s[failedPasscodesKey] = failed;
  await real.save();
  return Unlock.wrong;
}

// Same cost as the real check, so a vault without a decoy passcode takes just as long to answer.
Map<String, Object> _dummyRecord(int iterations) => {'alg': 'pbkdf2-sha256', 'iter': iterations, 'salt': base64.encode(List.filled(16, 0)), 'hash': ''};

/// Null if panic wipe may be turned on, otherwise why not, in plain words.
String? panicWipeBlocker(Map<String, dynamic> s, DateTime now) {
  if (s[passcodeKey] == null) return l10n.securityPanicNeedsPasscode;
  if (!backupIsRecent(s, now)) {
    return l10n.securityPanicNeedsBackup;
  }
  return null;
}

bool backupIsRecent(Map<String, dynamic> s, DateTime now) {
  final last = DateTime.tryParse(s[lastBackupKey] as String? ?? '');
  return last != null && now.toUtc().difference(last.toUtc()) <= const Duration(days: 30);
}

// ---------- security check-up ----------

enum CheckupIssue { lockOff, noPasscode, autoBackupFailed, noBackup, noRecoveryCodes }

class CheckupFinding {
  CheckupFinding(this.issue, [this.accounts = const []]);
  final CheckupIssue issue;
  final List<Account> accounts;
}

/// Everything worth fixing, most important first. An empty list means all good.
List<CheckupFinding> securityCheckup(Vault vault, DateTime now) {
  final s = vault.settings;
  final missingCodes = vault.visible.where((a) => a.recoveryCodes.isEmpty).toList();
  return [
    if (!isLockOn(s)) CheckupFinding(CheckupIssue.lockOff),
    if (s[passcodeKey] == null) CheckupFinding(CheckupIssue.noPasscode),
    if (autoBackup.failure.value != null && autoBackup.enabled(vault)) CheckupFinding(CheckupIssue.autoBackupFailed),
    if (!backupIsRecent(s, now)) CheckupFinding(CheckupIssue.noBackup),
    if (missingCodes.isNotEmpty) CheckupFinding(CheckupIssue.noRecoveryCodes, missingCodes),
  ];
}

// ---------- lock on sleep (Mac and Windows) ----------

/// Lock the app when the computer sleeps or its screen locks. On unless turned off, whenever a lock is set.
const lockOnSleepKey = 'lockOnSleep';
bool lockOnSleep(Map<String, dynamic> s) => isLockOn(s) && s[lockOnSleepKey] != false;

// ---------- backup nudge ----------

/// Until when "Not now" hides the backup reminder (ISO time).
const backupNudgeKey = 'backupNudgeUntil';
const backupNudgeSnooze = Duration(days: 7);

/// The newest change to any account, Trash included (moving to Trash or restoring counts as a change).
DateTime? lastAccountChange(Vault v) =>
    v.accounts.isEmpty ? null : v.accounts.map((a) => a.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);

/// Show the "back up your accounts" card: accounts changed since the last backup (by hand or automatic), and it
/// wasn't put off in the last 7 days.
bool showBackupNudge(Vault v, DateTime now) {
  final s = v.settings;
  if (v.live.isEmpty) return false;
  final until = DateTime.tryParse(s[backupNudgeKey] as String? ?? '');
  if (until != null && now.isBefore(until)) return false;
  final last = DateTime.tryParse(s[lastBackupKey] as String? ?? ''), changed = lastAccountChange(v);
  return last == null || (changed != null && changed.isAfter(last));
}

Future<void> snoozeBackupNudge(Vault v, DateTime now) async {
  v.settings[backupNudgeKey] = now.toUtc().add(backupNudgeSnooze).toIso8601String();
  await v.save();
}

// ---------- monthly summary (Premium) ----------

/// The month ("2026-11") whose summary card was closed.
const summaryDismissedKey = 'summaryDismissed';
/// Whether the optional "your summary is ready" notification on the 1st is on.
const summaryNotifyKey = 'summaryNotify';

class MonthlySummary {
  MonthlySummary(this.month, this.newAccounts, this.lastBackup, this.noRecoveryCodes, this.checkupItems);
  /// The month the numbers cover (the one that just ended).
  final DateTime month;
  final int newAccounts;
  final DateTime? lastBackup;
  final int noRecoveryCodes;
  final int checkupItems;
}

String _ym(DateTime t) => '${t.year}-${t.month.toString().padLeft(2, '0')}';

/// The summary card for [now]'s month: shown from the 1st through the 7th (so missing the 1st doesn't lose it)
/// until closed. Null when there's nothing to show.
MonthlySummary? monthlySummary(Vault v, DateTime now, {required bool premium}) {
  if (!premium || now.day > 7 || v.settings[summaryDismissedKey] == _ym(now) || v.live.isEmpty) return null;
  final start = DateTime(now.year, now.month - 1), end = DateTime(now.year, now.month);
  final added = v.live.where((a) => !a.createdAt.toLocal().isBefore(start) && a.createdAt.toLocal().isBefore(end)).length;
  final findings = securityCheckup(v, now);
  final noCodes = findings.where((f) => f.issue == CheckupIssue.noRecoveryCodes).firstOrNull?.accounts.length ?? 0;
  return MonthlySummary(start, added, DateTime.tryParse(v.settings[lastBackupKey] as String? ?? ''), noCodes, findings.length);
}

Future<void> dismissMonthlySummary(Vault v, DateTime now) async {
  v.settings[summaryDismissedKey] = _ym(now);
  await v.save();
}
