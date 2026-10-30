import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/importers.dart';
import '../core/vault.dart';
import 'backup_ui.dart';
import 'brand_icon.dart';

const _deleteNote = 'When you\'re done, delete the export file: anyone who gets it can make your codes.';

/// The apps we can bring accounts across from, with where to find their export in plain steps.
const _apps = <(ImportSource?, String, String)>[
  (
    ImportSource.aegis,
    'Aegis',
    'In Aegis on your Android phone:\n\n1. Tap ⋮, then Settings, then "Import & Export".\n2. Tap "Export", choose "Aegis (.JSON)".\n3. Keep "Encrypt the vault" on if you like; you\'ll type that password here.\n4. Save the file somewhere this device can open (for example Google Drive or email it to yourself).\n\nThen pick that file here.',
  ),
  (
    ImportSource.twoFas,
    '2FAS',
    'In 2FAS:\n\n1. Open Settings, then "2FAS Backup".\n2. Tap "Export to file". If it asks for a password, you\'ll type the same one here.\n3. Save the .2fas file somewhere this device can open.\n\nThen pick that file here.',
  ),
  (
    ImportSource.authy,
    'Authy',
    'Authy has no export button, and Authy for computers was shut down in 2024.\n\nIf you already got your accounts out with a tool such as "authy-export", pick the file it made (a .json file, or a .txt list of otpauth:// links).\n\nIf not, the safe way is one account at a time: log in to each website, turn two-factor login off and back on, and scan the new QR code with Tanooki Auth. Keep Authy until every account works here.',
  ),
  (
    ImportSource.bitwarden,
    'Bitwarden',
    'In Bitwarden (website or desktop app):\n\n1. Go to Tools, then "Export vault".\n2. Choose ".json" or ".csv". Not "encrypted".\n3. Save the file.\n\nThen pick that file here. Only logins with an authenticator key come across; your passwords are ignored.',
  ),
  (
    ImportSource.onePassword,
    '1Password',
    'In the 1Password app for Mac or Windows:\n\n1. Click File, then Export, then pick your account.\n2. Choose "CSV" as the format and save.\n\nThen pick that file here. Only items with a one-time password come across; your passwords are ignored.',
  ),
  (
    ImportSource.applePasswords,
    'Apple Passwords',
    'You need a Mac for this; iPhone can\'t save the file.\n\nOn a Mac with macOS Sequoia or newer:\n1. Open the Passwords app.\n2. In the menu bar, click File, then "Export All Passwords…".\n3. Click "Export Passwords", type your Mac password if asked, and save the file.\n\nOn an older Mac: open Safari, then Safari > Settings > Passwords, click the ⋯ button, and choose "Export All Passwords…".\n\nThen pick that file here. Only items with a verification code come across; your passwords are ignored.',
  ),
  (
    null,
    'Microsoft Authenticator',
    'Microsoft Authenticator can\'t export your accounts, so they can\'t be moved in one go.\n\nFor each account:\n1. Log in to that website on a computer.\n2. Find its security or two-factor settings.\n3. Turn two-factor login off and back on (or choose "add a new authenticator app").\n4. Scan the new QR code with Tanooki Auth and type in the code it shows to finish.\n\nKeep Microsoft Authenticator until every account works in Tanooki Auth. Your Microsoft account itself can also use Tanooki Auth: add it at account.microsoft.com, under Security.',
  ),
];

class ImportFromAppScreen extends StatelessWidget {
  const ImportFromAppScreen({super.key, required this.vault});
  final Vault vault;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move from another app')),
      body: ListView(children: [
        for (final (source, name, steps) in _apps)
          ListTile(
            leading: Icon(source == null ? Icons.help_outline : Icons.file_open_outlined),
            title: Text(name),
            subtitle: Text(source == null ? 'Can\'t export: how to move each account' : 'From an export file'),
            onTap: () => _start(context, source, name, steps),
          ),
      ]),
    );
  }

  Future<void> _start(BuildContext context, ImportSource? source, String name, String steps) async {
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(source == null ? name : 'Move from $name'),
        content: SingleChildScrollView(child: Text(steps)),
        actions: source == null
            ? [FilledButton(onPressed: () => Navigator.pop(c, false), child: const Text('Got it'))]
            : [
                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Pick file')),
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
    if (context.mounted) _say(context, 'That file couldn\'t be read.');
    return;
  }
  String? password;
  ImportResult? result;
  while (result == null) {
    if (!context.mounted) return;
    try {
      result = await busy(context, 'Reading $name export…', () => parseImport(source, text, password: password, brandName: brandTitle));
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
    await mergeAndReport(context, vault, const [], problems: result.problems.isEmpty ? ['No two-factor accounts were in that file.'] : result.problems);
    return;
  }
  if (await confirmImport(context, 'Import ${result.accounts.length} from $name?', result.accounts, note: _deleteNote) &&
      context.mounted) {
    await mergeAndReport(context, vault, result.accounts, problems: result.problems);
  }
}

Future<String?> _askExportPassword(BuildContext context, String name) {
  final field = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('$name export password'),
      content: TextField(
        controller: field,
        obscureText: true,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'The password you chose when exporting'),
        onSubmitted: (v) => Navigator.pop(c, v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(c, field.text), child: const Text('Open')),
      ],
    ),
  );
}
