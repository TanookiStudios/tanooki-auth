import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/account.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import 'add.dart';
import 'brand_icon.dart';
import 'clipboard.dart';
import 'recovery_codes.dart';
import 'settings.dart';
import 'share_ui.dart';
import 'theme.dart';

String groupCode(String code) => code.length == 6
    ? '${code.substring(0, 3)} ${code.substring(3)}'
    : code.length == 8
        ? '${code.substring(0, 4)} ${code.substring(4)}'
        : code;

String accountTitle(Account a) => a.issuer.isNotEmpty ? a.issuer : a.label;

/// Settings keys for the home list (stored in vault.settings).
const recentFirstKey = 'recentFirst', hideCodesKey = 'hideCodes', layoutKey = 'layout';

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
  String? _tag;
  final _revealed = <String, DateTime>{}; // account id -> when its hidden code was tapped
  final _focus = FocusNode();

  Map<String, dynamic> get _settings => widget.vault.settings;
  bool get _recentFirst => _settings[recentFirstKey] == true;
  bool get _hideCodes => _settings[hideCodesKey] == true;
  bool get _compact => _settings[layoutKey] == 'compact';
  double get _cardHeight => _compact ? 92 : 196; // roomy needs room for the "Next" line in the last 5 s

  List<Account> get _live => widget.vault.live;

  List<String> get _allTags => {for (final a in _live) ...a.tags}.toList()..sort();

  List<Account> get _visible {
    final q = _query.trim().toLowerCase();
    return homeOrder(widget.vault.accounts, recentFirst: _recentFirst)
        .where((a) => _tag == null || a.tags.contains(_tag))
        .where((a) => q.isEmpty || [a.issuer, a.label, ...a.domains, ...a.tags].any((f) => f.toLowerCase().contains(q)))
        .toList();
  }

  // Dragging only makes sense when the list shows the user's own order, unfiltered.
  bool get _canReorder => _query.isEmpty && _tag == null && !_recentFirst;

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

  bool _isHidden(Account a, DateTime now) {
    if (!_hideCodes) return false;
    final t = _revealed[a.id];
    return t == null || now.difference(t) > const Duration(seconds: 20);
  }

  Future<void> _copy(Account a) async {
    _revealed[a.id] = DateTime.now();
    await copyCode(a.codeAt(DateTime.now()));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Copied ${accountTitle(a)} code. The clipboard clears in 30 seconds.'),
        duration: const Duration(seconds: 2),
      ));
    a.lastUsedAt = DateTime.now().toUtc();
    await widget.vault.save();
    if (mounted) setState(() => _selected = _visible.indexOf(a).clamp(0, 1 << 30));
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

  Future<void> _toggleFavorite(Account a) async {
    setState(() => a.favorite = !a.favorite);
    await widget.vault.save();
  }

  Future<void> _recoveryCodes(Account a) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => RecoveryCodesScreen(vault: widget.vault, account: a)));
    setState(() {});
  }

  Future<void> _delete(Account a) async {
    a.deletedAt = DateTime.now().toUtc();
    await widget.vault.save();
    if (!mounted) return;
    setState(() => _selected = _selected.clamp(0, (_visible.length - 1).clamp(0, 1 << 30)));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Moved ${accountTitle(a)} to Trash. You can restore it from Settings for 30 days.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            a.deletedAt = null;
            await widget.vault.save();
            if (mounted) setState(() {});
          },
        ),
      ));
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

  /// Moves visible[from] to visible position [to] by reshuffling only the slots those accounts
  /// hold in the vault, so trashed accounts keep their place.
  Future<void> _reorder(List<Account> visible, int from, int to) async {
    if (from == to || to < 0 || to >= visible.length) return;
    final accounts = widget.vault.accounts;
    final order = [...visible];
    order.insert(to, order.removeAt(from));
    final slots = [for (final a in visible) accounts.indexOf(a)]..sort();
    setState(() {
      for (var k = 0; k < slots.length; k++) {
        accounts[slots[k]] = order[k];
      }
    });
    await widget.vault.save();
  }

  Future<void> _openSettings() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(vault: widget.vault)));
    setState(() {
      if (_tag != null && !_allTags.contains(_tag)) _tag = null;
    });
  }

  Widget _card(List<Account> visible, int i, DateTime now, int unix) {
    final a = visible[i];
    final left = a.type == OtpType.totp ? secondsLeft(unix, period: a.period) : null;
    return SizedBox(
      key: ValueKey(a.id),
      height: _cardHeight,
      child: AccountCard(
        account: a,
        code: a.codeAt(now),
        nextCode: left != null && left <= 5 ? a.codeAt(now.add(Duration(seconds: a.period))) : null,
        left: left,
        hidden: _isHidden(a, now),
        compact: _compact,
        selected: i == _selected && visible.length > 1,
        onTap: () {
          setState(() => _selected = i);
          _copy(a);
        },
        onEdit: () => _edit(a),
        onDelete: () => _delete(a),
        onNext: () => _nextHotp(a),
        onFavorite: () => _toggleFavorite(a),
        onRecoveryCodes: () => _recoveryCodes(a),
        onShare: () => shareAccountFlow(context, widget.vault, a),
        onMove: _canReorder ? (_, d) => _reorder(visible, i, i + d) : null,
      ),
    );
  }

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

  Widget _tagChips(EdgeInsets padding) {
    final tags = _allTags;
    if (tags.isEmpty) return const SizedBox.shrink();
    Widget chip(String label, String? tag) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: _tag == tag,
            showCheckmark: false,
            onSelected: (_) => setState(() {
              _tag = tag;
              _selected = 0;
            }),
          ),
        );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(children: [chip('All', null), for (final t in tags) chip(t, t)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final unix = now.millisecondsSinceEpoch ~/ 1000;
    // Sidebar layout from 700 pt, so an upright iPad mini (744 pt) gets it too.
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final live = _live;
    final visible = _visible;
    final gap = _compact ? 8.0 : 12.0;

    Widget list;
    if (live.isEmpty) {
      list = Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No accounts yet.\nAdd one to scan a setup QR code.',
              textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
        ),
      );
    } else if (visible.isEmpty) {
      list = Center(
          child: Text(_query.isEmpty ? 'No accounts with this tag.' : 'No accounts match your search.',
              style: TextStyle(color: Palette.muted)));
    } else if (wide) {
      // Cards need ~320 pt; narrower columns would squash the code and countdown.
      list = LayoutBuilder(
        builder: (_, box) => GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ((box.maxWidth - 40) / 334).floor().clamp(1, 6),
            mainAxisExtent: _cardHeight,
            crossAxisSpacing: 14,
            mainAxisSpacing: gap + 2,
          ),
          itemCount: visible.length,
          itemBuilder: (_, i) => _card(visible, i, now, unix),
        ),
      );
    } else if (!_canReorder) {
      list = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        itemCount: visible.length,
        separatorBuilder: (_, _) => SizedBox(height: gap),
        itemBuilder: (_, i) => _card(visible, i, now, unix),
      );
    } else {
      list = ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        itemCount: visible.length,
        onReorderItem: (from, to) => _reorder(visible, from, to),
        itemBuilder: (_, i) => Padding(
          key: ValueKey('row-${visible[i].id}'),
          padding: EdgeInsets.only(bottom: gap),
          child: _card(visible, i, now, unix),
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
            CountBadge(live.length),
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
          if (live.length > 3) Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: _search()),
          if (live.length <= 3) const SizedBox(height: 12),
          _tagChips(const EdgeInsets.fromLTRB(16, 0, 16, 8)),
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
                CountBadge(live.length),
                const SizedBox(width: 20),
                Expanded(child: _search()),
                const SizedBox(width: 12),
                FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
              ]),
            ),
            _tagChips(const EdgeInsets.fromLTRB(20, 12, 20, 0)),
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
    required this.onFavorite,
    required this.onRecoveryCodes,
    this.nextCode,
    this.hidden = false,
    this.compact = false,
    this.onMove,
    this.onShare,
  });

  final Account account;
  final String code;
  /// The code after this one, shown when the current one is about to run out.
  final String? nextCode;
  final int? left;
  final bool selected, hidden, compact;
  final VoidCallback onTap, onEdit, onDelete, onNext, onFavorite, onRecoveryCodes;
  final Future<void> Function(Account, int)? onMove;
  final VoidCallback? onShare;

  bool get _urgent => left != null && left! <= 5;

  Widget _menu() {
    final a = account;
    final left = a.recoveryCodes.where((r) => !r.used).length;
    return PopupMenuButton<String>(
      tooltip: 'More',
      iconSize: 18,
      icon: Icon(Icons.more_vert, color: Palette.muted),
      onSelected: (v) => switch (v) {
        'edit' => onEdit(),
        'favorite' => onFavorite(),
        'recovery' => onRecoveryCodes(),
        'share' => onShare?.call(),
        'delete' => onDelete(),
        'earlier' => onMove?.call(a, -1),
        _ => onMove?.call(a, 1),
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'favorite', child: Text(a.favorite ? 'Remove from favorites' : 'Add to favorites')),
        PopupMenuItem(
          value: 'recovery',
          child: Text(a.recoveryCodes.isEmpty ? 'Recovery codes' : 'Recovery codes ($left left)'),
        ),
        if (onShare != null) const PopupMenuItem(value: 'share', child: Text('Share securely')),
        if (onMove != null) const PopupMenuItem(value: 'earlier', child: Text('Move earlier')),
        if (onMove != null) const PopupMenuItem(value: 'later', child: Text('Move later')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }

  Widget _code(double size) {
    final shown = hidden ? groupCode('•' * code.length) : groupCode(code);
    return Text(
      shown,
      semanticsLabel: hidden ? 'Code hidden. Tap to show and copy.' : code.split('').join(' '),
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: _urgent ? Palette.red : Palette.text,
      ),
    );
  }

  Widget? _next() => nextCode == null || hidden
      ? null
      : Text('Next ${groupCode(nextCode!)}',
          semanticsLabel: 'Next code ${nextCode!.split('').join(' ')}',
          style: TextStyle(fontSize: 12, color: Palette.muted, fontFeatures: const [FontFeature.tabularFigures()]));

  Widget _timer() => left == null
      ? TextButton.icon(onPressed: onNext, icon: const Icon(Icons.refresh, size: 18), label: const Text('Next'))
      : Row(mainAxisSize: MainAxisSize.min, children: [
          Text('${left}s', style: TextStyle(fontSize: 12, color: _urgent ? Palette.red : Palette.muted)),
          const SizedBox(width: 8),
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              value: left! / account.period,
              strokeWidth: 3,
              color: _urgent ? Palette.red : Palette.accent,
              backgroundColor: Palette.line,
            ),
          ),
        ]);

  Widget _star() => Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Icon(Icons.star_rounded, size: 16, color: Palette.accent, semanticLabel: 'Favorite'),
      );

  @override
  Widget build(BuildContext context) {
    final a = account;
    final next = _next();
    final kind = a.type == OtpType.totp
        ? 'TOTP · ${a.digits} digits · ${a.period}s'
        : 'HOTP · ${a.digits} digits · #${a.counter}';
    final Widget body;
    if (compact) {
      final sub = [if (a.issuer.isNotEmpty) a.label, ...a.tags].where((s) => s.isNotEmpty).join(' · ');
      body = Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: Row(children: [
          IssuerAvatar(a, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                  child: Text(accountTitle(a),
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                if (a.favorite) _star(),
              ]),
              if (sub.isNotEmpty)
                Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Palette.muted)),
            ]),
          ),
          // Shrinks the code rather than overflow on narrow phones or with big text.
          Flexible(
            flex: 4, // the code wins most of the spare width over the title
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [_code(22), ?next]),
            ),
          ),
          const SizedBox(width: 10),
          _timer(),
          _menu(),
        ]),
      );
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 4, 0),
          child: Row(children: [
            Expanded(child: CapsLabel(kind)),
            if (a.domains.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 170),
                child: Pill(a.domains.first, color: Palette.green),
              ),
            _menu(),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            IssuerAvatar(a, size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(accountTitle(a),
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            if (a.favorite) _star(),
          ]),
        ),
        if ((a.issuer.isNotEmpty && a.label.isNotEmpty) || a.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: Row(children: [
              if (a.issuer.isNotEmpty && a.label.isNotEmpty) ...[
                const CapsLabel('Account'),
                const SizedBox(width: 8),
                Flexible(child: Pill(a.label)),
              ],
              for (final t in a.tags.take(2)) ...[const SizedBox(width: 6), Flexible(child: Pill(t, color: Palette.muted))],
            ]),
          ),
        const Spacer(),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 10, 8),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              _code(26),
              ?next,
            ]),
            const Spacer(),
            _timer(),
          ]),
        ),
      ]);
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: selected ? Palette.accent : Palette.line, width: selected ? 1.5 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, hoverColor: Colors.white.withValues(alpha: 0.03), child: body),
    );
  }
}
