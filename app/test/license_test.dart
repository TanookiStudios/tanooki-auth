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

}
