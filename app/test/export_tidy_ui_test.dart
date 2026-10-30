import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/export_ui.dart';
import 'package:tanooki_auth/ui/theme.dart';
import 'package:tanooki_auth/ui/tidy_ui.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  Future<void> pump(WidgetTester t, Widget home) async {
    t.view.physicalSize = const Size(500, 1600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: home));
    await t.pump();
  }

  testWidgets('Google export: pages through the QR codes and names every account left out', (t) async {
    final accounts = [
      for (var i = 0; i < 12; i++) Account(id: '$i', issuer: 'Site $i', secret: 'JBSWY3DPEHPK3PXP'),
      Account(id: 's', issuer: 'Steam', label: 'gamer', secret: 'MFRGGZDFMZTWQ2LK', type: OtpType.steam, digits: 5),
    ];
    await pump(t, GoogleExportScreen(accounts: accounts));
    expect(find.text('Code 1 of 2'), findsOneWidget);
    expect(find.textContaining('Left out (1)'), findsOneWidget);
    expect(find.text('• Steam (gamer): Steam codes'), findsOneWidget);
    await t.tap(find.text('Next code'));
    await t.pump();
    expect(find.text('Code 2 of 2'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('Tidy names: shows each change first, applies only the ticked ones', (t) async {
    final dir = Directory.systemTemp.createTempSync('tidy_ui');
    addTearDown(() => dir.deleteSync(recursive: true));
    final vault = Vault(File('${dir.path}/v.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 1)));
    vault.accounts.addAll([
      Account(id: '1', issuer: '', label: 'google.com:maddie@gmail.com (Personal)', secret: 'JBSWY3DPEHPK3PXP'),
      Account(id: '2', issuer: 'github.com (octo@example.com)', label: '', secret: 'GEZDGNBVGY3TQOJQ'),
      Account(id: '3', issuer: 'Discord', label: 'tanooki', secret: 'MFRGGZDFMZTWQ2LK'),
    ]);
    await pump(t, Builder(
      builder: (c) => TextButton(
        onPressed: () => Navigator.push(c, MaterialPageRoute(builder: (_) => TidyNamesScreen(vault: vault))),
        child: const Text('open'),
      ),
    ));
    await t.tap(find.text('open'));
    await t.pumpAndSettle();
    expect(find.text('Google · maddie@gmail.com'), findsOneWidget);
    expect(find.text('Was: google.com:maddie@gmail.com (Personal)'), findsOneWidget);
    expect(find.text('GitHub · octo@example.com'), findsOneWidget);
    expect(find.textContaining('Discord'), findsNothing, reason: 'already tidy: not listed');
    expect(vault.accounts.first.issuer, '', reason: 'nothing changes before Apply');

    await t.tap(find.text('GitHub · octo@example.com')); // untick it
    await t.pump();
    await t.tap(find.text('Apply 1'));
    for (var i = 0; i < 50 && find.byType(TidyNamesScreen).evaluate().isNotEmpty; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await t.pumpAndSettle();
    }
    expect([vault.accounts[0].issuer, vault.accounts[0].label], ['Google', 'maddie@gmail.com']);
    expect(vault.accounts[1].issuer, 'github.com (octo@example.com)', reason: 'unticked: left as it was');
  });
}
