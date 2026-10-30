import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/license.dart';

Future<String> issue(SimpleKeyPair pair, String payload) async {
  final sig = await Ed25519().sign(utf8.encode(payload), keyPair: pair);
  String b(List<int> x) => base64Url.encode(x).replaceAll('=', '');
  return 'TA1.${b(utf8.encode(payload))}.${b(sig.bytes)}';
}

void main() {
  test('accepts a key signed with the matching key; rejects tampering and other signers', () async {
    final pair = await Ed25519().newKeyPair();
    final pub = base64.encode((await pair.extractPublicKey()).bytes);
    final key = await issue(pair, '1|order_123|20261028');
    expect(await verifyLicense(key, publicKey: pub), isTrue);
    expect(await verifyLicense('  $key\n', publicKey: pub), isTrue, reason: 'pasted with whitespace');

    final parts = key.split('.');
    final forged = 'TA1.${base64Url.encode(utf8.encode('1|order_999|20261028')).replaceAll('=', '')}.${parts[2]}';
    expect(await verifyLicense(forged, publicKey: pub), isFalse, reason: 'changed payload');
    expect(await verifyLicense(key), isFalse, reason: 'signed by a key that is not ours');
    for (final junk in ['', 'TA1', 'TA1.x.y', 'TA2.${parts[1]}.${parts[2]}', 'hello']) {
      expect(await verifyLicense(junk, publicKey: pub), isFalse, reason: junk);
    }
  });

  test('family keys carry 5 seats; old keys still verify with 1 seat', () async {
    final pair = await Ed25519().newKeyPair();
    final pub = base64.encode((await pair.extractPublicKey()).bytes);
    final old = await issue(pair, '1|cs_live_old|20261028');
    final family = await issue(pair, '1|cs_live_fam|20261029|5');
    expect(await verifyLicense(old, publicKey: pub), isTrue);
    expect(await verifyLicense(family, publicKey: pub), isTrue);
    expect(licenseSeats(old), 1);
    expect(licenseSeats(family), 5);
    expect(licenseSeats('junk'), 1);
    // Upgrading a $5 key to family by editing the payload breaks the signature.
    final parts = old.split('.');
    final bumped = 'TA1.${base64Url.encode(utf8.encode('1|cs_live_old|20261028|5')).replaceAll('=', '')}.${parts[2]}';
    expect(await verifyLicense(bumped, publicKey: pub), isFalse);
  });
}
