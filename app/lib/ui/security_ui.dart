import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../core/auto_backup.dart';
import '../core/breaches.dart';
import '../core/security.dart';
import '../core/vault.dart';
import 'auto_backup_ui.dart';
import 'backup_ui.dart';
import 'home.dart';
import 'premium.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

const _window = MethodChannel('tanooki/window');

bool get _isPhone => Platform.isIOS || Platform.isAndroid;

/// Screenshot blocking is on by default on phones, off on computers (it also hides the window from screen sharing).
bool blockScreenshotsOn(Map<String, dynamic> s) => s[blockScreenshotsKey] as bool? ?? _isPhone;

Future<void> applyScreenshotBlocking(bool on) async {
  try {
    await _window.invokeMethod('setSecure', on);
  } on MissingPluginException {
    // Linux / tests: nothing to do.
  }
}

// ---------- "is it you?" before showing a setup key ----------

/// What this device asks for to prove it's you, in the words its owner knows.
String get proofName => Platform.isWindows
    ? l10n.securityUiProofWindows
    : Platform.isMacOS
        ? l10n.securityUiProofMac
        : Platform.isIOS
            ? l10n.securityUiProofIos
            : l10n.securityUiProofOther;

/// Tests replace this to skip the system Face ID / passcode prompt.
@visibleForTesting
Future<bool> Function(BuildContext context, Vault vault, String reason)? confirmItsYouOverride;

/// Asks for the same proof the app's own lock uses before showing a setup key (QR code or export):
/// Face ID / fingerprint / Touch ID / Windows Hello when the app lock is on, else the app passcode,
/// else the device's own lock if it has one. With no lock of any kind there is nothing to ask, just as
/// opening the app asks for nothing. True when it's OK to go ahead.
Future<bool> confirmItsYou(BuildContext context, Vault vault, String reason) async {
  final override = confirmItsYouOverride;
  if (override != null) return override(context, vault, reason);
  final auth = LocalAuthentication();
  Future<bool> device() async {
    try {
      return await auth.authenticate(localizedReason: reason);
    } catch (_) {
      return false;
    }
  }

  if (vault.settings[lockKey] == true) return device();
  if (vault.settings[passcodeKey] != null) return confirmCurrentPasscode(context, vault.settings[passcodeKey]);
  bool supported;
  try {
    supported = await auth.isDeviceSupported();
  } catch (_) {
    supported = false;
  }
  return supported ? device() : true;
}

// ---------- passcode prompts ----------

/// Asks for a new passcode twice. Returns it, or null if cancelled. [notThis] is a hash it must not match
/// (the real passcode when choosing a decoy one, and the other way round).
Future<String?> askNewPasscode(BuildContext context, {required String title, String? intro, Object? notThis}) async {
  final first = TextEditingController(), second = TextEditingController();
  String? error;
  return showDialog<String>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (intro != null) Text(intro),
            PasscodeField(controller: first, label: l10n.securityUiPasscodeAtLeast(minPasscodeLength), autofocus: true),
            PasscodeField(controller: second, label: l10n.securityUiTypeAgain),
            if (error != null)
              Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () async {
              final pin = first.text;
              final problem = passcodeProblem(pin) ?? (pin != second.text ? l10n.securityUiPasscodesDontMatch : null);
              if (problem != null) return setState(() => error = problem);
              if (notThis != null && await verifyPasscode(pin, notThis)) {
                return setState(() => error = l10n.securityUiPickDifferent);
              }
              if (c.mounted) Navigator.pop(c, pin);
            },
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    ),
  );
}

/// Asks for the current passcode before changing anything about it. True if it was right.
Future<bool> confirmCurrentPasscode(BuildContext context, Object? record) async {
  final field = TextEditingController();
  String? error;
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(l10n.securityUiEnterPasscode),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          PasscodeField(controller: field, label: l10n.securityUiPasscode, autofocus: true),
          if (error != null)
            Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () async {
              if (await verifyPasscode(field.text, record)) {
                if (c.mounted) Navigator.pop(c, true);
              } else {
                setState(() => error = l10n.securityUiWrongPasscode);
              }
            },
            child: Text(l10n.commonOk),
          ),
        ],
      ),
    ),
  );
  return ok == true;
}

class PasscodeField extends StatelessWidget {
  const PasscodeField({super.key, required this.controller, required this.label, this.autofocus = false, this.onSubmitted, this.focusNode});
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        obscureText: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(labelText: label),
        onSubmitted: onSubmitted,
      );
}

// ---------- security check-up ----------

class CheckupScreen extends StatefulWidget {
  const CheckupScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<CheckupScreen> createState() => _CheckupScreenState();
}

class _CheckupScreenState extends State<CheckupScreen> {
  @override
  Widget build(BuildContext context) {
    final findings = securityCheckup(widget.vault, DateTime.now());
    Widget item(IconData icon, String title, String body, {String? action, VoidCallback? onAction}) => Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(icon, color: Palette.red),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
              ]),
              const SizedBox(height: 6),
              Text(body),
              if (action != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: onAction, child: Text(action)),
                ),
            ]),
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityUiCheckupTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (findings.isEmpty)
          Card(
            child: ListTile(
              leading: Icon(Icons.verified_user, color: Palette.green),
              title: Text(l10n.securityUiAllGood),
              subtitle: Text(l10n.securityUiAllGoodBody),
            ),
          ),
        for (final f in findings)
          switch (f.issue) {
            CheckupIssue.lockOff => item(Icons.lock_open, l10n.securityUiLockOffTitle, l10n.securityUiLockOffBody),
            CheckupIssue.noPasscode => item(Icons.pin_outlined, l10n.securityUiNoPasscodeTitle, l10n.securityUiNoPasscodeBody),
            CheckupIssue.autoBackupFailed => item(Icons.cloud_off_outlined, l10n.securityUiAutoBackupFailed, autoBackup.failure.value?.message ?? '',
                action: l10n.securityUiOpenAutoBackups, onAction: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => AutoBackupScreen(vault: widget.vault)));
                setState(() {});
              }),
            CheckupIssue.noBackup => item(Icons.save_alt, l10n.securityUiNoBackupTitle, l10n.securityUiNoBackupBody,
                action: l10n.securityUiMakeBackupNow, onAction: () async {
                await exportBackupFlow(context, widget.vault);
                setState(() {});
              }),
            CheckupIssue.noRecoveryCodes => item(
                Icons.key_off_outlined,
                l10n.securityUiNoRecoveryTitle(f.accounts.length),
                l10n.securityUiNoRecoveryBody(f.accounts.map(accountTitle).join(', '))),
          },
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: Text(l10n.securityUiRecoveryKit),
            subtitle: Text(l10n.securityUiRecoveryKitSub),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => RecoveryKitScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
        ),
      ]),
    );
  }
}

// ---------- breach alerts (Premium) ----------

const breachAlertsKey = 'breachAlerts';
const _breachCheckedKey = 'breachCheckedAt';
const _breachSeenKey = 'breachSeen';

/// Fetches the public breach list; returns every match and the ones not shown before. Remembers what it has shown.
Future<(List<BreachMatch>, List<BreachMatch>)> checkBreaches(Vault vault, {BreachFetch? fetch}) async {
  final all = matchBreaches(await (fetch == null ? fetchBreaches() : fetchBreaches(fetch: fetch)), vault.visible);
  final seen = {...(vault.settings[_breachSeenKey] as List? ?? const []).cast<String>()};
  final fresh = all.where((m) => !seen.contains('${m.account.id}:${m.breach.name}')).toList();
  vault.settings[_breachCheckedKey] = DateTime.now().toUtc().toIso8601String();
  vault.settings[_breachSeenKey] = [...seen, for (final m in fresh) '${m.account.id}:${m.breach.name}'];
  await vault.save();
  return (all, fresh);
}

/// On unlock: if alerts are on (and Premium), check at most once a week. Never throws; offline is fine.
Future<void> weeklyBreachCheck(BuildContext context, Vault vault) async {
  if (vault.settings[breachAlertsKey] != true || !premium.value) return;
  final last = DateTime.tryParse(vault.settings[_breachCheckedKey] as String? ?? '');
  if (last != null && DateTime.now().toUtc().difference(last) < const Duration(days: 7)) return;
  try {
    final (_, fresh) = await checkBreaches(vault);
    if (fresh.isNotEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: Text(l10n.securityUiBreachSnack(fresh.map((m) => m.breach.title).toSet().join(', '))),
      ));
    }
  } catch (_) {
    // Offline or the list is down: try again next time the app opens.
  }
}

class BreachScreen extends StatefulWidget {
  const BreachScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<BreachScreen> createState() => _BreachScreenState();
}

class _BreachScreenState extends State<BreachScreen> {
  List<BreachMatch>? _matches;
  String? _error;
  bool _busy = false;

  bool get _on => widget.vault.settings[breachAlertsKey] == true;

  Future<void> _check() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      _matches = (await checkBreaches(widget.vault)).$1;
    } catch (_) {
      _error = l10n.securityUiBreachDownloadFailed;
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _toggle(bool on) async {
    if (on && !premium.value) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
      if (!premium.value) return;
    }
    widget.vault.settings[breachAlertsKey] = on;
    await widget.vault.save();
    setState(() {});
    if (on) await _check();
  }

  @override
  Widget build(BuildContext context) {
    final withSite = widget.vault.visible.where((a) => a.domains.isNotEmpty).length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityUiBreachAlerts)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: SwitchListTile(
            title: Text(premium.value ? l10n.securityUiBreachAlerts : l10n.securityUiBreachAlertsPremium),
            subtitle: Text(l10n.securityUiBreachAlertsSub),
            value: _on,
            onChanged: _toggle,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
              l10n.securityUiBreachHow),
        ),
        if (withSite < widget.vault.visible.length)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
                l10n.securityUiNoWebsite(widget.vault.visible.length - withSite),
                style: TextStyle(color: Palette.muted)),
          ),
        if (_on) ...[
          FilledButton.icon(onPressed: _busy ? null : _check, icon: const Icon(Icons.refresh), label: Text(l10n.securityUiCheckNow)),
          if (_busy) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          if (_error != null) Padding(padding: const EdgeInsets.all(8), child: Text(_error!, style: TextStyle(color: Palette.red))),
          if (_matches != null && _matches!.isEmpty)
            Padding(padding: const EdgeInsets.all(8), child: Text(l10n.securityUiNoBreaches)),
          for (final m in _matches ?? const <BreachMatch>[])
            Card(
              child: ListTile(
                leading: Icon(Icons.report_outlined, color: Palette.red),
                title: Text('${m.breach.title}: ${accountTitle(m.account)}'),
                subtitle: Text(_breachLine(m.breach.breachDate?.toIso8601String().substring(0, 10), m.breach.dataClasses.take(4).join(', '))),
              ),
            ),
        ],
      ]),
    );
  }
}

String _breachLine(String? date, String data) => date == null
    ? (data.isEmpty ? l10n.securityUiBreached : l10n.securityUiBreachedLeaked(data))
    : (data.isEmpty ? l10n.securityUiBreachedOn(date) : l10n.securityUiBreachedOnLeaked(date, data));

// ---------- recovery kit ----------

/// Shown once on first run: the three things that save you if this device is lost.
class RecoveryKitScreen extends StatelessWidget {
  const RecoveryKitScreen({super.key, required this.vault});
  final Vault vault;

  @override
  Widget build(BuildContext context) {
    Widget step(int n, String title, String body, [String? button, VoidCallback? onTap]) => Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$n. $title', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(body),
              if (button != null) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: onTap, child: Text(button))),
            ]),
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityUiRecoveryKit), automaticallyImplyLeading: false),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l10n.securityUiKitIntro),
        const SizedBox(height: 12),
        step(1, l10n.securityUiKitBackupTitle, l10n.securityUiKitBackupBody, l10n.securityUiKitBackupButton, () => exportBackupFlow(context, vault)),
        step(2, l10n.securityUiKitCodesTitle, l10n.securityUiKitCodesBody),
        step(3, l10n.securityUiKitPaperTitle, l10n.securityUiKitPaperBody, l10n.securityUiKitPaperButton, () => paperBackupFlow(context, vault)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.securityUiSkipForNow)),
          const SizedBox(width: 8),
          FilledButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonDone)),
        ]),
      ]),
    );
  }
}
