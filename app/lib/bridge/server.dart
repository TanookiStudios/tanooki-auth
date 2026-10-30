import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../core/account.dart';
import '../core/activity.dart';
import '../core/google_migration.dart';
import '../core/otpauth_uri.dart';
import '../core/totp.dart';
import '../core/vault.dart';
import '../l10n/l10n.dart';

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
  /// Always shown before a browser's add is saved: one account, or every account in a Google transfer code.
  Future<bool> confirmAdd(List<Account> accounts);
  /// For accounts set to "ask first": asks for Face ID / Touch ID / Windows Hello in the app before a code
  /// goes to [client]. True when allowed.
  Future<bool> confirmReveal(Account account, String client);
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

/// Raycast, Alfred and PowerToys send these fixed Origins. Exact match only.
const integrationOrigins = {'tanooki-integration://raycast', 'tanooki-integration://alfred', 'tanooki-integration://powertoys'};

bool isAllowedOrigin(String origin) => integrationOrigins.contains(origin) || extensionOrigin.hasMatch(origin);

/// What to call a paired client in the pairing dialog and Settings.
String bridgeClientName(String origin) => switch (origin) {
      'tanooki-integration://raycast' => 'Raycast',
      'tanooki-integration://alfred' => 'Alfred',
      'tanooki-integration://powertoys' => 'PowerToys',
      _ => l10n.serverBrowserExtension,
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
        reply = {'type': 'error', 'error': e.code, 'message': e.message};
      } catch (_) {
        reply = {'type': 'error', 'error': 'badRequest', 'message': l10n.serverBadRequest};
      }
      ws.add(jsonEncode({'id': id, ...reply}));
    });
  }

  Future<Map<String, dynamic>> _handle(Map<String, dynamic> msg, String origin, List<DateTime> codeTimes) async {
    final type = msg['type'];
    if (host.locked) throw _BridgeError('locked', l10n.serverLocked);
    if (type == 'ping') return {'ok': true};
    if (type == 'pair') return _pair(msg, origin);

    final token = msg['token'];
    final paired = token is String &&
        _pairings.any((p) => p['origin'] == origin && constantTimeEquals(p['token'] as String, token));
    if (!paired) throw _BridgeError('notPaired', l10n.serverNotPaired);

    // Trashed accounts, and those travel mode hides, are invisible to the extension.
    final accounts = host.vault.visible;
    Account find() => accounts.firstWhere((a) => a.id == msg['accountId'],
        orElse: () => throw _BridgeError('notFound', l10n.serverNotFound));

    switch (type) {
      case 'accounts':
        return {
          'accounts': [
            for (final a in accounts)
              {'id': a.id, 'type': a.type.name, 'issuer': a.issuer, 'label': a.label, 'domains': a.domains, 'requireAuth': a.requireAuth},
          ],
        };
      case 'code' || 'codes':
        final now = DateTime.now();
        codeTimes.removeWhere((t) => now.difference(t) > const Duration(seconds: 1));
        if (codeTimes.length >= _maxCodesPerSecond) throw _BridgeError('rateLimited', l10n.serverRateLimited);
        codeTimes.add(now);
        if (type == 'codes') {
          // Popup list: TOTP only. HOTP codes are single-use and must be asked for one at a time, and "ask first"
          // accounts only hand out a code one at a time, after the app asks.
          final ids = (msg['accountIds'] as List).cast<String>().toSet();
          return {
            'codes': {
              for (final a in accounts)
                if (ids.contains(a.id) && a.timeBased && !a.requireAuth)
                  a.id: {'code': a.codeAt(now), 'secondsLeft': secondsLeft(now.millisecondsSinceEpoch ~/ 1000, period: a.period)},
            },
          };
        }
        final a = find();
        if (a.requireAuth && !await host.confirmReveal(a, bridgeClientName(origin))) {
          throw _BridgeError('denied', l10n.serverDenied);
        }
        logActivity(host.vault, ActivityKind.filled, accountId: a.id, where: bridgeClientName(origin));
        if (activityPremium() && a.type != OtpType.hotp) await host.vault.save();
        final at = a.requireAuth ? DateTime.now() : now; // the prompt may have taken a while
        if (a.type == OtpType.hotp) {
          // Each HOTP code is single-use, so hand out the current one and move on.
          final code = a.codeAt(at);
          a.counter++;
          await host.vault.save();
          host.vaultChanged();
          return {'code': code, 'secondsLeft': null};
        }
        return {'code': a.codeAt(at), 'secondsLeft': secondsLeft(at.millisecondsSinceEpoch ~/ 1000, period: a.period)};
      case 'open':
        final screen = msg['screen'];
        if (screen != 'add' && screen != 'settings') throw _BridgeError('badRequest', l10n.serverUnknownScreen);
        host.openScreen(screen as String);
        return {'ok': true};
      case 'setDomain':
        final a = find();
        final d = _hostOf(msg['domain'] as String);
        if (d.isEmpty) throw _BridgeError('badRequest', l10n.serverNoWebsite);
        if (!a.domains.contains(d)) {
          a.domains.add(d);
          await host.vault.save();
          host.vaultChanged();
        }
        return {'ok': true};
      case 'add':
        final reply = await addFromUri(host.vault, msg['uri'], host.confirmAdd, domain: _hostOf(msg['domain'] as String? ?? ''));
        if (reply['type'] == 'added') host.vaultChanged();
        return reply;
      default:
        throw _BridgeError('badRequest', l10n.serverUnknownRequest('$type'));
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
      throw _BridgeError('pairing', l10n.serverPairingTimedOut);
    }
    if (!constantTimeEquals(_pairCode!, '$code')) {
      if (++_pairMisses >= 3) {
        cancelPairing();
        host.hidePairingCode();
        throw _BridgeError('pairing', l10n.serverThreeWrongCodes);
      }
      throw _BridgeError('wrongCode', l10n.serverWrongCode);
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

/// "Add to Tanooki Auth" from a browser (bridge or phone link). [uri] is an otpauth:// link or a Google
/// Authenticator transfer (otpauth-migration://, many accounts). Accounts already in the list are skipped.
/// Always asks the user once through [confirm] (issuer, name, Add / Cancel) and saves only on Add.
/// Replies `type` 'added', 'declined' or 'error' (with `message`), plus `accepted`, `reason`
/// ('declined', 'duplicate', 'badUri') and `accountIds`. The URI holds secrets: never logged or echoed.
Future<Map<String, dynamic>> addFromUri(Vault vault, Object? uri, Future<bool> Function(List<Account>) confirm, {String domain = ''}) async {
  List<Account> found;
  try {
    if (uri is! String) throw FormatException(l10n.serverNoLink);
    final migration = uri.trim().toLowerCase().startsWith('otpauth-migration://');
    found = migration ? parseGoogleMigration(uri) : [parseOtpauthUri(uri)];
    if (!migration && domain.isNotEmpty) found.single.domains.add(domain); // a transfer code isn't tied to the page
  } on FormatException catch (e) {
    return {'type': 'error', 'error': 'badRequest', 'accepted': false, 'reason': 'badUri', 'message': e.message};
  }
  final have = {for (final x in vault.live) x.secret};
  final fresh = <Account>[];
  for (final a in found) {
    if (have.add(a.secret)) fresh.add(a); // also drops repeats inside one transfer code
  }
  if (fresh.isEmpty) {
    return {
      'type': 'error',
      'accepted': false,
      'reason': 'duplicate',
      'message': found.length == 1 ? l10n.serverAlreadyThere : l10n.serverAlreadyThereMany,
    };
  }
  if (!await confirm(fresh)) return {'type': 'declined', 'accepted': false, 'reason': 'declined'};
  final secrets = {for (final a in fresh) a.secret};
  vault.accounts
    ..removeWhere((x) => secrets.contains(x.secret)) // old copies in Trash
    ..addAll(fresh);
  await vault.save();
  return {'type': 'added', 'accepted': true, 'accountId': fresh.first.id, 'accountIds': [for (final a in fresh) a.id]};
}

class _BridgeError implements Exception {
  _BridgeError(this.code, this.message);
  final String code, message;
}
