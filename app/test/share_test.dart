import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:image/image.dart' as img;
import 'package:tanooki_auth/core/qr_image.dart';
import 'package:tanooki_auth/core/share.dart';

import 'qr_image_test.dart' show renderQr;

void main() {
  final a = Account(id: 'x', issuer: 'GitHub', label: 'maddie', secret: 'JBSWY3DPEHPK3PXP');
  final t0 = DateTime.utc(2026, 10, 29, 12);

  test('round trip with the right code inside 24 hours', () async {
    final s = await createShare(a, now: t0);
    expect(s.code, matches(RegExp(r'^\d{6}$')));
    expect(s.text, startsWith(sharePrefix));
    expect(s.text, isNot(contains('JBSWY3DPEHPK3PXP')));
    final b = await openShare(s.text, ' ${s.code} ', now: t0.add(const Duration(hours: 23)));
    expect((b.issuer, b.label, b.secret), ('GitHub', 'maddie', 'JBSWY3DPEHPK3PXP'));
    expect(b.codeAt(t0), a.codeAt(t0));
  });

  test('wrong code, expired, tampered and junk are refused', () async {
    final s = await createShare(a, now: t0);
    final wrong = ((int.parse(s.code) + 1) % 1000000).toString().padLeft(6, '0');
    await expectLater(openShare(s.text, wrong, now: t0), throwsA(isA<ShareException>().having((e) => e.message, 'm', contains('Wrong code'))));
    await expectLater(openShare(s.text, s.code, now: t0.add(const Duration(hours: 24, seconds: 1))),
        throwsA(isA<ShareException>().having((e) => e.message, 'm', contains('expired'))));

    final body = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(s.text.substring(sharePrefix.length))))) as Map;
    String repack(Map m) => '$sharePrefix${base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '')}';
    // Pushing the expiry out a year must not work: it's authenticated.
    await expectLater(openShare(repack({...body, 'exp': body['exp'] + 31536000}), s.code, now: t0.add(const Duration(days: 2))),
        throwsA(isA<ShareException>().having((e) => e.message, 'm', contains('Wrong code'))));
    final c = base64Url.decode(base64Url.normalize(body['c'] as String))..[3] ^= 1;
    await expectLater(openShare(repack({...body, 'c': base64Url.encode(c)}), s.code, now: t0), throwsA(isA<ShareException>()));
    for (final junk in ['', 'otpauth://totp/x?secret=AA', '${sharePrefix}nope']) {
      await expectLater(openShare(junk, s.code, now: t0), throwsA(isA<ShareException>().having((e) => e.message, 'm', contains('isn\'t'))));
    }
  });

  test('a share fits in a QR code that the scanner reads back', () async {
    final s = await createShare(a, now: t0);
    final scanned = decodeQrImage(img.encodePng(renderQr(s.text)));
    expect(scanned, s.text);
    expect((await openShare(scanned, s.code, now: t0)).secret, a.secret);
  });
}
