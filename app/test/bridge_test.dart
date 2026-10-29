import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/bridge/server.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/totp.dart';
import 'package:tanooki_auth/core/vault.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

class FakeHost implements BridgeHost {
  FakeHost(this.vault);
  @override
  final Vault vault;
  @override
  bool locked = false;
  String? shownCode;
  bool approve = true;
  Account? offered;
  @override
  void showPairingCode(String code, String origin) => shownCode = code;
  @override
  void hidePairingCode() => shownCode = null;
  @override
  Future<bool> confirmAdd(Account a) async {
    offered = a;
    return approve;
  }

  @override
  void vaultChanged() {}
  @override
  void openScreen(String screen) => opened.add(screen);
  final opened = <String>[];
}

const ext = 'chrome-extension://abcdefghijklmnopabcdefghijklmnop';
const otherExt = 'chrome-extension://ponmlkjihgfedcbaponmlkjihgfedcba';

class Client {
  Client._(this.ws) {
    ws.listen((d) {
      final m = jsonDecode(d as String) as Map<String, dynamic>;
      _waiting.remove(m['id'])?.complete(m);
    });
  }
  final WebSocket ws;
  final _waiting = <int, Completer<Map<String, dynamic>>>{};
  int _next = 0;

  static Future<Client> connect(int port, {String origin = ext}) async =>
      Client._(await WebSocket.connect('ws://127.0.0.1:$port', headers: {'Origin': origin}));

  Future<Map<String, dynamic>> send(Map<String, dynamic> m) {
    final id = _next++;
    final c = _waiting[id] = Completer();
    ws.add(jsonEncode({'id': id, ...m}));
    return c.future;
  }
}

void main() {
  late Directory dir;
  late FakeHost host;
  late BridgeServer server;
  late int port;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('bridge_test');
    final vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore());
    await vault.load();
    vault.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP')..domains.add('github.com'));
    await vault.save();
    host = FakeHost(vault);
    server = BridgeServer(host);
    port = (await server.start(ports: [0]))!; // 0 = any free port, so tests never clash with a running app
  });
  tearDown(() async {
    await server.stop();
    dir.deleteSync(recursive: true);
  });

  Future<String> pair(Client c) async {
    expect((await c.send({'type': 'pair'}))['pending'], isTrue);
    final r = await c.send({'type': 'pair', 'code': host.shownCode});
    return r['token'] as String;
  }

  test('binds loopback only', () {
    expect(server.port, port);
    expect(server.address!.address, '127.0.0.1');
  });

  test('web page origins and missing origin are refused', () async {
    for (final origin in ['https://evil.example', 'null', 'chrome-extension://short']) {
      await expectLater(Client.connect(port, origin: origin), throwsA(isA<WebSocketException>()), reason: origin);
    }
    await expectLater(WebSocket.connect('ws://127.0.0.1:$port'), throwsA(isA<WebSocketException>()));
  });

  test('pairing, then accounts without secrets, then a correct code', () async {
    final c = await Client.connect(port);
    expect((await c.send({'type': 'accounts', 'token': 'nope'}))['error'], 'notPaired');
    final token = await pair(c);
    expect(token, hasLength(64));
    expect(host.shownCode, isNull, reason: 'dialog closes after pairing');

    final list = await c.send({'type': 'accounts', 'token': token});
    expect(jsonEncode(list).contains('JBSWY3DPEHPK3PXP'), isFalse, reason: 'secret must never be sent');
    final acct = (list['accounts'] as List).single as Map;
    expect(acct['domains'], ['github.com']);

    final code = await c.send({'type': 'code', 'token': token, 'accountId': acct['id']});
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    expect(code['code'], anyOf(totp(base32Decode('JBSWY3DPEHPK3PXP'), now), totp(base32Decode('JBSWY3DPEHPK3PXP'), now - 1)));
    expect(code['secondsLeft'], inInclusiveRange(1, 30));
  });

  test('token only works from the extension that paired', () async {
    final token = await pair(await Client.connect(port));
    final other = await Client.connect(port, origin: otherExt);
    expect((await other.send({'type': 'accounts', 'token': token}))['error'], 'notPaired');
  });

  test('three wrong codes end pairing', () async {
    final c = await Client.connect(port);
    await c.send({'type': 'pair'});
    final right = host.shownCode!;
    final wrong = right == '000000' ? '111111' : '000000';
    expect((await c.send({'type': 'pair', 'code': wrong}))['error'], 'wrongCode');
    expect((await c.send({'type': 'pair', 'code': wrong}))['error'], 'wrongCode');
    expect((await c.send({'type': 'pair', 'code': wrong}))['error'], 'pairing');
    expect(host.shownCode, isNull);
    expect((await c.send({'type': 'pair', 'code': right}))['error'], 'pairing', reason: 'old code is dead');
  });

  test('locked app refuses everything', () async {
    final c = await Client.connect(port);
    final token = await pair(c);
    host.locked = true;
    expect((await c.send({'type': 'accounts', 'token': token}))['error'], 'locked');
  });

  test('code requests are rate limited per browser, even across connections', () async {
    final token = await pair(await Client.connect(port));
    final id = host.vault.accounts.single.id;
    final replies = await Future.wait([
      for (var i = 0; i < 8; i++) Client.connect(port).then((c) => c.send({'type': 'code', 'token': token, 'accountId': id})),
    ]);
    expect(replies.where((r) => r['error'] == 'rateLimited'), isNotEmpty);
  });

  test('codes returns TOTP codes for many accounts in one request; open forwards to the app', () async {
    final c = await Client.connect(port);
    final token = await pair(c);
    host.vault.accounts.add(parseOtpauthUri('otpauth://hotp/Bank:me?secret=GEZDGNBVGY3TQOJQ&counter=1'));
    final ids = host.vault.accounts.map((a) => a.id).toList();
    final r = await c.send({'type': 'codes', 'token': token, 'accountIds': ids});
    expect((r['codes'] as Map).keys, [ids.first], reason: 'HOTP left out so it is not spent');
    expect(host.vault.accounts.last.counter, 1);

    await c.send({'type': 'open', 'token': token, 'screen': 'settings'});
    expect(host.opened, ['settings']);
    expect((await c.send({'type': 'open', 'token': token, 'screen': 'nope'}))['error'], 'badRequest');
  });

  test('add asks the app, stores the domain; duplicates and declines are reported', () async {
    final c = await Client.connect(port);
    final token = await pair(c);
    const uri = 'otpauth://totp/Discord:me?secret=MFRGGZDFMZTWQ2LK&issuer=Discord';

    host.approve = false;
    expect((await c.send({'type': 'add', 'token': token, 'uri': uri, 'domain': 'www.discord.com'}))['reason'], 'declined');
    expect(host.vault.accounts, hasLength(1));

    host.approve = true;
    final r = await c.send({'type': 'add', 'token': token, 'uri': uri, 'domain': 'www.discord.com'});
    expect(r['accepted'], isTrue);
    expect(host.offered!.domains, ['discord.com']);
    expect(host.vault.accounts, hasLength(2));

    expect((await c.send({'type': 'add', 'token': token, 'uri': uri, 'domain': 'discord.com'}))['reason'], 'duplicate');
  });

  test('setDomain appends once', () async {
    final c = await Client.connect(port);
    final token = await pair(c);
    final id = host.vault.accounts.single.id;
    await c.send({'type': 'setDomain', 'token': token, 'accountId': id, 'domain': 'gist.github.com'});
    await c.send({'type': 'setDomain', 'token': token, 'accountId': id, 'domain': 'gist.github.com'});
    expect(host.vault.accounts.single.domains, ['github.com', 'gist.github.com']);
  });

  test('constantTimeEquals', () {
    expect(constantTimeEquals('abc', 'abc'), isTrue);
    expect(constantTimeEquals('abc', 'abd'), isFalse);
    expect(constantTimeEquals('abc', 'abcd'), isFalse);
  });
}
