import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../core/account.dart';
import '../core/backup.dart';
import '../core/google_migration.dart';
import '../core/otpauth_uri.dart';
import '../core/vault.dart';
import 'home.dart';

void _say(BuildContext context, String msg) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(msg)));

/// Runs [work] behind a "please wait" dialog the user can't dismiss.
Future<T> _busy<T>(BuildContext context, String text, Future<T> Function() work) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(children: [const CircularProgressIndicator(), const SizedBox(width: 20), Expanded(child: Text(text))]),
      ),
    ),
  );
  try {
    return await work();
  } finally {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}

Future<String?> _askPassphrase(BuildContext context, {required bool forExport}) async {
  final first = TextEditingController(), second = TextEditingController();
  String? error;
  return showDialog<String>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(forExport ? 'Choose a backup passphrase' : 'Backup passphrase'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (forExport)
            const Text(
                'You\'ll need this to restore the backup. Nobody, including us, can recover it if you forget it. Write it down somewhere safe.'),
          TextField(
            controller: first,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Passphrase'),
          ),
          if (forExport)
            TextField(controller: second, obscureText: true, decoration: const InputDecoration(labelText: 'Type it again')),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
            ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final p = first.text;
              if (forExport && p.length < 8) {
                setState(() => error = 'Use at least 8 characters. A few random words works well.');
              } else if (forExport && p != second.text) {
                setState(() => error = 'The two passphrases don\'t match.');
              } else if (p.isEmpty) {
                setState(() => error = 'Type the passphrase.');
              } else {
                Navigator.pop(c, p);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

/// Phones: share sheet (AirDrop, Files, email). Computers: a Save dialog.
Future<bool> _deliver(BuildContext context, String fileName, Uint8List bytes, String mime) async {
  if (Platform.isIOS || Platform.isAndroid) {
    final box = context.findRenderObject() as RenderBox?;
    final result = await SharePlus.instance.share(ShareParams(
      files: [XFile.fromData(bytes, mimeType: mime)],
      fileNameOverrides: [fileName],
      sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    ));
    return result.status != ShareResultStatus.dismissed;
  }
  return await FilePicker.saveFile(fileName: fileName, bytes: bytes, mimeType: mime) != null;
}

String _today() => DateTime.now().toIso8601String().substring(0, 10);

Future<void> exportBackupFlow(BuildContext context, Vault vault) async {
  if (vault.accounts.isEmpty) {
    _say(context, 'There are no accounts to back up yet.');
    return;
  }
  final pass = await _askPassphrase(context, forExport: true);
  if (pass == null || !context.mounted) return;
  final text = await _busy(context, 'Encrypting backup…', () => exportBackup(vault.accounts, pass));
  if (!context.mounted) return;
  final saved = await _deliver(context, 'Tanooki Auth backup ${_today()}.$backupExtension',
      Uint8List.fromList(utf8.encode(text)), 'application/octet-stream');
  if (saved && context.mounted) _say(context, 'Backup of ${vault.accounts.length} accounts saved.');
}

/// Picks a backup file and decrypts it. Returns null if the user cancels or it fails (with a message shown).
Future<List<Account>?> pickAndOpenBackup(BuildContext context) async {
  final files = await FilePicker.pickFiles();
  if (files.isEmpty || !context.mounted) return null;
  final String text;
  try {
    text = utf8.decode(await files.first.readAsBytes());
  } catch (_) {
    if (context.mounted) _say(context, 'That file isn\'t a Tanooki Auth backup.');
    return null;
  }
  while (true) {
    if (!context.mounted) return null;
    final pass = await _askPassphrase(context, forExport: false);
    if (pass == null || !context.mounted) return null;
    try {
      return await _busy(context, 'Unlocking backup…', () => importBackup(text, pass));
    } on BackupException catch (e) {
      if (!context.mounted) return null;
      _say(context, e.message);
      if (!e.message.startsWith('Wrong passphrase')) return null; // only a passphrase is worth retrying
    }
  }
}

Future<void> importBackupFlow(BuildContext context, Vault vault) async {
  final incoming = await pickAndOpenBackup(context);
  if (incoming == null || !context.mounted) return;
  await _mergeAndReport(context, vault, incoming);
}

Future<void> _mergeAndReport(BuildContext context, Vault vault, List<Account> incoming) async {
  final (added, skipped) = mergeAccounts(vault.accounts, incoming);
  await vault.save();
  if (context.mounted) {
    _say(context, skipped == 0 ? 'Imported $added.' : 'Imported $added, skipped $skipped already in your list.');
  }
}

Future<void> importGoogleFlow(BuildContext context, Vault vault, String uri) async {
  final List<Account> incoming;
  try {
    incoming = parseGoogleMigration(uri);
  } on FormatException catch (e) {
    _say(context, e.message);
    return;
  }
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('Import ${incoming.length} from Google Authenticator?'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final a in incoming) Text('• ${accountTitle(a)}${a.issuer.isNotEmpty && a.label.isNotEmpty ? ' (${a.label})' : ''}'),
            const SizedBox(height: 12),
            const Text('If Google Authenticator showed more than one QR code, scan each of them.'),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Import')),
      ],
    ),
  );
  if (ok == true && context.mounted) await _mergeAndReport(context, vault, incoming);
}

Future<void> exportPlainFlow(BuildContext context, Vault vault) async {
  if (vault.accounts.isEmpty) {
    _say(context, 'There are no accounts to export yet.');
    return;
  }
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
      title: const Text('Export unencrypted?'),
      content: const Text(
          'This saves every setup key as plain text, for moving to another authenticator app. Anyone who gets this file can make your login codes. Import it, then delete it straight away. For a normal backup, use "Export backup" instead.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
          onPressed: () => Navigator.pop(c, true),
          child: const Text('I understand, export'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  final text = '${vault.accounts.map(toOtpauthUri).join('\n')}\n';
  await _deliver(context, 'Tanooki Auth setup links ${_today()}.txt', Uint8List.fromList(utf8.encode(text)), 'text/plain');
}
