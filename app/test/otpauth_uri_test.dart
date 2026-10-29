import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/totp.dart';

void main() {
  test('defaults: SHA1, 6 digits, 30 s', () {
    final a = parseOtpauthUri('otpauth://totp/alice@example.com?secret=JBSWY3DPEHPK3PXP');
    expect(a.type, OtpType.totp);
    expect(a.issuer, '');
    expect(a.label, 'alice@example.com');
    expect(a.algorithm, OtpAlgorithm.sha1);
    expect(a.digits, 6);
    expect(a.period, 30);
  });

  test('label decoding and issuer prefix', () {
    final a = parseOtpauthUri('otpauth://totp/ACME%20Co:john.doe%40email.com?secret=JBSWY3DPEHPK3PXP');
    expect(a.issuer, 'ACME Co');
    expect(a.label, 'john.doe@email.com');
  });

  test('issuer param wins over label prefix', () {
    final a = parseOtpauthUri('otpauth://totp/Old:bob?secret=JBSWY3DPEHPK3PXP&issuer=GitHub');
    expect(a.issuer, 'GitHub');
    expect(a.label, 'bob');
  });

  test('all parameters', () {
    final a = parseOtpauthUri(
        'otpauth://totp/X:y?secret=jbsw%20y3dp%20ehpk%203pxp&algorithm=sha512&digits=8&period=60');
    expect(a.secret, 'JBSWY3DPEHPK3PXP');
    expect(a.algorithm, OtpAlgorithm.sha512);
    expect(a.digits, 8);
    expect(a.period, 60);
  });

  test('hotp counter', () {
    final a = parseOtpauthUri('otpauth://hotp/X:y?secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ&counter=1');
    expect(a.type, OtpType.hotp);
    expect(a.codeAt(DateTime.now()), '287082'); // RFC 4226 counter 1
  });

  test('rejects bad input with a message', () {
    for (final bad in [
      'https://example.com',
      'otpauth://totp/x',
      'otpauth://totp/x?secret=1111',
      'otpauth://foo/x?secret=JBSWY3DPEHPK3PXP',
      'otpauth://totp/x?secret=JBSWY3DPEHPK3PXP&algorithm=MD5',
      'otpauth://totp/x?secret=JBSWY3DPEHPK3PXP&digits=4',
    ]) {
      expect(() => parseOtpauthUri(bad), throwsFormatException, reason: bad);
    }
  });

  test('round trip', () {
    for (final src in [
      'otpauth://totp/ACME%20Co:john.doe%40email.com?secret=JBSWY3DPEHPK3PXP&issuer=ACME%20Co&algorithm=SHA256&digits=8&period=60',
      'otpauth://hotp/bob?secret=JBSWY3DPEHPK3PXP&counter=7',
    ]) {
      final a = parseOtpauthUri(src);
      final b = parseOtpauthUri(toOtpauthUri(a));
      expect(b.toJson()..remove('id')..remove('createdAt'),
          a.toJson()..remove('id')..remove('createdAt'));
    }
  });
}
