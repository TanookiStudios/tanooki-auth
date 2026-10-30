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
import '../core/guides.dart';
import '../core/importers.dart';
import '../core/qr_image.dart';
import '../core/screen_capture.dart';
import '../core/share.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import 'backup_ui.dart';
import 'brand_icon.dart';
import 'code_view.dart';
import 'help.dart';
import 'home.dart';
import 'import_ui.dart';
import 'premium.dart';
import 'security_ui.dart' show proofName;
import 'share_ui.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

bool get hasCamera => Platform.isIOS || Platform.isAndroid || Platform.isMacOS;
bool get isPhone => Platform.isIOS || Platform.isAndroid;
bool get canScanScreen => Platform.isMacOS || Platform.isWindows;

/// Every folder name in use, A to Z.
List<String> folderNames(Iterable<Account> accounts) =>
    {for (final a in accounts) if (a.folder != null && a.folder!.isNotEmpty) a.folder!}.toList()..sort();

/// The one confirmation before accounts from a browser are saved: the usual account dialog for one,
/// a list of names for a Google Authenticator transfer with many.
Future<bool> confirmAddAccounts(BuildContext context, List<Account> accounts) async {
  if (accounts.length == 1) {
    return showAccountDialog(context, accounts.single, title: l10n.addFromBrowserOne, confirm: l10n.commonAdd);
  }
  String name(Account a) => a.issuer.isEmpty ? a.label : a.label.isEmpty ? a.issuer : '${a.issuer} (${a.label})';
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          title: Text(l10n.addFromBrowserMany(accounts.length)),
          content: SizedBox(
            width: 360,
            child: ListView(shrinkWrap: true, children: [
              Text(l10n.addFromGoogleTransfer),
              const SizedBox(height: 8),
              for (final a in accounts) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• ${name(a)}')),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.addCount(accounts.length))),
          ],
        ),
      ) ??
      false;
}

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
  final emoji = TextEditingController(text: a.emoji ?? '');
  int? color = a.color;
  // Advanced settings are tried on a copy, so the live preview never touches the real account until Save.
  var type = a.type, digits = a.digits, period = a.period, algorithm = a.algorithm;
  var advanced = false;
  var requireAuth = a.requireAuth, travelHidden = a.travelHidden;
  String? travelNote;
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

  // One round 48 px target per color (and "No color"), so each is easy to hit and to find with a screen reader.
  Widget swatch(int? value, String name, StateSetter setState) {
    final on = color == value;
    return Semantics(
      button: true,
      selected: on,
      label: value == null ? l10n.addNoColor : l10n.addColorName(name),
      excludeSemantics: true,
      child: InkResponse(
        key: Key('color-${value ?? 'none'}'),
        radius: 24,
        onTap: () => setState(() => color = value),
        child: SizedBox.square(
          dimension: 48,
          child: Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value == null ? null : Color(value),
                border: Border.all(color: on ? Palette.text : Palette.lineBright, width: on ? 3 : 1),
              ),
              child: value == null
                  ? Icon(Icons.block, size: 16, color: Palette.muted)
                  : on
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
          ),
        ),
      ),
    );
  }

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
              TextField(controller: issuer, decoration: InputDecoration(labelText: l10n.addServiceLabel)),
              TextField(controller: label, decoration: InputDecoration(labelText: l10n.addAccountLabel)),
              TextField(
                controller: domains,
                decoration: InputDecoration(
                  labelText: l10n.addWebsiteLabel,
                  helperText: l10n.addWebsiteHelp,
                  helperMaxLines: 2,
                ),
              ),
              ListenableBuilder(
                listenable: Listenable.merge([issuer, domains]),
                builder: (c, _) {
                  final g = guideFor(issuer.text, domains.text.split(',').map(normalizeDomain));
                  return g == null ? const SizedBox.shrink() : guideLink(c, g);
                },
              ),
              TextField(
                controller: tags,
                decoration: InputDecoration(
                  labelText: l10n.addTagsLabel,
                  helperText: l10n.addTagsHelp,
                ),
              ),
              TextField(
                key: const Key('folderField'),
                controller: folder,
                decoration: InputDecoration(
                  labelText: l10n.addFolderLabel,
                  helperText: l10n.addFolderHelp,
                  suffixIcon: folders.isEmpty
                      ? null
                      : PopupMenuButton<String>(
                          tooltip: l10n.addPickFolder,
                          icon: const Icon(Icons.folder_open),
                          onSelected: (f) => setState(() => folder.text = f),
                          itemBuilder: (_) => [
                            PopupMenuItem(value: '', child: Text(l10n.addNoFolder)),
                            for (final f in folders) PopupMenuItem(value: f, child: Text(f)),
                          ],
                        ),
                ),
              ),
              TextField(
                controller: notes,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(labelText: l10n.addNotesLabel),
              ),
              const SizedBox(height: 12),
              Text(l10n.addColorLabel, style: TextStyle(fontSize: 12, color: Palette.muted)),
              Wrap(children: [
                for (var i = 0; i < accountColors.length; i++) swatch(accountColors[i], accountColorNames[i], setState),
                swatch(null, '', setState),
              ]),
              TextField(
                key: const Key('emojiField'),
                controller: emoji,
                decoration: InputDecoration(
                  labelText: l10n.addEmojiLabel,
                  helperText: l10n.addEmojiHelp,
                  helperMaxLines: 2,
                ),
              ),
              Wrap(children: [
                for (final e in emojiSuggestions)
                  Semantics(
                    button: true,
                    label: l10n.addUseEmoji(e),
                    excludeSemantics: true,
                    child: InkResponse(
                      radius: 24,
                      onTap: () => emoji.text = e,
                      child: SizedBox.square(dimension: 48, child: Center(child: Text(e, style: const TextStyle(fontSize: 22)))),
                    ),
                  ),
              ]),
              const SizedBox(height: 4),
              SwitchListTile(
                key: const Key('requireAuthSwitch'),
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.addRequireAuth(proofName)),
                subtitle: Text(l10n.addRequireAuthHelp),
                value: requireAuth,
                onChanged: (on) => setState(() => requireAuth = on),
              ),
              SwitchListTile(
                key: const Key('travelHiddenSwitch'),
                contentPadding: EdgeInsets.zero,
                title: Text(premium.value ? l10n.addTravelHide : l10n.addTravelHidePremium),
                subtitle: Text(travelNote ?? l10n.addTravelHideHelp,
                    style: travelNote == null ? null : TextStyle(color: Palette.red)),
                value: travelHidden,
                onChanged: (on) => setState(() {
                  if (on && !premium.value) {
                    travelNote = l10n.addTravelNeedsPremium;
                  } else {
                    travelHidden = on;
                  }
                }),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => advanced = !advanced),
                  icon: Icon(advanced ? Icons.expand_less : Icons.expand_more),
                  label: Text(l10n.addAdvanced),
                ),
              ),
              if (advanced) ...[
                Text(
                  existing
                      ? l10n.addAdvancedExisting
                      : l10n.addAdvancedNew,
                  style: TextStyle(fontSize: 12, color: Palette.muted),
                ),
                choice<OtpType>(l10n.addType, type, {
                  OtpType.totp: l10n.addTypeTotp,
                  OtpType.hotp: l10n.addTypeHotp,
                  OtpType.steam: 'Steam Guard',
                }, (v) => setState(() => type = v)),
                if (type != OtpType.steam) ...[
                  choice<int>(l10n.addDigits, digits, const {6: '6', 7: '7', 8: '8'}, (v) => setState(() => digits = v)),
                  choice<OtpAlgorithm>(l10n.addAlgorithm, algorithm, {
                    OtpAlgorithm.sha1: l10n.addSha1Normal,
                    OtpAlgorithm.sha256: 'SHA-256',
                    OtpAlgorithm.sha512: 'SHA-512',
                  }, (v) => setState(() => algorithm = v)),
                ],
                if (type != OtpType.hotp)
                  choice<int>(l10n.addPeriod, period, {for (final p in {30, 60, period}) p: l10n.addSeconds(p)},
                      (v) => setState(() => period = v)),
                if (type == OtpType.hotp)
                  TextField(
                    controller: counter,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.addCounter, helperText: l10n.addCounterHelp),
                    onChanged: (_) => setState(() {}),
                  ),
              ],
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
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
  final e = emoji.text.trim();
  a
    ..emoji = e.isEmpty ? null : e.characters.first // one emoji; extra typing is dropped
    ..color = color;
  final f = folder.text.trim();
  a.folder = f.isEmpty ? null : f;
  a
    ..requireAuth = requireAuth
    ..travelHidden = travelHidden;
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
          : _say(l10n.addNotASharedFile));
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
      _say(l10n.addAlreadyInList(accountTitle(dupe)));
      return;
    }
    if (!mounted) return;
    if (!await showAccountDialog(context, a, title: l10n.addThisAccount, confirm: l10n.commonAdd, folders: folderNames(widget.vault.visible))) return;
    widget.vault.accounts
      ..removeWhere((x) => x.secret == a.secret) // an old copy in Trash
      ..add(a);
    await widget.vault.save();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _scan() async {
    if (!hasCamera) {
      _say(l10n.addNoCameraWindows);
      return;
    }
    final text = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const ScanScreen()));
    if (text != null) await _fromText(text);
  }

  Future<void> _fromGoogle() async {
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.addFromGoogle),
        content: Text(l10n.addFromGoogleSteps),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(hasCamera ? l10n.addScan : l10n.addOpenPicture)),
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
      _say(qrImageError(e));
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
    _say(l10n.addLookingOnScreen);
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
          ScreenScanFailure.noQr => l10n.addScreenNoQr,
          ScreenScanFailure.unsupported => l10n.addScreenUnsupported,
          _ => l10n.addScreenFailed,
        });
      }
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (!['otpauth://', 'otpauth-migration://', 'steam://', sharePrefix].any(text.startsWith)) {
      _say(l10n.addScreenWrongQr);
      return;
    }
    await _fromText(text);
  }

  Future<void> _explainScreenPermission() => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.addScreenPermissionTitle),
          content: Text(l10n.addScreenPermissionSteps),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonOk))],
        ),
      );

  Future<void> _paste() async {
    final field = TextEditingController(text: (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim() ?? '');
    if (!mounted) return;
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.addPasteLinksTitle),
        content: TextField(
          controller: field,
          autofocus: true,
          minLines: 3,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: l10n.addPasteLinksHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: Text(l10n.commonNext)),
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
        !await confirmImport(context, l10n.addManyTitle(r.accounts.length), r.accounts,
            note: r.problems.isEmpty ? null : l10n.addManyBadLines(r.problems.length))) {
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
        title: Text(l10n.addEnterKey),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: issuer, decoration: InputDecoration(labelText: l10n.addServiceLabel)),
          TextField(controller: label, decoration: InputDecoration(labelText: l10n.addAccountLabel)),
          TextField(
            controller: secret,
            decoration: InputDecoration(labelText: l10n.addSetupKey, helperText: l10n.addSetupKeyHelp),
            autocorrect: false,
            enableSuggestions: false,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonNext)),
        ],
      ),
    );
    if (ok != true) return;
    final key = secret.text.toUpperCase().replaceAll(RegExp(r'[\s=-]'), '');
    try {
      base32Decode(key);
    } on FormatException {
      _say(l10n.addBadKey);
      return;
    }
    await _confirmAndSave(Account(id: newId(), issuer: issuer.text.trim(), label: label.text.trim(), secret: key));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addTitle)),
      body: ListView(children: [
        ListTile(
          leading: Icon(Icons.qr_code_scanner, color: hasCamera ? null : Theme.of(context).disabledColor),
          title: Text(l10n.addScanQr),
          subtitle: Text(hasCamera ? l10n.addScanQrHelp : l10n.addNoCameraOn(Platform.isLinux ? 'Linux' : 'Windows')),
          onTap: _scan,
        ),
        if (canScanScreen)
          ListTile(
            leading: const Icon(Icons.screenshot_monitor),
            title: Text(l10n.addScanScreen),
            subtitle: Text(l10n.addScanScreenHelp),
            onTap: _scanScreen,
          ),
        if (Platform.isLinux)
          ListTile(
            enabled: false,
            leading: const Icon(Icons.screenshot_monitor),
            title: Text(l10n.addScanScreen),
            subtitle: Text(l10n.addScanScreenLinux),
          ),
        ListTile(
          leading: const Icon(Icons.image_outlined),
          title: Text(isPhone ? l10n.addFromPhotos : l10n.addFromPicture),
          subtitle: Text(isPhone ? l10n.addFromPhotosHelp : l10n.addFromPictureHelp),
          onTap: _image,
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(l10n.addPasteLink),
          subtitle: Text(l10n.addPasteLinkHelp),
          onTap: _paste,
        ),
        ListTile(
          leading: const Icon(Icons.people_outline),
          title: Text(l10n.addOpenShared),
          subtitle: Text(l10n.addOpenSharedHelp(shareExtension)),
          onTap: _openShareFile,
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz),
          title: Text(l10n.addFromGoogle),
          subtitle: Text(l10n.addFromGoogleHelp),
          onTap: _fromGoogle,
        ),
        ListTile(
          leading: const Icon(Icons.move_down),
          title: Text(l10n.addFromOtherApp),
          subtitle: Text(l10n.addFromOtherAppHelp),
          onTap: _fromOtherApp,
        ),
        ListTile(
          leading: const Icon(Icons.keyboard_outlined),
          title: Text(l10n.addEnterKey),
          subtitle: Text(l10n.addEnterKeyHelp),
          onTap: _manual,
        ),
      ]),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.prefixes = const ['otpauth://', 'otpauth-migration://', 'steam://', sharePrefix], this.title, this.wrongCode});
  /// QR codes this scan accepts; anything else shows [wrongCode].
  final List<String> prefixes;
  final String? title;
  final String? wrongCode;

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
      setState(() => _hint = widget.wrongCode ?? l10n.addWrongQr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? l10n.addScanQr)),
      body: Stack(children: [
        MobileScanner(
          onDetect: _onDetect,
          errorBuilder: (context, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error.errorCode == MobileScannerErrorCode.permissionDenied
                    ? l10n.addCameraDenied
                    : l10n.addCameraFailed(error.errorCode.name),
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
