import 'package:flutter/material.dart';

import '../core/account.dart';
import '../core/vault.dart';
import 'clipboard.dart';
import 'home.dart';
import 'theme.dart';

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
        title: const Text('Add recovery codes'),
        content: TextField(
          controller: field,
          autofocus: true,
          minLines: 4,
          maxLines: 10,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(
            hintText: 'Paste the codes the website gave you, one per line',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text), child: const Text('Add')),
        ],
      ),
    );
    if (text == null) return;
    final have = _codes.map((r) => r.code).toSet();
    final fresh = RecoveryCode.parseList(text).where((r) => have.add(r.code)).toList();
    if (fresh.isEmpty) {
      _say('No new codes found in what you pasted.');
      return;
    }
    _codes.addAll(fresh);
    await _save();
    _say('Added ${fresh.length} ${fresh.length == 1 ? 'code' : 'codes'}.');
  }

  Future<void> _copy(RecoveryCode r) async {
    await copyCode(r.code);
    _say(r.used
        ? 'Copied. Heads up: you marked this code as used, so it probably won\'t work again.'
        : 'Copied. The clipboard clears in 30 seconds. Mark it used once you\'ve signed in.');
  }

  Future<void> _remove(RecoveryCode r) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove this code?'),
        content: Text('${r.code}\n\nOnly remove it if the website no longer accepts it.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Remove')),
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
      appBar: AppBar(title: Text('${accountTitle(widget.account)} recovery codes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Add codes'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Text(
            _codes.isEmpty
                ? 'When you turn on two-factor login, most websites also give you a list of backup codes. Each one gets you in once if you ever lose this app. Paste them here so they\'re kept safe with the account.'
                : '$unused of ${_codes.length} unused. Tap a code to copy it, and tick it once you\'ve used it.',
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
                      semanticLabel: 'Used',
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
                    subtitle: r.used ? const Text('Used') : null,
                    onTap: () => _copy(r),
                    trailing: IconButton(
                      tooltip: 'Remove',
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
