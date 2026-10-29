import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

/// Decodes the QR code in an image file's bytes (PNG, JPEG, GIF, BMP, WebP...).
/// Throws [FormatException] with a user-readable message.
String decodeQrImage(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) throw const FormatException('That file is not a picture this app can read.');
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
  throw const FormatException('No QR code found in that picture.');
}
