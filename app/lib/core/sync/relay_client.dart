// HTTP side of the relay (relay/PROTOCOL.md): signed sync requests, invites, and the change socket.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'relay_crypto.dart';
import '../../l10n/l10n.dart';

/// A refusal or failure from the relay, with the relay's own plain-English sentence when it sent one.
class RelayException implements Exception {
  RelayException(this.status, this.message);
  final int status; // 0 = never reached the relay
  final String message;

  @override
  String toString() => 'RelayException($status): $message';
}

class RelayResponse {
  RelayResponse(this.status, this.body);
  final int status;
  final Map<String, dynamic> body;
}

/// Plain JSON over HTTPS. [token] is a phone-link room token; sync requests use [SyncRelay] instead.
Future<RelayResponse> relayFetch(String base, String method, String path,
    {Object? body, String? token, Map<String, String> headers = const {}, List<int>? rawBody}) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
  try {
    final req = await client.openUrl(method, Uri.parse('$base$path')).timeout(const Duration(seconds: 20));
    req.headers.set('content-type', 'application/json');
    if (token != null) req.headers.set('authorization', 'Bearer $token');
    headers.forEach(req.headers.set);
    final bytes = rawBody ?? (body == null ? null : utf8.encode(jsonEncode(body)));
    if (bytes != null) {
      req.contentLength = bytes.length;
      req.add(bytes);
    }
    final res = await req.close().timeout(const Duration(seconds: 30));
    final text = await res.transform(utf8.decoder).join();
    Map<String, dynamic> json;
    try {
      json = text.isEmpty ? {} : jsonDecode(text) as Map<String, dynamic>;
    } on FormatException {
      json = {'error': l10n.relayBadAnswer(res.statusCode)};
    }
    return RelayResponse(res.statusCode, json);
  } on SocketException {
    throw RelayException(0, l10n.relayUnreachable);
  } on TimeoutException {
    throw RelayException(0, l10n.relayTimeout);
  } on HandshakeException {
    throw RelayException(0, l10n.relayInsecure);
  } finally {
    client.close();
  }
}

/// Throws the relay's error sentence unless the status is one of [ok].
Map<String, dynamic> expectStatus(RelayResponse r, List<int> ok) {
  if (ok.contains(r.status)) return r.body;
  throw RelayException(r.status, r.body['error'] as String? ?? l10n.relaySaidNo(r.status));
}

/// Signed requests for one sync group, as one device.
class SyncRelay {
  SyncRelay(this.base, this.groupId, this.device);
  final String base;
  final String groupId;
  final DeviceKey device;
  /// Server clock minus ours, learned from a "timestamp outside the window" refusal.
  int _clockOffset = 0;

  String get groupPath => '/v1/sync/$groupId';

  Future<RelayResponse> call(String method, String path, [Object? body]) async {
    for (var attempt = 0;; attempt++) {
      final bytes = body == null ? <int>[] : utf8.encode(jsonEncode(body));
      final ts = '${DateTime.now().millisecondsSinceEpoch + _clockOffset}';
      final nonce = b64u(randomBytes(16));
      final sig = await device.sign('TA-RELAY-1\n$method\n$path\n$ts\n$nonce\n${sha256b64u(bytes)}');
      final r = await relayFetch(base, method, path, rawBody: body == null ? null : bytes, headers: {
        'x-ta-device': device.publicKey,
        'x-ta-timestamp': ts,
        'x-ta-nonce': nonce,
        'x-ta-signature': sig,
      });
      final serverTime = r.body['serverTime'];
      if (r.status == 401 && serverTime is int && attempt == 0) {
        _clockOffset = serverTime - DateTime.now().millisecondsSinceEpoch;
        continue; // PROTOCOL.md 1.3: retry once with the clock offset
      }
      return r;
    }
  }

  Future<int> create() async => expectStatus(await call('POST', '$groupPath/create', {}), [201])['cursor'] as int;

  /// A one-time invite another device can join with (PROTOCOL.md 1.4), valid for [life].
  Future<Map<String, dynamic>> invite({Duration life = const Duration(hours: 24)}) async {
    final nonce = b64u(randomBytes(16));
    final expiresAt = DateTime.now().add(life).millisecondsSinceEpoch + _clockOffset - 60000; // stay inside 24 h
    return {
      'inviter': device.publicKey,
      'nonce': nonce,
      'expiresAt': expiresAt,
      'sig': await device.sign('TA-INVITE-1\n$groupId\n$nonce\n$expiresAt'),
    };
  }

  Future<int> join(Map<String, dynamic> invite) async =>
      expectStatus(await call('POST', '$groupPath/join', {'invite': invite}), [201])['cursor'] as int;

  Future<List<({String key, DateTime added})>> devices() async {
    final b = expectStatus(await call('GET', '$groupPath/devices'), [200]);
    return [
      for (final d in b['devices'] as List)
        (key: d['key'] as String, added: DateTime.fromMillisecondsSinceEpoch(d['added'] as int)),
    ];
  }

  Future<void> removeDevice(String key) async => expectStatus(await call('DELETE', '$groupPath/devices/$key'), [200]);
  Future<void> deleteGroup() async => expectStatus(await call('DELETE', groupPath), [200]);

  /// One page of changes after [since].
  Future<({List<Map<String, dynamic>> records, int cursor, bool more})> changes(int since) async {
    final b = expectStatus(await call('GET', '$groupPath/changes?since=$since&limit=500'), [200]);
    return (records: (b['records'] as List).cast<Map<String, dynamic>>(), cursor: b['cursor'] as int, more: b['more'] == true);
  }

  Future<List<Map<String, dynamic>>> push(List<Map<String, dynamic>> records) async =>
      (expectStatus(await call('POST', '$groupPath/push', {'records': records}), [200])['results'] as List)
          .cast<Map<String, dynamic>>();

  /// Change notifications (PROTOCOL.md 1.6). Calls [onChanged] with the group's new cursor.
  Future<WebSocket> listen(void Function(int cursor) onChanged) async {
    final ts = '${DateTime.now().millisecondsSinceEpoch + _clockOffset}';
    final nonce = b64u(randomBytes(16));
    final sig = await device.sign('TA-RELAY-1\nGET\n$groupPath/ws\n$ts\n$nonce\n${sha256b64u(const [])}');
    final url = '${base.replaceFirst('http', 'ws')}$groupPath/ws?device=${device.publicKey}&ts=$ts&nonce=$nonce&sig=$sig';
    final ws = await WebSocket.connect(url).timeout(const Duration(seconds: 20));
    ws.pingInterval = null;
    ws.listen((m) {
      if (m is! String || m == 'pong') return;
      final msg = jsonDecode(m) as Map<String, dynamic>;
      if (msg['cursor'] is int) onChanged(msg['cursor'] as int);
    }, onError: (_) {}, cancelOnError: true);
    return ws;
  }
}
