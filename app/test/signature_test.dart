import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/ui/signature.dart';

void main() {
  test('signature path parses and stays inside its 330x116 box after the flourish transform', () {
    final path = parseSignaturePath('M50 92 C 46 66 48 34 56 30 C 62 27 62 46 63 62')
        .transform(signatureTransform.storage);
    final b = path.getBounds();
    expect(b.width, greaterThan(5));
    expect(b.left >= 0 && b.right <= 330 && b.top >= 0 && b.bottom <= 116, isTrue, reason: '$b');
  });
}
