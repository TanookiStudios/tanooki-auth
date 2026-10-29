import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'bridge/server.dart';
import 'core/account.dart';
import 'core/vault.dart';
import 'ui/add.dart';
import 'ui/backup_ui.dart';
import 'ui/home.dart';
import 'ui/premium.dart';
import 'ui/settings.dart';
import 'ui/theme.dart';

bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;

/// Tests and the screenshot harness pass `--dart-define=TA_STORAGE=name` so the whole app
/// (vault file and its key) uses a throwaway store and can never touch real accounts.
const storageName = String.fromEnvironment('TA_STORAGE');

Future<Vault> openVault() async {
  var dir = (await getApplicationSupportDirectory()).path;
  if (storageName.isNotEmpty) dir = '$dir/$storageName';
  return Vault(File('$dir/vault.json'),
      SecureKeyStore(storageName.isEmpty ? 'vault_key_v1' : 'vault_key_v1_$storageName'));
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  }

  @override
  void dispose() {
    themeChoice.removeListener(_repaintAll);
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
  Vault? _vault;
  VaultException? _error;
  bool _locked = true;
  bool _covered = false;
  DateTime? _backgroundedAt;
  late final AppLifecycleListener _lifecycle;
  final _auth = LocalAuthentication();

  bool get _lockOn => _vault?.settings['lock'] == true;
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
        return AlertDialog(
          title: const Text('Pair with your browser'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Type this code into the Tanooki Auth browser extension:'),
            const SizedBox(height: 16),
            SelectableText(
              '${code.substring(0, 3)} ${code.substring(3)}',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 4),
            ),
            const SizedBox(height: 12),
            const Text('Only do this if you just clicked "Pair" in the extension yourself.',
                style: TextStyle(fontSize: 12)),
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
  Future<bool> confirmAdd(Account account) async {
    await bringToFront();
    if (!mounted) return false;
    return showAccountDialog(context, account, title: 'Add from your browser?', confirm: 'Add');
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
    _load();
  }

  @override
  void dispose() {
    activeBridge?.stop();
    activeBridge = null;
    _lifecycle.dispose();
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
    await loadPremiumAndTheme(vault);
    setState(() {
      _vault = vault;
      _error = null;
    });
    await _askAboutLockOnFirstRun();
    await _startBridge();
    if (_lockOn) {
      await _unlock();
    } else {
      setState(() => _locked = false);
    }
  }

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
    vault.settings['lock'] = lock;
    await vault.save();
  }

  Future<void> _unlock() async {
    bool ok;
    try {
      ok = await _auth.authenticate(localizedReason: 'Unlock Tanooki Auth');
    } catch (_) {
      ok = false;
    }
    if (mounted) setState(() => _locked = !ok);
  }

  void _onLifecycle(AppLifecycleState state) {
    if (!isDesktop) setState(() => _covered = state != AppLifecycleState.resumed);
    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      _backgroundedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final away = _backgroundedAt;
      _backgroundedAt = null;
      if (_lockOn && !_locked && away != null && DateTime.now().difference(away) > const Duration(seconds: 30)) {
        setState(() => _locked = true);
        _unlock();
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
      body = Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 16),
            const Text('Tanooki Auth is locked'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _unlock, child: const Text('Unlock')),
          ]),
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
