import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/add.dart';
import 'package:tanooki_auth/ui/theme.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  testWidgets('pasting many links adds the good ones and lists each skipped line', (t) async {
    final dir = Directory.systemTemp.createTempSync('paste_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 3)));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async => null);
    t.view.physicalSize = const Size(420, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: AddScreen(vault: vault)));

    await t.tap(find.text('Paste setup link'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField),
        'otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP&issuer=GitHub\nnot a link\notpauth://totp/Discord:me?secret=MFRGGZDFMZTWQ2LK&issuer=Discord');
    await t.tap(find.text('Next'));
    await t.pumpAndSettle();
    expect(find.text('Add 2 accounts?'), findsOneWidget);
    await t.tap(find.text('Import'));
    for (var i = 0; i < 50 && find.text('Added 2, skipped 1.').evaluate().isEmpty; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await t.pump();
    }
    expect(find.text('Added 2, skipped 1.'), findsOneWidget);
    expect(find.text('• Line 2: That is not an otpauth:// link.'), findsOneWidget);
    expect(vault.live.map((a) => a.issuer), ['GitHub', 'Discord']);
  });
}
