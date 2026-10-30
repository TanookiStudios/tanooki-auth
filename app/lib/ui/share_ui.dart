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
import '../l10n/l10n.dart';

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
      title: Text(l10n.shareUiConfirmTitle(accountTitle(a))),
      content: Text(l10n.shareUiConfirmBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.shareUiConfirmButton)),
      ],
    ),
  );
  if (go != true || !context.mounted) return;
  final s = await busy(context, l10n.shareUiLocking, () => createShare(a));
  if (!context.mounted) return;
  await Navigator.push(context, MaterialPageRoute(builder: (_) => _ShareScreen(account: a, text: s.text, code: s.code)));
}

class _ShareScreen extends StatelessWidget {
  const _ShareScreen({required this.account, required this.text, required this.code});
  final Account account;
  final String text, code;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(l10n.shareUiTitle(accountTitle(account)))),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Text(l10n.shareUiInstructions,
              style: TextStyle(color: Palette.muted, height: 1.4)),
          const SizedBox(height: 12),
          Center(
            child: SelectableText('${code.substring(0, 3)} ${code.substring(3)}',
                semanticsLabel: code.split('').join(' '),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 4)),
          ),
          const SizedBox(height: 4),
          Center(child: Text(l10n.shareUiTellCode, style: TextStyle(color: Palette.muted, fontSize: 13))),
          const SizedBox(height: 20),
          Center(child: QrView(text, size: 240)),
          const SizedBox(height: 16),
          Builder(
            builder: (c) => OutlinedButton.icon(
              icon: const Icon(Icons.ios_share),
              label: Text(l10n.shareUiSendFile),
              onPressed: () => deliverFile(c, '${accountTitle(account).replaceAll(RegExp(r'[^\w .-]'), '')}.$shareExtension', utf8.encode(text), 'application/octet-stream'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.copy),
            label: Text(l10n.shareUiCopyLink),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.shareUiCopied)));
              }
            },
          ),
          const SizedBox(height: 12),
          Text(l10n.shareUiWorksFor,
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
        title: Text(l10n.shareUiOpenTitle),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.shareUiOpenBody),
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
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text), child: Text(l10n.commonOpen)),
        ],
      ),
    );
    if (code == null || !context.mounted) return null;
    try {
      return await busy(context, l10n.shareUiUnlocking, () => openShare(text, code.replaceAll(' ', '')));
    } on ShareException catch (e) {
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
      if (e.message != l10n.shareWrongCode) return null; // only a mistyped code is worth retrying
    }
  }
  return null;
}
