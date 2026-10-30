import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../bridge/server.dart';
import '../core/account.dart';
import '../core/clock_check.dart';
import '../core/sync/relay_client.dart' show RelayException;
import '../core/security.dart';
import '../core/spotlight.dart';
import '../core/vault.dart';
import '../core/widget_share.dart';
import '../main.dart' show createDecoyVault, deleteDecoyVault, isDecoyVault;
import 'about_maddie.dart';
import 'app_icon.dart';
import 'auto_backup_ui.dart';
import 'backup_ui.dart';
import 'clipboard.dart';
import 'code_view.dart';
import 'emergency_ui.dart';
import 'export_ui.dart';
import 'home.dart';
import 'premium.dart';
import 'team_ui.dart';
import 'security_extras.dart';
import 'security_ui.dart';
import 'sync_ui.dart' show syncAndLinkSection;
import 'theme.dart';
import 'tidy_ui.dart';
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
    if (appIconsSupported) currentAppIcon(widget.vault).then((id) => mounted ? setState(() => _appIcon = id) : null);
  }

  String _appIcon = 'default';

  Future<void> _pickAppIcon(String id) async {
    if (id == _appIcon) return;
    if (!premium.value) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
      if (!premium.value || !mounted) return setState(() {});
    }
    try {
      await setAppIcon(widget.vault, id);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Couldn\'t change the app icon${e.message == null ? '' : ' (${e.message})'}. Try again, or restart the app.')));
      return;
    }
    if (mounted) setState(() => _appIcon = id);
  }

  Widget _appIconPicker() {
    Widget tile(String id, String name) {
      final selected = _appIcon == id;
      final locked = !premium.value;
      return Semantics(
        button: true,
        selected: selected,
        label: '$name app icon${locked ? ', Premium' : ''}',
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _pickAppIcon(id),
          child: SizedBox(
            width: 72,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? Palette.accent : Colors.transparent, width: 2.5),
                ),
                child: Stack(alignment: Alignment.center, children: [
                  Image.asset(appIconAsset(id), width: 58, height: 58),
                  if (locked && id != 'default') Icon(Icons.lock, size: 16, color: Palette.muted),
                ]),
              ),
              const SizedBox(height: 4),
              Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Palette.text)),
            ]),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(premium.value ? 'App icon' : 'App icon (Premium)', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            Platform.isIOS || Platform.isAndroid
                ? 'The icon on your home screen.${Platform.isAndroid ? ' It may disappear for a moment while your phone swaps it.' : ''}'
                : Platform.isMacOS
                    ? 'Changes the Dock icon while Tanooki Auth is open. Macs can\'t keep a different icon after the app quits, so Finder and Launchpad keep the blue one.'
                    : 'App icons can be changed on iPhone and Android.',
            style: TextStyle(color: Palette.muted, height: 1.4),
          ),
          if (appIconsSupported) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 12, children: [
              for (final e in appIcons.entries) tile(e.key, e.value),
            ]),
          ],
        ]),
      ),
    );
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

  Future<void> _open(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  Future<void> _travelMode(bool on) async {
    if (on && !premium.value) {
      await _open(PremiumScreen(vault: widget.vault));
      if (!premium.value) return;
    }
    if (!mounted || (!on && !await confirmItsYou(context, widget.vault, 'Turn off travel mode'))) return;
    await _set(Vault.travelModeKey, on);
    if (!mounted) return;
    final hidden = widget.vault.live.where((a) => a.travelHidden).length;
    _tell(on
        ? (hidden == 0
            ? 'Travel mode on, but no account is marked "Hide in travel mode" yet. Mark them with ⋯ > Edit first.'
            : 'Travel mode on. $hidden account${hidden == 1 ? ' is' : 's are'} hidden.')
        : 'Travel mode off. Every account is back.');
  }

  Future<void> _monthlyNotify(bool on) async {
    if (on && !premium.value) {
      await _open(PremiumScreen(vault: widget.vault));
      if (!premium.value) return;
    }
    final problem = await setMonthlyNotification(on);
    if (problem != null) return _tell(problem);
    await _set(summaryNotifyKey, on);
  }

  Future<void> _checkClock() async {
    _tell('Checking your clock…');
    try {
      final w = await ClockCheck.instance.runNow();
      if (mounted) _tell(w ?? 'Your clock is right, so that\'s not it. Check the account\'s settings (⋯ > Edit > Advanced) match what the website said.');
    } on RelayException catch (e) {
      if (mounted) _tell('Couldn\'t check the clock: ${e.message}');
    }
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
          if (desktop && !Platform.isLinux) ...[
            const Divider(),
            SwitchListTile(
              title: const Text('Lock when the computer sleeps'),
              subtitle: Text(isLockOn(_s)
                  ? 'Also when the screen locks or you log out for a moment'
                  : 'Turn on the lock or a passcode first'),
              value: lockOnSleep(_s),
              onChanged: (on) => isLockOn(_s) ? _set(lockOnSleepKey, on) : _tell('Turn on "Lock the app" or an app passcode first, so there is something to lock.'),
            ),
          ],
          const Divider(),
          SwitchListTile(
            key: const Key('travelModeSwitch'),
            title: Text(premium.value ? 'Travel mode' : 'Travel mode (Premium)'),
            subtitle: Text(widget.vault.travelMode
                ? 'On. Accounts marked "Hide in travel mode" are gone from this device\'s screens, widgets, watch, extension and exports until you turn it off. They aren\'t deleted.'
                : 'Before a border crossing: hides the accounts you marked "Hide in travel mode" (⋯ > Edit). Turning it off asks for $proofName.'),
            value: widget.vault.travelMode,
            onChanged: _travelMode,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: Text(premium.value ? 'Security keys' : 'Security keys (Premium)'),
            subtitle: const Text('Unlock with a YubiKey or other security key'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(SecurityKeyScreen(vault: widget.vault)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(premium.value ? 'Activity history' : 'Activity history (Premium)'),
            subtitle: const Text('Which codes were copied, filled, typed or exported, and when. Kept on this device only.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(ActivityScreen(vault: widget.vault)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.emergency_outlined),
            title: Text(premium.value ? 'Emergency access' : 'Emergency access (Premium)'),
            subtitle: const Text('Let one trusted person get your accounts if something happens to you, after a 7-day wait you can stop'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(EmergencyScreen(vault: widget.vault)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('Team vault'),
            subtitle: const Text('Share sign-in codes with up to 10 people, end-to-end encrypted'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(TeamScreen(vault: widget.vault)),
          ),
          if (monthlyNotificationSupported) ...[
            const Divider(),
            SwitchListTile(
              title: Text(premium.value ? 'Monthly summary notification' : 'Monthly summary notification (Premium)'),
              subtitle: const Text('A reminder on the 1st of each month to look at your summary card. It never says anything about your accounts.'),
              value: premium.value && _s[summaryNotifyKey] == true,
              onChanged: _monthlyNotify,
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
                : 'Off. When on, the app downloads the public breach list once a week.'),
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
          subtitle: Text(premium.value ? 'Every theme and future Premium feature is yours.' : '$payOnce: every theme, sync across your devices, and more.'),
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
      const SizedBox(height: 10),
      _appIconPicker(),
      const SizedBox(height: 10),
      Card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const ListTile(
            title: Text('Countdown style'),
            subtitle: Text('How the time left on each code is shown'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: SegmentedButton<String>(
              key: const Key('countdownStyle'),
              showSelectedIcon: false,
              segments: [for (final e in countdownChoices.entries) ButtonSegment(value: e.key, label: Text(e.value))],
              selected: {countdownOf(widget.vault.settings)},
              onSelectionChanged: (v) => _set(countdownKey, v.first),
            ),
          ),
          const Divider(),
          SwitchListTile(
            key: const Key('easyFontSwitch'),
            title: const Text('Easy-to-read font'),
            subtitle: const Text('Atkinson Hyperlegible, made by the Braille Institute so letters and numbers are hard to mix up'),
            value: easyFont.value,
            onChanged: (on) async {
              easyFont.value = on;
              await _set(easyFontKey, on);
            },
          ),
        ]),
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
          ListTile(
            leading: const Icon(Icons.sort),
            title: const Text('Sort accounts'),
            subtitle: Text('${sortChoices[sortOf(s)]}. Favorites always come first.'),
            onTap: () async {
              final pick = await showDialog<String>(
                context: context,
                builder: (c) => SimpleDialog(title: const Text('Sort accounts'), children: [
                  for (final e in sortChoices.entries)
                    ListTile(
                      leading: Icon(e.key == sortOf(s) ? Icons.radio_button_checked : Icons.radio_button_off),
                      title: Text(e.value),
                      subtitle: Text(switch (e.key) {
                        'custom' => 'Your own order. Press and hold a card, then drag it.',
                        'recent' => 'Accounts you just copied a code from move to the top',
                        _ => 'By service name',
                      }),
                      onTap: () => Navigator.pop(c, e.key),
                    ),
                ]),
              );
              if (pick != null) await _set(sortKey, pick);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.auto_fix_high),
            title: const Text('Tidy account names'),
            subtitle: const Text('Turns names like "google.com:you@gmail.com" into "Google". You see every change first.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => TidyNamesScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Hide codes until tapped'),
            subtitle: const Text('Shows dots instead of codes, so people nearby can\'t read them'),
            value: s[hideCodesKey] == true,
            onChanged: (on) => _set(hideCodesKey, on),
          ),
          if (Platform.isIOS || Platform.isAndroid) ...[
            const Divider(),
            SwitchListTile(
              title: const Text('Show codes on widgets and watch'),
              subtitle: const Text(
                  'Your favorites\' codes show on your Home Screen, Lock Screen and watch without opening this app, so anyone holding your unlocked phone or your watch can read them. Star an account to make it a favorite.'),
              value: s[shareCodesKey] == true,
              onChanged: (on) => _set(shareCodesKey, on),
            ),
          ],
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

  /// Premium switches: opens the Premium screen first when it isn't unlocked yet.
  Future<void> _setPremium(String key, Object value) async {
    if (!premium.value) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
      if (!premium.value || !mounted) return setState(() {});
    }
    await _set(key, value);
  }

  Future<void> _pickComplication() async {
    final s = widget.vault.settings;
    final favorites = [for (final a in widget.vault.visible) if (a.favorite && a.timeBased && !a.requireAuth) a];
    final pick = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(title: const Text('Watch face favorite'), children: [
        if (favorites.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Text('Star an account on the main list first. Only favorites can go on the watch face.'),
          ),
        for (final a in favorites)
          ListTile(
            leading: Icon(s[complicationKey] == a.id ? Icons.radio_button_checked : Icons.radio_button_off),
            title: Text(accountTitle(a)),
            subtitle: a.issuer.isNotEmpty && a.label.isNotEmpty ? Text(a.label) : null,
            onTap: () => Navigator.pop(c, a.id),
          ),
        ListTile(
          leading: Icon(s[complicationKey] == null ? Icons.radio_button_checked : Icons.radio_button_off),
          title: const Text('None'),
          onTap: () => Navigator.pop(c, ''),
        ),
      ]),
    );
    if (pick == null) return;
    if (pick.isEmpty) {
      setState(() => s.remove(complicationKey));
      await widget.vault.save();
    } else {
      await _setPremium(complicationKey, pick);
    }
  }

  List<Widget> _copyingSection() {
    final s = widget.vault.settings;
    final chosen = widget.vault.visible.where((a) => a.id == s[complicationKey]).firstOrNull;
    return [
      const Padding(padding: EdgeInsets.fromLTRB(4, 0, 4, 8), child: CapsLabel('Copying and shortcuts')),
      Card(
        child: Column(children: [
          SwitchListTile(
            title: const Text('Copy on open'),
            subtitle: const Text(
                'Opening or unlocking the app copies the code of the account you used last. Accounts that ask before showing their code are skipped.'),
            value: s[copyOnOpenKey] == true,
            onChanged: (on) => _set(copyOnOpenKey, on),
          ),
          if (Platform.isMacOS) ...[
            const Divider(),
            SwitchListTile(
              title: const Text('Clear after one paste'),
              subtitle: const Text(
                  'The copied code works for one paste, then the clipboard empties. Clipboard history apps can count as that one paste. On Windows, codes clear after 30 seconds instead.'),
              value: s[pasteOnceKey] == true,
              onChanged: (on) {
                pasteOnce = on;
                _set(pasteOnceKey, on);
              },
            ),
          ],
          if (Platform.isIOS || Platform.isMacOS) ...[
            const Divider(),
            SwitchListTile(
              title: const Text('Show accounts in Spotlight'),
              subtitle: const Text('Search for an account\'s name from anywhere and jump straight to it. Only names are shared, never codes.'),
              value: s[spotlightKey] != false,
              onChanged: (on) => _set(spotlightKey, on),
            ),
          ],
          if (Platform.isIOS) ...[
            const Divider(),
            SwitchListTile(
              title: Text(premium.value ? 'Code on Lock Screen after copying' : 'Code on Lock Screen after copying (Premium)'),
              subtitle: const Text(
                  'After you copy a code, it shows on your Lock Screen and Dynamic Island with a countdown until it expires.'),
              value: premium.value && s[liveActivityKey] == true,
              onChanged: (on) => _setPremium(liveActivityKey, on),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.watch_outlined),
              title: Text(premium.value ? 'Watch face favorite' : 'Watch face favorite (Premium)'),
              subtitle: Text(chosen == null
                  ? 'Pick one favorite whose code shows on your Apple Watch face. Needs "Show codes on widgets and watch" on.'
                  : '${accountTitle(chosen)}. Add the Tanooki Auth complication to your watch face to see it.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickComplication,
            ),
          ],
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
          ..._copyingSection(),
          ...syncAndLinkSection(context, widget.vault, () => setState(() {})),
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
                autoBackupTile(context, widget.vault, () => setState(() {})),
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
                  leading: const Icon(Icons.fact_check_outlined),
                  title: const Text('Test a backup'),
                  subtitle: const Text('Checks a backup file opens with your passphrase. Changes nothing.'),
                  onTap: () => testBackupFlow(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.output),
                  title: const Text('Move to another app'),
                  subtitle: const Text(
                    'Aegis, 2FAS, Google Authenticator, or plain setup links',
                  ),
                  onTap: () => exportToAppFlow(context, widget.vault),
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
                  key: const Key('codesNotWorking'),
                  leading: const Icon(Icons.schedule),
                  title: const Text('Codes not working?'),
                  subtitle: Text(
                    'Device time ${two(now.hour)}:${two(now.minute)}:${two(now.second)}. Codes depend on the clock: tap to check it against the internet.',
                  ),
                  onTap: _checkClock,
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
                      privacyText,
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
