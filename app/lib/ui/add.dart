import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../core/account.dart';
import '../core/otpauth_uri.dart';
import '../core/qr_image.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import 'backup_ui.dart';
import 'home.dart';

bool get hasCamera => Platform.isIOS || Platform.isAndroid || Platform.isMacOS;

/// "https://www.GitHub.com/login" -> "github.com".
String normalizeDomain(String s) {
  var d = s.trim().toLowerCase();
  d = d.replaceFirst(RegExp(r'^[a-z]+://'), '');
  d = d.split(RegExp(r'[/?#:]')).first;
  if (d.startsWith('www.')) d = d.substring(4);
  return d;
}

/// Lets the user check and edit issuer, name and websites. Edits [a] in place when confirmed.
Future<bool> showAccountDialog(BuildContext context, Account a,
    {required String title, required String confirm}) async {
  final issuer = TextEditingController(text: a.issuer);
  final label = TextEditingController(text: a.label);
  final domains = TextEditingController(text: a.domains.join(', '));
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(groupCode(a.codeAt(DateTime.now())), style: Theme.of(c).textTheme.headlineMedium),
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
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(confirm)),
      ],
    ),
  );
  if (ok != true) return false;
  a.issuer = issuer.text.trim();
  a.label = label.text.trim();
  a.domains
    ..clear()
    ..addAll(domains.text.split(',').map(normalizeDomain).where((d) => d.isNotEmpty).toSet());
  return true;
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  /// Common path for every way of adding: parse, check duplicates, confirm, save.
  Future<void> _fromText(String text) async {
    if (text.startsWith('otpauth-migration://')) {
      final before = widget.vault.accounts.length;
      await importGoogleFlow(context, widget.vault, text);
      if (mounted && widget.vault.accounts.length > before) Navigator.pop(context);
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
    final dupe = widget.vault.accounts.where((x) => x.secret == a.secret).firstOrNull;
    if (dupe != null) {
      _say('${accountTitle(dupe)} is already in your list.');
      return;
    }
    if (!mounted) return;
    if (!await showAccountDialog(context, a, title: 'Add this account?', confirm: 'Add')) return;
    widget.vault.accounts.add(a);
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
    try {
      await _fromText(decodeQrImage(await files.first.readAsBytes()));
    } on FormatException catch (e) {
      _say(e.message);
    }
  }

  Future<void> _paste() async {
    final field = TextEditingController(text: (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim() ?? '');
    if (!mounted) return;
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Paste setup link'),
        content: TextField(
          controller: field,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'otpauth://totp/...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('Next')),
        ],
      ),
    );
    if (text != null && text.isNotEmpty) await _fromText(text);
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
        ListTile(
          leading: const Icon(Icons.image_outlined),
          title: const Text('Open a picture of a QR code'),
          subtitle: const Text('A screenshot of the setup page works'),
          onTap: _image,
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Paste setup link'),
          subtitle: const Text('A link starting with otpauth://'),
          onTap: _paste,
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz),
          title: const Text('Move from Google Authenticator'),
          subtitle: const Text('Bring all your accounts across at once'),
          onTap: _fromGoogle,
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
  const ScanScreen({super.key});

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
      if (v.startsWith('otpauth://') || v.startsWith('otpauth-migration://')) {
        _done = true;
        Navigator.pop(context, v);
        return;
      }
      setState(() => _hint = 'That QR code isn\'t a two-factor setup code.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR code')),
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
