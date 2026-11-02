import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/account.dart';
import '../core/activity.dart';
import '../core/totp.dart' show secondsLeft;
import '../core/vault.dart';
import 'brand_icon.dart';
import 'clipboard.dart';
import 'code_view.dart';
import 'home.dart' show accountTitle, groupCode;
import 'keys.dart';
import 'security_ui.dart' show confirmItsYou;
import '../l10n/l10n.dart';

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
      'self' => l10n.quickPickSelf,
      _ => l10n.quickPickTypeFailed(e.message ?? e.code),
    };
  } on MissingPluginException {
    return l10n.quickPickTypeUnavailable;
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
  int _selected = 0;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Account> get _matches {
    final q = _query.trim().toLowerCase();
    return homeOrder(widget.vault.visible, sort: 'recent')
        .where((a) => q.isEmpty || [a.issuer, a.label, ...a.domains, ...a.tags].any((f) => f.toLowerCase().contains(q)))
        .toList();
  }

  Future<void> _used(Account a, ActivityKind kind) async {
    a.lastUsedAt = DateTime.now().toUtc();
    logActivity(widget.vault, kind, accountId: a.id, where: 'Quick pick');
    await widget.vault.save();
  }

  /// "Ask first" accounts never show their code here, and ask for Touch ID / Windows Hello before using it.
  Future<bool> _ok(Account a) async =>
      !a.requireAuth || await confirmItsYou(context, widget.vault, l10n.quickPickUseCodeFor(accountTitle(a)));

  Future<void> _copy(Account a) async {
    if (!await _ok(a)) return;
    await copyCode(a.codeAt(DateTime.now()));
    await _used(a, ActivityKind.copied);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l10n.homeCopied(accountTitle(a))),
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> _type(Account a) async {
    if (!await _ok(a)) return;
    final problem = await typeCode(a.codeAt(DateTime.now()));
    if (problem == null) {
      await _used(a, ActivityKind.typed);
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
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonOk))],
        ),
      );
    }
  }

  Future<void> _explainPermission() => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.quickPickAllowTitle),
          content: Text(l10n.quickPickAllowBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonNotNow)),
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
              child: Text(l10n.quickPickOpenSystemSettings),
            ),
          ],
        ),
      );

  /// Keyboard: see [listKey]. Esc clears the search, or closes Quick pick when there's nothing to clear.
  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    final list = _matches;
    return listKey(
      e,
      inSearch: _searchFocus.hasFocus,
      onMove: (d) => setState(() => _selected = (_selected + d).clamp(0, (list.length - 1).clamp(0, 1 << 30))),
      onEnter: () {
        if (list.isNotEmpty) _copy(list[_selected.clamp(0, list.length - 1)]);
      },
      onEscape: () {
        if (_search.text.isEmpty) {
          Navigator.maybePop(context);
        } else {
          _search.clear();
          setState(() {
            _query = '';
            _selected = 0;
          });
        }
        return true;
      },
      onType: (ch) {
        typeInto(_search, _searchFocus, ch);
        setState(() {
          _query = _search.text;
          _selected = 0;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final list = _matches;
    final selected = list.isEmpty ? -1 : _selected.clamp(0, list.length - 1);
    return Focus(onKeyEvent: _onKey, child: Scaffold(
      appBar: AppBar(title: Text(l10n.quickPickTitle)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _search,
            focusNode: _searchFocus,
            autofocus: true,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l10n.quickPickSearch),
            onChanged: (v) => setState(() {
              _query = v;
              _selected = 0;
            }),
            onSubmitted: (_) => list.isEmpty ? null : _copy(list[selected]),
          ),
        ),
        if (Platform.isLinux)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.quickPickLinuxNote),
          ),
        Expanded(
          child: list.isEmpty
              ? Center(child: Text(l10n.quickPickNoMatches))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final a = list[i];
                    final code = a.codeAt(now);
                    final left = a.timeBased ? secondsLeft(now.millisecondsSinceEpoch ~/ 1000, period: a.period) : null;
                    return ListTile(
                      selected: i == selected && list.length > 1,
                      leading: IssuerAvatar(a, size: 32),
                      title: Text(accountTitle(a)),
                      subtitle: Text(
                        a.requireAuth ? l10n.quickPickAsksFirst : groupCode(code),
                        semanticsLabel: a.requireAuth ? l10n.quickPickHiddenAsks : codeSemantics(code, left),
                        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                      ),
                      onTap: () => _copy(a),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        if (left != null && !a.requireAuth) Countdown(left: left, period: a.period, style: countdownOf(widget.vault.settings)),
                        if (Platform.isMacOS || Platform.isWindows)
                          TextButton.icon(
                            onPressed: () => _type(a),
                            icon: const Icon(Icons.keyboard_outlined),
                            label: Text(l10n.quickPickType),
                          ),
                      ]),
                    );
                  },
                ),
        ),
      ]),
    ));
  }
}
