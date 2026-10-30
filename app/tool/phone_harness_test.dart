// Stand-in phone for the extension's phone-link browser test (extension/test/phone-e2e.cjs). Runs the app's
// real phone-link code (core/phone_link.dart) over a throwaway vault, against the live relay:
// waits for <HARNESS_DIR>/qr.txt, pairs, then answers every request the way the Approve/Deny sheet
// would: Approve when an account is saved for the site, Deny otherwise. Prints PAIRED, APPROVE <host>,
// DENY <host>. Stops when <HARNESS_DIR>/done appears. Not part of `flutter test`; started with:
//   flutter test tool/phone_harness_test.dart --dart-define=HARNESS_DIR=<dir>
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/phone_link.dart';

void main() {
  test('phone harness', () async {
    final dir = Directory(const String.fromEnvironment('HARNESS_DIR'));
    expect(dir.existsSync(), isTrue, reason: 'pass --dart-define=HARNESS_DIR');
    final accounts = [
      parseOtpauthUri('otpauth://totp/TestSite:demo?secret=KRUGKIDROVUWG2ZAMJZG653OEBTG66BAN52XE&issuer=TestSite')..domains.add('github.test'),
    ];
    final qrFile = File('${dir.path}/qr.txt');
    stdout.writeln('READY');
    while (!qrFile.existsSync()) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    final link = await BrowserLink.pair(qrFile.readAsStringSync().trim(), deviceName: 'Test phone');
    stdout.writeln('PAIRED');
    await link.connect((r) async {
      final offered = accountsForHost(accounts, r.host);
      stdout.writeln('${offered.isEmpty ? 'DENY' : 'APPROVE'} ${r.host}');
      await link.answer(r, offered.firstOrNull);
    }, onGone: () => stdout.writeln('UNPAIRED'), onDrop: () => stdout.writeln('DROPPED'));
    while (!File('${dir.path}/done').existsSync()) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    link.disconnect();
  }, timeout: const Timeout(Duration(minutes: 10)));
}
