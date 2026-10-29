import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/totp.dart';

void main() {
  // RFC 4226 Appendix D.
  test('HOTP RFC 4226 vectors', () {
    final key = utf8.encode('12345678901234567890');
    const expected = [
      '755224', '287082', '359152', '969429', '338314',
      '254676', '287922', '162583', '399871', '520489',
    ];
    for (var c = 0; c < expected.length; c++) {
      expect(hotp(key, c), expected[c], reason: 'counter $c');
    }
  });

  // RFC 6238 Appendix B (8 digits; SHA-256/512 keys are the seed repeated to hash length).
  test('TOTP RFC 6238 vectors', () {
    final k1 = utf8.encode('12345678901234567890');
    final k256 = utf8.encode('12345678901234567890123456789012');
    final k512 = utf8.encode(
        '1234567890123456789012345678901234567890123456789012345678901234');
    const rows = [
      // time, sha1, sha256, sha512
      [59, '94287082', '46119246', '90693936'],
      [1111111109, '07081804', '68084774', '25091201'],
      [1111111111, '14050471', '67062674', '99943326'],
      [1234567890, '89005924', '91819424', '93441116'],
      [2000000000, '69279037', '90698825', '38618901'],
      [20000000000, '65353130', '77737706', '47863826'],
    ];
    for (final r in rows) {
      final t = r[0] as int;
      expect(totp(k1, t, digits: 8), r[1], reason: 'sha1 t=$t');
      expect(totp(k256, t, digits: 8, algorithm: OtpAlgorithm.sha256), r[2], reason: 'sha256 t=$t');
      expect(totp(k512, t, digits: 8, algorithm: OtpAlgorithm.sha512), r[3], reason: 'sha512 t=$t');
    }
  });

  test('6-digit truncation keeps leading zeros', () {
    // t=1111111109 SHA-1 8-digit is 07081804, so 6-digit is 081804.
    expect(totp(utf8.encode('12345678901234567890'), 1111111109), '081804');
  });

  test('base32 tolerates padding, lowercase, spaces', () {
    final want = utf8.encode('12345678901234567890');
    const b32 = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';
    expect(base32Decode(b32), want);
    expect(base32Decode(b32.toLowerCase()), want);
    expect(base32Decode('GEZD GNBV GY3T QOJQ GEZD GNBV GY3T QOJQ'), want);
    expect(base32Decode('MZXW6==='), utf8.encode('foo'));
    expect(base32Decode('MZXW6'), utf8.encode('foo'));
    expect(base32Encode(want), b32);
    expect(() => base32Decode('ABC1'), throwsFormatException);
    expect(() => base32Decode(''), throwsFormatException);
  });

  test('secondsLeft', () {
    expect(secondsLeft(0), 30);
    expect(secondsLeft(59), 1);
  });
}
