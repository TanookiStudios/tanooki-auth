// Phone side of the browser phone link (relay/PROTOCOL.md section 2): pair by scanning the extension's QR,
// then answer its fill requests with Approve (sends the current code) or Deny. Everything between the
// extension and this phone is end-to-end encrypted; the relay sees only ciphertext.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

import 'account.dart';
import 'sync/relay_client.dart';
import 'sync/relay_crypto.dart';

/// Vault settings key: list of paired browsers (maps from [BrowserLink.toJson]).
const phoneLinksKey = 'phoneLinks';

/// What the extension's QR code says: `tanookiauth://link?v=1&relay=..&room=..&key=..&secret=..`.
({String relay, String room, String extPub, String secret}) parseLinkQr(String text) {
  final u = Uri.tryParse(text.trim());
  final q = u?.queryParameters ?? const {};
  final ok = u != null &&
      u.scheme == 'tanookiauth' &&
      u.host == 'link' &&
      q['v'] == '1' &&
      (q['relay'] ?? '').startsWith('https://') &&
      [q['room'], q['key'], q['secret']].every((v) => v != null && RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(v));
  if (!ok) throw const FormatException('That isn\'t a Tanooki Auth browser pairing code.');
  return (relay: q['relay']!, room: q['room']!, extPub: q['key']!, secret: q['secret']!);
}

/// A request from the browser, decrypted: a sign-in code for [host], or (when [addUri] is set) its
/// right-click "Add to Tanooki Auth" with an otpauth:// link.
class FillRequest {
  FillRequest(this.link, this.id, this.host, this.messageId, {this.addUri});
  final BrowserLink link;
  final String id;
  final String host;
  final int messageId;
  final String? addUri;
}

/// Accounts saved for [host] (same rule as the extension: the domain or a subdomain of it).
List<Account> accountsForHost(Iterable<Account> accounts, String host) {
  final h = host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
  return [
    for (final a in accounts)
      if (!a.trashed && a.domains.any((d) => h == d || h.endsWith('.$d'))) a,
  ];
}

/// One paired browser.
class BrowserLink {
  BrowserLink(this.data);
  final Map<String, dynamic> data;

  String get relay => data['relay'] as String;
  String get room => data['room'] as String;
  String get token => data['token'] as String;
  DateTime get pairedAt => DateTime.parse(data['pairedAt'] as String);
  String get roomPath => '/v1/link/rooms/$room';

  ({List<int> e2p, List<int> p2e})? _keys;
  final _seen = <String, DateTime>{};
  WebSocket? _ws;
  int _cursor = 0;

  Map<String, dynamic> toJson() => data;

  /// Joins the room in [qr], derives the shared keys and says hello (PROTOCOL.md 2.1 steps 4 and 6).
  static Future<BrowserLink> pair(String qr, {required String deviceName}) async {
    final p = parseLinkQr(qr);
    final seed = randomBytes(32);
    final pair = await X25519().newKeyPairFromSeed(seed);
    final phonePub = b64u((await pair.extractPublicKey()).bytes);
    final r = expectStatus(await relayFetch(p.relay, 'POST', '/v1/link/rooms/${p.room}/join', body: {'phoneKey': phonePub}), [201]);
    final link = BrowserLink({
      'relay': p.relay,
      'room': p.room,
      'extPub': p.extPub,
      'secret': p.secret,
      'seed': b64u(seed),
      'phonePub': phonePub,
      'token': r['phoneToken'],
      'pairedAt': DateTime.now().toUtc().toIso8601String(),
    });
    await link.send({'t': 'hello', 'device': deviceName});
    return link;
  }

  Future<({List<int> e2p, List<int> p2e})> keys() async {
    if (_keys != null) return _keys!;
    final pair = await X25519().newKeyPairFromSeed(unb64u(data['seed'] as String));
    final shared = await X25519().sharedSecretKey(
      keyPair: pair,
      remotePublicKey: SimplePublicKey(unb64u(data['extPub'] as String), type: KeyPairType.x25519),
    );
    final okm = await hkdf(await shared.extractBytes(), unb64u(data['secret'] as String),
        'TA-LINK-1|$room|${data['extPub']}|${data['phonePub']}', 64);
    return _keys = (e2p: okm.sublist(0, 32), p2e: okm.sublist(32));
  }

  /// Encrypts and sends one inner message to the browser.
  Future<void> send(Map<String, dynamic> msg) async {
    final full = {...msg, 'id': b64u(randomBytes(16)), 'ts': DateTime.now().millisecondsSinceEpoch};
    final ct = await seal((await keys()).p2e, full, 'TA-LINK-1|$room|p2e');
    expectStatus(await relayFetch(relay, 'POST', '$roomPath/messages', token: token, body: {'ciphertext': ct}), [201]);
  }

  /// Decrypts a message from the browser. Null if it doesn't decrypt, is stale, or is a replay.
  Future<Map<String, dynamic>?> _open(Map<String, dynamic> m) async {
    if (m['from'] != 'ext') return null;
    Map<String, dynamic> msg;
    try {
      msg = await open((await keys()).e2p, m['ciphertext'] as String, 'TA-LINK-1|$room|e2p');
    } catch (_) {
      return null;
    }
    final now = DateTime.now();
    final age = now.millisecondsSinceEpoch - (msg['ts'] as int? ?? 0);
    _seen.removeWhere((_, t) => now.difference(t) > const Duration(minutes: 5));
    final id = msg['id'] as String? ?? '';
    if (age > 120000 || age < -30000 || id.isEmpty || _seen.containsKey(id)) return null;
    _seen[id] = now;
    return msg;
  }

  Future<void> _handle(Map<String, dynamic> m, void Function(FillRequest) onRequest) async {
    final id = m['id'];
    if (id is int && id > _cursor) _cursor = id;
    final msg = await _open(m);
    if (msg != null && msg['t'] == 'fill-request' && msg['host'] is String) {
      onRequest(FillRequest(this, msg['id'] as String, msg['host'] as String, id as int));
    } else if (msg != null && msg['t'] == 'add-request' && msg['uri'] is String) {
      onRequest(FillRequest(this, msg['id'] as String, '', id as int, addUri: msg['uri'] as String));
    }
  }

  /// Fetches anything waiting (used after connecting and after a push notification).
  Future<void> poll(void Function(FillRequest) onRequest) async {
    final b = expectStatus(await relayFetch(relay, 'GET', '$roomPath/messages?after=$_cursor', token: token), [200]);
    for (final m in (b['messages'] as List).cast<Map<String, dynamic>>()) {
      await _handle(m, onRequest);
    }
  }

  /// Listens for requests while the app is open. [onGone] runs when the browser unpaired.
  Future<void> connect(void Function(FillRequest) onRequest, {required void Function() onGone, required void Function() onDrop}) async {
    final ws = await WebSocket.connect('${relay.replaceFirst('http', 'ws')}$roomPath/ws').timeout(const Duration(seconds: 20));
    _ws = ws;
    ws.add(jsonEncode({'type': 'auth', 'token': token}));
    ws.listen((raw) {
      if (raw is! String || raw == 'pong') return;
      final e = jsonDecode(raw) as Map<String, dynamic>;
      if (e['type'] == 'message') _handle((e['message'] as Map).cast<String, dynamic>(), onRequest);
      if (e['type'] == 'unpaired') onGone();
    }, onDone: () {
      if (ws.closeCode == 4001 || ws.closeCode == 4002) {
        onGone();
      } else if (_ws == ws) {
        onDrop();
      }
    }, cancelOnError: true);
    await poll(onRequest);
  }

  void disconnect() {
    final ws = _ws;
    _ws = null;
    ws?.close();
  }

  /// Sends the code for [account] in answer to [r], or a "deny" when [account] is null.
  Future<void> answer(FillRequest r, Account? account) async {
    if (account == null) {
      await send({'t': 'deny', 're': r.id});
    } else {
      final domain = accountsDomainFor(account, r.host);
      if (domain.isEmpty) throw ArgumentError('That account isn\'t saved for ${r.host}.');
      final now = DateTime.now();
      await send({
        't': 'code',
        're': r.id,
        'code': account.codeAt(now),
        'expiresIn': account.period - (now.millisecondsSinceEpoch ~/ 1000) % account.period,
        'domain': domain,
        'issuer': account.issuer,
      });
    }
    await relayFetch(relay, 'DELETE', '$roomPath/messages/${r.messageId}', token: token).catchError((_) => RelayResponse(0, {}));
  }

  /// Answers an `add-request` with `add-result` {re, accepted, reason} ([reply] comes from addFromUri).
  Future<void> answerAdd(FillRequest r, Map<String, dynamic> reply) async {
    await send({
      't': 'add-result',
      're': r.id,
      'accepted': reply['accepted'] == true,
      'reason': reply['reason'] ?? '',
      if (reply['message'] != null) 'message': reply['message'],
    });
    await relayFetch(relay, 'DELETE', '$roomPath/messages/${r.messageId}', token: token).catchError((_) => RelayResponse(0, {}));
  }

  /// Registers this phone's push token. Returns null when it worked, otherwise why not in plain words.
  Future<String?> registerPush(String platform, String pushToken, {String environment = 'production'}) async {
    final r = await relayFetch(relay, 'POST', '$roomPath/push',
        token: token, body: {'platform': platform, 'token': pushToken, 'environment': environment});
    if (r.status == 200) return null;
    if (r.status == 503) return 'Notifications aren\'t set up on the Tanooki Auth server yet, so requests only show up while the app is open.';
    return r.body['error'] as String? ?? 'Couldn\'t turn on notifications (HTTP ${r.status}).';
  }

  /// Erases the room; the browser hears "unpaired".
  Future<void> unpair() async {
    disconnect();
    final r = await relayFetch(relay, 'DELETE', roomPath, token: token);
    if (r.status != 200 && r.status != 404 && r.status != 401) expectStatus(r, [200]);
  }
}

/// The saved domain of [account] that [host] is on.
String accountsDomainFor(Account account, String host) {
  final h = host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
  return account.domains.firstWhere((d) => h == d || h.endsWith('.$d'), orElse: () => '');
}
