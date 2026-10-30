import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../bridge/server.dart';
import '../core/security.dart';
import '../core/vault.dart';
import '../main.dart' show createDecoyVault, deleteDecoyVault, isDecoyVault;
import 'about_maddie.dart';
import 'backup_ui.dart';
import 'home.dart';
import 'premium.dart';
import 'security_ui.dart';
import 'theme.dart';
import 'trash.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = LocalAuthentication();
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  String get _lockName => Platform.isWindows
      ? 'Windows Hello'
      : Platform.isMacOS
      ? 'Touch ID or your Mac password'
      : 'Face ID, fingerprint, or passcode';

  Future<void> _setLock(bool on) async {
    if (on && !await _auth.isDeviceSupported()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This device has no $_lockName set up, so the app can\'t be locked. Set one up in your system settings first.',
          ),
        ),
      );
      return;
    }
    // Prove the user can unlock before turning it on, so they can't lock themselves out.
    bool ok;
    try {
      ok = await _auth.authenticate(
        localizedReason: on ? 'Turn on the app lock' : 'Turn off the app lock',
      );
    } catch (_) {
      ok = false;
    }
    if (!ok) return;
    widget.vault.settings['lock'] = on;
    await widget.vault.save();
    setState(() {});
  }

  Map<String, dynamic> get _s => widget.vault.settings;

  void _tell(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _passcode() async {
    final v = widget.vault;
    if (_s[passcodeKey] == null) {
      final pin = await askNewPasscode(context,
          title: 'Set an app passcode',
          intro: 'Type this to open Tanooki Auth. It also works when Face ID or your fingerprint doesn\'t. If you forget it, the only way back in is a backup.');
      if (pin == null) return;
      _s[passcodeKey] = await hashPasscode(pin);
      await v.save();
      setState(() {});
      _tell('App passcode on.');
      return;
    }
    final choice = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(title: const Text('App passcode'), children: [
        SimpleDialogOption(onPressed: () => Navigator.pop(c, 'change'), child: const Text('Change passcode')),
        SimpleDialogOption(onPressed: () => Navigator.pop(c, 'off'), child: const Text('Turn passcode off')),
      ]),
    );
    if (choice == null || !mounted || !await confirmCurrentPasscode(context, _s[passcodeKey]) || !mounted) return;
    if (choice == 'change') {
      final pin = await askNewPasscode(context, title: 'New app passcode', notThis: _s[decoyPasscodeKey]);
      if (pin == null) return;
      _s[passcodeKey] = await hashPasscode(pin);
    } else {
      // Panic wipe and the decoy passcode both depend on the passcode, so they go with it.
      _s
        ..remove(passcodeKey)
        ..remove(panicWipeKey)
        ..remove(failedPasscodesKey);
      await _removeDecoy();
    }
    await v.save();
    setState(() {});
    _tell(choice == 'change' ? 'Passcode changed.' : 'App passcode off.');
  }

  Future<void> _removeDecoy() async {
    if (_s.remove(decoyPasscodeKey) != null && !isDecoyVault(widget.vault)) await deleteDecoyVault();
  }

  Future<void> _decoy() async {
    if (_s[decoyPasscodeKey] != null) {
      final off = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Remove the decoy passcode?'),
          content: const Text('The decoy accounts are erased. Your real accounts aren\'t touched.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Remove')),
          ],
        ),
      );
      if (off != true || !mounted || !await confirmCurrentPasscode(context, _s[passcodeKey])) return;
      await _removeDecoy();
      await widget.vault.save();
      setState(() {});
      return;
    }
    final pin = await askNewPasscode(context,
        title: 'Set a decoy passcode',
        intro: 'If someone forces you to open Tanooki Auth, type this one instead. It opens a separate, empty set of accounts, and nothing on screen shows it isn\'t the real one. Add a couple of harmless accounts there so it looks used.\n\nYour real passcode keeps opening your real accounts.',
        notThis: _s[passcodeKey]);
    if (pin == null) return;
    await createDecoyVault(widget.vault, await hashPasscode(pin));
    setState(() {});
    _tell('Decoy passcode set.');
  }

  Future<void> _panicWipe(bool on) async {
    if (!on) {
      _s.remove(panicWipeKey);
      await widget.vault.save();
      return setState(() {});
    }
    final blocker = panicWipeBlocker(_s, DateTime.now());
    if (blocker != null) return _tell(blocker);
    Future<bool> warn(String title, String body, String yes) async =>
        await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
                onPressed: () => Navigator.pop(c, true),
                child: Text(yes),
              ),
            ],
          ),
        ) ==
        true;
    if (!await warn('Erase everything after $panicWipeAttempts wrong passcodes?',
        'If anyone types the wrong app passcode $panicWipeAttempts times in a row, Tanooki Auth erases every account on this device. There is no undo and no way to stop it once it starts.',
        'Continue')) {
      return;
    }
    if (!mounted ||
        !await warn('Are you sure?',
            'A child playing with your phone, or you on a bad day, can trigger this. After an erase, the only way back is your backup file. Without it you could be locked out of every website that uses these codes.',
            'Turn on panic wipe')) {
      return;
    }
    _s[panicWipeKey] = true;
    await widget.vault.save();
    setState(() {});
  }

  Future<void> _blockScreenshots(bool on) async {
    await applyScreenshotBlocking(on);
    await _set(blockScreenshotsKey, on);
  }

  List<Widget> _securitySection() {
    final hasPasscode = _s[passcodeKey] != null;
    final desktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    return [
      Card(
        child: Column(children: [
          SwitchListTile(
            title: const Text('Lock the app'),
            subtitle: Text('Ask for $_lockName when the app opens'),
            value: _s['lock'] == true,
            onChanged: _setLock,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.pin_outlined),
            title: const Text('App passcode'),
            subtitle: Text(hasPasscode ? 'On. Tap to change or turn off.' : 'Off. Numbers you type to open the app, instead of or as well as $_lockName.'),
            onTap: _passcode,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Lock again'),
            subtitle: Text(isLockOn(_s)
                ? '${lockAfterChoices[lockAfterSeconds(_s)]} in the background'
                : 'Turn on the lock or a passcode first'),
            trailing: DropdownButton<int>(
              value: lockAfterSeconds(_s),
              onChanged: (v) => v == null ? null : _set(lockAfterKey, v),
              items: [for (final e in lockAfterChoices.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
            ),
          ),
          if (hasPasscode) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.theater_comedy_outlined),
              title: const Text('Decoy passcode'),
              subtitle: Text(_s[decoyPasscodeKey] != null
                  ? 'On. Opens a separate set of accounts. Tap to remove.'
                  : 'A second passcode that opens a separate, empty set of accounts'),
              onTap: _decoy,
            ),
            const Divider(),
            SwitchListTile(
              title: Text('Erase after $panicWipeAttempts wrong passcodes'),
              subtitle: const Text('Panic wipe. Needs a backup made in the last 30 days.'),
              value: _s[panicWipeKey] == true,
              onChanged: _panicWipe,
            ),
          ],
          const Divider(),
          SwitchListTile(
            title: const Text('Block screenshots'),
            subtitle: Text(desktop
                ? 'Hides this window from screenshots, screen recording and screen sharing'
                : 'Keeps codes out of screenshots, screen recording and the app switcher'),
            value: blockScreenshotsOn(_s),
            onChanged: _blockScreenshots,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.health_and_safety_outlined),
            title: const Text('Security check-up'),
            subtitle: const Text('Things worth fixing, and your recovery kit'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => CheckupScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.report_gmailerrorred_outlined),
            title: Text(premium.value ? 'Breach alerts' : 'Breach alerts (Premium)'),
            subtitle: Text(_s[breachAlertsKey] == true
                ? 'On. Checks the public breach list weekly.'
                : 'Off. When on, this is the app\'s only internet use besides sync and purchases.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => BreachScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
        ]),
      ),
    ];
  }

  Future<void> _pickTheme(String id) async {
    if (!freeThemes.contains(id) && !premium.value) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
      if (!premium.value) return;
    }
    widget.vault.settings['theme'] = id;
    await widget.vault.save();
    themeChoice.value = id;
  }

  List<Widget> _premiumAndAppearance() {
    Widget swatch(String id, AppPalette? p) {
      final selected = themeChoice.value == id;
      final locked = !freeThemes.contains(id) && !premium.value;
      final bg = p?.background ?? darkPalette.background;
      return Semantics(
        button: true,
        selected: selected,
        label: '${p?.name ?? 'Auto'} theme${locked ? ', Premium' : ''}',
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _pickTheme(id),
          child: SizedBox(
            width: 84,
            child: Column(children: [
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: selected ? Palette.accent : Palette.line, width: selected ? 2.5 : 1),
                  gradient: p == null
                      ? LinearGradient(colors: [lightPalette.background, lightPalette.background, darkPalette.background, darkPalette.background], stops: const [0, .5, .5, 1])
                      : null,
                  color: p == null ? null : bg,
                ),
                alignment: Alignment.center,
                child: locked
                    ? Icon(Icons.lock, size: 16, color: p!.muted)
                    : Container(width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle, color: (p ?? darkPalette).accent)),
              ),
              const SizedBox(height: 6),
              Text(p?.name ?? 'Auto', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Palette.text)),
            ]),
          ),
        ),
      );
    }

    return [
      Card(
        child: ListTile(
          leading: Icon(premium.value ? Icons.workspace_premium : Icons.workspace_premium_outlined, color: Palette.accent),
          title: Text(premium.value ? 'Premium: thank you!' : 'Get Premium'),
          subtitle: Text(premium.value ? 'Every theme and future Premium feature is yours.' : '\$5 once: every theme, cloud sync when it arrives, and more.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
            setState(() {});
          },
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('Appearance')),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Wrap(spacing: 10, runSpacing: 14, children: [
            for (final e in themeChoices.entries) swatch(e.key, e.value),
          ]),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }

  Future<void> _set(String key, Object value) async {
    setState(() => widget.vault.settings[key] = value);
    await widget.vault.save();
  }

  List<Widget> _listSection() {
    final s = widget.vault.settings;
    final trashed = widget.vault.trash.length;
    return [
      const Padding(padding: EdgeInsets.fromLTRB(4, 0, 4, 8), child: CapsLabel('Accounts list')),
      Card(
        child: Column(children: [
          SwitchListTile(
            title: const Text('Compact cards'),
            subtitle: const Text('Smaller cards, so more accounts fit on screen'),
            value: s[layoutKey] == 'compact',
            onChanged: (on) => _set(layoutKey, on ? 'compact' : 'roomy'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Recently used first'),
            subtitle: const Text('Accounts you just copied a code from move to the top, under your favorites'),
            value: s[recentFirstKey] == true,
            onChanged: (on) => _set(recentFirstKey, on),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Hide codes until tapped'),
            subtitle: const Text('Shows dots instead of codes, so people nearby can\'t read them'),
            value: s[hideCodesKey] == true,
            onChanged: (on) => _set(hideCodesKey, on),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(trashed == 0 ? 'Trash' : 'Trash ($trashed)'),
            subtitle: const Text('Deleted accounts stay here for 30 days'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => TrashScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
        ]),
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> _browserSection() {
    final b = activeBridge;
    final paired = b?.pairedOrigins ?? [];
    return [
      const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('Browser extension and launchers')),
      Card(
        child: Column(children: [
          ListTile(
            leading: Icon(b == null ? Icons.link_off : Icons.link, color: b == null ? Palette.red : Palette.green),
            title: Text(b == null ? 'Not running' : 'Ready for the browser extension'),
            subtitle: Text(b == null
                ? 'Ports ${bridgePorts.first}–${bridgePorts.last} are all in use by other programs, so the extension can\'t connect. Restart your computer and try again.'
                : 'Listening on this computer only (127.0.0.1:${b.port}). Works while Tanooki Auth is open.'),
          ),
          for (final origin in paired) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.extension_outlined),
              title: Text(integrationOrigins.contains(origin) ? 'Paired: ${bridgeClientName(origin)}' : 'Paired browser'),
              subtitle: integrationOrigins.contains(origin) ? null : Text('Extension ${origin.substring(origin.length - 8)}'),
              trailing: TextButton(
                onPressed: () async {
                  await b!.unpair(origin);
                  setState(() {});
                },
                child: const Text('Unpair'),
              ),
            ),
          ],
        ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._premiumAndAppearance(),
          ..._listSection(),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: CapsLabel('Security'),
          ),
          ..._securitySection(),
          if (Platform.isMacOS || Platform.isWindows) ..._browserSection(),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: CapsLabel('Backup'),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: const Text('Export backup'),
                  subtitle: const Text(
                    'An encrypted file, locked with a passphrase you choose',
                  ),
                  onTap: () => exportBackupFlow(context, widget.vault),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('Import backup'),
                  subtitle: const Text(
                    'Adds accounts from a backup file; skips ones you already have',
                  ),
                  onTap: () async {
                    await importBackupFlow(context, widget.vault);
                    setState(() {});
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.text_snippet_outlined),
                  title: const Text('Export as plain text'),
                  subtitle: const Text(
                    'Unencrypted setup links, for moving to another app',
                  ),
                  onTap: () => exportPlainFlow(context, widget.vault),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.print_outlined),
                  title: const Text('Print paper backup'),
                  subtitle: const Text('A PDF of QR codes and recovery codes to keep somewhere locked'),
                  onTap: () => paperBackupFlow(context, widget.vault),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: CapsLabel('About'),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text('About Maddie'),
                  subtitle: const Text('A note from the person who makes Tanooki Auth'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutMaddieScreen()),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    'Device time ${two(now.hour)}:${two(now.minute)}:${two(now.second)}',
                  ),
                  subtitle: const Text(
                    'Codes rejected? Codes depend on the clock. Make sure your device sets its time automatically.',
                  ),
                ),
                const Divider(),
                const AboutListTile(
                  icon: Icon(Icons.info_outline),
                  applicationName: 'Tanooki Auth',
                  applicationVersion: appVersion,
                  applicationLegalese: '© 2026 Tanooki Studios',
                  aboutBoxChildren: [
                    SizedBox(height: 12),
                    Text(
                      'No account, no tracking. Your setup keys are stored encrypted on this device and never leave it. The app only goes online if you turn on breach alerts (to download the public breach list) or sync, or to buy Premium.',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
