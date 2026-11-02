// Relay sync against a fake relay that follows PROTOCOL.md section 1: remote wipe (#23) and sync clashes (#26)
// end to end through RelaySync and SyncService. Never touches the real vault: every vault is a temp file.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/sync/merge.dart';
import 'package:tanooki_auth/core/sync/relay_client.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/sync/sync_engine.dart';
import 'package:tanooki_auth/core/sync/sync_service.dart';
import 'package:tanooki_auth/core/vault.dart';

import 'vault_test.dart' show MemoryKeyStore;

/// Just enough of relay/src/sync.js, in memory: one group, no signature checks (relay/test.mjs covers those).
class FakeSyncRelay {
  late HttpServer server;
  String get base => 'http://127.0.0.1:${server.port}';
  final devices = <String>{};
  final wiped = <String>{};
  final records = <String, Map<String, dynamic>>{};
  int seq = 0;

  Future<void> start() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      final text = await utf8.decoder.bind(req).join();
      final body = text.isEmpty ? <String, dynamic>{} : jsonDecode(text) as Map<String, dynamic>;
      final dev = req.headers.value('x-ta-device');
      // No change socket here (the WebSocket asks with the key in the query): the app falls back to polling.
      final (status, out) = dev == null ? (404, <String, dynamic>{'error': 'no socket in the fake'}) : handle(req.method, req.uri, dev, body);
      req.response
        ..statusCode = status
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(out));
      await req.response.close();
    });
  }

  (int, Map<String, dynamic>) handle(String method, Uri uri, String dev, Map<String, dynamic> b) {
    if (wiped.contains(dev)) return (410, {'error': 'this device was erased from another device in its sync group', 'wiped': true});
    final rest = uri.pathSegments.skip(3).toList();
    final route = rest.join('/');
    if (method == 'POST' && route == 'create') {
      devices.add(dev);
      return (201, {'ok': true, 'cursor': 0});
    }
    if (!devices.contains(dev)) return (403, {'error': 'device is not in this sync group'});
    if (method == 'POST' && rest.length == 3 && rest[0] == 'devices' && rest[2] == 'wipe') {
      if (rest[1] == dev) return (409, {'error': 'a device cannot erase itself this way; turn off sync on it instead'});
      if (!devices.remove(rest[1])) return (404, {'error': 'no such device in this group'});
      wiped.add(rest[1]);
      return (200, {'ok': true});
    }
    if (method == 'GET' && route == 'devices') {
      return (200, {'devices': [for (final d in devices) {'key': d, 'added': 0}]});
    }
    if (method == 'POST' && route == 'push') {
      final results = <Map<String, dynamic>>[];
      for (final r in (b['records'] as List).cast<Map<String, dynamic>>()) {
        final cur = records[r['id']];
        if ((cur?['version'] ?? 0) != r['baseVersion']) {
          results.add({'id': r['id'], 'status': 'conflict', 'current': cur});
          continue;
        }
        seq++;
        records[r['id'] as String] = {'id': r['id'], 'version': (cur?['version'] as int? ?? 0) + 1, 'deleted': r['deleted'] == true, 'updatedAt': 0, 'ciphertext': r['ciphertext'], 'seq': seq};
        results.add({'id': r['id'], 'status': 'ok', 'version': records[r['id']]!['version'], 'seq': seq});
      }
      return (200, {'results': results, 'cursor': seq});
    }
    if (method == 'GET' && route == 'changes') {
      final since = int.parse(uri.queryParameters['since'] ?? '0');
      final page = records.values.where((r) => (r['seq'] as int) > since).toList()..sort((a, b) => (a['seq'] as int).compareTo(b['seq'] as int));
      return (200, {'records': page, 'cursor': page.isEmpty ? since : page.last['seq'], 'more': false});
    }
    return (404, {'error': 'not found'});
  }
}

Future<Vault> newVault() async {
  final v = Vault(File('${Directory.systemTemp.createTempSync('relaysync').path}/v.json'), MemoryKeyStore());
  await v.load();
  return v;
}

/// A device in the fake relay's group (same root as every other device made with [root]).
Future<Vault> device(FakeSyncRelay relay, List<int> root, {bool create = false}) async {
  final v = await newVault();
  final key = await DeviceKey.create();
  v.settings[Vault.syncKey] = {
    'transport': 'relay',
    'root': b64u(root),
    'salt': b64u(randomBytes(16)),
    'device': b64u(key.seed),
    'devicePub': key.publicKey,
    'relay': relay.base,
    'cursor': 0,
  };
  if (create) {
    await (await RelaySync(v).relay()).create();
  } else {
    relay.devices.add(key.publicKey); // joined (the invite check is relay/test.mjs's job)
  }
  await v.save();
  return v;
}

Account github({String issuer = 'GitHub'}) => Account(id: 'acct-1', issuer: issuer, label: 'me', secret: 'JBSWY3DPEHPK3PXP');

void main() {
  late FakeSyncRelay relay;
  setUp(() async {
    relay = FakeSyncRelay();
    await relay.start();
  });
  tearDown(() => relay.server.close(force: true));

  test('remote wipe: the erased device deletes everything and leaves sync; the others are untouched', () async {
    final root = randomBytes(32);
    final a = await device(relay, root, create: true), b = await device(relay, root);
    a.accounts.add(github());
    await a.save();
    await RelaySync(a).sync();
    await RelaySync(b).sync();
    b.settings['license'] = 'TA1.some.key';
    await b.save();
    expect(b.accounts.single.issuer, 'GitHub');

    final ra = await RelaySync(a).relay(), rb = await RelaySync(b).relay();
    await expectLater(ra.wipeDevice(ra.device.publicKey), throwsA(isA<RelayException>().having((e) => e.status, 'status', 409)));
    await ra.wipeDevice(rb.device.publicKey);
    expect((await ra.devices()).map((d) => d.key), [ra.device.publicKey]);

    await expectLater(RelaySync(b).sync(), throwsA(isA<RemoteWipeException>()));
    expect(describeSyncError(RemoteWipeException('x')), contains('erased'));

    // The app's sync service acts on it: everything goes, including settings like the license and sync itself.
    final service = SyncService.instance;
    var erased = 0;
    final before = service.onRemoteWipe;
    service.onRemoteWipe = (v) async {
      erased++;
      await before(v);
    };
    addTearDown(() => service.onRemoteWipe = before);
    service.attach(b);
    await service.syncNow();
    expect(erased, 1);
    expect(b.accounts, isEmpty);
    expect(b.settings, isEmpty);
    expect(syncOn(b), isFalse);
    expect(service.status.value.error, contains('erased'));
    service.detach();

    // Reopened from disk, the vault is still empty: the erase was saved.
    final again = Vault(b.file, b.keyStore);
    await again.load();
    expect(again.accounts, isEmpty);

    // A is untouched and keeps syncing.
    await RelaySync(a).sync();
    expect(a.accounts.single.issuer, 'GitHub');
  });

  test('sync clash: both devices edit one account offline; the loser can pick its version and it wins everywhere', () async {
    final root = randomBytes(32);
    final a = await device(relay, root, create: true), b = await device(relay, root);
    a.accounts.add(github());
    await a.save();
    await RelaySync(a).sync();
    await RelaySync(b).sync();

    // Both edit while apart. A syncs first; B's edit is later, so B's wins, and A's is the other version.
    a.accounts.single.issuer = 'GitHub (A)';
    await a.save();
    await Future<void>.delayed(const Duration(milliseconds: 5));
    b.accounts.single.issuer = 'GitHub (B)';
    await b.save();
    await RelaySync(a).sync();
    await RelaySync(b).sync();
    expect(b.accounts.single.issuer, 'GitHub (B)');
    final clash = syncClashes(b).single;
    expect([clash.kept.issuer, clash.lost.issuer], ['GitHub (B)', 'GitHub (A)']);

    await RelaySync(a).sync();
    expect(a.accounts.single.issuer, 'GitHub (B)');
    expect(syncClashes(a), isEmpty, reason: 'A had already sent its edit, so for A this is just a newer change; the clash shows where both met, on B');

    // On B, "Keep this one" under A's version: it goes out as a fresh edit and lands on A.
    resolveClash(b, clash, keepLost: true);
    await b.save();
    await RelaySync(b).sync();
    await RelaySync(a).sync();
    expect([a.accounts.single.issuer, b.accounts.single.issuer], ['GitHub (A)', 'GitHub (A)']);
    expect(syncClashes(b), isEmpty);

    // A later edit on one side only is not a clash.
    a.accounts.single.label = 'work';
    await a.save();
    await RelaySync(a).sync();
    await RelaySync(b).sync();
    expect(b.accounts.single.label, 'work');
    expect(syncClashes(b), isEmpty);
  });
}
