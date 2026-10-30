import 'dart:io';

import 'package:flutter/foundation.dart' show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'bridge/server.dart';
import 'core/account.dart';
import 'core/activity.dart';
import 'core/auto_backup.dart';
import 'core/clock_check.dart';
import 'core/emergency.dart';
import 'core/security.dart';
import 'core/security_key.dart';
import 'core/spotlight.dart';
import 'core/vault.dart';
import 'core/widget_share.dart';
import 'ui/add.dart';
import 'ui/app_icon.dart';
import 'ui/backup_ui.dart';
import 'ui/brand_icon.dart';
import 'ui/clipboard.dart';
import 'ui/code_view.dart' show countdownKey;
import 'ui/help.dart' show showTourOrWhatsNew;
import 'ui/home.dart';
import 'ui/phone_link_ui.dart' show resumeSyncAndLink, startSyncAndLink, stopSyncAndLink;
import 'ui/premium.dart';
import 'ui/quick_pick.dart';
import 'ui/security_ui.dart';
import 'ui/settings.dart';
import 'ui/theme.dart';

bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;

/// Tests and the screenshot harness pass `--dart-define=TA_STORAGE=name` so the whole app
/// (vault file and its key) uses a throwaway store and can never touch real accounts.
const storageName = String.fromEnvironment('TA_STORAGE');

/// [second] is the decoy vault: its own file and its own key, so nothing in it can reach the real one.
Future<Vault> openVault({bool second = false}) async {
  var dir = (await getApplicationSupportDirectory()).path;
  if (storageName.isNotEmpty) dir = '$dir/$storageName';
  final key = storageName.isEmpty ? 'vault_key_v1' : 'vault_key_v1_$storageName';
  return second ? Vault(File('$dir/vault-b.json'), SecureKeyStore('${key}_b')) : Vault(File('$dir/vault.json'), SecureKeyStore(key));
}

/// Starts an empty decoy vault that looks like the real one (same theme, layout, lock), then saves the decoy
/// passcode's hash in the real vault, which is where the lock screen checks it.
Future<void> createDecoyVault(Vault real, Map<String, Object> passcodeRecord) async {
  if (isDecoyVault(real)) {
    // Someone set a "decoy" from inside the decoy: just remember it there, so it looks like it worked.
    real.settings[decoyPasscodeKey] = passcodeRecord;
    return real.save();
  }
  final decoy = await openVault(second: true);
  await decoy.resetToEmpty();
  const lookAlike = ['theme', 'license', easyFontKey, countdownKey, layoutKey, hideCodesKey, recentFirstKey, sortKey, lockKey, lockAfterKey, blockScreenshotsKey];
  for (final k in lookAlike) {
    if (real.settings.containsKey(k)) decoy.settings[k] = real.settings[k];
  }
  decoy.settings[passcodeKey] = passcodeRecord; // so its Settings shows a passcode, like the real one
  decoy.settings[kitShownKey] = true;
  await decoy.save();
  real.settings[decoyPasscodeKey] = passcodeRecord;
  await real.save();
}

bool isDecoyVault(Vault v) => v.file.path.endsWith('vault-b.json');

/// Erases the decoy vault. Its key is replaced too, so an old copy of the file can't be opened.
Future<void> deleteDecoyVault() async {
  final decoy = await openVault(second: true);
  if (await decoy.file.exists()) {
    await decoy.resetToEmpty();
    await decoy.file.delete();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // The bundled easy-to-read font's license travels with it (SIL Open Font License).
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Atkinson Hyperlegible'], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
  // Widgets and the watch follow the real vault only; the decoy never reaches them.
  Vault.onSaved = (v) {
    if (!isDecoyVault(v)) {
      publishSharedFavorites(v);
      // Test and screenshot stores never reach the real Spotlight index.
      if (storageName.isEmpty) publishSpotlight(v);
      autoBackup.vaultChanged(v);
      EmergencyService.instance.vaultChanged(v); // keeps the emergency copy current
    }
  };
  autoBackup.isPremium = () => premium.value;
  activityPremium = () => premium.value;
  EmergencyService.instance.isPremium = () => premium.value;
  ClockCheck.instance.auto = true;
  widgetPremium = () => premium.value;
  runApp(const TanookiAuthApp());
}

class TanookiAuthApp extends StatefulWidget {
  const TanookiAuthApp({super.key});

  @override
  State<TanookiAuthApp> createState() => _TanookiAuthAppState();
}

class _TanookiAuthAppState extends State<TanookiAuthApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    themeChoice.addListener(_repaintAll);
    easyFont.addListener(_repaintAll);
  }

  @override
  void dispose() {
    themeChoice.removeListener(_repaintAll);
    easyFont.removeListener(_repaintAll);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() => _repaintAll();

  // Widgets read colors from Palette directly, so after a theme switch every one of them must rebuild.
  // Re-keying the tree would also do it, but would throw away the open screens and the unlocked vault.
  void _repaintAll() {
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      void rebuild(Element e) {
        e.markNeedsBuild();
        e.visitChildren(rebuild);
      }

      if (mounted) (context as Element).visitChildren(rebuild);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fixed = themeChoices[themeChoice.value];
    return MaterialApp(
      title: 'Tanooki Auth',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(fixed ?? lightPalette),
      darkTheme: buildTheme(fixed ?? darkPalette),
      themeMode: fixed == null
          ? ThemeMode.system
          : fixed.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
      builder: (context, child) {
        Palette.current = fixed ?? (Theme.of(context).brightness == Brightness.dark ? darkPalette : lightPalette);
        return child!;
      },
      home: const Gate(),
    );
  }
}

const _window = MethodChannel('tanooki/window');

/// Brings the app window to the front so the user sees a prompt the browser triggered.
Future<void> bringToFront() async {
  try {
    await _window.invokeMethod('focus');
  } on MissingPluginException {
    // Not wired on this platform; the dialog still appears when the user switches over.
  }
}

/// Loads the vault, handles the lock, and covers the screen when the app is in the background.
class Gate extends StatefulWidget {
  const Gate({super.key});

  @override
  State<Gate> createState() => _GateState();
}

class _GateState extends State<Gate> implements BridgeHost {
  /// The real vault: its settings hold the lock, passcode, decoy and panic-wipe choices.
  Vault? _real;
  /// What's on screen: the real vault, or the decoy one after the decoy passcode.
  Vault? _vault;
  final _pin = TextEditingController();
  final _pinFocus = FocusNode();
  String? _pinError;
  bool _checking = false;
  VaultException? _error;
  bool _locked = true;
  bool _covered = false;
  DateTime? _backgroundedAt;
  late final AppLifecycleListener _lifecycle;
  final _auth = LocalAuthentication();
  /// "scan" (Control Center / quick settings) or "pick" (menu bar / tray), run once the app is unlocked.
  String? _pendingAction;

  bool get _lockOn => _real != null && isLockOn(_real!.settings);
  bool get _biometricOn => _real?.settings[lockKey] == true;
  BuildContext? _pairDialog;

  @override
  Vault get vault => _vault!;
  @override
  bool get locked => _locked || _vault == null;

  @override
  void vaultChanged() {
    if (mounted) setState(() {});
  }

  @override
  void showPairingCode(String code, String origin) {
    hidePairingCode();
    bringToFront();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        _pairDialog = c;
        final (title, body, warning) = switch (bridgeClientName(origin)) {
          'Raycast' => ('Pair with Raycast', 'Type this code into Raycast:', 'Only do this if you just started pairing in Raycast yourself.'),
          'Alfred' => ('Pair with Alfred', 'Type 2fa-pair and this code into Alfred:', 'Only do this if you just typed 2fa-pair in Alfred yourself.'),
          'PowerToys' => (
              'Pair with PowerToys',
              'Type this code into PowerToys Command Palette:',
              'Only do this if you just started pairing in PowerToys yourself.'
            ),
          _ => (
              'Pair with your browser',
              'Type this code into the Tanooki Auth browser extension:',
              'Only do this if you just clicked "Pair" in the extension yourself.'
            ),
        };
        return AlertDialog(
          title: Text(title),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(body),
            const SizedBox(height: 16),
            SelectableText(
              '${code.substring(0, 3)} ${code.substring(3)}',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 4),
            ),
            const SizedBox(height: 12),
            Text(warning, style: const TextStyle(fontSize: 12)),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                activeBridge?.cancelPairing();
                hidePairingCode();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void hidePairingCode() {
    final c = _pairDialog;
    _pairDialog = null;
    if (c != null && c.mounted) Navigator.of(c).pop();
  }

  @override
  Future<bool> confirmAdd(List<Account> accounts) async {
    await bringToFront();
    if (!mounted) return false;
    return confirmAddAccounts(context, accounts);
  }

  @override
  Future<bool> confirmReveal(Account account, String client) async {
    await bringToFront();
    if (!mounted || locked) return false;
    return confirmItsYou(context, vault, 'Send the code for ${accountTitle(account)} to $client');
  }

  @override
  Future<void> openScreen(String screen) async {
    await bringToFront();
    if (!mounted || _vault == null || _locked) return;
    final nav = Navigator.of(context);
    nav.popUntil((r) => r.isFirst);
    await nav.push(MaterialPageRoute(
      builder: (_) => screen == 'add' ? AddScreen(vault: _vault!) : SettingsScreen(vault: _vault!),
    ));
    if (mounted) setState(() {});
  }

  Future<void> _startBridge() async {
    if (!isDesktop || activeBridge != null) return;
    final b = BridgeServer(this);
    if (await b.start() != null) activeBridge = b;
  }

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: _onLifecycle);
    listenForPlatformActions(() async {
      _pendingAction = await takePendingAction() ?? _pendingAction;
      await _runPendingAction();
    });
    listenForSpotlight(() async {
      final id = await takeSpotlightOpen();
      if (id == null) return;
      _pendingAction = 'account:$id';
      await _runPendingAction();
    });
    _window.setMethodCallHandler((call) async {
      if (call.method == 'screenLocked') return _lockNow();
      if (call.method != 'trayClicked') return;
      _pendingAction = 'pick';
      await _runPendingAction();
    });
    _load();
  }

  @override
  void dispose() {
    stopSyncAndLink();
    activeBridge?.stop();
    activeBridge = null;
    _lifecycle.dispose();
    _pin.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final vault = await openVault();
    try {
      await vault.load();
    } on VaultException catch (e) {
      setState(() => _error = e);
      return;
    }
    await publishSharedFavorites(vault);
    if (storageName.isEmpty) await publishSpotlight(vault);
    _pendingAction = await takePendingAction() ?? _pendingAction;
    final spotlightId = await takeSpotlightOpen();
    if (spotlightId != null) _pendingAction = 'account:$spotlightId';
    await loadPremiumAndTheme(vault);
    easyFont.value = vault.settings[easyFontKey] == true;
    await restoreDockIcon(vault, premium: premium.value);
    await loadBrandIcons();
    await applyScreenshotBlocking(blockScreenshotsOn(vault.settings));
    setState(() {
      _real = vault;
      _vault = vault;
      _error = null;
      _locked = true;
    });
    await _askAboutLockOnFirstRun();
    await _startBridge();
    if (!_lockOn) {
      await _enter(vault);
    } else if (_biometricOn) {
      await _unlock();
    }
  }

  /// Unlocks into [v] (the real vault or the decoy). Only the real vault gets the first-run kit, the tour or What's new, and the breach check.
  Future<void> _enter(Vault v) async {
    if (v != _vault) {
      await loadPremiumAndTheme(v);
      easyFont.value = v.settings[easyFontKey] == true;
    }
    if (!mounted) return;
    setState(() {
      _vault = v;
      _locked = false;
      _pin.clear();
      _pinError = null;
    });
    if (mounted) startSyncAndLink(context, v, bringToFront);
    pasteOnce = v.settings[pasteOnceKey] == true;
    if (_pendingAction == null) await _copyOnOpen(v);
    if (v != _real) return _runPendingAction();
    if (v.settings[kitShownKey] != true) {
      v.settings[kitShownKey] = true;
      await v.save();
      if (mounted) await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => RecoveryKitScreen(vault: v)));
    }
    if (mounted) await showTourOrWhatsNew(context, v);
    autoBackup.appOpened(v); // runs in the background; a failure shows in Settings and the check-up
    EmergencyService.instance.check(v); // a request notification can be missed, so ask on every unlock
    if (mounted) await weeklyBreachCheck(context, v);
    await _runPendingAction();
  }

  /// "Copy on open": copies the most recently used account's code, with the usual message and 30 s clear.
  Future<void> _copyOnOpen(Vault v) async {
    final a = copyOnOpenPick(v);
    if (a == null || !mounted) return;
    final now = DateTime.now();
    await copyCode(a.codeAt(now));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Copied ${accountTitle(a)} code. The clipboard clears in 30 seconds.'),
        duration: const Duration(seconds: 2),
      ));
    await showCopiedCodeActivity(v, a, now);
  }

  Future<void> _runPendingAction() async {
    final action = _pendingAction;
    if (action == null || !mounted || _locked || _vault == null) return; // runs after unlock instead
    _pendingAction = null;
    final nav = Navigator.of(context);
    nav.popUntil((r) => r.isFirst);
    if (action.startsWith('account:')) {
      // A Spotlight result: the home list shows that account.
      openAccountRequest.value = action.substring('account:'.length);
      return;
    }
    await nav.push(MaterialPageRoute<void>(
      builder: (_) => action == 'pick'
          ? QuickPickScreen(vault: _vault!)
          : action.startsWith('share:')
              ? AddScreen(vault: _vault!, sharedFile: action.substring('share:'.length))
              : AddScreen(vault: _vault!, scanOnOpen: true),
    ));
    if (mounted) setState(() {});
  }

  Future<void> _submitPasscode() async {
    if (_checking || _real == null) return;
    final pin = _pin.text;
    if (pin.isEmpty) return;
    setState(() {
      _checking = true;
      _pinError = null;
    });
    final result = await tryPasscode(_real!, pin, wipeDecoy: deleteDecoyVault);
    if (!mounted) return;
    setState(() => _checking = false);
    switch (result) {
      case Unlock.real:
        await _enter(_real!);
      case Unlock.decoy:
        final decoy = await openVault(second: true);
        try {
          await decoy.load();
        } on VaultException {
          await decoy.resetToEmpty(); // the decoy has nothing worth keeping; never show an error that reveals it
        }
        await _enter(decoy);
      case Unlock.wrong:
        final left = panicWipeAttempts - failedPasscodes(_real!.settings);
        setState(() {
          _pin.clear();
          _pinError = _real!.settings[panicWipeKey] == true && left <= 5
              ? 'Wrong passcode. $left more wrong ${left == 1 ? 'try erases' : 'tries erase'} everything.'
              : 'Wrong passcode.';
        });
        _pinFocus.requestFocus(); // ready to type again
      case Unlock.wiped:
        _pin.clear();
        await _load();
    }
  }

  String get _biometricName => Platform.isWindows
      ? 'Windows Hello'
      : Platform.isMacOS
          ? 'Touch ID'
          : 'Face ID or fingerprint';

  // Phones: ask once, default on. Desktop: off by default, toggle in Settings.
  Future<void> _askAboutLockOnFirstRun() async {
    final vault = _vault!;
    if (vault.settings.containsKey('lock')) return;
    var lock = false;
    if (!isDesktop && await _auth.isDeviceSupported() && mounted) {
      lock = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (c) => AlertDialog(
              title: const Text('Lock Tanooki Auth?'),
              content: const Text(
                  'Ask for your face, fingerprint, or passcode when the app opens, so someone holding your unlocked phone can\'t read your codes. You can change this later in Settings.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Not now')),
                FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Turn on lock')),
              ],
            ),
          ) ??
          true;
    }
    vault.settings[lockKey] = lock;
    await vault.save();
  }

  Future<void> _unlock() async {
    bool ok;
    try {
      ok = await _auth.authenticate(localizedReason: 'Unlock Tanooki Auth');
    } catch (_) {
      ok = false;
    }
    if (ok && _real != null) await _enter(_real!);
  }

  /// The computer went to sleep or its screen locked (Mac and Windows): lock too, if that's on.
  void _lockNow() {
    if (_locked || _real == null || !lockOnSleep(_real!.settings)) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    setState(() => _locked = true);
    stopSyncAndLink();
  }

  String? _keyError;

  Future<void> _unlockWithKey() async {
    setState(() => _keyError = null);
    try {
      await SecurityKeys.unlock(_real!);
    } on SecurityKeyException catch (e) {
      if (mounted) setState(() => _keyError = e.message);
      return;
    }
    if (mounted) await _enter(_real!);
  }

  void _onLifecycle(AppLifecycleState state) {
    if (!isDesktop) setState(() => _covered = state != AppLifecycleState.resumed);
    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      _backgroundedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final away = _backgroundedAt;
      _backgroundedAt = null;
      if (!_locked && away != null) resumeSyncAndLink();
      if (!_locked && away != null && _real != null && shouldRelock(_real!.settings, DateTime.now().difference(away))) {
        setState(() => _locked = true);
        stopSyncAndLink();
        if (_biometricOn) _unlock();
      } else if (!_locked && away != null && _pendingAction == null && _vault != null) {
        _copyOnOpen(_vault!); // opened again from the background without needing to unlock
      }
    }
  }

  /// Decrypts a backup first, and only then replaces the unreadable vault with it.
  Future<void> _restore() async {
    final accounts = await pickAndOpenBackup(context);
    if (accounts == null) return;
    final vault = await openVault();
    await vault.resetToEmpty();
    vault.accounts.addAll(accounts);
    await vault.save();
    await _load();
  }

  Future<void> _startOver() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Start a new, empty vault?'),
        content: const Text(
            'This permanently replaces whatever is left of your old accounts. Only do this if you have no backup to restore, or you have already turned off two-factor login on those sites.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Erase and start over'),
          ),
        ],
      ),
    );
    if (sure != true) return;
    await (await openVault()).resetToEmpty();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_error != null) {
      body = Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(_error!.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              FilledButton(onPressed: _restore, child: const Text('Restore from backup')),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _load, child: const Text('Try again')),
              TextButton(onPressed: _startOver, child: const Text('Start a new, empty vault')),
            ]),
          ),
        ),
      );
    } else if (_vault == null) {
      body = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (_locked) {
      final hasPasscode = _real!.settings[passcodeKey] != null;
      body = Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              const Text('Tanooki Auth is locked'),
              const SizedBox(height: 16),
              if (hasPasscode) ...[
                SizedBox(
                  width: 260,
                  child: PasscodeField(controller: _pin, focusNode: _pinFocus, label: 'Passcode', autofocus: !_biometricOn, onSubmitted: (_) => _submitPasscode()),
                ),
                if (_pinError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_pinError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _checking ? null : _submitPasscode,
                  child: _checking
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Unlock'),
                ),
                if (_biometricOn) TextButton(onPressed: _unlock, child: Text('Use $_biometricName')),
              ] else
                FilledButton(onPressed: _unlock, child: const Text('Unlock')),
              if (securityKeysOf(_real!.settings).isNotEmpty) ...[
                TextButton.icon(onPressed: _unlockWithKey, icon: const Icon(Icons.key), label: const Text('Use security key')),
                if (_keyError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: 320,
                      child: Text(_keyError!, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ),
                  ),
              ],
            ]),
          ),
        ),
      );
    } else {
      body = HomeScreen(vault: _vault!);
    }
    return Stack(children: [
      body,
      if (_covered)
        Positioned.fill(
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: Icon(Icons.shield_outlined, size: 64)),
          ),
        ),
    ]);
  }
}
