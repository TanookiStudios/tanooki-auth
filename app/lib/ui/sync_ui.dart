import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw show Barcode, BarcodeBar;

import '../core/sync/sync_engine.dart';
import '../core/sync/sync_service.dart';
import '../core/vault.dart';
import 'add.dart' show ScanScreen, hasCamera;
import 'phone_link_ui.dart' show BrowserLinkScreen;
import 'premium.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// A QR code drawn on screen (black on white, with a quiet zone so cameras find it).
class QrView extends StatelessWidget {
  const QrView(this.data, {super.key, this.size = 220});
  final String data;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
        label: l10n.syncUiQrCode,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: CustomPaint(size: Size.square(size), painter: _QrPainter(data)),
        ),
      );
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.data);
  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final black = Paint()..color = Colors.black;
    for (final e in pw.Barcode.qrCode().make(data, width: size.width, height: size.height)) {
      if (e is pw.BarcodeBar && e.black) canvas.drawRect(Rect.fromLTWH(e.left, e.top, e.width, e.height), black);
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.data != data;
}

String agoText(DateTime? t) {
  if (t == null) return l10n.syncUiNotYet;
  final d = DateTime.now().difference(t);
  if (d.inSeconds < 60) return l10n.syncUiJustNow;
  if (d.inMinutes < 60) return l10n.syncUiMinutesAgo(d.inMinutes);
  if (d.inHours < 24) return l10n.syncUiHoursAgo(d.inHours);
  return l10n.syncUiDate(t);
}

/// Settings > Sync (Premium).
class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final _service = SyncService.instance;
  bool _working = false;
  List<_Device>? _devices;
  String? _devicesError;

  Vault get v => widget.vault;

  @override
  void initState() {
    super.initState();
    _service.status.addListener(_refresh);
    _loadDevices();
  }

  @override
  void dispose() {
    _service.status.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _loadDevices() async {
    if (!syncOn(v)) return;
    try {
      final list = syncTransport(v) == 'relay'
          ? [
              for (final d in await (await RelaySync(v).relay()).devices())
                _Device(d.key, d.key == syncState(v)['devicePub'] ? l10n.syncUiThisDevice : l10n.syncUiAnotherDevice, l10n.syncUiAdded(agoText(d.added)), d.key == syncState(v)['devicePub']),
            ]
          : [
              for (final d in await FolderSync(v, _service.folder).devices())
                _Device(d.id, d.id == syncState(v)['device'] ? l10n.syncUiThisDeviceNamed(d.name) : d.name, l10n.syncUiLastSyncedAgo(agoText(d.updated)), d.id == syncState(v)['device']),
            ];
      if (mounted) {
        setState(() {
          _devices = list;
          _devicesError = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _devicesError = describeSyncError(e));
    }
  }

  /// Runs [job] with a spinner; shows its error sentence if it fails.
  Future<bool> _busy(Future<void> Function() job) async {
    setState(() => _working = true);
    try {
      await job();
      return true;
    } catch (e) {
      _say(describeSyncError(e));
      return false;
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<String?> _askPassphrase({required bool newOne}) => showDialog<String>(
        context: context,
        builder: (_) => _PassphraseDialog(newOne: newOne),
      );

  Future<void> _turnOn() async {
    var transport = 'relay';
    final apple = Platform.isIOS || Platform.isMacOS;
    if (apple) {
      final icloudProblem = await ICloudFolder.problem();
      final icloud = icloudProblem == null;
      if (!mounted) return;
      final choice = await showDialog<String>(
        context: context,
        builder: (c) => SimpleDialog(title: Text(l10n.syncUiWhere), children: [
          SimpleDialogOption(
            onPressed: icloud ? () => Navigator.pop(c, 'icloud') : null,
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('iCloud'),
              subtitle: Text(icloudProblem ?? l10n.syncUiICloudHelp),
              enabled: icloud,
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(c, 'relay'),
            child: ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: Text(l10n.syncUiRelay),
              subtitle: Text(l10n.syncUiRelayHelp),
            ),
          ),
        ]),
      );
      if (choice == null) return;
      transport = choice;
    }
    final pass = await _askPassphrase(newOne: true);
    if (pass == null) return;
    var ok = await _busy(() => transport == 'icloud'
        ? SyncSetup.startICloud(v, pass, _service.folder)
        : SyncSetup.startRelay(v, pass));
    if (!ok && transport == 'icloud' && mounted) {
      final fresh = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.syncUiStartFreshTitle),
          content: Text(l10n.syncUiStartFreshBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.syncUiStartFresh)),
          ],
        ),
      );
      if (fresh == true) ok = await _busy(() => SyncSetup.startICloud(v, pass, _service.folder, fresh: true));
    }
    if (!ok) return;
    _service.attach(v);
    await _service.syncNow();
    await _loadDevices();
    _say(l10n.syncUiOn);
  }

  Future<void> _join() async {
    String? link;
    if (hasCamera) {
      link = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => ScanScreen(
            prefixes: const ['tanookiauth://sync?'],
            title: l10n.syncUiScanTitle,
            wrongCode: l10n.syncUiScanWrong,
          ),
        ),
      );
    } else {
      link = await _pasteDialog();
    }
    if (link == null || !mounted) return;
    final pass = await _askPassphrase(newOne: false);
    if (pass == null) return;
    if (!await _busy(() => SyncSetup.joinRelay(v, link!, pass))) return;
    _service.attach(v);
    await _service.syncNow();
    await _loadDevices();
    _say(l10n.syncUiNowSyncing);
  }

  Future<String?> _pasteDialog() {
    final field = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.syncUiPasteTitle),
        content: TextField(
          controller: field,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(hintText: l10n.syncUiPasteHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: Text(l10n.commonNext)),
        ],
      ),
    );
  }

  Future<void> _addDevice() async {
    if (syncTransport(v) != 'relay') {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.syncUiAddApple),
          content: Text(l10n.syncUiAddAppleBody),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonOk))],
        ),
      );
      return;
    }
    String? link;
    if (!await _busy(() async => link = await SyncSetup.inviteLink(v)) || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.syncUiAddDevice),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(l10n.syncUiAddDeviceBody),
            const SizedBox(height: 16),
            QrView(link!),
            const SizedBox(height: 12),
            Text(l10n.syncUiAddDeviceNote,
                style: TextStyle(color: Palette.muted, fontSize: 12)),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link!));
              if (c.mounted) Navigator.pop(c);
              _say(l10n.syncUiLinkCopied);
            },
            child: Text(l10n.syncUiCopyLink),
          ),
          FilledButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonDone)),
        ],
      ),
    );
    await _loadDevices();
  }

  Future<void> _removeDevice(_Device d) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.syncUiRemoveTitle),
        content: Text(l10n.syncUiRemoveBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonRemove)),
        ],
      ),
    );
    if (sure != true) return;
    await _busy(() async => syncTransport(v) == 'relay'
        ? (await RelaySync(v).relay()).removeDevice(d.id)
        : FolderSync(v, _service.folder).removeDevice(d.id));
    await _loadDevices();
  }

  Future<void> _turnOff() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.syncUiTurnOffTitle),
        content: Text(l10n.syncUiTurnOffBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonTurnOff)),
        ],
      ),
    );
    if (sure != true) return;
    _service.detach();
    await _busy(() => SyncSetup.turnOff(v, folder: _service.folder));
    setState(() => _devices = null);
    _say(l10n.syncUiOff);
  }

  @override
  Widget build(BuildContext context) {
    final st = _service.status.value;
    Widget body;
    if (!premium.value) {
      body = Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.syncUiPremium, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text(l10n.syncUiPremiumBody(payOnce),
                style: TextStyle(color: Palette.muted, height: 1.4)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: v)));
                setState(() {});
              },
              child: Text(l10n.commonSeePremium),
            ),
          ]),
        ),
      );
    } else if (!syncOn(v)) {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          l10n.syncUiIntro,
          style: TextStyle(color: Palette.muted, height: 1.4),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: _working ? null : _turnOn, icon: const Icon(Icons.sync), label: Text(l10n.syncUiTurnOn)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _working ? null : _join,
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(l10n.syncUiJoin),
        ),
        const SizedBox(height: 6),
        Text(l10n.syncUiJoinHelp, style: TextStyle(color: Palette.muted, fontSize: 12)),
      ]);
    } else {
      final relay = syncTransport(v) == 'relay';
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(
          child: Column(children: [
            ListTile(
              leading: Icon(st.error != null ? Icons.sync_problem : Icons.cloud_done_outlined, color: st.error != null ? Palette.red : Palette.green),
              title: Text(relay ? l10n.syncUiSyncingRelay : l10n.syncUiSyncingICloud),
              subtitle: Text(st.busy ? l10n.syncUiSyncingNow : st.error ?? l10n.teamUiLastSynced(agoText(st.lastSync))),
              trailing: st.busy
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : TextButton(onPressed: _service.syncNow, child: Text(l10n.teamUiSyncNow)),
            ),
            if (st.skipped > 0) ...[
              const Divider(),
              ListTile(
                leading: Icon(Icons.warning_amber_rounded, color: Palette.red),
                title: Text(l10n.syncUiSkipped(st.skipped)),
                subtitle: Text(l10n.syncUiSkippedHelp),
              ),
            ],
          ]),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel(l10n.syncUiDevices)),
        Card(
          child: Column(children: [
            if (_devicesError != null) ListTile(title: Text(_devicesError!)),
            if (_devices == null && _devicesError == null)
              ListTile(title: Text(l10n.syncUiLoading)),
            for (final d in _devices ?? const <_Device>[]) ...[
              ListTile(
                leading: Icon(d.me ? Icons.smartphone : Icons.devices_other),
                title: Text(d.name),
                subtitle: Text(d.detail),
                trailing: d.me ? null : TextButton(onPressed: () => _removeDevice(d), child: Text(l10n.commonRemove)),
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(l10n.syncUiAddDevice),
              subtitle: Text(relay ? l10n.syncUiAddDeviceRelay : l10n.syncUiAddDeviceApple),
              onTap: _working ? null : _addDevice,
            ),
          ]),
        ),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: _working ? null : _turnOff, child: Text(l10n.syncUiTurnOffButton)),
        const SizedBox(height: 10),
        Text(
          relay
              ? l10n.syncUiPassphraseNoteRelay
              : l10n.syncUiPassphraseNoteICloud,
          style: TextStyle(color: Palette.muted, fontSize: 12, height: 1.4),
        ),
      ]);
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncUiTitle)),
      body: Stack(children: [
        ListView(padding: const EdgeInsets.all(16), children: [
          Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: body)),
        ]),
        if (_working) const LinearProgressIndicator(),
      ]),
    );
  }
}

class _Device {
  _Device(this.id, this.name, this.detail, this.me);
  final String id;
  final String name;
  final String detail;
  final bool me;
}

class _PassphraseDialog extends StatefulWidget {
  const _PassphraseDialog({required this.newOne});
  final bool newOne;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final _a = TextEditingController();
  final _b = TextEditingController();
  String? _error;

  void _submit() {
    final p = _a.text;
    if (widget.newOne) {
      if (p.length < 10) return setState(() => _error = l10n.syncUiTooShort);
      if (p != _b.text) return setState(() => _error = l10n.syncUiMismatch);
    } else if (p.isEmpty) {
      return;
    }
    Navigator.pop(context, p);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.newOne ? l10n.syncUiChoosePassphrase : l10n.syncUiTypePassphrase),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.newOne
                ? l10n.syncUiChooseHelp
                : l10n.syncUiTypeHelp),
            const SizedBox(height: 12),
            TextField(
              controller: _a,
              autofocus: true,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(labelText: l10n.syncUiPassphrase),
              onSubmitted: widget.newOne ? null : (_) => _submit(),
            ),
            if (widget.newOne)
              TextField(
                controller: _b,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(labelText: l10n.syncUiTypeAgain),
                onSubmitted: (_) => _submit(),
              ),
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Palette.red))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: _submit, child: Text(widget.newOne ? l10n.syncUiTurnOn : l10n.teamUiJoinButton)),
        ],
      );
}


/// The "Sync and phone" card in Settings.
List<Widget> syncAndLinkSection(BuildContext context, Vault v, VoidCallback refresh) {
  final phone = Platform.isIOS || Platform.isAndroid;
  Future<void> open(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    refresh();
  }

  return [
    Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 8), child: CapsLabel(l10n.syncUiSectionTitle)),
    Card(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.sync),
          title: Text(premium.value ? l10n.syncUiTitle : l10n.syncUiTitlePremium),
          subtitle: Text(syncOn(v)
              ? (syncTransport(v) == 'relay' ? l10n.syncUiOnRelay : l10n.syncUiOnICloud)
              : l10n.syncUiOffHelp),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => open(SyncScreen(vault: v)),
        ),
        if (phone) ...[
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phonelink_lock_outlined),
            title: Text(premium.value ? l10n.syncUiBrowser : l10n.syncUiBrowserPremium),
            subtitle: Text(l10n.syncUiBrowserHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(BrowserLinkScreen(vault: v)),
          ),
        ],
      ]),
    ),
    const SizedBox(height: 20),
  ];
}
