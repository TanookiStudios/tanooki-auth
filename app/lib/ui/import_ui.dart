import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/importers.dart';
import '../core/vault.dart';
import 'backup_ui.dart';
import 'brand_icon.dart';
import '../l10n/l10n.dart';

String get _deleteNote => l10n.importUiDeleteNote;

/// The apps we can bring accounts across from, with where to find their export in plain steps.
List<(ImportSource?, String, String)> get _apps => [
  (
    ImportSource.aegis,
    'Aegis',
    l10n.importUiStepsAegis,
  ),
  (
    ImportSource.twoFas,
    '2FAS',
    l10n.importUiStepsTwoFas,
  ),
  (
    ImportSource.authy,
    'Authy',
    l10n.importUiStepsAuthy,
  ),
  (
    ImportSource.bitwarden,
    'Bitwarden',
    l10n.importUiStepsBitwarden,
  ),
  (
    ImportSource.onePassword,
    '1Password',
    l10n.importUiStepsOnePassword,
  ),
  (
    ImportSource.applePasswords,
    'Apple Passwords',
    l10n.importUiStepsApple,
  ),
  (
    null,
    'Microsoft Authenticator',
    l10n.importUiStepsMicrosoft,
  ),
];

class ImportFromAppScreen extends StatelessWidget {
  const ImportFromAppScreen({super.key, required this.vault});
  final Vault vault;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.importUiTitle)),
      body: ListView(children: [
        for (final (source, name, steps) in _apps)
          ListTile(
            leading: Icon(source == null ? Icons.help_outline : Icons.file_open_outlined),
            title: Text(name),
            subtitle: Text(source == null ? l10n.importUiCantExport : l10n.importUiFromExportFile),
            onTap: () => _start(context, source, name, steps),
          ),
      ]),
    );
  }

  Future<void> _start(BuildContext context, ImportSource? source, String name, String steps) async {
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(source == null ? name : l10n.importUiMoveFrom(name)),
        content: SingleChildScrollView(child: Text(steps)),
        actions: source == null
            ? [FilledButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.importUiGotIt))]
            : [
                TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
                FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.importUiPickFile)),
              ],
      ),
    );
    if (go != true || source == null || !context.mounted) return;
    await importFileFlow(context, vault, source, name);
  }
}

void _say(BuildContext context, String msg) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(msg)));

Future<void> importFileFlow(BuildContext context, Vault vault, ImportSource source, String name) async {
  final files = await FilePicker.pickFiles();
  if (files.isEmpty || !context.mounted) return;
  final String text;
  try {
    text = utf8.decode(await files.first.readAsBytes(), allowMalformed: true);
  } catch (_) {
    if (context.mounted) _say(context, l10n.importUiCouldntRead);
    return;
  }
  String? password;
  ImportResult? result;
  while (result == null) {
    if (!context.mounted) return;
    try {
      result = await busy(context, l10n.importUiReading(name), () => parseImport(source, text, password: password, brandName: brandTitle));
    } on ImportException catch (e) {
      if (!context.mounted) return;
      if (!e.needsPassword) {
        _say(context, e.message);
        return;
      }
      if (password != null) _say(context, e.message);
      password = await _askExportPassword(context, name);
      if (password == null) return;
    }
  }
  if (!context.mounted) return;
  if (result.accounts.isEmpty) {
    await mergeAndReport(context, vault, const [], problems: result.problems.isEmpty ? [l10n.importUiNoAccountsInFile] : result.problems);
    return;
  }
  if (await confirmImport(context, l10n.importUiImportFrom(result.accounts.length, name), result.accounts, note: _deleteNote) &&
      context.mounted) {
    await mergeAndReport(context, vault, result.accounts, problems: result.problems);
  }
}

Future<String?> _askExportPassword(BuildContext context, String name) {
  final field = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l10n.importUiExportPassword(name)),
      content: TextField(
        controller: field,
        obscureText: true,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.importUiPasswordHint),
        onSubmitted: (v) => Navigator.pop(c, v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: () => Navigator.pop(c, field.text), child: Text(l10n.commonOpen)),
      ],
    ),
  );
}
