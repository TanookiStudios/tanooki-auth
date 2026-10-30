import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tanooki_auth/core/totp.dart';
import 'package:tanooki_auth/main.dart';
import 'package:tanooki_auth/ui/home.dart';

// Run with: flutter test integration_test -d <device> --dart-define=TA_STORAGE=itest
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const uri = 'otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub';
  String expectedCode() =>
      groupCode(totp(base32Decode('JBSWY3DPEHPK3PXP'), DateTime.now().millisecondsSinceEpoch ~/ 1000));

  Future<void> settle(WidgetTester t) async {
    // The home screen ticks every second, so pumpAndSettle would never settle.
    for (var i = 0; i < 20; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  // Avoid asserting right as the code rolls over.
  Future<void> expectCurrentCode(WidgetTester t) async {
    if (secondsLeft(DateTime.now().millisecondsSinceEpoch ~/ 1000) <= 2) {
      for (var i = 0; i < 30; i++) {
        await t.pump(const Duration(milliseconds: 100));
      }
    }
    await t.pump(const Duration(seconds: 1));
    expect(find.text(expectedCode()), findsOneWidget);
  }

  Future<void> waitFor(WidgetTester t, Finder f) async {
    for (var i = 0; i < 100 && f.evaluate().isEmpty; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    expect(f, findsWidgets);
  }

  testWidgets('add by setup link, code is right, survives restart', (t) async {
    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault; pass --dart-define=TA_STORAGE=itest');
    await (await openVault()).resetToEmpty();

    await t.pumpWidget(const TanookiAuthApp());
    final notNow = find.text('Not now');
    final empty = find.textContaining('No accounts yet');
    for (var i = 0; i < 100 && notNow.evaluate().isEmpty && empty.evaluate().isEmpty; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    if (notNow.evaluate().isNotEmpty) {
      await t.tap(notNow); // phone first-run lock question; biometrics can't be automated
      await settle(t);
    }
    await waitFor(t, empty);

    await t.tap(find.text('Add account'));
    await settle(t);
    await t.tap(find.text('Paste setup link'));
    await settle(t);
    await t.enterText(find.byType(TextField), uri);
    await t.tap(find.text('Next'));
    await settle(t);
    expect(find.text('Add this account?'), findsOneWidget);
    await t.tap(find.text('Add'));
    await settle(t);

    await waitFor(t, find.text('GitHub'));
    expect(find.text('octo@example.com'), findsOneWidget);
    await expectCurrentCode(t);

    // Restart: a fresh app must load the account back from disk through the real secure store.
    await t.pumpWidget(const SizedBox());
    await t.pumpWidget(const TanookiAuthApp(key: ValueKey('second')));
    await waitFor(t, find.text('GitHub'));
    await expectCurrentCode(t);

    // Trash round trip through the real UI and disk: delete, see it in Settings > Trash, restore.
    await t.tap(find.byTooltip('More').first);
    await settle(t);
    await t.tap(find.text('Delete'));
    await settle(t);
    expect(find.text('GitHub'), findsNothing);
    await t.tap(find.byTooltip('Settings').evaluate().isNotEmpty ? find.byTooltip('Settings') : find.text('Settings'));
    await settle(t);
    await t.ensureVisible(find.text('Trash (1)'));
    await settle(t);
    await t.tap(find.text('Trash (1)'));
    await settle(t);
    expect(find.text('GitHub'), findsOneWidget);
    await t.tap(find.text('Restore'));
    await settle(t);
    expect(find.text('Trash is empty.\nDeleted accounts stay here for 30 days.'), findsOneWidget);
    await t.pageBack();
    await settle(t);
    await t.pageBack();
    await waitFor(t, find.text('GitHub'));
    final reloaded = await openVault();
    await reloaded.load();
    expect(reloaded.live.single.issuer, 'GitHub');

    final vaultFile = await openVault().then((v) => v.file);
    expect(vaultFile.existsSync(), isTrue);
    expect(vaultFile.readAsStringSync().contains('JBSWY3DPEHPK3PXP'), isFalse);
    stdout.writeln('PROOF vault=${vaultFile.path} accounts-restored=1 code-matches=true trash-restore=true platform=${Platform.operatingSystem}');
  });
}
