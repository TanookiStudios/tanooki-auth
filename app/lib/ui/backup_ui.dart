import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../core/account.dart';
import '../core/activity.dart';
import '../core/backup.dart';
import '../core/google_migration.dart';
import '../core/otpauth_uri.dart';
import '../core/paper_backup.dart';
import '../core/security.dart';
import '../core/tidy.dart';
import '../core/vault.dart';
import 'brand_icon.dart';
import 'home.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

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
        title: Text(forExport ? l10n.backupUiChoosePassphrase : l10n.backupUiPassphraseTitle),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (forExport)
            Text(l10n.backupUiPassphraseWarning),
          TextField(
            controller: first,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.backupUiPassphrase),
          ),
          if (forExport)
            TextField(controller: second, obscureText: true, decoration: InputDecoration(labelText: l10n.backupUiTypeAgain)),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
            ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () {
              final p = first.text;
              if (forExport && p.length < 8) {
                setState(() => error = l10n.backupUiTooShort);
              } else if (forExport && p != second.text) {
                setState(() => error = l10n.backupUiNoMatch);
              } else if (p.isEmpty) {
                setState(() => error = l10n.backupUiTypePassphrase);
              } else {
                Navigator.pop(c, p);
              }
            },
            child: Text(l10n.commonOk),
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
  if (vault.visible.isEmpty) {
    _say(context, l10n.backupUiNothingToBackUp);
    return;
  }
  final pass = await askPassphrase(context, forExport: true);
  if (pass == null || !context.mounted) return;
  final text = await busy(context, l10n.backupUiEncrypting, () => exportBackup(vault.visible, pass));
  if (!context.mounted) return;
  final saved = await deliverFile(context, 'Tanooki Auth backup ${_today()}.$backupExtension',
      Uint8List.fromList(utf8.encode(text)), 'application/octet-stream');
  if (!saved) return;
  vault.settings[lastBackupKey] = DateTime.now().toUtc().toIso8601String();
  logActivity(vault, ActivityKind.exported, where: 'Backup file');
  await vault.save();
  if (context.mounted) _say(context, l10n.backupUiSaved(vault.visible.length));
}

/// Picks a backup file and decrypts it. Returns null if the user cancels or it fails (with a message shown).
Future<List<Account>?> pickAndOpenBackup(BuildContext context) async {
  final files = await FilePicker.pickFiles();
  if (files.isEmpty || !context.mounted) return null;
  final String text;
  try {
    text = utf8.decode(await files.first.readAsBytes());
  } catch (_) {
    if (context.mounted) _say(context, l10n.backupUiNotABackup);
    return null;
  }
  while (true) {
    if (!context.mounted) return null;
    final pass = await askPassphrase(context, forExport: false);
    if (pass == null || !context.mounted) return null;
    try {
      return await busy(context, l10n.backupUiUnlocking, () => importBackup(text, pass));
    } on BackupException catch (e) {
      if (!context.mounted) return null;
      _say(context, e.message);
      if (e.message != l10n.backupWrongPassphrase) return null; // only a passphrase is worth retrying
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
/// [verb] is 'Imported' or 'Added' (which wording the summary uses).
Future<void> mergeAndReport(BuildContext context, Vault vault, List<Account> incoming,
    {List<String> problems = const [], String verb = 'Imported'}) async {
  final (added, already) = mergeAccounts(vault.accounts, incoming);
  if (added > 0) await vault.save();
  if (!context.mounted) return;
  final skipped = already + problems.length;
  final adding = verb == 'Added';
  final summary = skipped == 0
      ? (adding ? l10n.backupUiAdded(added) : l10n.backupUiImported(added))
      : (adding ? l10n.backupUiAddedSkipped(added, skipped) : l10n.backupUiImportedSkipped(added, skipped));
  if (problems.isEmpty) {
    _say(context, already == 0 ? summary : (adding ? l10n.backupUiAddedSkippedAlready(added, already) : l10n.backupUiImportedSkippedAlready(added, already)));
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(summary),
      content: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (already > 0) Text(l10n.backupUiAlreadyInList(already)),
          for (final p in problems) Text(l10n.backupUiBullet(p)),
        ]),
      ),
      actions: [FilledButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonOk))],
    ),
  );
}

/// "GitHub (maddie)": the account's title, plus its login name when it has both.
String accountNameWithLabel(Account a) =>
    a.issuer.isNotEmpty && a.label.isNotEmpty ? l10n.backupUiAccountWithLabel(accountTitle(a), a.label) : accountTitle(a);

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
            for (final a in incoming) Text(l10n.backupUiBullet(accountNameWithLabel(a))),
            if (note != null) ...[const SizedBox(height: 12), Text(note)],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.backupUiImport)),
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
  if (await confirmImport(context, l10n.backupUiImportFromGoogle(incoming.length), incoming,
          note: l10n.backupUiGoogleMoreCodes) &&
      context.mounted) {
    await mergeAndReport(context, vault, incoming);
  }
}

Future<void> exportPlainFlow(BuildContext context, Vault vault) async {
  if (vault.visible.isEmpty) {
    _say(context, l10n.backupUiNothingToExport);
    return;
  }
  if (!await confirmPlainExport(context) || !context.mounted) return;
  final text = '${vault.visible.map(toOtpauthUri).join('\n')}\n';
  if (!await deliverFile(context, 'Tanooki Auth setup links ${_today()}.txt', Uint8List.fromList(utf8.encode(text)), 'text/plain')) return;
  logActivity(vault, ActivityKind.exported, where: 'Setup links file');
  await vault.save();
}

/// The loud warning before any export that isn't encrypted. True when the user says go ahead.
Future<bool> confirmPlainExport(BuildContext context, {String? what}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
      title: Text(l10n.backupUiPlainTitle),
      content: Text(l10n.backupUiPlainBody(what ?? l10n.backupUiPlainWhat)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
          onPressed: () => Navigator.pop(c, true),
          child: Text(l10n.backupUiUnderstandExport),
        ),
      ],
    ),
  );
  return ok == true;
}

/// A printable PDF of every account's QR code and recovery codes, behind a blunt warning.
Future<void> paperBackupFlow(BuildContext context, Vault vault) async {
  if (vault.visible.isEmpty) {
    _say(context, l10n.backupUiNothingToPrint);
    return;
  }
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Theme.of(c).colorScheme.error),
      title: Text(l10n.backupUiPaperTitle),
      content: Text(l10n.backupUiPaperBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
          onPressed: () => Navigator.pop(c, true),
          child: Text(l10n.backupUiUnderstandPdf),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  final pdf = await busy(context, l10n.backupUiMakingPdf, () => buildPaperBackup(vault.visible));
  if (!context.mounted) return;
  final saved = await deliverFile(context, 'Tanooki Auth paper backup ${_today()}.pdf', pdf, 'application/pdf');
  if (saved) {
    logActivity(vault, ActivityKind.exported, where: 'Paper backup PDF');
    await vault.save();
  }
  if (saved && context.mounted) _say(context, l10n.backupUiPdfReady);
}

/// Settings > "Test a backup": opens a backup file with its passphrase and says what's in it. Adds nothing and
/// changes nothing.
Future<void> testBackupFlow(BuildContext context) async {
  final accounts = await pickAndOpenBackup(context);
  if (accounts == null || !context.mounted) return; // cancelled, or the reason was already shown
  await showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      icon: Icon(Icons.check_circle_outline, color: Palette.green),
      title: Text(l10n.backupUiWorksTitle),
      content: Text(l10n.backupUiWorksBody(accounts.length)),
      actions: [FilledButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonOk))],
    ),
  );
}
