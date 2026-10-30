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
import '../core/paper_backup.dart';
import '../core/security.dart';
import '../core/tidy.dart';
import '../core/vault.dart';
import 'brand_icon.dart';
import 'home.dart';

void _say(BuildContext context, String msg) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(msg)));

/// Runs [work] behind a "please wait" dialog the user can't dismiss.
Future<T> busy<T>(BuildContext context, String text, Future<T> Function() work) async {
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

Future<String?> askPassphrase(BuildContext context, {required bool forExport}) async {
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
Future<bool> deliverFile(BuildContext context, String fileName, Uint8List bytes, String mime) async {
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
  if (vault.live.isEmpty) {
    _say(context, 'There are no accounts to back up yet.');
    return;
  }
  final pass = await askPassphrase(context, forExport: true);
  if (pass == null || !context.mounted) return;
  final text = await busy(context, 'Encrypting backup…', () => exportBackup(vault.live, pass));
  if (!context.mounted) return;
  final saved = await deliverFile(context, 'Tanooki Auth backup ${_today()}.$backupExtension',
      Uint8List.fromList(utf8.encode(text)), 'application/octet-stream');
  if (!saved) return;
  vault.settings[lastBackupKey] = DateTime.now().toUtc().toIso8601String();
  await vault.save();
  if (context.mounted) _say(context, 'Backup of ${vault.live.length} accounts saved.');
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
    final pass = await askPassphrase(context, forExport: false);
    if (pass == null || !context.mounted) return null;
    try {
      return await busy(context, 'Unlocking backup…', () => importBackup(text, pass));
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
  await mergeAndReport(context, vault, incoming);
}

/// Adds [incoming], then says how many came in and how many were left out. [problems] are things the
/// importer couldn't read; they're listed in a dialog so nothing disappears without a reason.
Future<void> mergeAndReport(BuildContext context, Vault vault, List<Account> incoming,
    {List<String> problems = const [], String verb = 'Imported'}) async {
  final (added, already) = mergeAccounts(vault.accounts, incoming);
  if (added > 0) await vault.save();
  if (!context.mounted) return;
  final skipped = already + problems.length;
  final summary = skipped == 0 ? '$verb $added.' : '$verb $added, skipped $skipped.';
  if (problems.isEmpty) {
    _say(context, already == 0 ? summary : '$verb $added, skipped $already already in your list.');
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(summary),
      content: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (already > 0) Text('• $already already in your list'),
          for (final p in problems) Text('• $p'),
        ]),
      ),
      actions: [FilledButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
    ),
  );
}

/// Shows what's about to come in and asks before adding anything.
Future<bool> confirmImport(BuildContext context, String title, List<Account> incoming, {String? note}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final a in incoming) Text('• ${accountTitle(a)}${a.issuer.isNotEmpty && a.label.isNotEmpty ? ' (${a.label})' : ''}'),
            if (note != null) ...[const SizedBox(height: 12), Text(note)],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Import')),
      ],
    ),
  );
  return ok == true;
}

Future<void> importGoogleFlow(BuildContext context, Vault vault, String uri) async {
  final List<Account> incoming;
  try {
    incoming = parseGoogleMigration(uri);
    tidyAll(incoming, brandName: brandTitle);
  } on FormatException catch (e) {
    _say(context, e.message);
    return;
  }
  if (await confirmImport(context, 'Import ${incoming.length} from Google Authenticator?', incoming,
          note: 'If Google Authenticator showed more than one QR code, scan each of them.') &&
      context.mounted) {
    await mergeAndReport(context, vault, incoming);
  }
}

Future<void> exportPlainFlow(BuildContext context, Vault vault) async {
  if (vault.live.isEmpty) {
    _say(context, 'There are no accounts to export yet.');
    return;
  }
  if (!await confirmPlainExport(context) || !context.mounted) return;
  final text = '${vault.live.map(toOtpauthUri).join('\n')}\n';
  await deliverFile(context, 'Tanooki Auth setup links ${_today()}.txt', Uint8List.fromList(utf8.encode(text)), 'text/plain');
}

/// The loud warning before any export that isn't encrypted. True when the user says go ahead.
Future<bool> confirmPlainExport(BuildContext context,
    {String what = 'This saves every setup key as plain text, for moving to another authenticator app.'}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
      title: const Text('Export unencrypted?'),
      content: Text(
          '$what Anyone who gets this file can make your login codes. Import it, then delete it straight away. For a normal backup, use "Export backup" instead.'),
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
  return ok == true;
}

/// A printable PDF of every account's QR code and recovery codes, behind a blunt warning.
Future<void> paperBackupFlow(BuildContext context, Vault vault) async {
  if (vault.live.isEmpty) {
    _say(context, 'There are no accounts to print yet.');
    return;
  }
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
      title: const Text('Print a paper backup?'),
      content: const Text(
          'This makes a PDF with a QR code for every account, plus your unused recovery codes. Anyone who sees or photographs that paper can make your login codes, forever, without your phone or password.\n\n'
          'Print it, then delete the PDF. Keep the paper somewhere locked, like a safe or with important documents. Don\'t email it, and don\'t save it to a shared folder.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
          onPressed: () => Navigator.pop(c, true),
          child: const Text('I understand, make the PDF'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  final pdf = await busy(context, 'Making the PDF…', () => buildPaperBackup(vault.live));
  if (!context.mounted) return;
  final saved = await deliverFile(context, 'Tanooki Auth paper backup ${_today()}.pdf', pdf, 'application/pdf');
  if (saved && context.mounted) _say(context, 'PDF ready. Print it, then delete the file.');
}
