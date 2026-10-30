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

/// A QR code drawn on screen (black on white, with a quiet zone so cameras find it).
class QrView extends StatelessWidget {
  const QrView(this.data, {super.key, this.size = 220});
  final String data;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'QR code',
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
  if (t == null) return 'Not yet';
  final d = DateTime.now().difference(t);
  if (d.inSeconds < 60) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes} min ago';
  if (d.inHours < 24) return '${d.inHours} h ago';
  return '${t.month}/${t.day}/${t.year}';
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
                _Device(d.key, d.key == syncState(v)['devicePub'] ? 'This device' : 'Another device', 'Added ${agoText(d.added)}', d.key == syncState(v)['devicePub']),
            ]
          : [
              for (final d in await FolderSync(v, _service.folder).devices())
                _Device(d.id, d.id == syncState(v)['device'] ? 'This device (${d.name})' : d.name, 'Last synced ${agoText(d.updated)}', d.id == syncState(v)['device']),
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
        builder: (c) => SimpleDialog(title: const Text('Where should your devices sync?'), children: [
          SimpleDialogOption(
            onPressed: icloud ? () => Navigator.pop(c, 'icloud') : null,
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('iCloud'),
              subtitle: Text(icloudProblem ?? 'For iPhone, iPad and Mac only. Uses your own iCloud Drive.'),
              enabled: icloud,
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(c, 'relay'),
            child: const ListTile(
              leading: Icon(Icons.devices_outlined),
              title: Text('Tanooki relay'),
              subtitle: Text('Works with every device, including Android and Windows. The server only stores scrambled data.'),
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
          title: const Text('Start fresh?'),
          content: const Text(
              'If you\'ve forgotten the passphrase your other Apple devices use, you can start a new sync with this one. Your other devices then need to turn sync off and on again with the new passphrase.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Start fresh')),
          ],
        ),
      );
      if (fresh == true) ok = await _busy(() => SyncSetup.startICloud(v, pass, _service.folder, fresh: true));
    }
    if (!ok) return;
    _service.attach(v);
    await _service.syncNow();
    await _loadDevices();
    _say('Sync is on.');
  }

  Future<void> _join() async {
    String? link;
    if (hasCamera) {
      link = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => const ScanScreen(
            prefixes: ['tanookiauth://sync?'],
            title: 'Scan the sync code',
            wrongCode: 'That isn\'t a sync code. On your other device, open Settings, Sync, Add a device.',
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
    _say('This device is now syncing.');
  }

  Future<String?> _pasteDialog() {
    final field = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Paste the sync link'),
        content: TextField(
          controller: field,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'tanookiauth://sync?…  (from Add a device on your other device)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('Next')),
        ],
      ),
    );
  }

  Future<void> _addDevice() async {
    if (syncTransport(v) != 'relay') {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Add an Apple device'),
          content: const Text(
              'On your other iPhone, iPad or Mac (signed in to the same Apple ID, with iCloud Drive on), open Tanooki Auth, go to Settings, then Sync, tap "Turn on sync", pick iCloud and type the same sync passphrase.\n\nWant to add an Android phone or a Windows PC? Turn sync off on every device, then turn it on again with the Tanooki relay.'),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
      return;
    }
    String? link;
    if (!await _busy(() async => link = await SyncSetup.inviteLink(v)) || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add a device'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('On the new device, open Tanooki Auth, go to Settings, then Sync, and tap "Join from another device". Scan this code, then type your sync passphrase there.'),
            const SizedBox(height: 16),
            QrView(link!),
            const SizedBox(height: 12),
            Text('Works once, for 24 hours. Someone with only this code can\'t read anything without your passphrase.',
                style: TextStyle(color: Palette.muted, fontSize: 12)),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link!));
              if (c.mounted) Navigator.pop(c);
              _say('Link copied. Paste it on the new device.');
            },
            child: const Text('Copy link instead'),
          ),
          FilledButton(onPressed: () => Navigator.pop(c), child: const Text('Done')),
        ],
      ),
    );
    await _loadDevices();
  }

  Future<void> _removeDevice(_Device d) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove this device from sync?'),
        content: const Text(
            'It stops getting changes. If the device was lost or stolen, also change your sync passphrase: turn sync off on every device, then on again with a new passphrase, because the lost device still knows the old one.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Remove')),
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
        title: const Text('Turn off sync on this device?'),
        content: const Text('Your accounts stay on this device. It just stops sending and getting changes. Your other devices keep syncing with each other.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Turn off')),
        ],
      ),
    );
    if (sure != true) return;
    _service.detach();
    await _busy(() => SyncSetup.turnOff(v, folder: _service.folder));
    setState(() => _devices = null);
    _say('Sync is off on this device.');
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
            const Text('Sync is part of Premium', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Add an account on one device and it shows up on all of them, end-to-end encrypted. \$5 once, no subscription.',
                style: TextStyle(color: Palette.muted, height: 1.4)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: v)));
                setState(() {});
              },
              child: const Text('See Premium'),
            ),
          ]),
        ),
      );
    } else if (!syncOn(v)) {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          'Sync keeps your accounts the same on all your devices. Before anything leaves this device it\'s locked with your sync passphrase, so iCloud or our server only ever stores scrambled data. Nobody else can read it, including us.',
          style: TextStyle(color: Palette.muted, height: 1.4),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: _working ? null : _turnOn, icon: const Icon(Icons.sync), label: const Text('Turn on sync')),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _working ? null : _join,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Join from another device'),
        ),
        const SizedBox(height: 6),
        Text('Use "Join" when another device already syncs with the Tanooki relay.', style: TextStyle(color: Palette.muted, fontSize: 12)),
      ]);
    } else {
      final relay = syncTransport(v) == 'relay';
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(
          child: Column(children: [
            ListTile(
              leading: Icon(st.error != null ? Icons.sync_problem : Icons.cloud_done_outlined, color: st.error != null ? Palette.red : Palette.green),
              title: Text(relay ? 'Syncing with the Tanooki relay' : 'Syncing with iCloud'),
              subtitle: Text(st.busy ? 'Syncing now…' : st.error ?? 'Last synced: ${agoText(st.lastSync)}'),
              trailing: st.busy
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : TextButton(onPressed: _service.syncNow, child: const Text('Sync now')),
            ),
            if (st.skipped > 0) ...[
              const Divider(),
              ListTile(
                leading: Icon(Icons.warning_amber_rounded, color: Palette.red),
                title: Text('${st.skipped} synced item${st.skipped == 1 ? '' : 's'} couldn\'t be read'),
                subtitle: const Text('They may have been changed by someone else or made with another passphrase. Nothing was deleted because of them.'),
              ),
            ],
          ]),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('Devices')),
        Card(
          child: Column(children: [
            if (_devicesError != null) ListTile(title: Text(_devicesError!)),
            if (_devices == null && _devicesError == null)
              const ListTile(title: Text('Loading…')),
            for (final d in _devices ?? const <_Device>[]) ...[
              ListTile(
                leading: Icon(d.me ? Icons.smartphone : Icons.devices_other),
                title: Text(d.name),
                subtitle: Text(d.detail),
                trailing: d.me ? null : TextButton(onPressed: () => _removeDevice(d), child: const Text('Remove')),
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add a device'),
              subtitle: Text(relay ? 'Shows a code to scan on the new device' : 'Another iPhone, iPad or Mac'),
              onTap: _working ? null : _addDevice,
            ),
          ]),
        ),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: _working ? null : _turnOff, child: const Text('Turn off sync on this device')),
        const SizedBox(height: 10),
        Text(
          relay
              ? 'Your sync passphrase can\'t be recovered. If you forget it, turn sync off on every device and start again with a new one. Your accounts stay put.'
              : 'Sync uses your iCloud Drive. Your sync passphrase can\'t be recovered; if you forget it, start fresh with a new one. Your accounts stay put.',
          style: TextStyle(color: Palette.muted, fontSize: 12, height: 1.4),
        ),
      ]);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Sync')),
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
      if (p.length < 10) return setState(() => _error = 'Use at least 10 characters. A few random words works well.');
      if (p != _b.text) return setState(() => _error = 'The two passphrases don\'t match.');
    } else if (p.isEmpty) {
      return;
    }
    Navigator.pop(context, p);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.newOne ? 'Choose a sync passphrase' : 'Type your sync passphrase'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.newOne
                ? 'You\'ll type this once on each device you add. It locks your accounts before they leave this device.\n\nWrite it down somewhere safe. It can\'t be recovered or reset, by you or by us.'
                : 'The same passphrase you chose when you turned on sync on your first device.'),
            const SizedBox(height: 12),
            TextField(
              controller: _a,
              autofocus: true,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Sync passphrase'),
              onSubmitted: widget.newOne ? null : (_) => _submit(),
            ),
            if (widget.newOne)
              TextField(
                controller: _b,
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration(labelText: 'Type it again'),
                onSubmitted: (_) => _submit(),
              ),
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Palette.red))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: _submit, child: Text(widget.newOne ? 'Turn on sync' : 'Join')),
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
    const Padding(padding: EdgeInsets.fromLTRB(4, 0, 4, 8), child: CapsLabel('Sync and phone')),
    Card(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.sync),
          title: Text(premium.value ? 'Sync' : 'Sync (Premium)'),
          subtitle: Text(syncOn(v)
              ? 'On, with ${syncTransport(v) == 'relay' ? 'the Tanooki relay' : 'iCloud'}'
              : 'Keep your accounts the same on all your devices'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => open(SyncScreen(vault: v)),
        ),
        if (phone) ...[
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phonelink_lock_outlined),
            title: Text(premium.value ? 'Use with a browser' : 'Use with a browser (Premium)'),
            subtitle: const Text('Approve codes on this phone for a browser on any computer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(BrowserLinkScreen(vault: v)),
          ),
        ],
      ]),
    ),
    const SizedBox(height: 20),
  ];
}
