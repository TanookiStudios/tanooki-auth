import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../core/account.dart';
import '../core/otpauth_uri.dart';
import '../core/importers.dart';
import '../core/qr_image.dart';
import '../core/screen_capture.dart';
import '../core/share.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import 'backup_ui.dart';
import 'brand_icon.dart';
import 'home.dart';
import 'import_ui.dart';
import 'share_ui.dart';
import 'theme.dart';

bool get hasCamera => Platform.isIOS || Platform.isAndroid || Platform.isMacOS;
bool get isPhone => Platform.isIOS || Platform.isAndroid;
bool get canScanScreen => Platform.isMacOS || Platform.isWindows;

/// Every folder name in use, A to Z.
List<String> folderNames(Iterable<Account> accounts) =>
    {for (final a in accounts) if (a.folder != null && a.folder!.isNotEmpty) a.folder!}.toList()..sort();

/// Lets the user check and edit issuer, name, websites, folder and (under Advanced) how codes are made.
/// Edits [a] in place when confirmed. [folders] are the existing folder names to pick from.
Future<bool> showAccountDialog(BuildContext context, Account a,
    {required String title, required String confirm, List<String> folders = const [], bool existing = false}) async {
  final issuer = TextEditingController(text: a.issuer);
  final label = TextEditingController(text: a.label);
  final domains = TextEditingController(text: a.domains.join(', '));
  final tags = TextEditingController(text: a.tags.join(', '));
  final notes = TextEditingController(text: a.notes);
  final folder = TextEditingController(text: a.folder ?? '');
  final counter = TextEditingController(text: '${a.counter}');
  // Advanced settings are tried on a copy, so the live preview never touches the real account until Save.
  var type = a.type, digits = a.digits, period = a.period, algorithm = a.algorithm;
  var advanced = false;
  Account draft() => Account(
        id: a.id,
        secret: a.secret,
        type: type,
        digits: type == OtpType.steam ? 5 : digits,
        period: period,
        algorithm: type == OtpType.steam ? OtpAlgorithm.sha1 : algorithm,
        counter: int.tryParse(counter.text.trim()) ?? a.counter,
      );
  Widget choice<T>(String label, T value, Map<T, String> options, void Function(T) set) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true, // long choices wrap to the dialog's width instead of overflowing
          decoration: InputDecoration(labelText: label, isDense: true),
          items: [for (final e in options.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
          onChanged: (v) => v == null ? null : set(v),
        ),
      );

  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => _Ticker(
        child: AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(groupCode(draft().codeAt(DateTime.now())),
                  key: const Key('previewCode'), textAlign: TextAlign.center, style: Theme.of(c).textTheme.headlineMedium),
              const SizedBox(height: 8),
              TextField(controller: issuer, decoration: const InputDecoration(labelText: 'Service (e.g. GitHub)')),
              TextField(controller: label, decoration: const InputDecoration(labelText: 'Account (e.g. your email)')),
              TextField(
                controller: domains,
                decoration: const InputDecoration(
                  labelText: 'Website (optional)',
                  helperText: 'e.g. github.com. The browser extension only fills codes here.',
                  helperMaxLines: 2,
                ),
              ),
              TextField(
                controller: tags,
                decoration: const InputDecoration(
                  labelText: 'Tags (optional)',
                  helperText: 'e.g. work, games. Separate with commas.',
                ),
              ),
              TextField(
                key: const Key('folderField'),
                controller: folder,
                decoration: InputDecoration(
                  labelText: 'Folder (optional)',
                  helperText: 'e.g. Work. Leave empty for no folder.',
                  suffixIcon: folders.isEmpty
                      ? null
                      : PopupMenuButton<String>(
                          tooltip: 'Pick a folder',
                          icon: const Icon(Icons.folder_open),
                          onSelected: (f) => setState(() => folder.text = f),
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: '', child: Text('No folder')),
                            for (final f in folders) PopupMenuItem(value: f, child: Text(f)),
                          ],
                        ),
                ),
              ),
              TextField(
                controller: notes,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => advanced = !advanced),
                  icon: Icon(advanced ? Icons.expand_less : Icons.expand_more),
                  label: const Text('Advanced'),
                ),
              ),
              if (advanced) ...[
                Text(
                  existing
                      ? 'Only change these if the website told you to. Wrong settings make wrong codes, and the website will refuse them.'
                      : 'Most websites use the normal settings. Only change these if the website told you to.',
                  style: TextStyle(fontSize: 12, color: Palette.muted),
                ),
                choice<OtpType>('Type', type, const {
                  OtpType.totp: 'Time-based (normal)',
                  OtpType.hotp: 'Counter-based (new code when you ask)',
                  OtpType.steam: 'Steam Guard',
                }, (v) => setState(() => type = v)),
                if (type != OtpType.steam) ...[
                  choice<int>('Digits', digits, const {6: '6', 7: '7', 8: '8'}, (v) => setState(() => digits = v)),
                  choice<OtpAlgorithm>('Algorithm', algorithm, const {
                    OtpAlgorithm.sha1: 'SHA-1 (normal)',
                    OtpAlgorithm.sha256: 'SHA-256',
                    OtpAlgorithm.sha512: 'SHA-512',
                  }, (v) => setState(() => algorithm = v)),
                ],
                if (type != OtpType.hotp)
                  choice<int>('New code every', period, {30: '30 seconds', 60: '60 seconds', if (period != 30 && period != 60) period: '$period seconds'},
                      (v) => setState(() => period = v)),
                if (type == OtpType.hotp)
                  TextField(
                    controller: counter,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Counter', helperText: 'How many codes have been used so far'),
                    onChanged: (_) => setState(() {}),
                  ),
              ],
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(confirm)),
          ],
        ),
      ),
    ),
  );
  if (ok != true) return false;
  a.issuer = issuer.text.trim();
  a.label = label.text.trim();
  a.domains
    ..clear()
    ..addAll(domains.text.split(',').map(normalizeDomain).where((d) => d.isNotEmpty).toSet());
  a.tags
    ..clear()
    ..addAll(tags.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toSet());
  a.notes = notes.text.trim();
  final f = folder.text.trim();
  a.folder = f.isEmpty ? null : f;
  final d = draft();
  a
    ..type = d.type
    ..digits = d.digits
    ..period = d.period
    ..algorithm = d.algorithm
    ..counter = d.counter < 0 ? a.counter : d.counter;
  return true;
}

/// Rebuilds [child] every second, so a code preview stays current.
class _Ticker extends StatefulWidget {
  const _Ticker({required this.child});
  final Widget child;
  @override
  State<_Ticker> createState() => _TickerState();
}

class _TickerState extends State<_Ticker> {
  late final Timer _t;
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key, required this.vault, this.scanOnOpen = false, this.sharedFile});
  final Vault vault;
  /// Opens the camera straight away (from the Control Center button or quick settings tile).
  final bool scanOnOpen;
  /// The text of a shared-account file the person tapped in another app; opened straight away.
  final String? sharedFile;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.scanOnOpen) WidgetsBinding.instance.addPostFrameCallback((_) => _scan());
    final shared = widget.sharedFile;
    if (shared != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => shared.trim().startsWith(sharePrefix)
          ? _fromText(shared)
          : _say('That file isn\'t a Tanooki Auth shared account. Ask the person to share it again.'));
    }
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  /// Common path for every way of adding: parse, check duplicates, confirm, save.
  Future<void> _fromText(String text) async {
    if (text.trim().startsWith(sharePrefix)) {
      final a = await openShareFlow(context, text.trim());
      if (a != null) await _confirmAndSave(a);
      return;
    }
    if (text.startsWith('otpauth-migration://')) {
      final before = widget.vault.live.length;
      await importGoogleFlow(context, widget.vault, text);
      if (mounted && widget.vault.live.length > before) Navigator.pop(context);
      return;
    }
    final Account a;
    try {
      a = parseOtpauthUri(text);
    } on FormatException catch (e) {
      _say(e.message);
      return;
    }
    await _confirmAndSave(a);
  }

  Future<void> _confirmAndSave(Account a) async {
    final dupe = widget.vault.live.where((x) => x.secret == a.secret).firstOrNull;
    if (dupe != null) {
      _say('${accountTitle(dupe)} is already in your list.');
      return;
    }
    if (!mounted) return;
    if (!await showAccountDialog(context, a, title: 'Add this account?', confirm: 'Add', folders: folderNames(widget.vault.live))) return;
    widget.vault.accounts
      ..removeWhere((x) => x.secret == a.secret) // an old copy in Trash
      ..add(a);
    await widget.vault.save();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _scan() async {
    if (!hasCamera) {
      _say('Windows can\'t use a camera in Tanooki Auth. Open a picture of the QR code or paste the setup link instead.');
      return;
    }
    final text = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const ScanScreen()));
    if (text != null) await _fromText(text);
  }

  Future<void> _fromGoogle() async {
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Move from Google Authenticator'),
        content: const Text(
            'On the device with Google Authenticator:\n\n1. Open Google Authenticator.\n2. Tap the menu (☰ or ⋮), then "Transfer accounts", then "Export accounts".\n3. Pick the accounts and tap Next. It shows a QR code.\n\nThen scan that QR code here. If it shows several QR codes, scan each one.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(hasCamera ? 'Scan' : 'Open picture')),
        ],
      ),
    );
    if (go != true) return;
    hasCamera ? await _scan() : await _image();
  }

  Future<void> _image() async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty) return;
    final bytes = await files.first.readAsBytes();
    final String text;
    try {
      text = await Isolate.run(() => decodeQrImage(bytes));
    } on FormatException catch (e) {
      _say(e.message);
      return;
    }
    await _fromText(text);
  }

  Future<void> _openShareFile() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return;
    await _fromText(utf8.decode(await files.first.readAsBytes(), allowMalformed: true));
  }

  Future<void> _fromOtherApp() async {
    final before = widget.vault.live.length;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => ImportFromAppScreen(vault: widget.vault)));
    if (mounted && widget.vault.live.length > before) Navigator.pop(context);
  }

  Future<void> _scanScreen() async {
    _say('Looking for a QR code on your screen…');
    final String text;
    try {
      text = await scanScreenForQr();
    } on ScreenScanException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (e.failure == ScreenScanFailure.denied) {
        await _explainScreenPermission();
      } else {
        _say(switch (e.failure) {
          ScreenScanFailure.noQr =>
            'No QR code found on your screen. Make sure the whole code is showing and not covered by another window, then try again.',
          ScreenScanFailure.unsupported => 'Scanning the screen needs macOS 14 (Sonoma) or newer. Take a screenshot and use "Open a picture" instead.',
          _ => 'Couldn\'t take a picture of the screen. Take a screenshot and use "Open a picture" instead.',
        });
      }
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (!['otpauth://', 'otpauth-migration://', 'steam://', sharePrefix].any(text.startsWith)) {
      _say('Found a QR code on your screen, but it isn\'t a two-factor setup code.');
      return;
    }
    await _fromText(text);
  }

  Future<void> _explainScreenPermission() => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Let Tanooki Auth see your screen'),
          content: const Text(
              'To read a QR code off your screen, your Mac needs to let Tanooki Auth take a picture of it. Tanooki Auth only looks when you press "Scan my screen", and the picture never leaves this Mac.\n\n'
              '1. Open System Settings (the gear icon in the Dock, or Apple menu > System Settings).\n'
              '2. Click "Privacy & Security" in the left column.\n'
              '3. Click "Screen & System Audio Recording".\n'
              '4. Turn on the switch next to Tanooki Auth. If it isn\'t in the list, click +, pick Tanooki Auth from Applications, and turn it on.\n'
              '5. Your Mac will ask to quit Tanooki Auth. Click "Quit & Reopen", then press "Scan my screen" again.'),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );

  Future<void> _paste() async {
    final field = TextEditingController(text: (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim() ?? '');
    if (!mounted) return;
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Paste setup links'),
        content: TextField(
          controller: field,
          autofocus: true,
          minLines: 3,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(hintText: 'otpauth://totp/...\nOne link per line. You can paste many at once.'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('Next')),
        ],
      ),
    );
    if (text == null || text.isEmpty || !mounted) return;
    if (text.split('\n').where((l) => l.trim().isNotEmpty).length == 1) return _fromText(text);
    await _pasteMany(text);
  }

  /// Many links at once: adds every good one, then lists each skipped line and why.
  Future<void> _pasteMany(String text) async {
    final r = parseOtpauthLines(text, brandName: brandTitle);
    if (r.accounts.isNotEmpty &&
        !await confirmImport(context, 'Add ${r.accounts.length} accounts?', r.accounts,
            note: r.problems.isEmpty ? null : '${r.problems.length} line(s) can\'t be used; you\'ll see which after.')) {
      return;
    }
    if (!mounted) return;
    final before = widget.vault.live.length;
    await mergeAndReport(context, widget.vault, r.accounts, problems: r.problems, verb: 'Added');
    if (mounted && widget.vault.live.length > before) Navigator.pop(context);
  }

  Future<void> _manual() async {
    final issuer = TextEditingController(), label = TextEditingController(), secret = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Enter setup key'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: issuer, decoration: const InputDecoration(labelText: 'Service (e.g. GitHub)')),
          TextField(controller: label, decoration: const InputDecoration(labelText: 'Account (e.g. your email)')),
          TextField(
            controller: secret,
            decoration: const InputDecoration(labelText: 'Setup key', helperText: 'The letters and numbers the website shows'),
            autocorrect: false,
            enableSuggestions: false,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Next')),
        ],
      ),
    );
    if (ok != true) return;
    final key = secret.text.toUpperCase().replaceAll(RegExp(r'[\s=-]'), '');
    try {
      base32Decode(key);
    } on FormatException {
      _say('That setup key isn\'t valid. It should only contain letters A–Z and numbers 2–7.');
      return;
    }
    await _confirmAndSave(Account(id: newId(), issuer: issuer.text.trim(), label: label.text.trim(), secret: key));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add account')),
      body: ListView(children: [
        ListTile(
          leading: Icon(Icons.qr_code_scanner, color: hasCamera ? null : Theme.of(context).disabledColor),
          title: const Text('Scan QR code'),
          subtitle: Text(hasCamera ? 'Point the camera at the code the website shows' : 'No camera support on Windows'),
          onTap: _scan,
        ),
        if (canScanScreen)
          ListTile(
            leading: const Icon(Icons.screenshot_monitor),
            title: const Text('Scan my screen'),
            subtitle: const Text('Reads a QR code showing anywhere on your screen'),
            onTap: _scanScreen,
          ),
        ListTile(
          leading: const Icon(Icons.image_outlined),
          title: Text(isPhone ? 'Scan a QR code from your photos' : 'Open a picture of a QR code'),
          subtitle: Text(isPhone ? 'Pick a screenshot of the setup page' : 'A screenshot of the setup page works'),
          onTap: _image,
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Paste setup link'),
          subtitle: const Text('Links starting with otpauth://, one or many'),
          onTap: _paste,
        ),
        ListTile(
          leading: const Icon(Icons.people_outline),
          title: const Text('Open a shared account'),
          subtitle: const Text('A .$shareExtension file someone sent you'),
          onTap: _openShareFile,
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz),
          title: const Text('Move from Google Authenticator'),
          subtitle: const Text('Bring all your accounts across at once'),
          onTap: _fromGoogle,
        ),
        ListTile(
          leading: const Icon(Icons.move_down),
          title: const Text('Move from another app'),
          subtitle: const Text('Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple Passwords, Microsoft'),
          onTap: _fromOtherApp,
        ),
        ListTile(
          leading: const Icon(Icons.keyboard_outlined),
          title: const Text('Enter setup key'),
          subtitle: const Text('Type the key shown under "can\'t scan the code?"'),
          onTap: _manual,
        ),
      ]),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.prefixes = const ['otpauth://', 'otpauth-migration://', 'steam://', sharePrefix], this.title = 'Scan QR code', this.wrongCode = 'That QR code isn\'t a two-factor setup code.'});
  /// QR codes this scan accepts; anything else shows [wrongCode].
  final List<String> prefixes;
  final String title;
  final String wrongCode;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _done = false;
  String? _hint;

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final b in capture.barcodes) {
      final v = b.rawValue;
      if (v == null) continue;
      if (widget.prefixes.any(v.startsWith)) {
        _done = true;
        Navigator.pop(context, v);
        return;
      }
      setState(() => _hint = widget.wrongCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(children: [
        MobileScanner(
          onDetect: _onDetect,
          errorBuilder: (context, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error.errorCode == MobileScannerErrorCode.permissionDenied
                    ? 'Tanooki Auth isn\'t allowed to use the camera. Turn on camera access for Tanooki Auth in your device\'s Settings, or go back and use a picture or the setup key instead.'
                    : 'The camera couldn\'t start (${error.errorCode.name}). Go back and use a picture or the setup key instead.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        if (_hint != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(_hint!))),
          ),
      ]),
    );
  }
}
