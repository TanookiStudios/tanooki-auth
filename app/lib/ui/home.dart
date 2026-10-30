import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../core/account.dart';
import '../core/activity.dart';
import '../core/clock_check.dart';
import '../core/otpauth_uri.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import '../core/widget_share.dart' show showCopiedCodeActivity;
import 'account_details.dart';
import 'add.dart';
import 'brand_icon.dart';
import 'home_cards.dart';
import 'clipboard.dart';
import 'code_view.dart';
import 'recovery_codes.dart';
import 'security_ui.dart';
import 'settings.dart';
import 'share_ui.dart';
import 'sync_ui.dart' show QrView;
import 'team_ui.dart';
import 'theme.dart';

String groupCode(String code) => codeGroups(code).join(' ');

String accountTitle(Account a) => a.issuer.isNotEmpty ? a.issuer : a.label;

/// Settings keys for the home list (stored in vault.settings).
const recentFirstKey = 'recentFirst', hideCodesKey = 'hideCodes', layoutKey = 'layout';
/// Folder names folded away on the home list ('' is "No folder").
const collapsedFoldersKey = 'collapsedFolders';

/// An account id the home list should show (a tapped Spotlight result). The list searches for it.
final openAccountRequest = ValueNotifier<String?>(null);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// A folder's title row on the home list. [name] null is "No folder".
class _Section {
  const _Section(this.name, this.count);
  final String? name;
  final int count;
}

class _HomeScreenState extends State<HomeScreen> {
  late final Timer _tick;
  int _selected = 0;
  String _query = '';
  String? _tag;
  final _revealed = <String, DateTime>{}; // account id -> when its hidden code was tapped
  final _proved = <String, DateTime>{}; // account id -> when Face ID etc. let an "ask first" account show its code
  final _focus = FocusNode();
  final _searchText = TextEditingController();
  bool _selecting = false;
  final _picked = <String>{}; // account ids ticked in select mode

  Map<String, dynamic> get _settings => widget.vault.settings;
  String get _sort => sortOf(_settings);
  bool get _hideCodes => _settings[hideCodesKey] == true;
  bool get _compact => _settings[layoutKey] == 'compact';
  double get _cardHeight => _compact ? 92 : 196; // roomy needs room for the "Next" line in the last 5 s

  List<Account> get _live => widget.vault.visible;

  List<String> get _allTags => {for (final a in _live) ...a.tags}.toList()..sort();

  bool get _hasFolders => _live.any((a) => a.folder != null);
  Set<String> get _collapsed => {...((_settings[collapsedFoldersKey] as List?) ?? const []).cast<String>()};
  bool get _filtering => _query.trim().isNotEmpty || _tag != null;

  /// Everything matching the search and tag, in list order (folders included, collapsed or not).
  List<Account> get _filtered {
    final q = _query.trim().toLowerCase();
    return homeOrder(_live, sort: _sort)
        .where((a) => _tag == null || a.tags.contains(_tag))
        .where((a) => q.isEmpty || [a.issuer, a.label, ...a.domains, ...a.tags, ?a.folder].any((f) => f.toLowerCase().contains(q)))
        .toList();
  }

  /// The cards on screen, in screen order: grouped by folder when there are folders, minus collapsed ones.
  List<Account> get _visible => _rows(_filtered).whereType<Account>().toList();

  /// Folder title rows and cards, in screen order. Without folders: just the cards.
  List<Object> _rows(List<Account> filtered) {
    if (!_hasFolders) return filtered;
    final collapsed = _collapsed;
    final rows = <Object>[];
    for (final f in [...folderNames(_live), null]) {
      final inside = filtered.where((a) => a.folder == f).toList();
      if (inside.isEmpty) continue; // e.g. a folder whose cards are all filtered out
      rows.add(_Section(f, inside.length));
      if (!collapsed.contains(f ?? '')) rows.addAll(inside);
    }
    return rows;
  }

  // Dragging only makes sense when the list shows the user's own order, unfiltered.
  bool get _canReorder => !_filtering && _sort == 'custom' && !_selecting;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
      ClockCheck.instance.maybeRun(); // at most hourly, while codes are on screen
    });
    ClockCheck.instance.maybeRun();
    openAccountRequest.addListener(_showRequested);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRequested());
  }

  /// Narrows the list to the account [openAccountRequest] names, by searching for its name.
  void _showRequested() {
    final id = openAccountRequest.value;
    if (id == null) return;
    openAccountRequest.value = null;
    final a = _live.where((x) => x.id == id).firstOrNull;
    if (a == null || !mounted) return; // deleted since Spotlight listed it, or the decoy vault is open
    // Short lists (and phones with 3 or fewer accounts) have no search box: just select the card there.
    final searchShown = _live.length > 3 || MediaQuery.sizeOf(context).width >= 700;
    setState(() {
      _searchText.text = _query = searchShown ? accountTitle(a) : '';
      _tag = null;
      _selecting = false;
      _selected = _visible.indexOf(a).clamp(0, 1 << 30);
    });
  }

  @override
  void dispose() {
    _tick.cancel();
    openAccountRequest.removeListener(_showRequested);
    _searchText.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// How long a code stays shown after Face ID (or a tap, with "Hide codes until tapped").
  static const _showFor = Duration(seconds: 20);

  bool _isHidden(Account a, DateTime now) {
    if (a.requireAuth) {
      final t = _proved[a.id];
      return t == null || now.difference(t) > _showFor;
    }
    if (!_hideCodes) return false;
    final t = _revealed[a.id];
    return t == null || now.difference(t) > _showFor;
  }

  /// For accounts set to "ask first": Face ID / Touch ID / passcode before the code is shown, copied or shared.
  /// True when it's fine to go ahead.
  Future<bool> _prove(Account a, String why) async {
    if (!a.requireAuth || !_isHidden(a, DateTime.now())) return true;
    if (!await confirmItsYou(context, widget.vault, '$why ${accountTitle(a)}')) return false;
    _proved[a.id] = DateTime.now();
    return true;
  }

  void _say(String msg, {SnackBarAction? action}) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), action: action));

  Future<void> _copy(Account a) async {
    if (!await _prove(a, 'Copy the code for') || !mounted) return;
    final now = DateTime.now();
    _revealed[a.id] = now;
    await copyCode(a.codeAt(now));
    showCopiedCodeActivity(widget.vault, a, now);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Copied ${accountTitle(a)} code. The clipboard clears in 30 seconds.'),
        duration: const Duration(seconds: 2),
      ));
    a.lastUsedAt = DateTime.now().toUtc();
    logActivity(widget.vault, ActivityKind.copied, accountId: a.id, where: 'This app');
    await widget.vault.save();
    if (mounted) setState(() => _selected = _visible.indexOf(a).clamp(0, 1 << 30));
  }

  /// Speaks the code slowly. "Ask first" accounts ask for Face ID etc. first, like copying does.
  Future<void> _readAloud(Account a) async {
    if (!await _prove(a, 'Read aloud the code for') || !mounted) return;
    await readAloud(a, a.codeAt(DateTime.now()));
  }

  Future<void> _add() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddScreen(vault: widget.vault)));
    setState(() {});
  }

  Future<void> _edit(Account a) async {
    // The edit window previews the code, so "ask first" accounts ask here too (also stops turning it off unseen).
    if (!await _prove(a, 'Edit') || !mounted) return;
    final changed = await showAccountDialog(context, a,
        title: 'Edit account', confirm: 'Save', folders: folderNames(_live), existing: true);
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

  Future<void> _showQr(Account a) async {
    if (!await confirmItsYou(context, widget.vault, 'Show the QR code for ${accountTitle(a)}') || !mounted) return;
    final shownAt = DateTime.now();
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AccountQrScreen(account: a)));
    logActivity(widget.vault, ActivityKind.shownQr, accountId: a.id, where: 'This app', now: shownAt);
    await widget.vault.save();
  }

  Future<void> _delete(Account a) async {
    a.deletedAt = DateTime.now().toUtc();
    await widget.vault.save();
    if (!mounted) return;
    setState(() => _selected = _selected.clamp(0, (_visible.length - 1).clamp(0, 1 << 30)));
    _say('Moved ${accountTitle(a)} to Trash. You can restore it from Settings for 30 days.',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            a.deletedAt = null;
            await widget.vault.save();
            if (mounted) setState(() {});
          },
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

  /// Puts [order] (a reshuffle of the accounts on screen) into the vault by reusing only the slots those
  /// accounts hold there, so trashed and hidden accounts keep their place.
  Future<void> _applyOrder(List<Account> before, List<Account> order) async {
    final accounts = widget.vault.accounts;
    final slots = [for (final a in before) accounts.indexOf(a)]..sort();
    setState(() {
      for (var k = 0; k < slots.length; k++) {
        accounts[slots[k]] = order[k];
      }
    });
    await widget.vault.save();
  }

  /// Moves visible[from] to visible position [to].
  Future<void> _reorder(List<Account> visible, int from, int to) async {
    if (from == to || to < 0 || to >= visible.length) return;
    final order = [...visible];
    order.insert(to, order.removeAt(from));
    await _applyOrder(visible, order);
  }

  /// Drag in the folder view: a card dropped under a folder's title moves into that folder.
  Future<void> _reorderRows(List<Object> rows, int from, int to) async {
    if (from == to || rows[from] is! Account) return;
    final before = rows.whereType<Account>().toList();
    final moved = rows.removeAt(from) as Account;
    rows.insert(to, moved);
    final header = rows.sublist(0, to).whereType<_Section>().lastOrNull ?? rows.whereType<_Section>().first;
    moved.folder = header.name;
    await _applyOrder(before, rows.whereType<Account>().toList());
  }

  Future<void> _toggleFolder(String? name) async {
    final c = _collapsed;
    final key = name ?? '';
    c.contains(key) ? c.remove(key) : c.add(key);
    _settings[collapsedFoldersKey] = c.toList()..sort();
    setState(() {});
    await widget.vault.save();
  }

  Future<void> _openSettings() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(vault: widget.vault)));
    setState(() {
      if (_tag != null && !_allTags.contains(_tag)) _tag = null;
    });
  }

  // ---------- select many ----------

  void _startSelecting() => setState(() {
        _selecting = true;
        _picked.clear();
      });

  void _stopSelecting() => setState(() {
        _selecting = false;
        _picked.clear();
      });

  void _togglePick(Account a) => setState(() => _picked.contains(a.id) ? _picked.remove(a.id) : _picked.add(a.id));

  List<Account> get _pickedAccounts => _live.where((a) => _picked.contains(a.id)).toList();

  Future<void> _bulkDone(String msg, {SnackBarAction? action}) async {
    await widget.vault.save();
    if (!mounted) return;
    _stopSelecting();
    _say(msg, action: action);
  }

  String _count(int n) => n == 1 ? '1 account' : '$n accounts';

  Future<void> _bulkTag() async {
    final picked = _pickedAccounts;
    if (picked.isEmpty) return;
    final field = TextEditingController();
    final tag = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Add a tag to ${_count(picked.length)}'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            controller: field,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Tag (e.g. work)'),
            onSubmitted: (v) => Navigator.pop(c, v.trim()),
          ),
          if (_allTags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 4, children: [
              for (final t in _allTags) ActionChip(label: Text(t), onPressed: () => Navigator.pop(c, t)),
            ]),
          ],
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('Add tag')),
        ],
      ),
    );
    if (tag == null || tag.isEmpty) return;
    for (final a in picked) {
      if (!a.tags.contains(tag)) a.tags.add(tag);
    }
    await _bulkDone('Tagged ${_count(picked.length)} "$tag".');
  }

  Future<void> _bulkFolder() async {
    final picked = _pickedAccounts;
    if (picked.isEmpty) return;
    final field = TextEditingController();
    // Returns the folder name, '' for "No folder", or null when canceled.
    final folder = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Move ${_count(picked.length)} to a folder'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            for (final f in folderNames(_live))
              ListTile(leading: const Icon(Icons.folder_outlined), title: Text(f), onTap: () => Navigator.pop(c, f)),
            ListTile(leading: const Icon(Icons.folder_off_outlined), title: const Text('No folder'), onTap: () => Navigator.pop(c, '')),
            TextField(
              controller: field,
              decoration: const InputDecoration(labelText: 'Or a new folder (e.g. Work)'),
              onSubmitted: (v) => v.trim().isEmpty ? null : Navigator.pop(c, v.trim()),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => field.text.trim().isEmpty ? null : Navigator.pop(c, field.text.trim()),
            child: const Text('Move to new folder'),
          ),
        ],
      ),
    );
    if (folder == null) return;
    for (final a in picked) {
      a.folder = folder.isEmpty ? null : folder;
    }
    await _bulkDone(folder.isEmpty ? 'Took ${_count(picked.length)} out of their folders.' : 'Moved ${_count(picked.length)} to $folder.');
  }

  Future<void> _bulkFavorite() async {
    final picked = _pickedAccounts;
    if (picked.isEmpty) return;
    final on = !picked.every((a) => a.favorite);
    for (final a in picked) {
      a.favorite = on;
    }
    await _bulkDone(on ? 'Added ${_count(picked.length)} to favorites.' : 'Removed ${_count(picked.length)} from favorites.');
  }

  Future<void> _bulkTrash() async {
    final picked = _pickedAccounts;
    if (picked.isEmpty) return;
    final now = DateTime.now().toUtc();
    for (final a in picked) {
      a.deletedAt = now;
    }
    _selected = 0;
    await _bulkDone('Moved ${_count(picked.length)} to Trash. You can restore them from Settings for 30 days.',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            for (final a in picked) {
              a.deletedAt = null;
            }
            await widget.vault.save();
            if (mounted) setState(() {});
          },
        ));
  }

  Widget _selectionBar(EdgeInsets padding) {
    final picked = _pickedAccounts;
    final none = picked.isEmpty;
    final allFav = !none && picked.every((a) => a.favorite);
    final all = _visible;
    return Padding(
      padding: padding,
      child: Material(
        color: Palette.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Palette.line)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(children: [
            IconButton(tooltip: 'Done selecting', icon: const Icon(Icons.close), onPressed: _stopSelecting),
            Expanded(
              child: Text(none ? 'Tap accounts to select' : '${picked.length} selected',
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            IconButton(
              tooltip: picked.length == all.length ? 'Select none' : 'Select all',
              icon: Icon(picked.length == all.length && !none ? Icons.deselect : Icons.select_all),
              onPressed: () => setState(() {
                if (picked.length == all.length) {
                  _picked.clear();
                } else {
                  _picked.addAll(all.map((a) => a.id));
                }
              }),
            ),
            // Disabled-looking buttons still say why when pressed.
            for (final (icon, tip, run) in [
              (Icons.sell_outlined, 'Add a tag', _bulkTag),
              (Icons.drive_file_move_outlined, 'Move to folder', _bulkFolder),
              (allFav ? Icons.star_rounded : Icons.star_outline_rounded, allFav ? 'Remove from favorites' : 'Add to favorites', _bulkFavorite),
              (Icons.delete_outline, 'Move to Trash', _bulkTrash),
            ])
              IconButton(
                tooltip: tip,
                icon: Icon(icon, color: none ? Palette.muted : null),
                onPressed: none ? () => _say('Select some accounts first: tap them in the list.') : run,
              ),
          ]),
        ),
      ),
    );
  }

  // ---------- list ----------

  Widget _card(List<Account> visible, int i, DateTime now, int unix) {
    final a = visible[i];
    final left = a.timeBased ? secondsLeft(unix, period: a.period) : null;
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
        countdownStyle: countdownOf(_settings),
        onReadAloud: () => _readAloud(a),
        selected: !_selecting && i == _selected && visible.length > 1,
        picked: _selecting ? _picked.contains(a.id) : null,
        onTap: () {
          if (_selecting) return _togglePick(a);
          setState(() => _selected = i);
          _copy(a);
        },
        onEdit: () => _edit(a),
        onDelete: () => _delete(a),
        onNext: () => _nextHotp(a),
        onFavorite: () => _toggleFavorite(a),
        onRecoveryCodes: () => _recoveryCodes(a),
        onShare: () async {
          if (await _prove(a, 'Share') && mounted) await shareAccountFlow(context, widget.vault, a);
        },
        onShowQr: () => _showQr(a),
        onMove: _canReorder ? (_, d) => _reorder(visible, i, i + d) : null,
      ),
    );
  }

  Widget _sectionHeader(_Section s) {
    final open = !_collapsed.contains(s.name ?? '');
    final name = s.name ?? 'No folder';
    return Semantics(
      button: true,
      expanded: open,
      label: '$name, ${_count(s.count)}, ${open ? 'tap to fold away' : 'tap to show'}',
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('folder-${s.name ?? ''}'),
        borderRadius: BorderRadius.circular(8),
        onTap: () => _toggleFolder(s.name),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(children: [
            Icon(open ? Icons.expand_more : Icons.chevron_right, color: Palette.muted),
            const SizedBox(width: 4),
            Icon(s.name == null ? Icons.folder_off_outlined : Icons.folder_outlined, size: 20, color: Palette.muted),
            const SizedBox(width: 8),
            Flexible(
              child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            CountBadge(s.count),
          ]),
        ),
      ),
    );
  }

  Widget _search() => TextField(
        controller: _searchText,
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

  Widget _list(bool wide, DateTime now, int unix) {
    final live = _live;
    final rows = _rows(_filtered);
    final visible = rows.whereType<Account>().toList();
    final gap = _compact ? 8.0 : 12.0;
    if (live.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No accounts yet.\nAdd one to scan a setup QR code.',
              textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
        ),
      );
    }
    if (rows.isEmpty) {
      return Center(
          child: Text(_query.isEmpty ? 'No accounts with this tag.' : 'No accounts match your search.',
              style: TextStyle(color: Palette.muted)));
    }
    if (wide) {
      // Cards need ~320 pt; narrower columns would squash the code and countdown.
      return LayoutBuilder(builder: (_, box) {
        SliverGridDelegate grid() => SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ((box.maxWidth - 40) / 334).floor().clamp(1, 6),
              mainAxisExtent: _cardHeight,
              crossAxisSpacing: 14,
              mainAxisSpacing: gap + 2,
            );
        final slivers = <Widget>[];
        var run = <Account>[];
        void flush() {
          if (run.isEmpty) return;
          final cards = run;
          slivers.add(SliverGrid.builder(
            gridDelegate: grid(),
            itemCount: cards.length,
            itemBuilder: (_, k) => _card(visible, visible.indexOf(cards[k]), now, unix),
          ));
          run = [];
        }

        for (final r in rows) {
          if (r is _Section) {
            flush();
            slivers.add(SliverToBoxAdapter(
                child: Padding(padding: EdgeInsets.only(top: slivers.isEmpty ? 0 : 12, bottom: 6), child: _sectionHeader(r))));
          } else {
            run.add(r as Account);
          }
        }
        flush();
        return CustomScrollView(slivers: [SliverPadding(padding: const EdgeInsets.all(20), sliver: SliverMainAxisGroup(slivers: slivers))]);
      });
    }
    Widget row(int i) {
      final r = rows[i];
      if (r is _Section) return Padding(key: ValueKey('section-${r.name ?? ''}'), padding: EdgeInsets.only(bottom: gap / 2), child: _sectionHeader(r));
      final a = r as Account;
      final card = _card(visible, visible.indexOf(a), now, unix);
      return Padding(key: ValueKey('row-${a.id}'), padding: EdgeInsets.only(bottom: gap), child: card);
    }

    const pad = EdgeInsets.fromLTRB(16, 4, 16, 96);
    if (!_canReorder) return ListView.builder(padding: pad, itemCount: rows.length, itemBuilder: (_, i) => row(i));
    if (!_hasFolders) {
      return ReorderableListView.builder(
        padding: pad,
        itemCount: rows.length,
        onReorderItem: (from, to) => _reorder(visible, from, to),
        itemBuilder: (_, i) => row(i),
      );
    }
    // With folders, only cards can be picked up (press and hold); the folder titles stay put.
    return ReorderableListView.builder(
      padding: pad,
      itemCount: rows.length,
      buildDefaultDragHandles: false,
      onReorderItem: (from, to) => _reorderRows([...rows], from, to),
      itemBuilder: (_, i) {
        final w = row(i);
        return rows[i] is Account ? ReorderableDelayedDragStartListener(key: w.key, index: i, child: w) : w;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final unix = now.millisecondsSinceEpoch ~/ 1000;
    // Sidebar layout from 700 pt, so an upright iPad mini (744 pt) gets it too. From 900 the list becomes
    // one column with a details pane beside it ([_split]).
    final width = MediaQuery.sizeOf(context).width;
    final split = width >= 900, wide = width >= 700 && !split;
    final live = _live;

    Widget list = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (_visible.isNotEmpty && !_selecting) _copy(_visible[_selected.clamp(0, _visible.length - 1)]);
        },
        const SingleActivator(LogicalKeyboardKey.numpadEnter): () {
          if (_visible.isNotEmpty && !_selecting) _copy(_visible[_selected.clamp(0, _visible.length - 1)]);
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (_selecting) _stopSelecting();
        },
      },
      child: Focus(focusNode: _focus, autofocus: true, child: _list(wide, now, unix)),
    );

    final selectButton = live.isEmpty || _selecting
        ? null
        : IconButton(tooltip: 'Select accounts', icon: const Icon(Icons.checklist), onPressed: _startSelecting);

    if (split) return _split(list, live, selectButton, now, unix);

    if (!wide) {
      return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            const Flexible(child: Text('Tanooki Auth', maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 10),
            CountBadge(live.length),
          ]),
          actions: [
            ?selectButton,
            IconButton(tooltip: 'Settings', icon: const Icon(Icons.settings_outlined), onPressed: _openSettings),
          ],
        ),
        floatingActionButton: _selecting
            ? null
            : FloatingActionButton.extended(
                onPressed: _add,
                icon: const Icon(Icons.add),
                label: const Text('Add account'),
              ),
        body: Column(children: [
          if (live.length > 3) Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: _search()),
          if (live.length <= 3) const SizedBox(height: 12),
          _tagChips(const EdgeInsets.fromLTRB(16, 0, 16, 8)),
          HomeNotices(vault: widget.vault, padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), onChanged: () => setState(() {})),
          TeamHomeSection(vault: widget.vault, padding: const EdgeInsets.fromLTRB(16, 0, 16, 8)),
          if (_selecting) _selectionBar(const EdgeInsets.fromLTRB(16, 0, 16, 8)),
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
                // Gives way first on an upright iPad mini, where the row is tight.
                const Flexible(child: Text('Your accounts', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                const SizedBox(width: 10),
                CountBadge(live.length),
                const SizedBox(width: 20),
                Expanded(child: _search()),
                const SizedBox(width: 12),
                if (selectButton != null) ...[
                  OutlinedButton.icon(onPressed: _startSelecting, icon: const Icon(Icons.checklist, size: 18), label: const Text('Select')),
                  const SizedBox(width: 8),
                ],
                FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
              ]),
            ),
            _tagChips(const EdgeInsets.fromLTRB(20, 12, 20, 0)),
            HomeNotices(vault: widget.vault, padding: const EdgeInsets.fromLTRB(20, 12, 20, 0), onChanged: () => setState(() {})),
            TeamHomeSection(vault: widget.vault, padding: const EdgeInsets.fromLTRB(20, 12, 20, 0)),
            if (_selecting) _selectionBar(const EdgeInsets.fromLTRB(20, 12, 20, 0)),
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

  /// Wide layout (900 px and up): the list on the left, the selected account's details on the right.
  Widget _split(Widget list, List<Account> live, Widget? selectButton, DateTime now, int unix) {
    final visible = _visible;
    final a = visible.isEmpty ? null : visible[_selected.clamp(0, visible.length - 1)];
    return Scaffold(
      body: Row(children: [
        Sidebar(onAdd: _add, onSettings: _openSettings),
        const VerticalDivider(width: 1),
        SizedBox(
          width: 380,
          child: Column(children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Palette.line))),
              child: Row(children: [
                const Text('Accounts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(width: 10),
                CountBadge(live.length),
                const Spacer(),
                ?selectButton,
              ]),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: _search()),
            _tagChips(const EdgeInsets.fromLTRB(16, 0, 16, 8)),
            HomeNotices(vault: widget.vault, padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), onChanged: () => setState(() {})),
            if (_selecting) _selectionBar(const EdgeInsets.fromLTRB(16, 0, 16, 8)),
            Expanded(child: list),
          ]),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: a == null
              ? Center(child: Text('Pick an account on the left to see it here.', style: TextStyle(color: Palette.muted)))
              : AccountDetails(
                  key: ValueKey('details-${a.id}'),
                  account: a,
                  code: a.codeAt(now),
                  left: a.timeBased ? secondsLeft(unix, period: a.period) : null,
                  hidden: _isHidden(a, now),
                  countdownStyle: countdownOf(_settings),
                  onCopy: () => _copy(a),
                  onReadAloud: () => _readAloud(a),
                  onShowQr: () => _showQr(a),
                  onRecoveryCodes: () => _recoveryCodes(a),
                  onEdit: () => _edit(a),
                  onNext: () => _nextHotp(a),
                ),
        ),
      ]),
    );
  }
}

/// One account's setup QR code, for adding it to another app or device. Closes itself after 30 seconds,
/// or as soon as the app goes to the background.
class AccountQrScreen extends StatefulWidget {
  const AccountQrScreen({super.key, required this.account});
  final Account account;
  static const showFor = 30;

  @override
  State<AccountQrScreen> createState() => _AccountQrScreenState();
}

class _AccountQrScreenState extends State<AccountQrScreen> {
  late final Timer _tick;
  late final AppLifecycleListener _life;
  int _left = AccountQrScreen.showFor;

  void _close() {
    if (mounted && ModalRoute.of(context)?.isCurrent == true) Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _left--);
      if (_left <= 0) _close();
    });
    _life = AppLifecycleListener(onHide: _close);
  }

  @override
  void dispose() {
    _tick.cancel();
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.account;
    return Scaffold(
      appBar: AppBar(title: Text('QR code for ${accountTitle(a)}')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            QrView(toOtpauthUri(a), size: 240),
            const SizedBox(height: 16),
            Text(accountTitle(a), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            if (a.issuer.isNotEmpty && a.label.isNotEmpty) Text(a.label, style: TextStyle(color: Palette.muted)),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                'Scan this with another authenticator app to add the same account there. Anyone who sees or photographs it can make your codes, so keep it private.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.muted, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            Text('Hides in $_left seconds', key: const Key('qrCountdown'), style: TextStyle(color: Palette.red, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), // 48 px tall: easy to hit
                child: Row(children: [
                  Icon(icon, size: 20, color: active ? Palette.text : Palette.muted),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600, color: active ? Palette.text : Palette.muted)),
                  ),
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
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('TANOOKI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 3)),
                  Text('AUTH', style: TextStyle(fontSize: 11, letterSpacing: 5, color: Palette.muted)),
                ]),
              ),
            ),
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

class AccountCard extends StatefulWidget {
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
    this.onShowQr,
    this.picked,
    this.countdownStyle = 'ring',
    this.onReadAloud,
  });

  final Account account;
  final String code;
  /// The code after this one, shown when the current one is about to run out.
  final String? nextCode;
  final int? left;
  final bool selected, hidden, compact;
  final VoidCallback onTap, onEdit, onDelete, onNext, onFavorite, onRecoveryCodes;
  final Future<void> Function(Account, int)? onMove;
  final VoidCallback? onShare, onShowQr;
  /// Select mode: whether this card is ticked. Null when not selecting (shows the menu instead).
  final bool? picked;
  /// How the time left is drawn: 'ring', 'bar' or 'number' (Settings > Countdown style).
  final String countdownStyle;
  /// Reads the code aloud (asking first for "ask first" accounts). Null hides the speaker button.
  final VoidCallback? onReadAloud;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  final _menuKey = GlobalKey<PopupMenuButtonState<String>>();

  Account get account => widget.account;
  String get code => widget.code;
  String? get nextCode => widget.nextCode;
  int? get left => widget.left;
  bool get hidden => widget.hidden;
  bool? get picked => widget.picked;
  bool get _urgent => left != null && left! <= 5;
  VoidCallback? get _readAloud => picked == null && readAloudSupported ? widget.onReadAloud : null;

  Widget _menu() {
    final a = account;
    final w = widget;
    if (picked != null) {
      return Checkbox(value: picked, onChanged: (_) => w.onTap(), semanticLabel: 'Select ${accountTitle(a)}');
    }
    final left = a.recoveryCodes.where((r) => !r.used).length;
    return PopupMenuButton<String>(
      key: _menuKey,
      tooltip: 'More',
      iconSize: 18,
      icon: Icon(Icons.more_vert, color: Palette.muted),
      onSelected: (v) => switch (v) {
        'edit' => w.onEdit(),
        'favorite' => w.onFavorite(),
        'recovery' => w.onRecoveryCodes(),
        'share' => w.onShare?.call(),
        'qr' => w.onShowQr?.call(),
        'delete' => w.onDelete(),
        'earlier' => w.onMove?.call(a, -1),
        _ => w.onMove?.call(a, 1),
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'favorite', child: Text(a.favorite ? 'Remove from favorites' : 'Add to favorites')),
        PopupMenuItem(
          value: 'recovery',
          child: Text(a.recoveryCodes.isEmpty ? 'Recovery codes' : 'Recovery codes ($left left)'),
        ),
        if (w.onShare != null) const PopupMenuItem(value: 'share', child: Text('Share securely')),
        if (w.onShowQr != null) const PopupMenuItem(value: 'qr', child: Text('Show QR code')),
        if (w.onMove != null) const PopupMenuItem(value: 'earlier', child: Text('Move earlier')),
        if (w.onMove != null) const PopupMenuItem(value: 'later', child: Text('Move later')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }

  Widget _code(double size) {
    final shown = hidden ? groupCode('•' * code.length) : groupCode(code);
    return Text(
      shown,
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
          style: TextStyle(fontSize: 12, color: Palette.muted, fontFeatures: const [FontFeature.tabularFigures()]));

  Widget _timer() => left == null
      ? TextButton.icon(onPressed: widget.onNext, icon: const Icon(Icons.refresh, size: 18), label: const Text('Next code'))
      : Countdown(left: left!, period: account.period, style: widget.countdownStyle);

  /// The whole card is one screen-reader item: name, code in groups and time left; tap copies, and the
  /// speaker, "Next code" and menu buttons are its actions.
  String get _semanticsLabel {
    final a = account;
    final parts = [
      accountTitle(a),
      if (a.issuer.isNotEmpty && a.label.isNotEmpty) a.label,
      if (a.favorite) 'Favorite',
      hidden ? (a.requireAuth ? 'Code hidden until you confirm it is you' : 'Code hidden') : codeSemantics(code, left),
      if (nextCode != null && !hidden) 'Next code ${spokenCode(nextCode!)}',
    ];
    return parts.join('. ');
  }

  Widget _star() => Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Icon(Icons.star_rounded, size: 16, color: Palette.accent, semanticLabel: 'Favorite'),
      );

  @override
  Widget build(BuildContext context) {
    final a = account;
    final w = widget;
    final compact = w.compact;
    final next = _next();
    final speaker = _readAloud == null ? null : ReadAloudButton(onPressed: _readAloud!);
    final kind = switch (a.type) {
      OtpType.totp => 'TOTP · ${a.digits} digits · ${a.period}s',
      OtpType.steam => 'Steam · 5 characters · ${a.period}s',
      OtpType.hotp => 'HOTP · ${a.digits} digits · #${a.counter}',
    };
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
          ?speaker,
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
            // Shrinks the code rather than overflow next to a wide button (HOTP "Next code") or big text.
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  _code(26),
                  ?next,
                ]),
              ),
            ),
            _timer(),
            ?speaker,
          ]),
        ),
      ]);
    }
    return Semantics(
      container: true,
      button: true,
      selected: picked ?? false,
      label: _semanticsLabel,
      onTapHint: picked != null ? (picked! ? 'unselect' : 'select') : 'copy the code',
      onTap: w.onTap,
      customSemanticsActions: {
        const CustomSemanticsAction(label: 'Read code aloud'): ?_readAloud,
        if (left == null) const CustomSemanticsAction(label: 'Next code'): w.onNext,
        if (picked == null) const CustomSemanticsAction(label: 'More options'): () => _menuKey.currentState?.showButtonMenu(),
      },
      excludeSemantics: true,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: w.selected ? Palette.accent : Palette.line, width: w.selected ? 1.5 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: w.onTap, hoverColor: Colors.white.withValues(alpha: 0.03), child: body),
      ),
    );
  }
}
