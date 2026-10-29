import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/account.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import 'add.dart';
import 'clipboard.dart';
import 'settings.dart';
import 'theme.dart';

String groupCode(String code) => code.length == 6
    ? '${code.substring(0, 3)} ${code.substring(3)}'
    : code.length == 8
        ? '${code.substring(0, 4)} ${code.substring(4)}'
        : code;

String accountTitle(Account a) => a.issuer.isNotEmpty ? a.issuer : a.label;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Timer _tick;
  int _selected = 0;
  String _query = '';
  final _focus = FocusNode();

  List<Account> get _accounts => widget.vault.accounts;

  List<Account> get _visible {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _accounts;
    return _accounts
        .where((a) => [a.issuer, a.label, ...a.domains].any((f) => f.toLowerCase().contains(q)))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _copy(Account a) async {
    await copyCode(a.codeAt(DateTime.now()));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Copied ${accountTitle(a)} code. The clipboard clears in 30 seconds.'),
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> _add() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddScreen(vault: widget.vault)));
    setState(() {});
  }

  Future<void> _edit(Account a) async {
    final changed = await showAccountDialog(context, a, title: 'Edit account', confirm: 'Save');
    if (changed) {
      await widget.vault.save();
      setState(() {});
    }
  }

  Future<void> _delete(Account a) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Delete ${accountTitle(a)}?'),
        content: const Text(
            'You will lose this account\'s codes. Before deleting, turn off two-factor login on that website or make sure you have its backup codes, or you could be locked out.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (sure != true) return;
    _accounts.remove(a);
    await widget.vault.save();
    setState(() => _selected = _selected.clamp(0, (_accounts.length - 1).clamp(0, 1 << 30)));
  }

  Future<void> _nextHotp(Account a) async {
    a.counter++;
    await widget.vault.save();
    setState(() {});
  }

  void _move(int delta) {
    final n = _visible.length;
    if (n == 0) return;
    setState(() => _selected = (_selected + delta).clamp(0, n - 1));
  }

  Future<void> _shift(Account a, int delta) async {
    final i = _accounts.indexOf(a), j = i + delta;
    if (j < 0 || j >= _accounts.length) return;
    setState(() => _accounts.insert(j, _accounts.removeAt(i)));
    await widget.vault.save();
  }

  Future<void> _openSettings() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(vault: widget.vault)));
    setState(() {});
  }

  Widget _card(Account a, int i, DateTime now, int unix, {required bool grid}) => SizedBox(
      key: ValueKey(a.id),
      height: 184,
      child: AccountCard(
        account: a,
        code: a.codeAt(now),
        left: a.type == OtpType.totp ? secondsLeft(unix, period: a.period) : null,
        selected: i == _selected && _visible.length > 1,
        onTap: () {
          setState(() => _selected = i);
          _copy(a);
        },
        onEdit: () => _edit(a),
        onDelete: () => _delete(a),
        onNext: () => _nextHotp(a),
        onMove: grid && _query.isEmpty ? _shift : null,
      ));

  Widget _search() => TextField(
        onChanged: (v) => setState(() {
          _query = v;
          _selected = 0;
        }),
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Palette.muted),
          hintText: 'Search accounts or websites…',
        ),
      );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final unix = now.millisecondsSinceEpoch ~/ 1000;
    // Sidebar layout from 700 pt, so an upright iPad mini (744 pt) gets it too.
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final visible = _visible;

    Widget list;
    if (_accounts.isEmpty) {
      list = Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No accounts yet.\nAdd one to scan a setup QR code.',
              textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
        ),
      );
    } else if (visible.isEmpty) {
      list = Center(child: Text('No accounts match your search.', style: TextStyle(color: Palette.muted)));
    } else if (wide) {
      // Cards need ~320 pt; narrower columns would squash the code and countdown.
      list = LayoutBuilder(
        builder: (_, box) => GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ((box.maxWidth - 40) / 334).floor().clamp(1, 6),
            mainAxisExtent: 184,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: visible.length,
          itemBuilder: (_, i) => _card(visible[i], i, now, unix, grid: true),
        ),
      );
    } else if (_query.isNotEmpty) {
      list = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        itemCount: visible.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _card(visible[i], i, now, unix, grid: false),
      );
    } else {
      list = ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        itemCount: visible.length,
        onReorderItem: (from, to) async {
          setState(() => _accounts.insert(to, _accounts.removeAt(from)));
          await widget.vault.save();
        },
        itemBuilder: (_, i) => Padding(
          key: ValueKey('row-${visible[i].id}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: _card(visible[i], i, now, unix, grid: false),
        ),
      );
    }

    list = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (_visible.isNotEmpty) _copy(_visible[_selected.clamp(0, _visible.length - 1)]);
        },
        const SingleActivator(LogicalKeyboardKey.numpadEnter): () {
          if (_visible.isNotEmpty) _copy(_visible[_selected.clamp(0, _visible.length - 1)]);
        },
      },
      child: Focus(focusNode: _focus, autofocus: true, child: list),
    );

    if (!wide) {
      return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            const Text('Tanooki Auth'),
            const SizedBox(width: 10),
            CountBadge(_accounts.length),
          ]),
          actions: [
            IconButton(tooltip: 'Settings', icon: const Icon(Icons.settings_outlined), onPressed: _openSettings),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _add,
          icon: const Icon(Icons.add),
          label: const Text('Add account'),
        ),
        body: Column(children: [
          if (_accounts.length > 3) Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: _search()),
          if (_accounts.length <= 3) const SizedBox(height: 12),
          Expanded(child: list),
        ]),
      );
    }

    return Scaffold(
      body: Row(children: [
        Sidebar(onAdd: _add, onSettings: _openSettings),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Palette.line))),
              child: const Text('Accounts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(children: [
                const Text('Your accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(width: 10),
                CountBadge(_accounts.length),
                const SizedBox(width: 20),
                Expanded(child: _search()),
                const SizedBox(width: 12),
                FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
              ]),
            ),
            Expanded(child: list),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Palette.line))),
              child: Text(
                Platform.isIOS || Platform.isAndroid
                    ? 'Tap (Copy) · Enter (Copy) · Arrows (Navigate)'
                    : 'Click (Copy) · Enter (Copy) · Arrows (Navigate)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Palette.muted),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.onAdd, required this.onSettings});
  final VoidCallback onAdd, onSettings;

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label, VoidCallback? onTap, {bool active = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: Material(
            color: active ? Palette.card : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: active ? Palette.line : Colors.transparent),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  Icon(icon, size: 20, color: active ? Palette.text : Palette.muted),
                  const SizedBox(width: 12),
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: active ? Palette.text : Palette.muted)),
                ]),
              ),
            ),
          ),
        );

    return Container(
      width: 220,
      color: Palette.panel,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Row(children: [
            Icon(Icons.shield_rounded, size: 38, color: Palette.accent),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('TANOOKI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 3)),
              Text('AUTH', style: TextStyle(fontSize: 11, letterSpacing: 5, color: Palette.muted)),
            ]),
          ]),
        ),
        item(Icons.key_rounded, 'Accounts', () {}, active: true),
        item(Icons.add_circle_outline, 'Add account', onAdd),
        item(Icons.settings_outlined, 'Settings', onSettings),
        const Spacer(),
        const Divider(),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('v0.1.0 · stays on this device', style: TextStyle(fontSize: 11, color: Palette.muted)),
        ),
      ]),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.code,
    required this.left,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onNext,
    this.onMove,
  });

  final Account account;
  final String code;
  final int? left;
  final bool selected;
  final VoidCallback onTap, onEdit, onDelete, onNext;
  final Future<void> Function(Account, int)? onMove;

  @override
  Widget build(BuildContext context) {
    final a = account;
    final urgent = left != null && left! <= 5;
    final kind = a.type == OtpType.totp
        ? 'TOTP · ${a.digits} digits · ${a.period}s'
        : 'HOTP · ${a.digits} digits · #${a.counter}';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: selected ? Palette.accent : Palette.line, width: selected ? 1.5 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.white.withValues(alpha: 0.03),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 4, 0),
            child: Row(children: [
              Expanded(child: CapsLabel(kind)),
              if (a.domains.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Pill(a.domains.first, color: Palette.green),
                ),
              PopupMenuButton<String>(
                tooltip: 'More',
                iconSize: 18,
                icon: Icon(Icons.more_vert, color: Palette.muted),
                onSelected: (v) => switch (v) {
                  'edit' => onEdit(),
                  'delete' => onDelete(),
                  'earlier' => onMove?.call(a, -1),
                  _ => onMove?.call(a, 1),
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (onMove != null) const PopupMenuItem(value: 'earlier', child: Text('Move earlier')),
                  if (onMove != null) const PopupMenuItem(value: 'later', child: Text('Move later')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(accountTitle(a),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ),
          if (a.issuer.isNotEmpty && a.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(children: [
                const CapsLabel('Account'),
                const SizedBox(width: 8),
                Flexible(child: Pill(a.label)),
              ]),
            ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 10, 10),
            child: Row(children: [
              Text(
                groupCode(code),
                semanticsLabel: code.split('').join(' '),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: urgent ? Palette.red : Palette.text,
                ),
              ),
              const Spacer(),
              if (left == null)
                TextButton.icon(onPressed: onNext, icon: const Icon(Icons.refresh, size: 18), label: const Text('Next'))
              else ...[
                Text('${left}s', style: TextStyle(fontSize: 12, color: urgent ? Palette.red : Palette.muted)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    value: left! / a.period,
                    strokeWidth: 3,
                    color: urgent ? Palette.red : Palette.accent,
                    backgroundColor: Palette.line,
                  ),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}
