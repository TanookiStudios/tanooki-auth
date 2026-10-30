import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../bridge/server.dart';
import '../core/vault.dart';
import 'about_maddie.dart';
import 'backup_ui.dart';
import 'home.dart';
import 'premium.dart';
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
      const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('Browser extension')),
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
              title: const Text('Paired browser'),
              subtitle: Text('Extension ${origin.substring(origin.length - 8)}'),
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
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Lock the app'),
                  subtitle: Text('Ask for $_lockName when the app opens'),
                  value: widget.vault.settings['lock'] == true,
                  onChanged: _setLock,
                ),
              ],
            ),
          ),
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
                      'No account, no server, no tracking. Your setup keys are stored encrypted on this device and never leave it.',
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
