import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bridge/server.dart' show addFromUri;
import '../core/account.dart';
import '../core/activity.dart';
import '../core/phone_link.dart';
import '../core/sync/relay_client.dart';
import '../core/sync/sync_service.dart' show SyncService, thisDeviceName;
import '../core/vault.dart';
import 'add.dart' show ScanScreen, hasCamera, confirmAddAccounts;
import 'home.dart' show accountTitle;
import 'premium.dart';
import 'security_ui.dart' show confirmItsYou;
import 'theme.dart';

// ---------------------------------------------------------------- push notifications

const _push = MethodChannel('tanooki/push');

/// Asks the OS for a push token. Returns (platform, token), or throws a plain sentence saying why not.
Future<(String, String)> pushToken() async {
  if (Platform.isAndroid) {
    // deferred(firebase): Android push needs a Firebase project and its google-services.json, which only
    // Maddie's Google account can create. Until then, requests arrive while the app is open.
    throw 'Notifications on Android aren\'t set up yet, so requests show up while Tanooki Auth is open.';
  }
  if (!Platform.isIOS) throw 'This device gets requests while Tanooki Auth is open.';
  try {
    final token = await _push.invokeMethod<String>('register');
    if (token == null || token.isEmpty) throw 'iPhone didn\'t give the app a notification token.';
    return ('apns', token);
  } on PlatformException catch (e) {
    throw e.code == 'denied'
        ? 'Notifications are turned off for Tanooki Auth. Turn them on in the iPhone Settings app, under Notifications, to get requests when the app is closed.'
        : 'Couldn\'t turn on notifications: ${e.message ?? e.code}. Requests still show up while Tanooki Auth is open.';
  } on MissingPluginException {
    throw 'Notifications aren\'t available in this build. Requests show up while Tanooki Auth is open.';
  }
}

// ---------------------------------------------------------------- running

/// Keeps a connection to each paired browser while the app is unlocked, and asks the user about each request.
class LinkService {
  LinkService._();
  static final instance = LinkService._();

  /// What happens with notifications, in plain words (null = working).
  final pushStatus = ValueNotifier<String?>('Checking whether notifications work…');

  Vault? _vault;
  Future<Account?> Function(FillRequest)? _ask;
  Future<bool> Function(List<Account>)? _confirmAdd;
  final _links = <BrowserLink>[];
  final _queue = <FillRequest>[];
  bool _asking = false;

  List<BrowserLink> linksOf(Vault v) =>
      [for (final m in (v.settings[phoneLinksKey] as List?) ?? const []) BrowserLink((m as Map).cast<String, dynamic>())];

  void attach(Vault v, Future<Account?> Function(FillRequest) ask, [Future<bool> Function(List<Account>)? confirmAdd]) {
    detach();
    _vault = v;
    _ask = ask;
    _confirmAdd = confirmAdd ?? _confirmAdd;
    _links.addAll(linksOf(v));
    for (final l in _links) {
      _connect(l);
    }
  }

  void detach() {
    for (final l in _links) {
      l.disconnect();
    }
    _links.clear();
    _queue.clear();
    _vault = null;
  }

  /// After the app comes back to the front (perhaps from a notification): reconnect and fetch.
  void reconnect() {
    final v = _vault, ask = _ask;
    if (v != null && ask != null) attach(v, ask);
  }

  Future<void> _connect(BrowserLink l) async {
    try {
      await l.connect(_onRequest, onGone: () => _forget(l), onDrop: () => Timer(const Duration(seconds: 15), () {
            if (_links.contains(l)) _connect(l);
          }));
    } on RelayException catch (e) {
      if (e.status == 401 || e.status == 404) _forget(l); // the browser unpaired while we were away
    } catch (_) {
      if (_links.contains(l)) Timer(const Duration(seconds: 30), () => _links.contains(l) ? _connect(l) : null);
    }
  }

  Future<void> _forget(BrowserLink l) async {
    final v = _vault;
    l.disconnect();
    _links.remove(l);
    if (v == null) return;
    (v.settings[phoneLinksKey] as List?)?.removeWhere((m) => (m as Map)['room'] == l.room);
    await v.save();
  }

  void _onRequest(FillRequest r) {
    if (_queue.any((q) => q.id == r.id)) return;
    _queue.add(r);
    _next();
  }

  Future<void> _next() async {
    if (_asking || _queue.isEmpty || _ask == null) return;
    _asking = true;
    final r = _queue.removeAt(0);
    try {
      if (r.addUri != null) {
        final v = _vault, confirm = _confirmAdd;
        await r.link.answerAdd(r, v == null || confirm == null ? {'accepted': false, 'reason': 'declined'} : await addFromUri(v, r.addUri, confirm));
        return;
      }
      final account = await _ask!(r);
      await r.link.answer(r, account);
    } catch (_) {
      // Offline or the browser gave up: it times out on its own and shows why.
    } finally {
      _asking = false;
      _next();
    }
  }

  /// Pairs with the browser whose QR is [qr], saves it, and turns on notifications for it.
  Future<void> pair(Vault v, String qr) async {
    final link = await BrowserLink.pair(qr, deviceName: thisDeviceName);
    v.settings[phoneLinksKey] = [...?(v.settings[phoneLinksKey] as List?), link.toJson()];
    await v.save();
    if (_vault == v) {
      _links.add(link);
      _connect(link);
    }
    await registerPush(v);
  }

  Future<void> unpair(Vault v, BrowserLink l) async {
    for (final x in _links.where((x) => x.room == l.room).toList()) {
      x.disconnect();
      _links.remove(x);
    }
    await l.unpair().catchError((_) {}); // already gone on the server is fine
    (v.settings[phoneLinksKey] as List?)?.removeWhere((m) => (m as Map)['room'] == l.room);
    await v.save();
  }

  /// Registers this phone's notification token with every paired browser's room.
  Future<void> registerPush(Vault v) async {
    final links = linksOf(v);
    if (links.isEmpty) return;
    try {
      final (platform, token) = await pushToken();
      String? problem;
      for (final l in links) {
        problem ??= await l.registerPush(platform, token, environment: kReleaseMode ? 'production' : 'sandbox');
      }
      pushStatus.value = problem;
    } on String catch (why) {
      pushStatus.value = why;
    } on RelayException catch (e) {
      pushStatus.value = e.message;
    }
  }
}

// ---------------------------------------------------------------- the Approve / Deny sheet

/// Asks whether to send a code for [r]. Returns the account to send, or null to deny.
Future<Account?> askToApprove(BuildContext context, Vault vault, FillRequest r) async {
  final offered = accountsForHost(vault.visible, r.host);
  final nav = Navigator.of(context);
  var open = true;
  // The browser stops waiting after about two minutes; don't leave a stale question on screen.
  final expire = Timer(const Duration(seconds: 110), () {
    if (open) nav.pop();
  });
  final result = await showModalBottomSheet<Account>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (c) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Sign-in code request', style: TextStyle(color: Palette.muted, fontSize: 13)),
          const SizedBox(height: 4),
          Text(r.host, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            offered.isEmpty
                ? 'No account is saved for this website, so there\'s nothing to send. If you expected one, this might be a fake site pretending to be a real one.'
                : 'Your paired browser wants the code for this website. Only approve if you\'re signing in right now.',
            style: TextStyle(color: Palette.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          for (final a in offered)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilledButton(
                onPressed: () => Navigator.pop(c, a),
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: Text(offered.length == 1 ? 'Approve' : 'Approve: ${accountTitle(a)}'),
              ),
            ),
          OutlinedButton(
            onPressed: () => Navigator.pop(c),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Deny'),
          ),
        ]),
      ),
    ),
  );
  open = false;
  expire.cancel();
  return result;
}

// ---------------------------------------------------------------- Settings > Use with a browser

class BrowserLinkScreen extends StatefulWidget {
  const BrowserLinkScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<BrowserLinkScreen> createState() => _BrowserLinkScreenState();
}

class _BrowserLinkScreenState extends State<BrowserLinkScreen> {
  final _service = LinkService.instance;
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _service.pushStatus.addListener(_refresh);
    if (_service.linksOf(widget.vault).isNotEmpty) _service.registerPush(widget.vault);
  }

  @override
  void dispose() {
    _service.pushStatus.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pair() async {
    String? qr;
    if (hasCamera) {
      qr = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => const ScanScreen(
            prefixes: ['tanookiauth://link?'],
            title: 'Scan the browser\'s code',
            wrongCode: 'That isn\'t a browser pairing code. In the browser, click the Tanooki Auth extension, then "Use my phone instead".',
          ),
        ),
      );
    } else {
      final field = TextEditingController();
      qr = await showDialog<String>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Paste the pairing link'),
          content: TextField(controller: field, autofocus: true, maxLines: 3),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('Pair')),
          ],
        ),
      );
    }
    if (qr == null || !mounted) return;
    setState(() => _working = true);
    try {
      await _service.pair(widget.vault, qr);
      _say('Paired. When that browser asks for a code, you\'ll see it here.');
    } on FormatException catch (e) {
      _say(e.message);
    } on RelayException catch (e) {
      _say(e.status == 410 ? 'That code has expired. In the browser, make a new one and scan it again.' : e.message);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _unpair(BrowserLink l) async {
    setState(() => _working = true);
    await _service.unpair(widget.vault, l);
    if (mounted) setState(() => _working = false);
  }

  @override
  Widget build(BuildContext context) {
    final links = _service.linksOf(widget.vault);
    final Widget body;
    if (!premium.value) {
      body = Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Using your phone with a browser is part of Premium', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: widget.vault)));
                setState(() {});
              },
              child: const Text('See Premium'),
            ),
          ]),
        ),
      );
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          'Fill codes in a browser on any computer, even one without the Tanooki Auth app. The browser extension asks, and you tap Approve here. Codes travel end-to-end encrypted, and only for the website each account is saved for.',
          style: TextStyle(color: Palette.muted, height: 1.4),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _working ? null : _pair,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Pair a browser'),
        ),
        const SizedBox(height: 6),
        Text('In the browser, click the Tanooki Auth extension, then "Use my phone instead" to show the code.',
            style: TextStyle(color: Palette.muted, fontSize: 12)),
        const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('Paired browsers')),
        Card(
          child: Column(children: [
            if (links.isEmpty) const ListTile(title: Text('None yet')),
            for (final l in links)
              ListTile(
                leading: const Icon(Icons.web_outlined),
                title: const Text('Browser'),
                subtitle: Text('Paired ${l.pairedAt.toLocal().month}/${l.pairedAt.toLocal().day}/${l.pairedAt.toLocal().year}'),
                trailing: TextButton(onPressed: _working ? null : () => _unpair(l), child: const Text('Unpair')),
              ),
            if (links.isNotEmpty) ...[
              const Divider(),
              ListTile(
                leading: Icon(_service.pushStatus.value == null ? Icons.notifications_active_outlined : Icons.notifications_off_outlined),
                title: Text(_service.pushStatus.value == null ? 'Notifications on' : 'Requests show while the app is open'),
                subtitle: Text(_service.pushStatus.value ?? 'You\'ll get a notification for each request, even when Tanooki Auth is closed.'),
              ),
            ],
          ]),
        ),
      ]);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Use with a browser')),
      body: Stack(children: [
        ListView(padding: const EdgeInsets.all(16), children: [
          Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: body)),
        ]),
        if (_working) const LinearProgressIndicator(),
      ]),
    );
  }
}

// ---------------------------------------------------------------- hooks for the app's lock (main.dart)

/// Starts sync and the browser link once the app is unlocked into [v].
void startSyncAndLink(BuildContext context, Vault v, Future<void> Function() bringToFront) {
  SyncService.instance.attach(v);
  LinkService.instance.attach(v, (r) async {
    await bringToFront();
    if (!context.mounted) return null;
    final a = await askToApprove(context, v, r);
    if (a == null || !context.mounted) return null;
    // "Ask first" accounts: Face ID / passcode here before the code goes to the browser.
    if (a.requireAuth && !await confirmItsYou(context, v, 'Send the code for ${accountTitle(a)}')) return null;
    logActivity(v, ActivityKind.filled, accountId: a.id, where: 'Browser, through this phone');
    await v.save();
    return a;
  }, (accounts) async {
    // The browser's right-click "Add to Tanooki Auth": always ask here before saving.
    await bringToFront();
    return context.mounted && await confirmAddAccounts(context, accounts);
  });
}

/// Stops both when the app locks or closes: nothing talks to the internet while locked.
void stopSyncAndLink() {
  SyncService.instance.detach();
  LinkService.instance.detach();
}

/// Back in front (maybe from a notification): reconnect, fetch waiting requests, and sync.
void resumeSyncAndLink() {
  LinkService.instance.reconnect();
  SyncService.instance.syncNow();
}
