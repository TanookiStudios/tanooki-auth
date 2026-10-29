import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/google_migration.dart';
import 'package:tanooki_auth/core/totp.dart';

List<int> _varint(int v) {
  final out = <int>[];
  while (v >= 0x80) {
    out.add((v & 0x7f) | 0x80);
    v >>= 7;
  }
  return out..add(v);
}

List<int> _bytes(int field, List<int> v) => [..._varint(field << 3 | 2), ..._varint(v.length), ...v];
List<int> _int(int field, int v) => [..._varint(field << 3), ..._varint(v)];

void main() {
  test('public example payload: secret "Hello!\\xDE\\xAD\\xBE\\xEF" = JBSWY3DPEHPK3PXP', () {
    final list = parseGoogleMigration(
        'otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SGEV4YW1wbGU6YWxpY2VAZ29vZ2xlLmNvbRoHRXhhbXBsZTAC');
    expect(list, hasLength(1));
    expect(list.single.secret, 'JBSWY3DPEHPK3PXP');
    expect(list.single.issuer, 'Example');
    expect(list.single.label, 'alice@google.com');
    expect(list.single.type, OtpType.totp);
  });

  test('several accounts, HOTP, SHA-256, 8 digits, url-encoded data with +', () {
    final payload = [
      ..._bytes(1, [
        ..._bytes(1, utf8.encode('12345678901234567890')),
        ..._bytes(2, utf8.encode('bob')),
        ..._bytes(3, utf8.encode('Bank')),
        ..._int(4, 2),
        ..._int(5, 2),
        ..._int(6, 1),
        ..._int(7, 300),
      ]),
      ..._bytes(1, [..._bytes(1, [0xfb, 0xff, 0xfe]), ..._bytes(2, utf8.encode('Site:carol'))]),
      ..._int(2, 1), // payload version
    ];
    final b64 = base64.encode(payload);
    expect(b64.contains('+') || b64.contains('/'), isTrue, reason: 'exercise URL encoding');
    final list = parseGoogleMigration('otpauth-migration://offline?data=${Uri.encodeQueryComponent(b64)}');
    expect(list, hasLength(2));
    final bank = list[0];
    expect((bank.issuer, bank.label, bank.type, bank.algorithm, bank.digits, bank.counter),
        ('Bank', 'bob', OtpType.hotp, OtpAlgorithm.sha256, 8, 300));
    expect(base32Decode(bank.secret), utf8.encode('12345678901234567890'));
    expect((list[1].issuer, list[1].label, list[1].type), ('Site', 'carol', OtpType.totp));
    // Raw '+' left unencoded (seen in some exports) must also work.
    expect(parseGoogleMigration('otpauth-migration://offline?data=$b64'), hasLength(2));
  });

  test('bad input throws a message', () {
    expect(() => parseGoogleMigration('otpauth-migration://offline?data='), throwsFormatException);
    expect(() => parseGoogleMigration('otpauth-migration://offline?data=!!!'), throwsFormatException);
    expect(() => parseGoogleMigration('otpauth-migration://offline?data=CgM='), throwsFormatException);
  });
}
