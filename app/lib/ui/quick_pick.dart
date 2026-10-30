import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/account.dart';
import '../core/vault.dart';
import 'clipboard.dart';
import 'home.dart' show accountTitle, groupCode;

const _window = MethodChannel('tanooki/window');

/// Types [code] into whatever box was focused before Tanooki Auth came forward.
/// Hides our window first (so focus goes back to the other app) and refuses to type into ourselves.
/// Returns null when typed, otherwise a message for the user.
Future<String?> typeCode(String code) async {
  try {
    await _window.invokeMethod<void>('typeText', code);
    return null;
  } on PlatformException catch (e) {
    return switch (e.code) {
      'denied' => 'denied',
      'self' => 'Tanooki Auth was still in front, so nothing was typed. Click into the box you want to fill, then use the menu bar icon again.',
      _ => 'Couldn\'t type the code (${e.message ?? e.code}). Copy it instead.',
    };
  } on MissingPluginException {
    return 'Typing codes isn\'t available on this computer. Copy it instead.';
  }
}

/// The small search list opened from the menu bar (Mac) or tray icon (Windows).
/// Click copies a code; "Type" types it into the box you were in.
class QuickPickScreen extends StatefulWidget {
  const QuickPickScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<QuickPickScreen> createState() => _QuickPickScreenState();
}

class _QuickPickScreenState extends State<QuickPickScreen> {
  late final Timer _tick;
  String _query = '';

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

  List<Account> get _matches {
    final q = _query.trim().toLowerCase();
    return homeOrder(widget.vault.accounts, sort: 'recent')
        .where((a) => q.isEmpty || [a.issuer, a.label, ...a.domains, ...a.tags].any((f) => f.toLowerCase().contains(q)))
        .toList();
  }

  Future<void> _used(Account a) async {
    a.lastUsedAt = DateTime.now().toUtc();
    await widget.vault.save();
  }

  Future<void> _copy(Account a) async {
    await copyCode(a.codeAt(DateTime.now()));
    await _used(a);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Copied ${accountTitle(a)} code. The clipboard clears in 30 seconds.'),
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> _type(Account a) async {
    final problem = await typeCode(a.codeAt(DateTime.now()));
    if (problem == null) {
      await _used(a);
      if (mounted) Navigator.pop(context);
      return;
    }
    if (!mounted) return;
    if (problem == 'denied') {
      await _explainPermission();
    } else {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          content: Text(problem),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    }
  }

  Future<void> _explainPermission() => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Allow Tanooki Auth to type'),
          content: const Text(
              'To type a code into another app, your Mac needs to let Tanooki Auth press keys for you.\n\n'
              '1. Click "Open System Settings" below.\n'
              '2. You\'ll see a list called Accessibility. Find Tanooki Auth and turn its switch on (blue).\n'
              '3. If your Mac asks for your password or Touch ID, give it.\n'
              '4. Come back here and click Type again.\n\n'
              'Tanooki Auth only presses keys when you click Type, and only types the code.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Not now')),
            FilledButton(
              onPressed: () async {
                Navigator.pop(c);
                // Asking the system here (not on the first Type) lists the app under Accessibility so the switch is there.
                try {
                  await _window.invokeMethod<void>('requestTypeAccess');
                } on MissingPluginException {
                  // Older native side: Settings still opens.
                }
                await launchUrl(Uri.parse('x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'));
              },
              child: const Text('Open System Settings'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final list = _matches;
    return Scaffold(
      appBar: AppBar(title: const Text('Quick pick')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search accounts'),
            onChanged: (v) => setState(() => _query = v),
            onSubmitted: (_) => list.isEmpty ? null : _copy(list.first),
          ),
        ),
        if (Platform.isLinux)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Typing codes into other apps isn\'t available on Linux. Click an account to copy its code.'),
          ),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('No matching accounts'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final a = list[i];
                    return ListTile(
                      title: Text(accountTitle(a)),
                      subtitle: Text(
                        groupCode(a.codeAt(now)),
                        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                      ),
                      onTap: () => _copy(a),
                      trailing: Platform.isMacOS || Platform.isWindows
                          ? TextButton.icon(
                              onPressed: () => _type(a),
                              icon: const Icon(Icons.keyboard_outlined),
                              label: const Text('Type'),
                            )
                          : null,
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
