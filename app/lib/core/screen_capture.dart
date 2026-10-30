import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'qr_image.dart';

const _window = MethodChannel('tanooki/window');

/// Why "Scan my screen" didn't work. [denied] is the Mac's Screen Recording permission being off.
enum ScreenScanFailure { denied, unsupported, captureFailed, noQr }

class ScreenScanException implements Exception {
  ScreenScanException(this.failure);
  final ScreenScanFailure failure;
}

/// Takes a picture of every screen (leaving out Tanooki Auth's own window) and returns the first
/// QR code found. Mac returns PNGs; Windows returns raw BGRA pixels with their size.
Future<String> scanScreenForQr() async {
  final List<Object?> shots;
  try {
    shots = await _window.invokeMethod<List<Object?>>('captureScreen') ?? const [];
  } on MissingPluginException {
    throw ScreenScanException(ScreenScanFailure.unsupported);
  } on PlatformException catch (e) {
    throw ScreenScanException(e.code == 'denied' ? ScreenScanFailure.denied : ScreenScanFailure.captureFailed);
  }
  if (shots.isEmpty) throw ScreenScanException(ScreenScanFailure.captureFailed);
  final found = await Isolate.run(() {
    for (final s in shots) {
      try {
        if (s is Uint8List) return decodeQrImage(s);
        if (s is Map) {
          final bgra = s['bgra'] as Uint8List;
          final image = img.Image.fromBytes(
              width: s['width'] as int, height: s['height'] as int, bytes: Uint8List.fromList(bgra).buffer, numChannels: 4, order: img.ChannelOrder.bgra);
          return decodeQr(image);
        }
      } on FormatException {
        // no QR on this screen; try the next one
      }
    }
    return null;
  });
  if (found == null) throw ScreenScanException(ScreenScanFailure.noQr);
  return found;
}
