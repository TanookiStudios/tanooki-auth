// Phase C (security): security-key wrapping, clock check, activity history, travel mode on every surface,
// ask-first accounts, backup nudge, monthly summary and lock on sleep.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/activity.dart';
import 'package:tanooki_auth/core/clock_check.dart';
import 'package:tanooki_auth/core/phone_link.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/security_key.dart';
import 'package:tanooki_auth/core/spotlight.dart';
import 'package:tanooki_auth/core/sync/relay_client.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/core/widget_share.dart';
import 'package:tanooki_auth/ui/clipboard.dart';

import 'vault_test.dart' show MemoryKeyStore;

/// A pretend security key: its PRF output is a fixed function of its own secret and the salt, like a real one.
class FakeKeys implements SecurityKeyPlatform {
  String? why;
  /// The key "plugged in": its secret byte. Touching with a different one is a different key.
  int plugged = 1;
  final made = <String, int>{}; // credential id -> the key it lives on
  bool giveAtRegister = false;

  Uint8List prf(int key, List<int> salt) => Uint8List.fromList([for (var i = 0; i < 32; i++) (key * 31 + salt[i] * 7 + i) & 255]);

  @override
  Future<String?> unavailable() async => why;

  @override
  Future<({String id, Uint8List? prf})> register({required List<int> userId, required String name, required List<int> salt}) async {
    final id = 'cred${made.length}-key$plugged';
    made[id] = plugged;
    return (id: id, prf: giveAtRegister ? prf(plugged, salt) : null);
  }

  @override
  Future<KeyTouch> touch({required List<String> ids, required List<int> salt}) async {
    final id = ids.firstWhere((i) => made[i] == plugged, orElse: () => throw SecurityKeyException(
        'The security key didn\'t answer, or it isn\'t one added here.'));
    return (id: id, prf: prf(plugged, salt));
  }
}

void main() {
  late Directory dir;
  late Vault vault;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('phase_c_test');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 9)));
  });
  tearDown(() {
    activityPremium = () => false;
    dir.deleteSync(recursive: true);
  });

  Account acct(String id, {bool fav = false, DateTime? used}) =>
      Account(id: id, issuer: id, label: '$id@me', secret: 'JBSWY3DPEHPK3PXP', favorite: fav, lastUsedAt: used, domains: ['$id.com'.toLowerCase()]);

  // ------------------------------------------------------------------ 21 security keys

  group('security key', () {
    test('the vault key wrapped with a fake PRF output opens with that output only, and only for its credential', () async {
      final vaultKey = List.generate(32, (i) => i);
      final prf = List.generate(32, (i) => 200 - i);
      final wrapped = await wrapVaultKey(vaultKey, prf, 'cred-a');
      expect(wrapped, isNot(contains(base64.encode(vaultKey))));
      expect(await unwrapVaultKey(wrapped, prf, 'cred-a'), vaultKey);
      final otherPrf = [...prf]..[0] ^= 1;
      await expectLater(unwrapVaultKey(wrapped, otherPrf, 'cred-a'),
          throwsA(isA<SecurityKeyException>().having((e) => e.message, 'm', contains('isn\'t one you added'))));
      await expectLater(unwrapVaultKey(wrapped, prf, 'cred-b'), throwsA(isA<SecurityKeyException>()), reason: 'bound to its credential');
    });

    test('add, unlock, wrong key, removed key, and a key from before a reset', () async {
      final keys = FakeKeys();
      SecurityKeys.platform = keys;
      await vault.save();
      final e = await SecurityKeys.add(vault, ' Blue YubiKey ');
      expect(e.name, 'Blue YubiKey');
      expect(securityKeysOf(vault.settings).single.id, e.id);
      await SecurityKeys.unlock(vault); // no throw: it opens this vault

      // Survives a reload (the salt and wrapped key are saved).
      final again = Vault(vault.file, vault.keyStore);
      await again.load();
      await SecurityKeys.unlock(again);

      keys.plugged = 2; // a different key
      await expectLater(SecurityKeys.unlock(vault), throwsA(isA<SecurityKeyException>()));

      keys.plugged = 1;
      final keyB64 = vault.keyStore as MemoryKeyStore;
      keyB64.value = base64.encode(List.filled(32, 4)); // the vault key changed under it
      await expectLater(SecurityKeys.unlock(vault),
          throwsA(isA<SecurityKeyException>().having((e) => e.message, 'm', contains('before your accounts were reset'))));

      await SecurityKeys.remove(vault, e.id);
      await expectLater(SecurityKeys.unlock(vault),
          throwsA(isA<SecurityKeyException>().having((e) => e.message, 'm', contains('No security key'))));
    });

    test('a key that gives its PRF output when made needs no second touch', () async {
      final keys = FakeKeys()..giveAtRegister = true;
      SecurityKeys.platform = keys;
      await vault.save();
      await SecurityKeys.add(vault, 'Key');
      await SecurityKeys.unlock(vault);
    });

    test('a device that can\'t use keys says so instead of failing quietly', () async {
      SecurityKeys.platform = FakeKeys()..why = 'Not available on this device yet.';
      await vault.save();
      await expectLater(SecurityKeys.add(vault, 'Key'),
          throwsA(isA<SecurityKeyException>().having((e) => e.message, 'm', 'Not available on this device yet.')));
      expect(securityKeysOf(vault.settings), isEmpty);
    });
  });

  // ------------------------------------------------------------------ 22 clock check

  group('clock check', () {
    test('warns only past 30 seconds, in whole minutes', () {
      expect(clockProblem(const Duration(seconds: 30)), isNull);
      expect(clockProblem(const Duration(seconds: -29)), isNull);
      expect(clockProblem(const Duration(seconds: 31)),
          'Your device clock is about 1 minute off, so codes won\'t work. Turn on automatic time in Settings.');
      expect(clockProblem(const Duration(minutes: -7, seconds: -10)), contains('about 7 minutes off'));
    });

    test('measures against the relay\'s /health time, allowing for the round trip', () async {
      final server = await HttpServer.bind('127.0.0.1', 0);
      var asked = 0;
      server.listen((req) {
        asked++;
        expect(req.uri.path, '/health');
        // The server's clock is 5 minutes behind ours.
        final t = DateTime.now().toUtc().subtract(const Duration(minutes: 5)).toIso8601String();
        req.response
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'ok': true, 'time': t}))
          ..close();
      });
      final off = await relayClockOffset(base: 'http://127.0.0.1:${server.port}');
      expect(off.inSeconds, inInclusiveRange(299, 301));
      expect(asked, 1);
      await server.close(force: true);
    });

    test('runs at most hourly, only when switched on, and offline is quiet', () async {
      var calls = 0;
      var offset = const Duration(minutes: 3);
      final c = ClockCheck(measure: () async {
        calls++;
        if (offset == Duration.zero) throw RelayException(0, 'offline');
        return offset;
      });
      final t = DateTime(2026, 11, 1, 9);
      await c.maybeRun(now: t);
      expect(calls, 0, reason: 'off until the app turns it on');
      c.auto = true;
      await c.maybeRun(now: t);
      expect(calls, 1);
      expect(c.warning.value, contains('about 3 minutes off'));
      await c.maybeRun(now: t.add(const Duration(minutes: 59)));
      expect(calls, 1, reason: 'not again within the hour');
      offset = Duration.zero;
      await c.maybeRun(now: t.add(const Duration(minutes: 61)));
      expect(calls, 2);
      expect(c.warning.value, contains('3 minutes'), reason: 'offline keeps the last answer, no crash');
      offset = const Duration(seconds: 2);
      expect(await c.runNow(), isNull, reason: '"Codes not working?" runs any time');
      expect(c.warning.value, isNull);
    });
  });

  // ------------------------------------------------------------------ 23 activity history

  group('activity history', () {
    test('recorded only with Premium, newest first, capped at 500, clearable', () async {
      logActivity(vault, ActivityKind.copied, accountId: 'a', where: 'This app');
      expect(activityOf(vault), isEmpty, reason: 'free: nothing recorded');
      activityPremium = () => true;
      final t = DateTime.utc(2026, 11, 1);
      for (var i = 0; i < 505; i++) {
        logActivity(vault, ActivityKind.values[i % ActivityKind.values.length], accountId: '$i', where: 'w$i', now: t.add(Duration(minutes: i)));
      }
      final list = activityOf(vault);
      expect(list, hasLength(maxActivity));
      expect((list.first.accountId, list.first.where), ('504', 'w504'));
      expect(list.last.accountId, '5', reason: 'the oldest 5 fell off');
      await vault.save();
      final again = Vault(vault.file, vault.keyStore);
      await again.load();
      expect(activityOf(again).first.time, t.add(const Duration(minutes: 504)));
      await clearActivity(again);
      expect(activityOf(again), isEmpty);
    });
  });

  // ------------------------------------------------------------------ 25 travel mode, one test per surface

  group('travel mode hides marked accounts from', () {
    late Account hidden, shown;
    setUp(() {
      hidden = acct('Bank', fav: true, used: DateTime.utc(2026, 11, 2))..travelHidden = true;
      shown = acct('Game', fav: true, used: DateTime.utc(2026, 11, 1));
      vault.accounts.addAll([hidden, shown]);
      vault.settings[shareCodesKey] = true;
      vault.settings[copyOnOpenKey] = true;
      vault.settings[liveActivityKey] = true;
      vault.settings[complicationKey] = hidden.id;
    });

    void both(void Function(bool on) check) {
      check(false);
      vault.settings[Vault.travelModeKey] = true;
      check(true);
    }

    test('the list, search and Quick pick (Vault.visible, homeOrder)', () => both((on) {
          expect(vault.visible.contains(hidden), !on);
          expect(homeOrder(vault.visible).map((a) => a.id), on ? ['Game'] : ['Bank', 'Game']);
          expect(vault.live, contains(hidden), reason: 'never deleted');
        }));

    test('widgets, watch and the complication (sharedFavorites)', () => both((on) {
          final favs = sharedFavorites(vault, premium: true);
          expect(favs.map((f) => f['issuer']), on ? ['Game'] : ['Bank', 'Game']);
          expect(favs.any((f) => f['complication'] == true), !on);
        }));

    test('Spotlight (spotlightItems)', () => both((on) => expect(spotlightItems(vault).map((i) => i['id']), on ? ['Game'] : ['Bank', 'Game'])));

    test('the Lock Screen Live Activity (liveActivityAllowed)', () => both((on) => expect(liveActivityAllowed(vault, hidden, premium: true), !on)));

    test('copy on open (copyOnOpenPick)', () => both((on) => expect(copyOnOpenPick(vault)!.id, on ? 'Game' : 'Bank')));

    test('phone link approvals (accountsForHost over Vault.visible)', () => both((on) => expect(accountsForHost(vault.visible, 'bank.com'), on ? isEmpty : [hidden])));

    test('the security check-up (securityCheckup)', () => both((on) {
          final missing = securityCheckup(vault, DateTime.now()).firstWhere((f) => f.issue == CheckupIssue.noRecoveryCodes).accounts;
          expect(missing.contains(hidden), !on);
        }));

    test('Trash (Vault.trash)', () => both((on) {
          hidden.deletedAt = DateTime.now().toUtc();
          expect(vault.trash.contains(hidden), !on);
          hidden.deletedAt = null;
        }));

    test('exports (every export reads Vault.visible) but sync and auto backups keep them', () => both((on) {
          expect(vault.visible.length, on ? 1 : 2);
          expect(vault.live.length, 2, reason: 'auto backup and the emergency copy use live, so nothing is lost');
        }));
  });

  // ------------------------------------------------------------------ 24 ask-first accounts

  test('ask-first accounts never reach widgets, the watch or the Live Activity', () {
    final a = acct('Bank', fav: true)..requireAuth = true;
    vault.accounts.addAll([a, acct('Game', fav: true)]);
    vault.settings[shareCodesKey] = true;
    vault.settings[liveActivityKey] = true;
    expect(sharedFavorites(vault, premium: true).map((f) => f['issuer']), ['Game']);
    expect(liveActivityAllowed(vault, a, premium: true), isFalse);
    expect(liveActivityAllowed(vault, vault.accounts[1], premium: true), isTrue);
    expect(liveActivityAllowed(vault, vault.accounts[1], premium: false), isFalse);
  });

  // ------------------------------------------------------------------ 29 backup nudge

  test('backup nudge: after changes since the last backup, put off for 7 days by "Not now"', () async {
    final now = DateTime.utc(2026, 11, 10, 12);
    expect(showBackupNudge(vault, now), isFalse, reason: 'no accounts, nothing to back up');
    vault.accounts.add(Account(id: 'a', issuer: 'A', secret: 'JBSWY3DPEHPK3PXP', createdAt: now.subtract(const Duration(days: 3))));
    expect(showBackupNudge(vault, now), isTrue, reason: 'never backed up');
    vault.settings[lastBackupKey] = now.subtract(const Duration(days: 1)).toIso8601String();
    expect(showBackupNudge(vault, now), isFalse, reason: 'backed up after the last change');
    vault.accounts.single.updatedAt = now.subtract(const Duration(hours: 1));
    expect(showBackupNudge(vault, now), isTrue, reason: 'changed since');
    await snoozeBackupNudge(vault, now);
    expect(showBackupNudge(vault, now.add(const Duration(days: 6, hours: 23))), isFalse);
    expect(showBackupNudge(vault, now.add(const Duration(days: 7, minutes: 1))), isTrue);
  });

  // ------------------------------------------------------------------ 30 monthly summary

  test('monthly summary: Premium, the first week of the month, until closed; counts last month', () async {
    final nov1 = DateTime(2026, 11, 1, 9);
    vault.accounts.addAll([
      Account(id: 'old', issuer: 'Old', secret: 'JBSWY3DPEHPK3PXP', createdAt: DateTime(2026, 9, 5), recoveryCodes: [RecoveryCode('x')]),
      Account(id: 'oct1', issuer: 'New1', secret: 'JBSWY3DPEHPK3PXP', createdAt: DateTime(2026, 10, 1, 0, 30)),
      Account(id: 'oct2', issuer: 'New2', secret: 'JBSWY3DPEHPK3PXP', createdAt: DateTime(2026, 10, 31, 23)),
      Account(id: 'nov', issuer: 'Nov', secret: 'JBSWY3DPEHPK3PXP', createdAt: DateTime(2026, 11, 1, 8), recoveryCodes: [RecoveryCode('y')]),
    ]);
    expect(monthlySummary(vault, nov1, premium: false), isNull);
    expect(monthlySummary(vault, DateTime(2026, 11, 8), premium: true), isNull, reason: 'only the first 7 days');
    final s = monthlySummary(vault, nov1, premium: true)!;
    expect((s.month, s.newAccounts, s.lastBackup, s.noRecoveryCodes), (DateTime(2026, 10), 2, null, 2));
    expect(s.checkupItems, greaterThanOrEqualTo(3), reason: 'lock off, no passcode, no backup, missing recovery codes');
    await dismissMonthlySummary(vault, nov1);
    expect(monthlySummary(vault, DateTime(2026, 11, 3), premium: true), isNull, reason: 'closed for November');
    expect(monthlySummary(vault, DateTime(2026, 12, 1), premium: true), isNotNull, reason: 'back next month');
  });

  // ------------------------------------------------------------------ 28 lock on sleep

  test('lock on sleep is on by default once a lock is set, and can be turned off', () {
    final s = <String, dynamic>{};
    expect(lockOnSleep(s), isFalse, reason: 'nothing to lock');
    s[lockKey] = true;
    expect(lockOnSleep(s), isTrue);
    s[lockOnSleepKey] = false;
    expect(lockOnSleep(s), isFalse);
  });
}
