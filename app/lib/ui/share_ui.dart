import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/account.dart';
import '../core/share.dart';
import '../core/vault.dart';
import 'backup_ui.dart' show busy, deliverFile;
import 'home.dart' show accountTitle;
import 'premium.dart';
import 'sync_ui.dart' show QrView;
import 'theme.dart';

/// "Share securely" from an account's menu. Premium only; free users are sent to the Premium screen.
Future<void> shareAccountFlow(BuildContext context, Vault vault, Account a) async {
  if (!premium.value) {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: vault)));
    if (!premium.value) return;
  }
  if (!context.mounted) return;
  final go = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('Share ${accountTitle(a)}?'),
      content: const Text(
          'The person you share this with gets full access: their phone will make the same codes as yours, for as long as they keep it. '
          'Only share with someone you trust completely, like family.\n\n'
          'Removing it from your list later does not take it back from them. To cut them off, turn two-factor off and on again on the website.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('I understand, share it')),
      ],
    ),
  );
  if (go != true || !context.mounted) return;
  final s = await busy(context, 'Locking the share…', () => createShare(a));
  if (!context.mounted) return;
  await Navigator.push(context, MaterialPageRoute(builder: (_) => _ShareScreen(account: a, text: s.text, code: s.code)));
}

class _ShareScreen extends StatelessWidget {
  const _ShareScreen({required this.account, required this.text, required this.code});
  final Account account;
  final String text, code;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Share ${accountTitle(account)}')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Text('On their device: open Tanooki Auth, tap Add account, then "Scan QR code" (or "Open a shared account" for the file). '
              'Then they type this code:',
              style: TextStyle(color: Palette.muted, height: 1.4)),
          const SizedBox(height: 12),
          Center(
            child: SelectableText('${code.substring(0, 3)} ${code.substring(3)}',
                semanticsLabel: code.split('').join(' '),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 4)),
          ),
          const SizedBox(height: 4),
          Center(child: Text('Tell them the code yourself, out loud or in a different app from the file.', style: TextStyle(color: Palette.muted, fontSize: 13))),
          const SizedBox(height: 20),
          Center(child: QrView(text, size: 240)),
          const SizedBox(height: 16),
          Builder(
            builder: (c) => OutlinedButton.icon(
              icon: const Icon(Icons.ios_share),
              label: const Text('Send as a file instead'),
              onPressed: () => deliverFile(c, '${accountTitle(account).replaceAll(RegExp(r'[^\w .-]'), '')}.$shareExtension', utf8.encode(text), 'application/octet-stream'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy as a link'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied. They paste it with "Paste setup link".')));
              }
            },
          ),
          const SizedBox(height: 12),
          Text('Works for 24 hours, and only with the code. Nothing goes through a server.',
              textAlign: TextAlign.center, style: TextStyle(color: Palette.muted, fontSize: 13)),
        ]),
      );
}

/// Receiver side: asks for the 6-digit code and opens the share. Returns null if they cancel.
Future<Account?> openShareFlow(BuildContext context, String text) async {
  while (context.mounted) {
    final field = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Shared account'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Type the 6-digit code the person who shared it gave you.'),
          const SizedBox(height: 12),
          TextField(
            controller: field,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 7,
            decoration: const InputDecoration(hintText: '123 456', counterText: ''),
            onSubmitted: (v) => Navigator.pop(c, v),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text), child: const Text('Open')),
        ],
      ),
    );
    if (code == null || !context.mounted) return null;
    try {
      return await busy(context, 'Unlocking…', () => openShare(text, code.replaceAll(' ', '')));
    } on ShareException catch (e) {
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
      if (!e.message.startsWith('Wrong code')) return null; // only a mistyped code is worth retrying
    }
  }
  return null;
}
