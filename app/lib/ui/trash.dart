import 'package:flutter/material.dart';

import '../core/account.dart';
import '../core/vault.dart';
import 'brand_icon.dart';
import 'home.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// Deleted accounts wait here for 30 days, then the app removes them for good when it next opens.
class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  int _daysLeft(Account a) =>
      (Vault.trashDays - DateTime.now().toUtc().difference(a.deletedAt!).inDays).clamp(0, Vault.trashDays);

  Future<void> _restore(Account a) async {
    a.deletedAt = null;
    await widget.vault.save();
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.trashRestored(accountTitle(a)))));
  }

  Future<void> _deleteForever(Account a) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.trashDeleteTitle(accountTitle(a))),
        content: Text(
            l10n.trashDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.trashDeleteForGood),
          ),
        ],
      ),
    );
    if (sure != true) return;
    widget.vault.accounts.remove(a);
    await widget.vault.save();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final trash = widget.vault.trash;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trashTitle)),
      body: trash.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.trashEmpty,
                    textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
              ),
            )
          : ListView(padding: const EdgeInsets.all(16), children: [
              Text(l10n.trashNote,
                  style: TextStyle(color: Palette.muted)),
              const SizedBox(height: 16),
              Card(
                child: Column(children: [
                  for (final (i, a) in trash.indexed) ...[
                    if (i > 0) const Divider(),
                    ListTile(
                      leading: IssuerAvatar(a),
                      title: Text(accountTitle(a)),
                      subtitle: Text([
                        if (a.issuer.isNotEmpty && a.label.isNotEmpty) a.label,
                        switch (_daysLeft(a)) { 0 => l10n.trashRemovedNextOpen, final n => l10n.trashDaysLeft(n) },
                      ].join(' · ')),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        TextButton(onPressed: () => _restore(a), child: Text(l10n.trashRestore)),
                        IconButton(
                          tooltip: l10n.trashDeleteForGood,
                          icon: Icon(Icons.delete_forever_outlined, color: Palette.red),
                          onPressed: () => _deleteForever(a),
                        ),
                      ]),
                    ),
                  ],
                ]),
              ),
            ]),
    );
  }
}
