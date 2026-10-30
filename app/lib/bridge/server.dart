import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../core/account.dart';
import '../core/otpauth_uri.dart';
import '../core/totp.dart';
import '../core/vault.dart';

/// The running bridge (desktop only), started by the app once the vault is open.
BridgeServer? activeBridge;

const bridgePorts = [41984, 41985, 41986, 41987, 41988, 41989, 41990, 41991, 41992, 41993];
const _pairingsKey = 'bridgePairings';
const _maxCodesPerSecond = 5;

/// What the bridge needs from the app: the vault, whether it's locked, and dialogs.
abstract class BridgeHost {
  Vault get vault;
  bool get locked;
  void showPairingCode(String code, String origin);
  void hidePairingCode();
  Future<bool> confirmAdd(Account account);
  void vaultChanged();

  /// Brings the app forward on a screen: 'add' or 'settings'.
  void openScreen(String screen);
}

bool constantTimeEquals(String a, String b) {
  // Hash first so the comparison length never depends on the secret.
  final x = sha256.convert(utf8.encode(a)).bytes, y = sha256.convert(utf8.encode(b)).bytes;
  var diff = 0;
  for (var i = 0; i < x.length; i++) {
    diff |= x[i] ^ y[i];
  }
  return diff == 0;
}

/// Chrome/Edge/Brave (32 letters a–p), Firefox and Safari (a UUID) extension origins. Web pages can't send these.
final extensionOrigin = RegExp(
    r'^(chrome-extension://[a-p]{32}|(moz|safari-web)-extension://[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$',
    caseSensitive: false);

/// Raycast and Alfred send these fixed Origins. Exact match only.
const integrationOrigins = {'tanooki-integration://raycast', 'tanooki-integration://alfred'};

bool isAllowedOrigin(String origin) => integrationOrigins.contains(origin) || extensionOrigin.hasMatch(origin);

/// What to call a paired client in the pairing dialog and Settings.
String bridgeClientName(String origin) => switch (origin) {
      'tanooki-integration://raycast' => 'Raycast',
      'tanooki-integration://alfred' => 'Alfred',
      _ => 'Browser extension',
    };

String _hostOf(String domain) => domain.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');

/// Loopback-only WebSocket server the Chrome extension talks to. Secrets never leave;
/// the extension only ever gets one account's current code.
class BridgeServer {
  BridgeServer(this.host);

  final BridgeHost host;
  HttpServer? _http;
  int? get port => _http?.port;
  InternetAddress? get address => _http?.address;

  final _codeTimes = <String, List<DateTime>>{};
  String? _pairCode, _pairOrigin;
  int _pairMisses = 0;

  List<Map<String, dynamic>> get _pairings =>
      ((host.vault.settings[_pairingsKey] as List?) ?? []).cast<Map<String, dynamic>>();

  List<String> get pairedOrigins => [for (final p in _pairings) p['origin'] as String];

  Future<void> unpair(String origin) async {
    host.vault.settings[_pairingsKey] = _pairings.where((p) => p['origin'] != origin).toList();
    await host.vault.save();
  }

  /// Binds 127.0.0.1 on the first free port in [bridgePorts]. Returns the port, or null if all are busy.
  Future<int?> start({List<int> ports = bridgePorts}) async {
    for (final p in ports) {
      try {
        _http = await HttpServer.bind(InternetAddress.loopbackIPv4, p);
        _http!.listen(_onRequest);
        return _http!.port;
      } on SocketException {
        continue;
      }
    }
    return null;
  }

  Future<void> stop() async {
    await _http?.close(force: true);
    _http = null;
  }

  void cancelPairing() {
    _pairCode = null;
    _pairOrigin = null;
    _pairMisses = 0;
  }

  Future<void> _onRequest(HttpRequest req) async {
    final origin = req.headers.value('origin') ?? '';
    // Only a browser extension may talk to us; web pages send their own https:// origin.
    if (!isAllowedOrigin(origin)) {
      req.response.statusCode = HttpStatus.forbidden;
      await req.response.close();
      return;
    }
    if (!WebSocketTransformer.isUpgradeRequest(req)) {
      req.response.statusCode = HttpStatus.badRequest;
      await req.response.close();
      return;
    }
    final ws = await WebSocketTransformer.upgrade(req);
    final codeTimes = _codeTimes.putIfAbsent(origin, () => []);
    ws.listen((data) async {
      Map<String, dynamic> reply;
      Object? id;
      try {
        final msg = jsonDecode(data as String) as Map<String, dynamic>;
        id = msg['id'];
        reply = await _handle(msg, origin, codeTimes);
      } on _BridgeError catch (e) {
        reply = {'error': e.code, 'message': e.message};
      } catch (_) {
        reply = {'error': 'badRequest', 'message': 'Tanooki Auth didn\'t understand that request.'};
      }
      ws.add(jsonEncode({'id': id, ...reply}));
    });
  }

  Future<Map<String, dynamic>> _handle(Map<String, dynamic> msg, String origin, List<DateTime> codeTimes) async {
    final type = msg['type'];
    if (host.locked) throw _BridgeError('locked', 'Tanooki Auth is locked. Unlock it, then try again.');
    if (type == 'ping') return {'ok': true};
    if (type == 'pair') return _pair(msg, origin);

    final token = msg['token'];
    final paired = token is String &&
        _pairings.any((p) => p['origin'] == origin && constantTimeEquals(p['token'] as String, token));
    if (!paired) throw _BridgeError('notPaired', 'This app isn\'t paired with Tanooki Auth.');

    // Trashed accounts are invisible to the extension.
    final accounts = host.vault.live;
    Account find() => accounts.firstWhere((a) => a.id == msg['accountId'],
        orElse: () => throw _BridgeError('notFound', 'That account isn\'t in Tanooki Auth any more.'));

    switch (type) {
      case 'accounts':
        return {
          'accounts': [
            for (final a in accounts)
              {'id': a.id, 'type': a.type.name, 'issuer': a.issuer, 'label': a.label, 'domains': a.domains},
          ],
        };
      case 'code' || 'codes':
        final now = DateTime.now();
        codeTimes.removeWhere((t) => now.difference(t) > const Duration(seconds: 1));
        if (codeTimes.length >= _maxCodesPerSecond) throw _BridgeError('rateLimited', 'Too many requests.');
        codeTimes.add(now);
        if (type == 'codes') {
          // Popup list: TOTP only. HOTP codes are single-use and must be asked for one at a time.
          final ids = (msg['accountIds'] as List).cast<String>().toSet();
          return {
            'codes': {
              for (final a in accounts)
                if (ids.contains(a.id) && a.timeBased)
                  a.id: {'code': a.codeAt(now), 'secondsLeft': secondsLeft(now.millisecondsSinceEpoch ~/ 1000, period: a.period)},
            },
          };
        }
        final a = find();
        if (a.type == OtpType.hotp) {
          // Each HOTP code is single-use, so hand out the current one and move on.
          final code = a.codeAt(now);
          a.counter++;
          await host.vault.save();
          host.vaultChanged();
          return {'code': code, 'secondsLeft': null};
        }
        return {'code': a.codeAt(now), 'secondsLeft': secondsLeft(now.millisecondsSinceEpoch ~/ 1000, period: a.period)};
      case 'open':
        final screen = msg['screen'];
        if (screen != 'add' && screen != 'settings') throw _BridgeError('badRequest', 'Unknown screen.');
        host.openScreen(screen as String);
        return {'ok': true};
      case 'setDomain':
        final a = find();
        final d = _hostOf(msg['domain'] as String);
        if (d.isEmpty) throw _BridgeError('badRequest', 'No website given.');
        if (!a.domains.contains(d)) {
          a.domains.add(d);
          await host.vault.save();
          host.vaultChanged();
        }
        return {'ok': true};
      case 'add':
        final Account a;
        try {
          a = parseOtpauthUri(msg['uri'] as String);
        } on FormatException catch (e) {
          throw _BridgeError('badRequest', e.message);
        }
        final dupe = accounts.where((x) => x.secret == a.secret).firstOrNull;
        if (dupe != null) return {'accepted': false, 'reason': 'duplicate'};
        final d = _hostOf(msg['domain'] as String? ?? '');
        if (d.isNotEmpty) a.domains.add(d);
        if (!await host.confirmAdd(a)) return {'accepted': false, 'reason': 'declined'};
        host.vault.accounts
          ..removeWhere((x) => x.secret == a.secret) // an old copy in Trash
          ..add(a);
        await host.vault.save();
        host.vaultChanged();
        return {'accepted': true, 'accountId': a.id};
      default:
        throw _BridgeError('badRequest', 'Unknown request "$type".');
    }
  }

  Future<Map<String, dynamic>> _pair(Map<String, dynamic> msg, String origin) async {
    final code = msg['code'];
    if (code == null) {
      // Step 1: show a code in the app; the user types it into the extension.
      final r = Random.secure();
      _pairCode = List.generate(6, (_) => r.nextInt(10)).join();
      _pairOrigin = origin;
      _pairMisses = 0;
      host.showPairingCode(_pairCode!, origin);
      return {'pending': true};
    }
    if (_pairCode == null || _pairOrigin != origin) {
      throw _BridgeError('pairing', 'Pairing timed out or was closed. Start pairing again.');
    }
    if (!constantTimeEquals(_pairCode!, '$code')) {
      if (++_pairMisses >= 3) {
        cancelPairing();
        host.hidePairingCode();
        throw _BridgeError('pairing', 'Three wrong codes. Start pairing again.');
      }
      throw _BridgeError('wrongCode', 'That code doesn\'t match. Check the code shown in Tanooki Auth.');
    }
    cancelPairing();
    host.hidePairingCode();
    final r = Random.secure();
    final token = List.generate(32, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
    host.vault.settings[_pairingsKey] = [
      ..._pairings.where((p) => p['origin'] != origin),
      {'origin': origin, 'token': token, 'pairedAt': DateTime.now().toUtc().toIso8601String()},
    ];
    await host.vault.save();
    return {'token': token};
  }
}

class _BridgeError implements Exception {
  _BridgeError(this.code, this.message);
  final String code, message;
}
