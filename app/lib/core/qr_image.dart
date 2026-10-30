import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

/// Decodes the QR code in an image file's bytes (PNG, JPEG, GIF, BMP, WebP...).
/// Throws [FormatException] with a user-readable message.
String decodeQrImage(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) throw const FormatException('That file is not a picture this app can read.');
  return decodeQr(image);
}

/// Decodes the QR code in a picture or screen capture. Big pictures (phone photos, 5K screens) are
/// tried at a smaller size first, which is much faster and usually enough, then at full size.
String decodeQr(img.Image image) {
  const big = 2000;
  if (image.width > big || image.height > big) {
    final small = image.width >= image.height ? img.copyResize(image, width: big ~/ 1.25) : img.copyResize(image, height: big ~/ 1.25);
    final text = _tryDecode(small);
    if (text != null) return text;
  }
  return _tryDecode(image) ?? (throw const FormatException('No QR code found in that picture.'));
}

String? _tryDecode(img.Image image) {
  // zxing's finder can lock onto a finder-like square inside the data of a dense code (about 1 in 20
  // share-sized codes) before it reaches the real third corner. It scans top to bottom, so the same picture
  // turned a quarter turn is scanned in a different order and usually reads fine.
  for (final angle in const [0, 90, 180, 270]) {
    final text = _tryDecodeOnce(angle == 0 ? image : img.copyRotate(image, angle: angle));
    if (text != null) return text;
  }
  return null;
}

String? _tryDecodeOnce(img.Image image) {
  // 8 bits per channel whatever the file used (1-bit and palette PNGs are common for QR codes), laid out as
  // the 0xAARRGGBB ints zxing reads: on a little-endian CPU that is B, G, R, A in memory.
  final pixels = image.convert(format: img.Format.uint8, numChannels: 4, alpha: 255).getBytes(order: img.ChannelOrder.bgra).buffer.asInt32List();
  final source = RGBLuminanceSource(image.width, image.height, pixels);
  for (final bitmap in [
    BinaryBitmap(HybridBinarizer(source)),
    BinaryBitmap(GlobalHistogramBinarizer(source)),
  ]) {
    try {
      return QRCodeReader().decode(bitmap, hints: DecodeHints()..put(DecodeHintType.tryHarder)).text;
    } on ReaderException {
      // try the next binarizer
    }
  }
  return null;
}
