// Emergency access (feature 26), app side, against a fake relay that follows PROTOCOL.md section 3 (roles,
// signatures, the wait). Set RELAY_URL to a local `npx wrangler dev --var TEST_MODE:1` to run the same flow
// against the real relay code: the wait is then 2 seconds instead of 7 days.
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/emergency.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/vault.dart';

import 'vault_test.dart' show MemoryKeyStore;

/// In-memory relay: one grant per id, owner = first signer, contact named by the owner, and a wait the test
/// controls ([released]). Every request's Ed25519 signature is checked like the real relay does.
class FakeRelay {
  late HttpServer _server;
  final grants = <String, Map<String, dynamic>>{};
  final pushes = <String>[];
  bool released = false;
  String get base => 'http://127.0.0.1:${_server.port}';

  Future<void> start() async {
    _server = await HttpServer.bind('127.0.0.1', 0);
    _server.listen(_handle);
  }

  Future<void> stop() => _server.close(force: true);

  Future<void> _handle(HttpRequest req) async {
    final bytes = await req.fold<List<int>>([], (a, b) => a..addAll(b));
    void send(int status, Map<String, dynamic> body) => req.response
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body))
      ..close();
    final h = req.headers;
    final dev = h.value('x-ta-device')!;
    final signed = 'TA-RELAY-1\n${req.method}\n${req.uri.path}\n${h.value('x-ta-timestamp')}\n${h.value('x-ta-nonce')}\n${sha256b64u(bytes)}';
    final ok = await Ed25519().verify(utf8.encode(signed),
        signature: Signature(unb64u(h.value('x-ta-signature')!), publicKey: SimplePublicKey(unb64u(dev), type: KeyPairType.ed25519)));
    if (!ok) return send(401, {'error': 'bad signature'});
    final p = req.uri.pathSegments; // v1 emergency <id> [sub]
    final id = p[2], sub = p.length > 3 ? p[3] : '';
    final body = bytes.isEmpty ? <String, dynamic>{} : jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    var g = grants[id];
    Map<String, dynamic> status() => {
          'owner': g!['owner'],
          'contactKey': g['contactKey'],
          'state': g['releaseAt'] == null ? 'idle' : released ? 'released' : 'waiting',
          'requestedAt': g['requestedAt'],
          'releaseAt': g['releaseAt'],
          'updatedAt': g['updatedAt'],
          'blobLength': (g['blob'] as String).length,
        };
    if (req.method == 'POST' && sub == '') {
      if (g != null && g['owner'] != dev) return send(403, {'error': 'only the owner can change this grant'});
      final fresh = g == null;
      g = grants[id] = {...?g, 'owner': dev, 'contactKey': body['contactKey'], 'blob': body['blob'], 'updatedAt': DateTime.now().millisecondsSinceEpoch};
      return send(fresh ? 201 : 200, status());
    }
    if (g == null) return send(404, {'error': 'grant not found'});
    final role = dev == g['owner'] ? 'owner' : dev == g['contactKey'] ? 'contact' : null;
    if (role == null) return send(403, {'error': 'device is neither the owner nor the contact of this grant'});
    if (req.method == 'GET' && sub == '') return send(200, status());
    if (role == 'owner' && sub == 'deny') {
      if (g['releaseAt'] == null) return send(409, {'error': 'there is no request to deny'});
      g.remove('releaseAt');
      g.remove('requestedAt');
      released = false;
      return send(200, status());
    }
    if (role == 'owner' && sub == 'push') {
      pushes.add(body['token'] as String);
      return send(200, {'ok': true});
    }
    if (role == 'owner' && req.method == 'DELETE') {
      grants.remove(id);
      return send(200, {'ok': true});
    }
    if (role == 'contact' && sub == 'request') {
      if (g['releaseAt'] != null) return send(200, status());
      final now = DateTime.now().millisecondsSinceEpoch;
      g['requestedAt'] = now;
      g['releaseAt'] = now + emergencyWait.inMilliseconds;
      return send(201, status());
    }
    if (role == 'contact' && sub == 'blob') {
      if (g['releaseAt'] == null) return send(409, {'error': 'ask for access first (POST request)'});
      if (!released) return send(403, {'error': 'the waiting period has not ended', 'releaseAt': g['releaseAt']});
      return send(200, {'blob': g['blob'], 'updatedAt': g['updatedAt']});
    }
    send(404, {'error': 'not found'});
  }
}

void main() {
  late Directory dir;
  late FakeRelay relay;
  late Vault owner, contact;
  // A real relay (wrangler dev with TEST_MODE) when given; the fake otherwise.
  const realRelay = String.fromEnvironment('RELAY_URL');

  Vault newVault(String name, int key) => Vault(File('${dir.path}/$name.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, key)));

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('emergency_test');
    relay = FakeRelay();
    await relay.start();
    owner = newVault('owner', 1);
    contact = newVault('contact', 2);
    owner.accounts.addAll([
      Account(id: 'gh', issuer: 'GitHub', label: 'maddie', secret: 'JBSWY3DPEHPK3PXP'),
      Account(id: 'bank', issuer: 'Bank', secret: 'GEZDGNBVGY3TQOJQ')..travelHidden = true,
    ]);
    owner.settings[Vault.travelModeKey] = true; // the emergency copy still holds every account
    await owner.save();
    await contact.save();
  });
  tearDown(() async {
    await relay.stop();
    dir.deleteSync(recursive: true);
  });

  test('a sealed copy opens only with the contact\'s key', () async {
    final me = await myContactKeys(contact);
    final code = parseContactCode(await myContactCode(contact, 'Sam'));
    expect(code.name, 'Sam');
    expect(code.signKey, me.sign.publicKey);
    final blob = await sealSnapshot(owner.live, code.boxKey);
    expect(blob, isNot(contains('JBSWY3DPEHPK3PXP')));
    expect((await openSnapshot(blob, me.box)).map((a) => a.secret), ['JBSWY3DPEHPK3PXP', 'GEZDGNBVGY3TQOJQ']);
    final stranger = await X25519().newKeyPair();
    await expectLater(openSnapshot(blob, stranger), throwsA(isA<EmergencyException>()));
  });

  test('junk codes are refused with a plain sentence', () async {
    expect(() => parseContactCode('hello'), throwsA(isA<EmergencyException>().having((e) => e.message, 'm', contains('contact code'))));
    await expectLater(addGrantCode(contact, '${grantPrefix}bm9wZQ'), throwsA(isA<EmergencyException>()));
  });

  test('the whole flow: choose, ask, owner sees it and denies, ask again, wait ends, contact opens the copy', () async {
    final base = realRelay.isEmpty ? relay.base : realRelay;
    final service = EmergencyService(base: base)..isPremium = () => true;

    // The contact shows a code; the owner chooses them and gets a code to give back.
    final contactCode = parseContactCode(await myContactCode(contact, 'Sam'));
    await contact.save();
    final grant = await service.setUp(owner, contactCode, 'Maddie');
    expect(service.status.value!.state, 'idle');
    expect(grantOf(owner)!['contactName'], 'Sam');
    final from = await addGrantCode(contact, grant);
    expect((from.ownerName, copiesForMe(contact).single.grantId), ('Maddie', grantOf(owner)!['id']));

    // Before asking: no copy. Asking starts the 7-day wait.
    final asContact = await contactRelay(contact, from.grantId, base: base);
    await expectLater(asContact.blob(), throwsA(isA<EmergencyException>().having((e) => e.message, 'm', 'Ask for access first.')));
    final asked = await asContact.request();
    expect(asked.state, 'waiting');
    expect(asked.releaseAt!.difference(asked.requestedAt!), emergencyWait);
    await expectLater(asContact.blob(), throwsA(isA<EmergencyException>().having((e) => e.message, 'm', contains('7-day wait isn\'t over'))));

    // The owner's app sees the request when it checks (as on every unlock) and denies it.
    expect((await service.check(owner))!.state, 'waiting');
    await service.deny(owner);
    expect(service.status.value!.state, 'idle');
    expect((await asContact.status()).state, 'idle');

    // The owner adds an account; the copy updates (debounced after a save).
    owner.accounts.add(Account(id: 'new', issuer: 'Steam', secret: 'MFRGGZDFMZTWQ2LK'));
    await owner.save();
    service.vaultChanged(owner, delay: Duration.zero);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(service.problem.value, isNull);

    // Asked again, and this time nobody denies.
    await asContact.request(testDelaySeconds: realRelay.isEmpty ? null : 2);
    if (realRelay.isEmpty) {
      relay.released = true;
    } else {
      await Future<void>.delayed(const Duration(seconds: 3));
    }
    final copy = await fetchEmergencyCopy(contact, from.grantId, base: base);
    expect(copy.map((a) => a.issuer), ['GitHub', 'Bank', 'Steam'], reason: 'everything, travel-hidden included, and the update');

    // Another device can't read the status, and removing deletes it from the relay.
    final stranger = EmergencyRelay(from.grantId, await DeviceKey.create(), base: base);
    await expectLater(stranger.status(), throwsA(isA<EmergencyException>().having((e) => e.message, 'm', contains('isn\'t the owner or the contact'))));
    await service.remove(owner);
    expect(grantOf(owner), isNull);
    await expectLater(asContact.status(), throwsA(isA<EmergencyException>().having((e) => e.message, 'm', contains('doesn\'t exist any more'))));
  });

  test('waitLeft reads like a person would say it', () {
    final now = DateTime(2026, 11, 1, 12);
    expect(waitLeft(now.add(const Duration(days: 7)), now), '7 days');
    expect(waitLeft(now.add(const Duration(days: 6, hours: 4, minutes: 3)), now), '6 days 4 hours');
    expect(waitLeft(now.add(const Duration(hours: 1, minutes: 59)), now), '1 hour');
    expect(waitLeft(now.add(const Duration(seconds: 20)), now), 'less than a minute');
  });
}
