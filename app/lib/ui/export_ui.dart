import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/account.dart';
import '../core/activity.dart';
import '../core/exporters.dart';
import '../core/google_migration.dart';
import '../core/vault.dart';
import 'backup_ui.dart';
import 'security_ui.dart';
import 'sync_ui.dart' show QrView;
import 'theme.dart';
import '../l10n/l10n.dart';

void _say(BuildContext context, String msg) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(msg)));

String _today() => DateTime.now().toIso8601String().substring(0, 10);

/// Settings > "Move to another app": pick where the accounts are going.
Future<void> exportToAppFlow(BuildContext context, Vault vault) async {
  if (vault.visible.isEmpty) {
    _say(context, l10n.backupUiNothingToExport);
    return;
  }
  final choice = await showDialog<String>(
    context: context,
    builder: (c) => SimpleDialog(title: Text(l10n.exportUiTitle), children: [
      for (final (id, title, sub) in [
        ('aegisLocked', l10n.exportUiAegisLocked, l10n.exportUiAegisLockedSub),
        ('aegisPlain', l10n.exportUiAegisPlain, l10n.exportUiAegisPlainSub),
        ('twoFas', '2FAS', l10n.exportUiTwoFasSub),
        ('google', 'Google Authenticator', l10n.exportUiGoogleSub),
        ('links', l10n.exportUiLinks, l10n.exportUiLinksSub),
      ])
        ListTile(title: Text(title), subtitle: Text(sub), onTap: () => Navigator.pop(c, id)),
    ]),
  );
  if (choice == null || !context.mounted) return;
  if (choice == 'links') return exportPlainFlow(context, vault);
  if (!await confirmItsYou(context, vault, l10n.exportUiConfirmReason) || !context.mounted) return;
  final accounts = vault.visible;
  Future<void> save(String name, String text) => _save(context, vault, name, text, accounts.length);
  switch (choice) {
    case 'aegisLocked':
      final pass = await askPassphrase(context, forExport: true);
      if (pass == null || !context.mounted) return;
      final text = await busy(context, l10n.exportUiEncryptingAegis, () => exportAegisEncrypted(accounts, pass));
      if (!context.mounted) return;
      await save('Tanooki Auth for Aegis ${_today()}.json', text);
    case 'aegisPlain':
      if (!await confirmPlainExport(context, what: l10n.exportUiAegisPlainWhat) || !context.mounted) return;
      await save('Tanooki Auth for Aegis (not encrypted) ${_today()}.json', exportAegisPlain(accounts));
    case 'twoFas':
      if (!await confirmPlainExport(context, what: l10n.exportUiTwoFasWhat) || !context.mounted) return;
      await save('Tanooki Auth for 2FAS ${_today()}.2fas', export2fas(accounts));
    case 'google':
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
          title: Text(l10n.exportUiGoogleTitle),
          content: Text(l10n.exportUiGoogleBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
              onPressed: () => Navigator.pop(c, true),
              child: Text(l10n.exportUiShowCodes),
            ),
          ],
        ),
      );
      if (ok != true || !context.mounted) return;
      logActivity(vault, ActivityKind.exported, where: 'Google Authenticator QR codes');
      await vault.save();
      if (!context.mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (_) => GoogleExportScreen(accounts: accounts)));
  }
}

Future<void> _save(BuildContext context, Vault vault, String name, String text, int count) async {
  final saved = await deliverFile(context, name, Uint8List.fromList(utf8.encode(text)), 'application/json');
  if (saved) {
    logActivity(vault, ActivityKind.exported, where: name);
    await vault.save();
  }
  if (saved && context.mounted) {
    _say(context, l10n.exportUiExported(count));
  }
}

/// Google Authenticator "Transfer accounts" QR codes, one page at a time, plus the accounts Google can't hold.
class GoogleExportScreen extends StatefulWidget {
  const GoogleExportScreen({super.key, required this.accounts});
  final List<Account> accounts;

  @override
  State<GoogleExportScreen> createState() => _GoogleExportScreenState();
}

class _GoogleExportScreenState extends State<GoogleExportScreen> {
  late final List<String> _codes = buildGoogleMigration(widget.accounts);
  late final List<Account> _left = widget.accounts.where((a) => googleCantTake(a) != null).toList();
  late final AppLifecycleListener _life;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(onHide: () {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Authenticator')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_codes.isEmpty)
                Text(l10n.exportUiNoneForGoogle, textAlign: TextAlign.center)
              else ...[
                Text(_codes.length == 1 ? l10n.exportUiScanThisCode : l10n.exportUiCodeOf(_page + 1, _codes.length),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                QrView(_codes[_page], size: 260),
                const SizedBox(height: 12),
                if (_codes.length > 1)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton.icon(
                      onPressed: _page == 0 ? null : () => setState(() => _page--),
                      icon: const Icon(Icons.chevron_left),
                      label: Text(l10n.commonBack),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _page == _codes.length - 1 ? null : () => setState(() => _page++),
                      icon: const Icon(Icons.chevron_right),
                      label: Text(l10n.exportUiNextCode),
                    ),
                  ]),
              ],
              if (_left.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(l10n.exportUiLeftOut(_left.length),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                for (final a in _left)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.exportUiLeftOutLine(accountNameWithLabel(a), googleCantTake(a) ?? ''),
                        style: TextStyle(color: Palette.muted)),
                  ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
