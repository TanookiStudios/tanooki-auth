import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/auto_backup.dart';
import '../core/breaches.dart';
import '../core/security.dart';
import '../core/vault.dart';
import 'auto_backup_ui.dart';
import 'backup_ui.dart';
import 'home.dart';
import 'premium.dart';
import 'theme.dart';

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
            PasscodeField(controller: first, label: 'Passcode (at least $minPasscodeLength numbers)', autofocus: true),
            PasscodeField(controller: second, label: 'Type it again'),
            if (error != null)
              Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final pin = first.text;
              final problem = passcodeProblem(pin) ?? (pin != second.text ? 'The two passcodes don\'t match.' : null);
              if (problem != null) return setState(() => error = problem);
              if (notThis != null && await verifyPasscode(pin, notThis)) {
                return setState(() => error = 'Pick a different passcode from your other one.');
              }
              if (c.mounted) Navigator.pop(c, pin);
            },
            child: const Text('Save'),
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
        title: const Text('Enter your app passcode'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          PasscodeField(controller: field, label: 'Passcode', autofocus: true),
          if (error != null)
            Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (await verifyPasscode(field.text, record)) {
                if (c.mounted) Navigator.pop(c, true);
              } else {
                setState(() => error = 'That\'s not your passcode.');
              }
            },
            child: const Text('OK'),
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
      appBar: AppBar(title: const Text('Security check-up')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (findings.isEmpty)
          Card(
            child: ListTile(
              leading: Icon(Icons.verified_user, color: Palette.green),
              title: const Text('All good'),
              subtitle: const Text('Your app is locked, you have a recent backup, and every account has recovery codes.'),
            ),
          ),
        for (final f in findings)
          switch (f.issue) {
            CheckupIssue.lockOff => item(Icons.lock_open, 'The app isn\'t locked',
                'Anyone who picks up your unlocked device can see your codes. Turn on "Lock the app" or an app passcode in Settings.'),
            CheckupIssue.noPasscode => item(Icons.pin_outlined, 'No app passcode',
                'A passcode lets you open Tanooki Auth even if Face ID or your fingerprint stops working. Set one in Settings.'),
            CheckupIssue.autoBackupFailed => item(Icons.cloud_off_outlined, 'Automatic backup failed', autoBackup.failure.value?.message ?? '',
                action: 'Open automatic backups', onAction: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => AutoBackupScreen(vault: widget.vault)));
                setState(() {});
              }),
            CheckupIssue.noBackup => item(Icons.save_alt, 'No backup in the last 30 days',
                'If this device is lost or broken, a backup is the only way to get your accounts back.',
                action: 'Make a backup now', onAction: () async {
                await exportBackupFlow(context, widget.vault);
                setState(() {});
              }),
            CheckupIssue.noRecoveryCodes => item(
                Icons.key_off_outlined,
                '${f.accounts.length} ${f.accounts.length == 1 ? 'account has' : 'accounts have'} no recovery codes',
                'Recovery codes get you into a website if you lose this app. Find them in each site\'s security settings, then add them with ⋯ > Recovery codes on the account.\n\n'
                    '${f.accounts.map(accountTitle).join(', ')}'),
          },
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('Your recovery kit'),
            subtitle: const Text('Backup, recovery codes and a paper copy, step by step'),
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
  final all = matchBreaches(await (fetch == null ? fetchBreaches() : fetchBreaches(fetch: fetch)), vault.live);
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
        content: Text('${fresh.map((m) => m.breach.title).toSet().join(', ')} had a data breach. Change your password there.'),
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
      _error = 'Couldn\'t download the breach list. Check your internet connection and try again.';
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
    final withSite = widget.vault.live.where((a) => a.domains.isNotEmpty).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Breach alerts')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: SwitchListTile(
            title: Text(premium.value ? 'Breach alerts' : 'Breach alerts (Premium)'),
            subtitle: const Text('Once a week, tells you if a website you use had a data breach'),
            value: _on,
            onChanged: _toggle,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
              'How it works: Tanooki Auth downloads the public list of known breaches from haveibeenpwned.com and compares it with your saved websites on this device. '
              'Nothing about you or your accounts is sent: it\'s the same download for everyone. '
              'This is the only time the app goes on the internet, apart from sync and buying Premium.'),
        ),
        if (withSite < widget.vault.live.length)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
                '${widget.vault.live.length - withSite} of your accounts have no website saved, so they can\'t be checked. Add one with ⋯ > Edit.',
                style: TextStyle(color: Palette.muted)),
          ),
        if (_on) ...[
          FilledButton.icon(onPressed: _busy ? null : _check, icon: const Icon(Icons.refresh), label: const Text('Check now')),
          if (_busy) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          if (_error != null) Padding(padding: const EdgeInsets.all(8), child: Text(_error!, style: TextStyle(color: Palette.red))),
          if (_matches != null && _matches!.isEmpty)
            const Padding(padding: EdgeInsets.all(8), child: Text('No known breaches for your saved websites.')),
          for (final m in _matches ?? const <BreachMatch>[])
            Card(
              child: ListTile(
                leading: Icon(Icons.report_outlined, color: Palette.red),
                title: Text('${m.breach.title}: ${accountTitle(m.account)}'),
                subtitle: Text(
                    '${m.breach.breachDate == null ? 'Breached' : 'Breached ${m.breach.breachDate!.toIso8601String().substring(0, 10)}'}'
                    '${m.breach.dataClasses.isEmpty ? '' : '. Leaked: ${m.breach.dataClasses.take(4).join(', ')}'}. '
                    'If you made your password before then, change it there.'),
              ),
            ),
        ],
      ]),
    );
  }
}

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
      appBar: AppBar(title: const Text('Your recovery kit'), automaticallyImplyLeading: false),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text(
            'If you lose this device, these are how you get back into your accounts. Each takes a minute. '
            'If you haven\'t added any accounts yet, add them first, then come back here from Settings > Security check-up.'),
        const SizedBox(height: 12),
        step(1, 'Make a backup', 'An encrypted file, locked with a passphrase you choose. Keep it somewhere other than this device, like iCloud Drive, Google Drive, or a USB stick.',
            'Make a backup', () => exportBackupFlow(context, vault)),
        step(2, 'Save your recovery codes', 'When you turn on two-factor login, most websites give you a list of one-time recovery codes. Add them to each account with ⋯ > Recovery codes, so they\'re in your backup too.'),
        step(3, 'Print a paper backup', 'Optional. A printed page of QR codes works even if every device is gone. Keep it locked away: anyone with it can make your codes.',
            'Print paper backup', () => paperBackupFlow(context, vault)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Skip for now')),
          const SizedBox(width: 8),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ]),
      ]),
    );
  }
}
