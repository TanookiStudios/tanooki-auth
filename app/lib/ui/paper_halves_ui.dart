import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/activity.dart';
import '../core/backup.dart';
import '../core/paper_backup.dart';
import '../core/paper_halves.dart';
import '../core/qr_image.dart';
import '../core/security.dart' show lastBackupKey;
import '../core/vault.dart';
import 'add.dart' show ScanScreen, hasCamera;
import 'backup_ui.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

void _say(BuildContext context, String msg) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(msg)));

String _today() => DateTime.now().toIso8601String().substring(0, 10);

/// Settings > Backup > "Paper backup in two halves": the encrypted backup, split so each half alone is useless,
/// saved as two PDFs ("Half A of 2", "Half B of 2") to print and keep in different places.
Future<void> paperHalvesFlow(BuildContext context, Vault vault) async {
  if (vault.visible.isEmpty) return _say(context, l10n.backupUiNothingToPrint);
  final go = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l10n.halvesTitle),
      content: SingleChildScrollView(child: Text(l10n.halvesExplain)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonContinueLabel)),
      ],
    ),
  );
  if (go != true || !context.mounted) return;
  final pass = await askPassphrase(context, forExport: true);
  if (pass == null || !context.mounted) return;
  final (a, b) = await busy(context, l10n.backupUiMakingPdf, () async {
    final halves = splitBackupText(await exportBackup(vault.visible, pass));
    return (await buildHalfPaper('A', halves.a), await buildHalfPaper('B', halves.b));
  });
  if (!context.mounted) return;
  if (!await deliverFile(context, 'Tanooki Auth backup half A ${_today()}.pdf', a, 'application/pdf') || !context.mounted) return;
  final next = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l10n.halvesNowB),
      content: Text(l10n.halvesNowBBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.halvesSaveB)),
      ],
    ),
  );
  if (!context.mounted) return;
  if (next != true) return _say(context, l10n.halvesOnlyA);
  if (!await deliverFile(context, 'Tanooki Auth backup half B ${_today()}.pdf', b, 'application/pdf')) {
    if (context.mounted) _say(context, l10n.halvesOnlyA);
    return;
  }
  vault.settings[lastBackupKey] = DateTime.now().toUtc().toIso8601String();
  logActivity(vault, ActivityKind.exported, where: 'Paper backup in two halves');
  await vault.save();
  if (context.mounted) _say(context, l10n.halvesReady);
}

/// Settings > Backup > "Restore from two halves": scan (or open pictures of) every code on both halves, then
/// type the backup's passphrase. Nothing is added before the usual "add these accounts?" summary.
class HalvesRestoreScreen extends StatefulWidget {
  const HalvesRestoreScreen({super.key, required this.vault, this.collector});
  final Vault vault;
  /// Tests start with some codes already in.
  final HalfCollector? collector;

  @override
  State<HalvesRestoreScreen> createState() => _HalvesRestoreScreenState();
}

class _HalvesRestoreScreenState extends State<HalvesRestoreScreen> {
  late HalfCollector _codes = widget.collector ?? HalfCollector();

  /// What to say after one code: a problem, the progress, or null when both halves are complete.
  String? _take(String text) {
    final problem = _codes.add(text);
    setState(() {});
    return switch (problem) {
      HalfProblem.notAHalf => l10n.halvesNotAHalf,
      HalfProblem.otherSet => l10n.halvesOtherSet,
      HalfProblem.duplicate => l10n.halvesAlreadyHave,
      null => _codes.complete ? null : _progress(),
    };
  }

  String _progress() => '${_line('A')}\n${_line('B')}';

  String _line(String which) {
    final total = _codes.total(which);
    final name = which == 'A' ? l10n.halvesHalfA : l10n.halvesHalfB;
    return total == null ? l10n.halvesNotStarted(name) : l10n.halvesProgress(name, _codes.have(which), total);
  }

  Future<void> _scan() async {
    await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ScanScreen(prefixes: const [halfPrefix], title: l10n.halvesScanTitle, wrongCode: l10n.halvesNotAHalf, onEach: _take)),
    );
    if (mounted) setState(() {});
  }

  Future<void> _pictures() async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty || !mounted) return;
    var none = 0;
    for (final f in files) {
      final bytes = await f.readAsBytes();
      try {
        _take(await Isolate.run(() => decodeQrImage(bytes)));
      } on FormatException {
        none++;
      }
    }
    if (mounted) _say(context, none == 0 ? _progress() : l10n.halvesSomeUnread(none));
  }

  Future<void> _restore() async {
    final String text;
    try {
      text = _codes.join();
    } on FormatException {
      setState(() => _codes = HalfCollector());
      return _say(context, l10n.halvesDontFit);
    }
    while (true) {
      if (!mounted) return;
      final pass = await askPassphrase(context, forExport: false);
      if (pass == null || !mounted) return;
      try {
        final accounts = await busy(context, l10n.backupUiUnlocking, () => importBackup(text, pass));
        if (!mounted) return;
        if (!await confirmImport(context, l10n.halvesTitle, accounts) || !mounted) return;
        await mergeAndReport(context, widget.vault, accounts);
        if (mounted) Navigator.pop(context);
        return;
      } on BackupException catch (e) {
        if (!mounted) return;
        _say(context, e.message);
        if (e.message != l10n.backupWrongPassphrase) return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget half(String which) {
      final done = _codes.done(which);
      return ListTile(
        leading: Icon(done ? Icons.check_circle : Icons.qr_code_2, color: done ? Palette.green : Palette.muted),
        title: Text(_line(which)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.halvesRestoreTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l10n.halvesRestoreIntro, style: TextStyle(color: Palette.muted, height: 1.4)),
        const SizedBox(height: 12),
        Card(child: Column(children: [half('A'), const Divider(), half('B')])),
        const SizedBox(height: 16),
        if (_codes.complete)
          FilledButton.icon(key: const Key('halvesRestore'), onPressed: _restore, icon: const Icon(Icons.restore), label: Text(l10n.halvesRestoreNow))
        else ...[
          if (hasCamera) FilledButton.icon(onPressed: _scan, icon: const Icon(Icons.qr_code_scanner), label: Text(l10n.halvesScan)),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: _pictures, icon: const Icon(Icons.image_outlined), label: Text(l10n.halvesPictures)),
        ],
      ]),
    );
  }
}
