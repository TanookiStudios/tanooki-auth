// Stand-in desktop app for the extension's automated browser test (extension/test/e2e.cjs).
// Runs the real BridgeServer over a throwaway vault, prints events to stdout, auto-approves adds,
// and writes the setup-page QR image. Not part of `flutter test`; e2e.cjs starts it with:
//   flutter test tool/bridge_harness_test.dart --dart-define=HARNESS_DIR=<dir>
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:tanooki_auth/bridge/server.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:zxing2/qrcode.dart';

const setupUri = 'otpauth://totp/TestSite:demo%40example.com?secret=KRUGKIDROVUWG2ZAMJZG653OEBTG66BAN52XE&issuer=TestSite';
// Shown as a CSS background, which the in-page scanner can't see; the popup's "Scan page" must.
const setupUri2 = 'otpauth://totp/OtherSite:demo?secret=JBSWY3DPEHPK3PXP&issuer=OtherSite';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

class HarnessHost implements BridgeHost {
  HarnessHost(this.vault);
  @override
  final Vault vault;
  @override
  bool get locked => false;
  @override
  void showPairingCode(String code, String origin) => stdout.writeln('PAIRCODE $code');
  @override
  void hidePairingCode() {}
  @override
  Future<bool> confirmAdd(Account a) async {
    stdout.writeln('CONFIRM ${a.issuer} ${a.domains.join(',')}');
    return true;
  }

  @override
  void vaultChanged() {}
  @override
  void openScreen(String screen) => stdout.writeln('OPEN $screen');
}

void main() {
  test('bridge harness', () async {
    final dir = Directory(const String.fromEnvironment('HARNESS_DIR'));
    expect(dir.existsSync(), isTrue, reason: 'pass --dart-define=HARNESS_DIR');

    void writeQr(String uri, String name) {
      final matrix = Encoder.encode(uri, ErrorCorrectionLevel.m).matrix!;
      const s = 6, q = 4;
      final qr = img.Image(width: (matrix.width + 2 * q) * s, height: (matrix.height + 2 * q) * s)
        ..clear(img.ColorRgb8(255, 255, 255));
      for (var y = 0; y < matrix.height; y++) {
        for (var x = 0; x < matrix.width; x++) {
          if (matrix.get(x, y) == 1) {
            img.fillRect(qr, x1: (x + q) * s, y1: (y + q) * s, x2: (x + q + 1) * s - 1, y2: (y + q + 1) * s - 1, color: img.ColorRgb8(0, 0, 0));
          }
        }
      }
      File('${dir.path}/$name').writeAsBytesSync(img.encodePng(qr));
    }

    writeQr(setupUri, 'setup-qr.png');
    writeQr(setupUri2, 'setup2-qr.png');

    final vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore());
    await vault.load();
    final server = BridgeServer(HarnessHost(vault));
    final port = await server.start();
    expect(port, bridgePorts.first, reason: 'something else (the real app?) is on ${bridgePorts.first}; close it first');
    stdout.writeln('READY $port');

    final done = File('${dir.path}/done');
    while (!done.existsSync()) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    stdout.writeln('ACCOUNTS ${vault.accounts.map((a) => '${a.issuer}@${a.domains.join(',')}').join(' ')}');
    await server.stop();
  }, timeout: const Timeout(Duration(minutes: 5)));
}
