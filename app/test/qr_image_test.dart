import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:tanooki_auth/core/qr_image.dart';
import 'package:zxing2/qrcode.dart';

img.Image renderQr(String text) {
  final matrix = Encoder.encode(text, ErrorCorrectionLevel.m).matrix!;
  const scale = 8, quiet = 4;
  final size = (matrix.width + quiet * 2) * scale;
  final image = img.Image(width: size, height: size)..clear(img.ColorRgb8(255, 255, 255));
  for (var y = 0; y < matrix.height; y++) {
    for (var x = 0; x < matrix.width; x++) {
      if (matrix.get(x, y) == 1) {
        img.fillRect(image,
            x1: (x + quiet) * scale, y1: (y + quiet) * scale,
            x2: (x + quiet + 1) * scale - 1, y2: (y + quiet + 1) * scale - 1,
            color: img.ColorRgb8(0, 0, 0));
      }
    }
  }
  return image;
}

void main() {
  const uri = 'otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP&issuer=GitHub';

  test('decodes PNG and JPEG', () {
    final qr = renderQr(uri);
    expect(decodeQrImage(img.encodePng(qr)), uri);
    expect(decodeQrImage(img.encodeJpg(qr, quality: 80)), uri);
  });

  test('clear errors for non-images and images without a QR', () {
    expect(() => decodeQrImage(img.encodePng(img.Image(width: 50, height: 50))), throwsFormatException);
    expect(() => decodeQrImage(Uint8List.fromList([1, 2, 3])), throwsFormatException);
  });

  test('finds a small QR code on a big screen capture (fast path and full-size fallback)', () {
    final screen = img.Image(width: 3840, height: 2160)..clear(img.ColorRgb8(240, 240, 240));
    img.compositeImage(screen, renderQr(uri), dstX: 2900, dstY: 1500);
    expect(decodeQr(screen), uri);
    // Too small to survive shrinking: only the full-size pass can read it.
    final tiny = img.copyResize(renderQr(uri), width: 120, interpolation: img.Interpolation.nearest);
    final screen2 = img.Image(width: 5120, height: 2880)..clear(img.ColorRgb8(255, 255, 255));
    img.compositeImage(screen2, tiny, dstX: 4000, dstY: 2000);
    expect(decodeQr(screen2), uri);
  });
}
