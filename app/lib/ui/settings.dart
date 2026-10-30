import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../bridge/server.dart';
import '../core/account.dart';
import '../core/clock_check.dart';
import '../core/guides.dart' show guidesIndexUrl;
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
import 'help.dart';
import 'home.dart';
import 'premium.dart';
import 'team_ui.dart';
import 'security_extras.dart';
import 'security_ui.dart';
import 'sync_ui.dart' show syncAndLinkSection;
import 'theme.dart';
import 'tidy_ui.dart';
import 'trash.dart';
import '../l10n/l10n.dart';

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
          content: Text(e.message == null ? l10n.settingsIconFailed : l10n.settingsIconFailedWhy(e.message!))));
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
        label: locked ? l10n.settingsIconSemanticPremium(name) : l10n.settingsIconSemantic(name),
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
          Text(premium.value ? l10n.settingsAppIcon : l10n.settingsAppIconPremium, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            Platform.isIOS || Platform.isAndroid
                ? (Platform.isAndroid ? l10n.settingsAppIconAndroid : l10n.settingsAppIconIos)
                : Platform.isMacOS
                    ? l10n.settingsAppIconMac
                    : l10n.settingsAppIconOther,
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
      ? l10n.settingsLockNameMac
      : l10n.settingsLockNamePhone;

  Future<void> _setLock(bool on) async {
    if (on && !await _auth.isDeviceSupported()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsNoLockSetUp(_lockName),
          ),
        ),
      );
      return;
    }
    // Prove the user can unlock before turning it on, so they can't lock themselves out.
    bool ok;
    try {
      ok = await _auth.authenticate(
        localizedReason: on ? l10n.settingsLockReasonOn : l10n.settingsLockReasonOff,
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
          title: l10n.settingsSetPasscode,
          intro: l10n.settingsSetPasscodeIntro);
      if (pin == null) return;
      _s[passcodeKey] = await hashPasscode(pin);
      await v.save();
      setState(() {});
      _tell(l10n.settingsPasscodeOn);
      return;
    }
    final choice = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(title: Text(l10n.settingsPasscode), children: [
        SimpleDialogOption(onPressed: () => Navigator.pop(c, 'change'), child: Text(l10n.settingsChangePasscode)),
        SimpleDialogOption(onPressed: () => Navigator.pop(c, 'off'), child: Text(l10n.settingsPasscodeOff)),
      ]),
    );
    if (choice == null || !mounted || !await confirmCurrentPasscode(context, _s[passcodeKey]) || !mounted) return;
    if (choice == 'change') {
      final pin = await askNewPasscode(context, title: l10n.settingsNewPasscode, notThis: _s[decoyPasscodeKey]);
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
    _tell(choice == 'change' ? l10n.settingsPasscodeChanged : l10n.settingsPasscodeIsOff);
  }

  Future<void> _removeDecoy() async {
    if (_s.remove(decoyPasscodeKey) != null && !isDecoyVault(widget.vault)) await deleteDecoyVault();
  }

  Future<void> _decoy() async {
    if (_s[decoyPasscodeKey] != null) {
      final off = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.settingsRemoveDecoyTitle),
          content: Text(l10n.settingsRemoveDecoyBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonRemove)),
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
        title: l10n.settingsSetDecoy,
        intro: l10n.settingsSetDecoyIntro,
        notThis: _s[passcodeKey]);
    if (pin == null) return;
    await createDecoyVault(widget.vault, await hashPasscode(pin));
    setState(() {});
    _tell(l10n.settingsDecoySet);
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
              TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
                onPressed: () => Navigator.pop(c, true),
                child: Text(yes),
              ),
            ],
          ),
        ) ==
        true;
    if (!await warn(l10n.settingsWipeTitle(panicWipeAttempts), l10n.settingsWipeBody(panicWipeAttempts), l10n.commonContinueLabel)) {
      return;
    }
    if (!mounted ||
        !await warn(l10n.settingsWipeSureTitle, l10n.settingsWipeSureBody, l10n.settingsWipeTurnOn)) {
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
    if (!mounted || (!on && !await confirmItsYou(context, widget.vault, l10n.settingsTravelOffReason))) return;
    await _set(Vault.travelModeKey, on);
    if (!mounted) return;
    final hidden = widget.vault.live.where((a) => a.travelHidden).length;
    _tell(on
        ? (hidden == 0 ? l10n.settingsTravelOnNone : l10n.settingsTravelOn(hidden))
        : l10n.settingsTravelOff);
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
    _tell(l10n.settingsCheckingClock);
    try {
      final w = await ClockCheck.instance.runNow();
      if (mounted) _tell(w ?? l10n.settingsClockRight);
    } on RelayException catch (e) {
      if (mounted) _tell(l10n.settingsClockFailed(e.message));
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
            title: Text(l10n.settingsLockApp),
            subtitle: Text(l10n.settingsLockAppHelp(_lockName)),
            value: _s['lock'] == true,
            onChanged: _setLock,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.pin_outlined),
            title: Text(l10n.settingsPasscode),
            subtitle: Text(hasPasscode ? l10n.settingsPasscodeOnHelp : l10n.settingsPasscodeOffHelp(_lockName)),
            onTap: _passcode,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l10n.settingsLockAgain),
            // The picker sits under the text, not beside it, so long words and large text still fit a phone.
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(isLockOn(_s)
                  ? l10n.settingsLockAgainHelp(lockAfterChoices[lockAfterSeconds(_s)] ?? '')
                  : l10n.settingsLockFirst),
              DropdownButton<int>(
                isExpanded: true, // long choices wrap to the tile's width
                value: lockAfterSeconds(_s),
                onChanged: (v) => v == null ? null : _set(lockAfterKey, v),
                items: [for (final e in lockAfterChoices.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
              ),
            ]),
          ),
          if (hasPasscode) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.theater_comedy_outlined),
              title: Text(l10n.settingsDecoy),
              subtitle: Text(_s[decoyPasscodeKey] != null ? l10n.settingsDecoyOn : l10n.settingsDecoyOff),
              onTap: _decoy,
            ),
            const Divider(),
            SwitchListTile(
              title: Text(l10n.settingsWipe(panicWipeAttempts)),
              subtitle: Text(l10n.settingsWipeHelp),
              value: _s[panicWipeKey] == true,
              onChanged: _panicWipe,
            ),
          ],
          if (desktop && !Platform.isLinux) ...[
            const Divider(),
            SwitchListTile(
              title: Text(l10n.settingsLockOnSleep),
              subtitle: Text(isLockOn(_s) ? l10n.settingsLockOnSleepHelp : l10n.settingsLockFirst),
              value: lockOnSleep(_s),
              onChanged: (on) => isLockOn(_s) ? _set(lockOnSleepKey, on) : _tell(l10n.settingsLockOnSleepNeedsLock),
            ),
          ],
          const Divider(),
          SwitchListTile(
            key: const Key('travelModeSwitch'),
            title: Text(premium.value ? l10n.settingsTravel : l10n.settingsTravelPremium),
            subtitle: Text(widget.vault.travelMode ? l10n.settingsTravelOnHelp : l10n.settingsTravelOffHelp(proofName)),
            value: widget.vault.travelMode,
            onChanged: _travelMode,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: Text(premium.value ? l10n.settingsKeys : l10n.settingsKeysPremium),
            subtitle: Text(l10n.settingsKeysHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(SecurityKeyScreen(vault: widget.vault)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(premium.value ? l10n.settingsActivity : l10n.settingsActivityPremium),
            subtitle: Text(l10n.settingsActivityHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(ActivityScreen(vault: widget.vault)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.emergency_outlined),
            title: Text(premium.value ? l10n.settingsEmergency : l10n.settingsEmergencyPremium),
            subtitle: Text(l10n.settingsEmergencyHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(EmergencyScreen(vault: widget.vault)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: Text(l10n.teamUiTitle),
            subtitle: Text(l10n.settingsTeamHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(TeamScreen(vault: widget.vault)),
          ),
          if (monthlyNotificationSupported) ...[
            const Divider(),
            SwitchListTile(
              title: Text(premium.value ? l10n.settingsMonthly : l10n.settingsMonthlyPremium),
              subtitle: Text(l10n.settingsMonthlyHelp),
              value: premium.value && _s[summaryNotifyKey] == true,
              onChanged: _monthlyNotify,
            ),
          ],
          const Divider(),
          SwitchListTile(
            title: Text(l10n.settingsBlockShots),
            subtitle: Text(desktop ? l10n.settingsBlockShotsDesktop : l10n.settingsBlockShotsPhone),
            value: blockScreenshotsOn(_s),
            onChanged: _blockScreenshots,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.health_and_safety_outlined),
            title: Text(l10n.settingsCheckup),
            subtitle: Text(l10n.settingsCheckupHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => CheckupScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.report_gmailerrorred_outlined),
            title: Text(premium.value ? l10n.premiumPerkBreach : l10n.settingsBreachPremium),
            subtitle: Text(_s[breachAlertsKey] == true ? l10n.settingsBreachOn : l10n.settingsBreachOff),
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
        label: locked ? l10n.settingsThemeSemanticPremium(themeName(id)) : l10n.settingsThemeSemantic(themeName(id)),
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
              Text(themeName(id), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Palette.text)),
            ]),
          ),
        ),
      );
    }

    return [
      Card(
        child: ListTile(
          leading: Icon(premium.value ? Icons.workspace_premium : Icons.workspace_premium_outlined, color: Palette.accent),
          title: Text(premium.value ? l10n.settingsPremiumThanks : l10n.settingsGetPremium),
          subtitle: Text(premium.value ? l10n.settingsPremiumThanksHelp : l10n.settingsGetPremiumHelp(payOnce)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
            setState(() {});
          },
        ),
      ),
      Padding(padding: const EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel(l10n.settingsAppearance)),
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
          ListTile(
            title: Text(l10n.settingsCountdown),
            subtitle: Text(l10n.settingsCountdownHelp),
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
            title: Text(l10n.settingsEasyFont),
            subtitle: Text(l10n.settingsEasyFontHelp),
            value: easyFont.value,
            onChanged: (on) async {
              easyFont.value = on;
              await _set(easyFontKey, on);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsLanguage),
            subtitle: DropdownButton<String>(
              key: const Key('languagePicker'),
              isExpanded: true,
              value: appLanguage.value ?? '',
              onChanged: (v) => v == null ? null : _setLanguage(v),
              items: [
                DropdownMenuItem(value: '', child: Text(l10n.settingsLanguageSystem)),
                for (final e in languageNames.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
            ),
          ),
        ]),
      ),
      const SizedBox(height: 20),
    ];
  }

  /// '' follows the device again. The app rebuilds in the new language (main.dart listens to appLanguage).
  Future<void> _setLanguage(String v) async {
    appLanguage.value = v.isEmpty ? null : v;
    if (v.isNotEmpty) return _set(languageKey, v);
    setState(() => widget.vault.settings.remove(languageKey));
    await widget.vault.save();
  }

  Future<void> _set(String key, Object value) async {
    setState(() => widget.vault.settings[key] = value);
    await widget.vault.save();
  }

  List<Widget> _listSection() {
    final s = widget.vault.settings;
    final trashed = widget.vault.trash.length;
    return [
      Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 8), child: CapsLabel(l10n.settingsAccountsList)),
      Card(
        child: Column(children: [
          SwitchListTile(
            title: Text(l10n.settingsCompact),
            subtitle: Text(l10n.settingsCompactHelp),
            value: s[layoutKey] == 'compact',
            onChanged: (on) => _set(layoutKey, on ? 'compact' : 'roomy'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sort),
            title: Text(l10n.settingsSort),
            subtitle: Text(l10n.settingsSortHelp(sortChoices[sortOf(s)] ?? '')),
            onTap: () async {
              final pick = await showDialog<String>(
                context: context,
                builder: (c) => SimpleDialog(title: Text(l10n.settingsSort), children: [
                  for (final e in sortChoices.entries)
                    ListTile(
                      leading: Icon(e.key == sortOf(s) ? Icons.radio_button_checked : Icons.radio_button_off),
                      title: Text(e.value),
                      subtitle: Text(switch (e.key) {
                        'custom' => l10n.settingsSortCustom,
                        'recent' => l10n.settingsSortRecent,
                        _ => l10n.settingsSortName,
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
            title: Text(l10n.tidyTitle),
            subtitle: Text(l10n.settingsTidyHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => TidyNamesScreen(vault: widget.vault)));
              setState(() {});
            },
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.settingsHideCodes),
            subtitle: Text(l10n.settingsHideCodesHelp),
            value: s[hideCodesKey] == true,
            onChanged: (on) => _set(hideCodesKey, on),
          ),
          if (Platform.isIOS || Platform.isAndroid) ...[
            const Divider(),
            SwitchListTile(
              title: Text(l10n.settingsShareCodes),
              subtitle: Text(l10n.settingsShareCodesHelp),
              value: s[shareCodesKey] == true,
              onChanged: (on) => _set(shareCodesKey, on),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(trashed == 0 ? l10n.settingsTrash : l10n.settingsTrashCount(trashed)),
            subtitle: Text(l10n.settingsTrashHelp),
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
      builder: (c) => SimpleDialog(title: Text(l10n.settingsWatchFace), children: [
        if (favorites.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Text(l10n.settingsWatchFaceNoFavorites),
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
          title: Text(l10n.settingsNone),
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
      Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 8), child: CapsLabel(l10n.settingsCopying)),
      Card(
        child: Column(children: [
          SwitchListTile(
            title: Text(l10n.settingsCopyOnOpen),
            subtitle: Text(l10n.settingsCopyOnOpenHelp),
            value: s[copyOnOpenKey] == true,
            onChanged: (on) => _set(copyOnOpenKey, on),
          ),
          if (Platform.isMacOS) ...[
            const Divider(),
            SwitchListTile(
              title: Text(l10n.settingsPasteOnce),
              subtitle: Text(l10n.settingsPasteOnceHelp),
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
              title: Text(l10n.settingsSpotlight),
              subtitle: Text(l10n.settingsSpotlightHelp),
              value: s[spotlightKey] != false,
              onChanged: (on) => _set(spotlightKey, on),
            ),
          ],
          if (Platform.isIOS) ...[
            const Divider(),
            SwitchListTile(
              title: Text(premium.value ? l10n.settingsLiveActivity : l10n.settingsLiveActivityPremium),
              subtitle: Text(l10n.settingsLiveActivityHelp),
              value: premium.value && s[liveActivityKey] == true,
              onChanged: (on) => _setPremium(liveActivityKey, on),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.watch_outlined),
              title: Text(premium.value ? l10n.settingsWatchFace : l10n.settingsWatchFacePremium),
              subtitle: Text(chosen == null ? l10n.settingsWatchFaceHelp : l10n.settingsWatchFaceChosen(accountTitle(chosen))),
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
      Padding(padding: const EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel(l10n.settingsBrowserSection)),
      Card(
        child: Column(children: [
          ListTile(
            leading: Icon(b == null ? Icons.link_off : Icons.link, color: b == null ? Palette.red : Palette.green),
            title: Text(b == null ? l10n.settingsBridgeOff : l10n.settingsBridgeOn),
            subtitle: Text(b == null
                ? l10n.settingsBridgeOffHelp('${bridgePorts.first}', '${bridgePorts.last}')
                : l10n.settingsBridgeOnHelp('${b.port}')),
          ),
          for (final origin in paired) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.extension_outlined),
              title: Text(integrationOrigins.contains(origin) ? l10n.settingsPairedClient(bridgeClientName(origin)) : l10n.settingsPairedBrowser),
              subtitle: integrationOrigins.contains(origin) ? null : Text(l10n.settingsExtensionId(origin.substring(origin.length - 8))),
              trailing: TextButton(
                onPressed: () async {
                  await b!.unpair(origin);
                  setState(() {});
                },
                child: Text(l10n.phoneUiUnpair),
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
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._premiumAndAppearance(),
          ..._listSection(),
          ..._copyingSection(),
          ...syncAndLinkSection(context, widget.vault, () => setState(() {})),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: CapsLabel(l10n.settingsSecurity),
          ),
          ..._securitySection(),
          if (Platform.isMacOS || Platform.isWindows) ..._browserSection(),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: CapsLabel(l10n.settingsBackup),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: Text(l10n.settingsExport),
                  subtitle: Text(l10n.settingsExportHelp),
                  onTap: () => exportBackupFlow(context, widget.vault),
                ),
                const Divider(),
                autoBackupTile(context, widget.vault, () => setState(() {})),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: Text(l10n.settingsImport),
                  subtitle: Text(l10n.settingsImportHelp),
                  onTap: () async {
                    await importBackupFlow(context, widget.vault);
                    setState(() {});
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.fact_check_outlined),
                  title: Text(l10n.settingsTestBackup),
                  subtitle: Text(l10n.settingsTestBackupHelp),
                  onTap: () => testBackupFlow(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.output),
                  title: Text(l10n.settingsMoveOut),
                  subtitle: Text(l10n.settingsMoveOutHelp),
                  onTap: () => exportToAppFlow(context, widget.vault),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.print_outlined),
                  title: Text(l10n.settingsPaper),
                  subtitle: Text(l10n.settingsPaperHelp),
                  onTap: () => paperBackupFlow(context, widget.vault),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: CapsLabel(l10n.settingsHelp),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(l10n.helpAllGuides),
                  subtitle: Text(l10n.settingsGuidesHelp),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => openLink(context, guidesIndexUrl),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.tour_outlined),
                  title: Text(l10n.settingsTour),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TourScreen(vault: widget.vault))),
                ),
                const Divider(),
                ListTile(
                  key: const Key('sendFeedback'),
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text(l10n.helpFeedbackTitle),
                  subtitle: Text(l10n.settingsFeedbackHelp),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen())),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: CapsLabel(l10n.settingsAbout),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: Text(l10n.aboutTitle),
                  subtitle: Text(l10n.settingsAboutMaddieHelp),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutMaddieScreen()),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.new_releases_outlined),
                  title: Text(l10n.helpWhatsNew),
                  subtitle: Text(l10n.helpVersion(appVersion)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WhatsNewScreen())),
                ),
                const Divider(),
                ListTile(
                  key: const Key('codesNotWorking'),
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.settingsCodesNotWorking),
                  subtitle: Text(l10n.settingsCodesNotWorkingHelp('${two(now.hour)}:${two(now.minute)}:${two(now.second)}')),
                  onTap: _checkClock,
                ),
                const Divider(),
                AboutListTile(
                  icon: const Icon(Icons.info_outline),
                  applicationName: 'Tanooki Auth',
                  applicationVersion: appVersion,
                  applicationLegalese: '© 2026 Tanooki Studios',
                  aboutBoxChildren: [
                    const SizedBox(height: 12),
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
