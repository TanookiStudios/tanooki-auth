import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/auto_backup.dart';
import '../core/vault.dart';
import 'backup_ui.dart' show askPassphrase, busy;
import 'premium.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// Lets the user pick a folder the app can keep writing to after a restart. Null if they cancel.
Future<({String ref, String name})?> pickBackupFolder() async {
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    final r = await folderCall<Map>('pick');
    return r == null ? null : (ref: r['ref'] as String, name: r['name'] as String);
  }
  final p = await FilePicker.getDirectoryPath(dialogTitle: l10n.autoBackupUiChooseFolderDialog);
  return p == null ? null : (ref: p, name: p.split(RegExp(r'[\\/]')).lastWhere((x) => x.isNotEmpty, orElse: () => p));
}

String _when(DateTime t) {
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  final time = appLocale().languageCode == 'en'
      ? '${t.hour % 12 == 0 ? 12 : t.hour % 12}:${two(t.minute)} ${t.hour < 12 ? 'AM' : 'PM'}'
      : '${t.hour}:${two(t.minute)}'; // 24-hour clock outside English
  final today = DateTime(now.year, now.month, now.day), day = DateTime(t.year, t.month, t.day);
  if (day == today) return l10n.autoBackupUiToday(time);
  if (day == today.subtract(const Duration(days: 1))) return l10n.autoBackupUiYesterday(time);
  return l10n.autoBackupUiOnDay('${t.year}-${two(t.month)}-${two(t.day)}', time);
}

/// Settings > Backup > Automatic backups (Premium).
class AutoBackupScreen extends StatefulWidget {
  const AutoBackupScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<AutoBackupScreen> createState() => _AutoBackupScreenState();
}

class _AutoBackupScreenState extends State<AutoBackupScreen> {
  Vault get _v => widget.vault;

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  @override
  void initState() {
    super.initState();
    autoBackup.failure.addListener(_changed);
  }

  @override
  void dispose() {
    autoBackup.failure.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  Future<void> _backUpNow() async {
    final ok = await busy(context, l10n.autoBackupUiBackingUp, () => autoBackup.runNow(_v));
    if (!mounted) return;
    setState(() {});
    _say(ok ? l10n.autoBackupUiBackedUp(_v.live.length) : autoBackup.failure.value!.message);
  }

  /// Turning on: folder, then passphrase (only the first time), then a first backup straight away.
  Future<void> _chooseFolder() async {
    final ({String ref, String name})? picked;
    try {
      picked = await pickBackupFolder();
    } on AutoBackupException catch (e) {
      return _say((e.detail ?? '').trim().isEmpty ? l10n.autoBackupUiCouldntUseFolder : l10n.autoBackupUiCouldntUseFolderWhy(e.detail!.trim()));
    }
    if (picked == null || !mounted) return;
    final current = autoBackupSettings(_v);
    var pass = current?['passphrase'] as String?;
    pass ??= await askPassphrase(context, forExport: true);
    if (pass == null || !mounted) return;
    _v.settings[autoBackupKey] = {
      ...?current,
      'folder': picked.ref,
      'folderName': picked.name,
      'passphrase': pass,
    }..remove('lastAt'); // a new folder has no backup yet
    await _v.save();
    if (!mounted) return;
    setState(() {});
    await _backUpNow();
  }

  Future<void> _turnOff() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.autoBackupUiTurnOffTitle),
        content: Text(l10n.autoBackupUiTurnOffBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonTurnOff)),
        ],
      ),
    );
    if (ok != true) return;
    autoBackup.cancel();
    autoBackup.failure.value = null;
    _v.settings.remove(autoBackupKey);
    await _v.save();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = autoBackupSettings(_v);
    final on = s?['folder'] is String;
    final last = lastAutoBackup(_v);
    final problem = autoBackup.failure.value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.autoBackupUiTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          l10n.autoBackupUiIntro(autoBackupsKept),
          style: TextStyle(color: Palette.muted, height: 1.4),
        ),
        const SizedBox(height: 16),
        if (problem != null && on)
          Card(
            child: ListTile(
              leading: Icon(Icons.error_outline, color: Palette.red),
              title: Text(l10n.autoBackupUiLastFailed),
              subtitle: Text(problem.message),
            ),
          ),
        if (!on)
          FilledButton.icon(onPressed: _chooseFolder, icon: const Icon(Icons.folder_open), label: Text(l10n.autoBackupUiChooseFolder))
        else
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(s!['folderName'] as String? ?? l10n.autoBackupUiBackupFolder),
                subtitle: Text(last == null ? l10n.autoBackupUiNoBackupYet : l10n.autoBackupUiLastBackup(_when(last))),
              ),
              const Divider(),
              ListTile(leading: const Icon(Icons.backup_outlined), title: Text(l10n.autoBackupUiBackUpNow), onTap: _backUpNow),
              const Divider(),
              ListTile(leading: const Icon(Icons.drive_file_move_outline), title: Text(l10n.autoBackupUiChangeFolder), onTap: _chooseFolder),
              const Divider(),
              ListTile(leading: const Icon(Icons.cloud_off_outlined), title: Text(l10n.commonTurnOff), onTap: _turnOff),
            ]),
          ),
      ]),
    );
  }
}

/// The Settings row. Free users go to the Premium screen first.
Widget autoBackupTile(BuildContext context, Vault vault, VoidCallback refresh) {
  final s = autoBackupSettings(vault);
  final problem = autoBackup.failure.value;
  final last = lastAutoBackup(vault);
  final on = s?['folder'] is String;
  return ListTile(
    leading: Icon(problem != null && on ? Icons.error_outline : Icons.cloud_upload_outlined, color: problem != null && on ? Palette.red : null),
    title: Text(premium.value ? l10n.autoBackupUiTitle : l10n.autoBackupUiTitlePremium),
    subtitle: Text(!on
        ? l10n.autoBackupUiOffSubtitle
        : problem != null
            ? problem.message
            : last == null
                ? l10n.autoBackupUiOnNoBackup('${s!['folderName']}')
                : l10n.autoBackupUiOnLast('${s!['folderName']}', _when(last))),
    trailing: const Icon(Icons.chevron_right),
    onTap: () async {
      if (!premium.value) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: vault)));
        if (!premium.value || !context.mounted) return refresh();
      }
      await Navigator.push(context, MaterialPageRoute(builder: (_) => AutoBackupScreen(vault: vault)));
      refresh();
    },
  );
}
