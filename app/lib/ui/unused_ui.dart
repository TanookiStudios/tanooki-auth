import 'package:flutter/material.dart';

import '../core/account.dart';
import '../core/unused.dart';
import '../core/vault.dart';
import 'brand_icon.dart';
import 'home.dart' show accountTitle;
import 'theme.dart';
import '../l10n/l10n.dart';

/// "Accounts you never use": accounts with no copied code in 6 months or more (never-used ones counted from
/// when they were added). Tick some, then move them to Trash (30 days to change your mind) or tag them.
class UnusedAccountsScreen extends StatefulWidget {
  const UnusedAccountsScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<UnusedAccountsScreen> createState() => _UnusedAccountsScreenState();
}

class _UnusedAccountsScreenState extends State<UnusedAccountsScreen> {
  final _picked = <String>{};

  List<Account> get _unused => unusedAccounts(widget.vault.visible, DateTime.now());
  List<Account> get _pickedAccounts => _unused.where((a) => _picked.contains(a.id)).toList();

  void _say(String msg, {SnackBarAction? action}) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), action: action));

  Future<void> _trash() async {
    final picked = _pickedAccounts;
    if (picked.isEmpty) return _say(l10n.unusedPickFirst);
    final now = DateTime.now().toUtc();
    for (final a in picked) {
      a.deletedAt = now;
    }
    await widget.vault.save();
    if (!mounted) return;
    setState(_picked.clear);
    _say(l10n.homeBulkTrashed(picked.length),
        action: SnackBarAction(
          label: l10n.homeUndo,
          onPressed: () async {
            for (final a in picked) {
              a.deletedAt = null;
            }
            await widget.vault.save();
            if (mounted) setState(() {});
          },
        ));
  }

  Future<void> _tag() async {
    final picked = _pickedAccounts;
    if (picked.isEmpty) return _say(l10n.unusedPickFirst);
    final field = TextEditingController(text: l10n.unusedTagSuggestion);
    final tag = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.homeAddTagTo(picked.length)),
        content: TextField(
          controller: field,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.homeTagHint),
          onSubmitted: (v) => Navigator.pop(c, v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: Text(l10n.homeAddTag)),
        ],
      ),
    );
    field.dispose();
    if (tag == null || tag.isEmpty) return;
    for (final a in picked) {
      if (!a.tags.contains(tag)) a.tags.add(tag);
    }
    await widget.vault.save();
    if (!mounted) return;
    setState(_picked.clear);
    _say(l10n.homeTagged(picked.length, tag));
  }

  @override
  Widget build(BuildContext context) {
    final unused = _unused;
    final all = unused.isNotEmpty && unused.every((a) => _picked.contains(a.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.unusedTitle),
        actions: [
          if (unused.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => all ? _picked.clear() : _picked.addAll(unused.map((a) => a.id))),
              child: Text(all ? l10n.homeSelectNone : l10n.homeSelectAll),
            ),
        ],
      ),
      body: unused.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.unusedNone, textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
              ),
            )
          : ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
              Text(l10n.unusedIntro, style: TextStyle(color: Palette.muted, height: 1.4)),
              const SizedBox(height: 12),
              for (final a in unused)
                Card(
                  child: CheckboxListTile(
                    key: ValueKey('unused-${a.id}'),
                    value: _picked.contains(a.id),
                    onChanged: (v) => setState(() => v == true ? _picked.add(a.id) : _picked.remove(a.id)),
                    secondary: IssuerAvatar(a, size: 32),
                    title: Text(accountTitle(a), style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(a.lastUsedAt == null
                        ? l10n.unusedNeverUsed(a.createdAt.toLocal())
                        : l10n.unusedLastUsed(a.lastUsedAt!.toLocal())),
                  ),
                ),
            ]),
      bottomNavigationBar: unused.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _tag,
                      icon: const Icon(Icons.sell_outlined),
                      label: Text(l10n.homeAddATag),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      key: const Key('unusedTrash'),
                      onPressed: _trash,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.homeMoveToTrash),
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}
