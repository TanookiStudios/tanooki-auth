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
  final pixels = image.convert(numChannels: 4).getBytes(order: img.ChannelOrder.abgr).buffer.asInt32List();
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
