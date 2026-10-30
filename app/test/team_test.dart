// Team vault (feature 42): the whole life of a team (create, invite, join, share accounts, edit, remove someone
// and rotate the key, renew the license, leave, delete) against a fake relay that follows PROTOCOL.md section 4.
//
// The same scenario also runs against a real local relay when TEAM_RELAY_URL and TEAM_LICENSE_SEED are set:
//   cd relay && npx wrangler dev --var TEST_MODE:1 --var LICENSE_PUBLIC:<public half of a throwaway key>
//   TEAM_RELAY_URL=http://127.0.0.1:8787 TEAM_LICENSE_SEED=<its base64 seed> flutter test test/team_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/sync/relay_client.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/team.dart';
import 'package:tanooki_auth/core/vault.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

Future<Vault> newVault() async {
  final v = Vault(File('${Directory.systemTemp.createTempSync('team').path}/v.json'), MemoryKeyStore());
  await v.load();
  return v;
}

/// Just enough of relay/src/team.js, in memory: one team, no signature checks (the live run covers those).
class FakeTeamRelay {
  late HttpServer server;
  String get base => 'http://127.0.0.1:${server.port}';
  String? admin;
  int epoch = 0, seq = 0, licenseEnd = 0;
  bool needsRotation = false;
  final members = <String, Map<String, dynamic>>{};
  final wrapped = <String, Map<String, dynamic>>{};
  final entries = <String, Map<String, dynamic>>{};
  final invites = <String>{};

  Future<void> start() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      final text = await utf8.decoder.bind(req).join();
      final body = text.isEmpty ? <String, dynamic>{} : jsonDecode(text) as Map<String, dynamic>;
      final (status, out) = handle(req.method, req.uri, req.headers.value('x-ta-device'), body);
      req.response
        ..statusCode = status
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(out));
      await req.response.close();
    });
  }

  Map<String, dynamic> status() => {
        'admin': admin,
        'epoch': epoch,
        'needsRotation': needsRotation,
        'licenseEnd': licenseEnd,
        'cursor': seq,
        'members': [
          for (final e in members.entries) {'key': e.key, ...e.value, 'hasKey': wrapped[e.key]?['epoch'] == epoch},
        ],
      };

  int? _licenseEnd(Object? lic) {
    try {
      final p = utf8.decode(unb64u((lic as String).split('.')[1])).split('|');
      return lic.startsWith('TT1.') && p[0] == 'team1' ? int.parse(p[2]) * 1000 : null;
    } catch (_) {
      return null;
    }
  }

  (int, Map<String, dynamic>) handle(String method, Uri uri, String? dev, Map<String, dynamic> b) {
    (int, Map<String, dynamic>) err(int s, String e) => (s, {'error': e});
    if (dev == null) return err(401, 'missing or malformed signature headers');
    final route = uri.pathSegments.skip(3).join('/');
    if (method == 'POST' && route == 'create') {
      if (admin != null) return err(409, 'team already exists');
      final end = _licenseEnd(b['license']);
      if (end == null) return err(402, 'team license is malformed');
      admin = dev;
      epoch = 1;
      licenseEnd = end;
      members[dev] = {'role': 'admin', 'boxKey': b['boxKey'], 'added': DateTime.now().millisecondsSinceEpoch};
      return (201, status());
    }
    if (admin == null) return err(404, 'team not found');
    if (method == 'POST' && route == 'join') {
      if (!invites.remove(b['invite'])) return err(403, 'invite is not valid, expired, or already used');
      if (members.length >= 10) return err(507, 'team is full (10 members)');
      members[dev] = {'role': 'member', 'boxKey': b['boxKey'], 'added': DateTime.now().millisecondsSinceEpoch};
      return (201, status());
    }
    if (!members.containsKey(dev)) return err(403, 'device is not in this team');
    final isAdmin = dev == admin;
    switch ((method, route)) {
      case ('GET', ''):
        return (200, status());
      case ('DELETE', ''):
        if (!isAdmin) return err(403, 'only the team admin can do this');
        admin = null;
        members.clear();
        entries.clear();
        return (200, {'ok': true});
      case ('POST', 'license'):
        final end = _licenseEnd(b['license']);
        if (end == null) return err(402, 'team license is malformed');
        if (end > licenseEnd) licenseEnd = end;
        return (200, status());
      case ('POST', 'invites'):
        if (!isAdmin) return err(403, 'only the team admin can do this');
        final inv = b64u(randomBytes(24));
        invites.add(inv);
        return (201, {'invite': inv, 'expiresAt': 0});
      case ('POST', 'keys'):
        if (!isAdmin) return err(403, 'only the team admin can do this');
        final keys = (b['keys'] as Map).cast<String, String>();
        if (b['epoch'] == epoch + 1) {
          if (members.keys.any((m) => !keys.containsKey(m))) return err(400, 'a key rotation must include a wrapped key for every member');
          epoch++;
          needsRotation = false;
          wrapped.clear();
        } else if (b['epoch'] != epoch) {
          return (409, {'error': 'epoch must be $epoch (add keys) or ${epoch + 1} (rotate)', 'epoch': epoch});
        }
        keys.forEach((k, w) => wrapped[k] = {'epoch': epoch, 'blob': w});
        return (200, status());
      case ('GET', 'key'):
        final w = wrapped[dev];
        return w == null ? err(404, 'the admin has not shared the team key with this device yet') : (200, {'epoch': w['epoch'], 'wrapped': w['blob']});
      case ('POST', 'entries'):
        final list = (b['entries'] as List).cast<Map<String, dynamic>>();
        if (list.any((e) => e['epoch'] != epoch)) return (409, {'error': 'the team key has changed; fetch the new key and encrypt with it', 'epoch': epoch});
        final results = <Map<String, dynamic>>[];
        for (final e in list) {
          final old = entries[e['id']];
          if (old != null && ((old['updatedAt'] as int) > (e['updatedAt'] as int) || old['updatedAt'] == e['updatedAt'] && (old['epoch'] as int) >= epoch)) {
            results.add({'id': e['id'], 'status': 'stale', 'current': old});
            continue;
          }
          seq++;
          entries[e['id'] as String] = {'id': e['id'], 'updatedAt': e['updatedAt'], 'deleted': e['deleted'] == true, 'epoch': epoch, 'ciphertext': e['ciphertext'], 'seq': seq};
          results.add({'id': e['id'], 'status': 'ok', 'seq': seq});
        }
        return (200, {'results': results, 'cursor': seq});
      case ('GET', 'entries'):
        final since = int.parse(uri.queryParameters['since'] ?? '0');
        final page = entries.values.where((e) => (e['seq'] as int) > since).toList()..sort((a, b) => (a['seq'] as int).compareTo(b['seq'] as int));
        return (200, {'entries': page, 'cursor': page.isEmpty ? since : page.last['seq'], 'more': false});
    }
    if (method == 'DELETE' && route.startsWith('members/')) {
      final target = route.substring(8);
      if (!isAdmin && target != dev) return err(403, 'only the team admin can do this');
      if (target == admin) return err(409, 'the admin cannot leave; delete the team instead');
      members.remove(target);
      wrapped.remove(target);
      needsRotation = true;
      return (200, status());
    }
    return err(404, 'not found');
  }
}

Account github() => Account(id: 'acct-1', issuer: 'GitHub', label: 'ops@example.com', secret: 'JBSWY3DPEHPK3PXP', folder: 'Work', favorite: true);

/// Team license `TT1.<team1|sub|periodEnd>.<sig>`, signed with [seed] (any key for the fake relay).
Future<String> teamLicense(List<int> seed, int periodEnd) async {
  final pair = await Ed25519().newKeyPairFromSeed(seed);
  final payload = utf8.encode('team1|sub_test|$periodEnd');
  return 'TT1.${b64u(payload)}.${b64u((await Ed25519().sign(payload, keyPair: pair)).bytes)}';
}

/// The whole life of a team. [epochOnRelay] reads an entry's epoch straight from the relay (fake only).
Future<void> scenario(String base, List<int> seed, {int Function(String id)? epochOnRelay}) async {
  final yearOut = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 365 * 86400;
  final a = await newVault(), b = await newVault(), c = await newVault();

  await expectLater(TeamClient.create(a, 'TA1.not.a-team-license', relay: base), throwsA(isA<TeamException>()));
  await TeamClient.create(a, await teamLicense(seed, yearOut), relay: base);
  expect(isTeamAdmin(a), isTrue);

  final invite = await TeamClient(a).inviteLink();
  expect(invite, startsWith(teamLinkPrefix));
  await TeamClient.join(b, invite);
  await expectLater(TeamClient.join(c, invite), throwsA(isA<TeamException>().having((e) => e.message, 'message', contains('already been used'))));
  expect(inTeam(c), isFalse);

  // B waits for its key until the admin's app syncs.
  expect((await TeamClient(b).sync()).waitingForKey, isTrue);

  // A shares one of its accounts; the copy has a new id and none of A's own folder or favorite.
  a.accounts.add(github());
  final shared = teamCopyOf(github());
  expect(shared.id, isNot('acct-1'));
  expect([shared.folder, shared.favorite], [null, false]);
  putTeamAccount(a, shared);
  await a.save();
  expect((await TeamClient(a).sync()).pushed, 1);

  final rb = await TeamClient(b).sync();
  expect([rb.waitingForKey, rb.pulled], [false, 1]);
  final now = DateTime.now();
  expect(teamAccounts(b).single.codeAt(now), github().codeAt(now));
  expect(b.accounts, isEmpty, reason: 'team accounts never land in the personal list (or personal sync)');
  expect(a.accounts.length, 1);

  // B renames it; A sees the rename.
  final edit = teamAccounts(b).single..issuer = 'GitHub (ops)';
  putTeamAccount(b, edit);
  await b.save();
  await TeamClient(b).sync();
  await TeamClient(a).sync();
  expect(teamAccounts(a).single.issuer, 'GitHub (ops)');

  // C joins with a fresh invite.
  await TeamClient.join(c, await TeamClient(a).inviteLink());
  await TeamClient(a).sync(); // wraps the key for C
  await TeamClient(c).sync();
  expect(teamAccounts(c).single.issuer, 'GitHub (ops)');

  // Removing B rotates the key; B is out at once and forgets the team.
  final bKey = await TeamClient(b).myKey();
  await TeamClient(a).removeMember(bKey);
  final st = await TeamClient(a).status();
  expect([st.epoch, st.needsRotation, st.members.length], [2, false, 2]);
  await expectLater(TeamClient(b).sync(), throwsA(isA<TeamGoneException>()));
  expect(inTeam(b), isFalse);

  // C gets the new key and moves the old entry onto it (same time, new epoch).
  final rc = await TeamClient(c).sync();
  expect(rc.pushed, 1, reason: 're-encrypted under epoch 2');
  if (epochOnRelay != null) expect(epochOnRelay(shared.id), 2);
  await TeamClient(a).sync();
  expect(teamAccounts(a).single.issuer, 'GitHub (ops)');

  // C deletes it; A sees it gone.
  removeTeamAccount(c, shared.id);
  await c.save();
  await TeamClient(c).sync();
  await TeamClient(a).sync();
  expect(teamAccounts(a), isEmpty);

  // About once a day the admin's app renews the license and hands it to the relay.
  final renewed = await teamLicense(seed, yearOut + 86400);
  String? asked;
  await TeamClient(a, refreshLicense: (t) async => (asked = t, renewed).$2).sync();
  expect(asked, isNull, reason: 'checked at creation, so not again yet');
  teamState(a)!['licenseCheckedAt'] = 0;
  await TeamClient(a, refreshLicense: (t) async => (asked = t, renewed).$2).sync();
  expect(asked, startsWith('TT1.'));
  expect((await TeamClient(a).status()).licenseEnd.millisecondsSinceEpoch, (yearOut + 86400) * 1000);
  expect(teamState(a)!['license'], renewed);

  // C leaves: the next admin sync rotates again.
  await TeamClient(c).leave();
  expect(inTeam(c), isFalse);
  await TeamClient(a).sync();
  expect((await TeamClient(a).status()).epoch, 3);

  await TeamClient(a).deleteTeam();
  expect(inTeam(a), isFalse);
}

void main() {
  test('wrapped team keys open only with the right box key', () async {
    final box = await X25519().newKeyPair();
    final pub = b64u((await box.extractPublicKey()).bytes);
    final key = randomBytes(32);
    final w = await wrapTeamKey(key, pub);
    expect(await unwrapTeamKey(w, box), key);
    await expectLater(unwrapTeamKey(w, await X25519().newKeyPair()), throwsA(isA<TeamException>()));
  });

  test('invite links: round trip, and junk is refused with a sentence', () {
    final id = b64u(randomBytes(32));
    final inv = parseTeamInvite(teamInviteLink('https://relay.example', id, 'tok+/en'));
    expect([inv.relay, inv.teamId, inv.invite], ['https://relay.example', id, 'tok+/en']);
    for (final junk in ['', 'tanookiauth://sync?v=1', '${teamLinkPrefix}v=1&relay=https://x&team=short&invite=a', 'https://example.com']) {
      expect(() => parseTeamInvite(junk), throwsA(isA<TeamException>()), reason: junk);
    }
  });

  test('a whole team, against a fake relay', () async {
    final relay = FakeTeamRelay();
    await relay.start();
    addTearDown(() => relay.server.close(force: true));
    await scenario(relay.base, randomBytes(32), epochOnRelay: (id) => relay.entries[id]!['epoch'] as int);
  });

  test('a removed device gets a plain sentence, not a crash', () async {
    final relay = FakeTeamRelay();
    await relay.start();
    addTearDown(() => relay.server.close(force: true));
    final v = await newVault();
    v.settings[teamStateKey] = {'relay': relay.base, 'teamId': b64u(randomBytes(32)), 'role': 'member', 'device': b64u(randomBytes(32)), 'box': b64u(randomBytes(32)), 'keys': {}, 'cursor': 0, 'entries': {}};
    await expectLater(TeamClient(v).sync(), throwsA(isA<TeamGoneException>().having((e) => e.message, 'message', 'This team was deleted by its admin.')));
    expect(inTeam(v), isFalse);
  });

  final live = Platform.environment['TEAM_RELAY_URL'], seed = Platform.environment['TEAM_LICENSE_SEED'];
  test('a whole team, against a real local relay (wrangler dev)', () async {
    try {
      await scenario(live!, base64.decode(seed!));
    } on RelayException catch (e) {
      fail('relay said: ${e.status} ${e.message}');
    }
  }, skip: live == null || seed == null ? 'set TEAM_RELAY_URL and TEAM_LICENSE_SEED to run against wrangler dev' : false);
}
