import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/phone_link.dart';
import 'package:tanooki_auth/core/sync/merge.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';

// Expected values come from Node's WebCrypto: node app/tool/make_relay_vectors.mjs
Uint8List seq(int n, int start) => Uint8List.fromList(List.generate(n, (i) => (start + i) & 255));

void main() {
  test('sync keys match the protocol (group id, record id, record decrypts)', () async {
    final keys = await SyncKeys.fromRoot(seq(32, 1));
    expect(keys.groupId, 'X6qV1QCCpdDHkS2oB42Csf4K2dHxzsMWYRVtuuAIxUE');
    final rid = await keys.recordId('account-uuid-1');
    expect(rid, 'v6ZJP_mLeB5OBGbUgNtiULjozt4jal1EgSNXZMoLvbk');
    const record =
        'ZGVmZ2hpamtsbW5vr_19Baoeb0vTDF7o3tOnCVvPZlF1CGPxfBISOFoNgCZ3uxa9jTwtNaL6G7kL9SdUkrsWoUARd4e_EqLS0Izv0Q';
    final item = SyncItem.fromJson(await open(keys.recordKey, record, keys.aad(rid)));
    expect(item.purged, isTrue);
    expect(item.time, 1793322371412);
    // Bound to its record id: the same ciphertext under another id must not open.
    expect(() => open(keys.recordKey, record, keys.aad('another-id')), throwsA(anything));
  });

  test('our own seal opens, and survives a JSON round trip of an account', () async {
    final key = randomBytes(32);
    final a = Account(id: 'x', issuer: 'GitHub', secret: 'JBSWY3DPEHPK3PXP');
    final back = SyncItem.fromJson(await open(key, await seal(key, SyncItem.account(a).toJson(), 'aad'), 'aad'));
    expect(back.account!.syncContent, a.syncContent);
    expect(back.time, a.updatedAt.millisecondsSinceEpoch);
  });

  test('device signature matches Ed25519 in Node', () async {
    final d = await DeviceKey.fromSeed(seq(32, 50));
    expect(d.publicKey, 'XkIwMwRPVqE6aGeZSHvL-mPdHjkgTOwn3TmibaphVig');
    expect(await d.sign('TA-RELAY-1\nGET\n/v1/sync/x/devices\n1\nn\n${sha256b64u(const [])}'),
        'SHL_Dh6r5il_Wvv2W2RIpqK_MSmGKDoSNUJ4VvTaXvJ5YB9ZzC38-_YdF-dkhn3Z_GWkxMcsNynyB-AmAuJxDA');
    expect(sha256b64u(const []), '47DEQpj8HBSa-_TImW-5JCeuQeRkm5NMpJWZG3hSuFU');
  });

  test('phone link keys match the extension\'s (X25519 + HKDF), fill request decrypts', () async {
    final link = BrowserLink({
      'relay': relayUrl,
      'room': 'BwgJCgsMDQ4PEBESExQVFhcYGRobHB0eHyAhIiMkJSY',
      'extPub': 'CCZK5pC0Edjj7eQPhxklheoRSggnRKd2EFqsBeqxBS4',
      'secret': 'CQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJyg',
      'seed': b64u(seq(32, 200)),
      'phonePub': 'TVuribBzPZ2Nzs8E8yHJC3Ybd2WmvbK92_rT56vfH2Y',
      'token': 't',
      'pairedAt': DateTime.now().toIso8601String(),
    });
    final k = await link.keys();
    expect(b64u(k.p2e), 'W2-ZTs36n8C1VD8nbPEJsFrw8THY_dmCsNN6HLnyJxI');
    final msg = await open(k.e2p,
        'Hh8gISIjJCUmJygpyizPEc6dII4h1_IWxNG6p6x9xRJ21ia8MPPOOucwg9AuAW8apXAxJw3lKrHKM_XNgVfzoDZzPmGDwssN0tNPP6R77PZIX_T9Rc_m',
        'TA-LINK-1|${link.room}|e2p');
    expect(msg['host'], 'github.com');
  });

  test('pairing QR is parsed strictly', () {
    final ok = parseLinkQr('tanookiauth://link?v=1&relay=${Uri.encodeComponent(relayUrl)}&room=${'a' * 43}&key=${'b' * 43}&secret=${'c' * 43}');
    expect(ok.relay, relayUrl);
    for (final bad in [
      'otpauth://totp/x?secret=A',
      'tanookiauth://link?v=1&relay=http%3A%2F%2Fevil&room=${'a' * 43}&key=${'b' * 43}&secret=${'c' * 43}',
      'tanookiauth://link?v=1&relay=${Uri.encodeComponent(relayUrl)}&room=short&key=${'b' * 43}&secret=${'c' * 43}',
    ]) {
      expect(() => parseLinkQr(bad), throwsFormatException, reason: bad);
    }
  });

  test('only accounts saved for the requesting site are offered', () {
    final gh = Account(id: '1', issuer: 'GitHub', secret: 'A', domains: ['github.com']);
    final other = Account(id: '2', issuer: 'Other', secret: 'B', domains: ['github.com.evil.io']);
    final trashed = Account(id: '3', issuer: 'Old', secret: 'C', domains: ['github.com'], deletedAt: DateTime.now());
    expect(accountsForHost([gh, other, trashed], 'www.github.com'), [gh]);
    expect(accountsForHost([gh, other], 'gist.github.com'), [gh]);
    expect(accountsForHost([gh, other], 'gihtub.com'), isEmpty);
    expect(accountsForHost([gh, other], 'evilgithub.com'), isEmpty);
  });
}
