import 'package:flutter/material.dart';

import '../core/account.dart';
import '../core/vault.dart';
import 'clipboard.dart';
import 'home.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// The one-time backup codes a website gave out, kept with the account.
class RecoveryCodesScreen extends StatefulWidget {
  const RecoveryCodesScreen({super.key, required this.vault, required this.account});
  final Vault vault;
  final Account account;

  @override
  State<RecoveryCodesScreen> createState() => _RecoveryCodesScreenState();
}

class _RecoveryCodesScreenState extends State<RecoveryCodesScreen> {
  List<RecoveryCode> get _codes => widget.account.recoveryCodes;

  Future<void> _save() async {
    await widget.vault.save();
    if (mounted) setState(() {});
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));

  Future<void> _add() async {
    final field = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.recoveryAddTitle),
        content: TextField(
          controller: field,
          autofocus: true,
          minLines: 4,
          maxLines: 10,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            hintText: l10n.recoveryPasteHint,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text), child: Text(l10n.commonAdd)),
        ],
      ),
    );
    if (text == null) return;
    final have = _codes.map((r) => r.code).toSet();
    final fresh = RecoveryCode.parseList(text).where((r) => have.add(r.code)).toList();
    if (fresh.isEmpty) {
      _say(l10n.recoveryNoneNew);
      return;
    }
    _codes.addAll(fresh);
    await _save();
    _say(l10n.recoveryAdded(fresh.length));
  }

  Future<void> _copy(RecoveryCode r) async {
    await copyCode(r.code);
    _say(r.used
        ? l10n.recoveryCopiedUsed
        : l10n.recoveryCopied);
  }

  Future<void> _remove(RecoveryCode r) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.recoveryRemoveTitle),
        content: Text(l10n.recoveryRemoveBody(r.code)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonRemove)),
        ],
      ),
    );
    if (sure != true) return;
    _codes.remove(r);
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    final unused = _codes.where((r) => !r.used).length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recoveryTitle(accountTitle(widget.account)))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: Text(l10n.recoveryAddCodes),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Text(
            _codes.isEmpty
                ? l10n.recoveryIntro
                : l10n.recoveryUnusedOf('$unused', _codes.length),
            style: TextStyle(color: Palette.muted),
          ),
          const SizedBox(height: 16),
          if (_codes.isNotEmpty)
            Card(
              child: Column(children: [
                for (final (i, r) in _codes.indexed) ...[
                  if (i > 0) const Divider(),
                  ListTile(
                    leading: Checkbox(
                      value: r.used,
                      semanticLabel: l10n.recoveryUsed,
                      onChanged: (v) {
                        r.used = v ?? false;
                        _save();
                      },
                    ),
                    title: Text(
                      r.code,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        color: r.used ? Palette.muted : Palette.text,
                        decoration: r.used ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: r.used ? Text(l10n.recoveryUsed) : null,
                    onTap: () => _copy(r),
                    trailing: IconButton(
                      tooltip: l10n.commonRemove,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _remove(r),
                    ),
                  ),
                ],
              ]),
            ),
        ],
      ),
    );
  }
}
