import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/main.dart';
import 'package:tanooki_auth/ui/premium.dart';

// Unattended screenshots over fabricated demo data:
//   SHOTS_DEVICE=iphone flutter drive -d <sim> --driver=test_driver/integration_test.dart \
//     --target=integration_test/screenshots_test.dart --dart-define=TA_STORAGE=shots
// Fails if any expected screen doesn't appear.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const demo = [
    'otpauth://totp/GitHub:octocat?secret=JBSWY3DPEHPK3PXP&issuer=GitHub',
    'otpauth://totp/Google:maddie.demo%40gmail.com?secret=GEZDGNBVGY3TQOJQ&issuer=Google',
    'otpauth://totp/Discord:tanooki_demo?secret=MFRGGZDFMZTWQ2LK&issuer=Discord',
    'otpauth://totp/Amazon%20Web%20Services:root?secret=ONSWG4TFOQYTEMZU&issuer=Amazon%20Web%20Services',
    'otpauth://totp/Dropbox:demo%40example.com?secret=KRUGKIDROVUWG2ZA&issuer=Dropbox',
    'otpauth://hotp/Bank:card?secret=NBSWY3DPO5XXE3DE&issuer=Bank&counter=3',
  ];
  const domains = ['github.com', 'google.com', 'discord.com', 'aws.amazon.com', 'dropbox.com', ''];

  Future<void> pumpFor(WidgetTester t, Finder f) async {
    for (var i = 0; i < 100 && f.evaluate().isEmpty; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    expect(f, findsWidgets, reason: 'expected screen did not appear');
    for (var i = 0; i < 8; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('screenshots', (t) async {
    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault');
    final vault = await openVault();
    await vault.resetToEmpty();
    for (var i = 0; i < demo.length; i++) {
      vault.accounts.add(parseOtpauthUri(demo[i])..domains.addAll([if (domains[i].isNotEmpty) domains[i]]));
    }
    vault.settings['lock'] = false;
    await vault.save();

    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
    await t.pumpWidget(const TanookiAuthApp());
    await pumpFor(t, find.text('GitHub'));
    await binding.takeScreenshot('1-accounts');

    await t.tap(find.text('Add account').first);
    await pumpFor(t, find.text('Paste setup link'));
    await binding.takeScreenshot('2-add');
    await t.pageBack();
    await pumpFor(t, find.text('GitHub'));

    await t.tap(find.byTooltip('Settings').evaluate().isNotEmpty ? find.byTooltip('Settings') : find.text('Settings'));
    await pumpFor(t, find.text('Export backup'));
    await binding.takeScreenshot('3-settings');
    await t.scrollUntilVisible(find.text('About Maddie'), 200, scrollable: find.byType(Scrollable).first);
    await t.tap(find.text('About Maddie'));
    await pumpFor(t, find.textContaining('I\'m a big believer in privacy'));
    await binding.takeScreenshot('5-about-maddie');
    await t.drag(find.byType(ListView).last, const Offset(0, -4000));
    await pumpFor(t, find.text('Support my work: tanookistudios.com/support'));
    await binding.takeScreenshot('6-about-signature');
    await t.pageBack();
    await pumpFor(t, find.text('Export backup'));
    await t.pageBack();

    await pumpFor(t, find.text('GitHub'));
    await t.tap(find.text('GitHub'));
    await pumpFor(t, find.byType(SnackBar));
    await binding.takeScreenshot('4-copied');

    await t.tap(find.byTooltip('Settings').evaluate().isNotEmpty ? find.byTooltip('Settings') : find.text('Settings'));
    await pumpFor(t, find.text('Get Premium'));
    await t.tap(find.text('Get Premium'));
    await pumpFor(t, find.text('Every Premium theme'));
    await binding.takeScreenshot('7-premium');
    await t.pageBack();
    await pumpFor(t, find.text('APPEARANCE'));
    await binding.takeScreenshot('8-appearance');
    await t.pageBack();

    // Demo only: unlock Premium in memory to show each theme.
    premium.value = true;
    for (final theme in ['light', 'pink', 'blue']) {
      themeChoice.value = theme;
      await pumpFor(t, find.text('GitHub'));
      await binding.takeScreenshot('9-theme-$theme');
    }
    themeChoice.value = 'auto';
  });
}
