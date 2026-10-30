import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/totp.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/home.dart';
import 'package:tanooki_auth/ui/theme.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;
  String? clipboard;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('home_test');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 3)));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform,
        (call) async {
      if (call.method == 'Clipboard.setData') clipboard = (call.arguments as Map)['text'] as String;
      if (call.method == 'Clipboard.getData') return {'text': clipboard};
      return null;
    });
  });
  tearDown(() => dir.deleteSync(recursive: true));

  Account acct(String issuer, String secret, {bool fav = false, List<String> tags = const []}) =>
      Account(id: issuer, issuer: issuer, label: '$issuer user', secret: secret, favorite: fav, tags: [...tags]);

  Future<void> pumpHome(WidgetTester t) async {
    t.view.physicalSize = const Size(420, 900); // phone width: the list layout
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: HomeScreen(vault: vault)));
    await t.pump();
  }

  // Lets file writes (vault.save) finish, which fake time can't do on its own.
  // Polls until [done] holds, so a busy machine (other tests hashing in parallel) can't make it flaky.
  Future<void> flushIo(WidgetTester t, bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await t.pump();
    }
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 31)); // let the clipboard-clear timer run out
  }

  testWidgets('tap copies the code, shows the toast, and records last used', (t) async {
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
    await pumpHome(t);
    await t.tap(find.text('GitHub'));
    await t.pump();
    await flushIo(t, () => vault.accounts.single.lastUsedAt != null);
    expect(find.text('Copied GitHub code. The clipboard clears in 30 seconds.'), findsOneWidget);
    expect(clipboard, matches(RegExp(r'^\d{6}$')));
    expect(vault.accounts.single.lastUsedAt, isNotNull);
    await finish(t);
  });

  testWidgets('favorites sit on top; tag chips filter the list', (t) async {
    vault.accounts.addAll([
      acct('Alpha', 'JBSWY3DPEHPK3PXP', tags: ['work']),
      acct('Bravo', 'GEZDGNBVGY3TQOJQ', fav: true),
      acct('Charlie', 'MFRGGZDFMZTWQ2LK', tags: ['games']),
    ]);
    await pumpHome(t);
    double y(String s) => t.getTopLeft(find.text(s)).dy;
    expect(y('Bravo'), lessThan(y('Alpha')));
    expect(y('Alpha'), lessThan(y('Charlie')));

    await t.tap(find.widgetWithText(ChoiceChip, 'games'));
    await t.pump();
    expect(find.text('Charlie'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Bravo'), findsNothing);
    await finish(t);
  });

  testWidgets('hidden codes show dots until tapped', (t) async {
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
    vault.settings[hideCodesKey] = true;
    await pumpHome(t);
    expect(find.text('••• •••'), findsOneWidget);
    await t.tap(find.text('GitHub'));
    await t.pump();
    await flushIo(t, () => vault.accounts.single.lastUsedAt != null);
    expect(find.text('••• •••'), findsNothing);
    final shown = groupCode(vault.accounts.single.codeAt(DateTime.now()));
    expect(find.text(shown), findsOneWidget);
    await finish(t);
  });

  testWidgets('next code appears only in the last 5 seconds', (t) async {
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
    // The card follows the real clock, so check whichever case "now" falls in (retry if it moved mid-check).
    int left() => secondsLeft(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    await pumpHome(t);
    for (var i = 0; i < 5; i++) {
      final before = left();
      await t.pump();
      if (left() != before) continue;
      expect(find.textContaining('Next '), before <= 5 ? findsOneWidget : findsNothing);
      break;
    }
    await finish(t);
  });

  testWidgets('delete moves to Trash with undo; trashed accounts are not shown', (t) async {
    vault.accounts.addAll([acct('Alpha', 'JBSWY3DPEHPK3PXP'), acct('Bravo', 'GEZDGNBVGY3TQOJQ')]);
    await pumpHome(t);
    await t.tap(find.byTooltip('More').first);
    await t.pumpAndSettle();
    await t.tap(find.text('Delete'));
    await t.pump();
    await flushIo(t, () => find.text('Alpha').evaluate().isEmpty);
    expect(find.text('Alpha'), findsNothing);
    expect(vault.accounts.first.trashed, isTrue);
    expect(find.textContaining('Moved Alpha to Trash'), findsOneWidget);

    await t.pump(const Duration(milliseconds: 600)); // let the toast slide in
    await t.tap(find.text('Undo'));
    await t.pump();
    await flushIo(t, () => find.text('Alpha').evaluate().isNotEmpty);
    expect(find.text('Alpha'), findsOneWidget);
    expect(vault.accounts.first.trashed, isFalse);
    await finish(t);
  });

  for (final compact in [false, true]) {
    testWidgets('card fits with the next code showing (${compact ? 'compact' : 'roomy'})', (t) async {
      final a = acct('A very long service name indeed', 'JBSWY3DPEHPK3PXP', fav: true, tags: ['work', 'games'])
        ..domains.add('github.com');
      void nop() {}
      await t.pumpWidget(MaterialApp(
        theme: buildTheme(darkPalette),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 340,
              height: compact ? 92 : 196,
              child: AccountCard(
                account: a, code: '123456', nextCode: '654321', left: 3, selected: false, compact: compact,
                onTap: nop, onEdit: nop, onDelete: nop, onNext: nop, onFavorite: nop, onRecoveryCodes: nop,
              ),
            ),
          ),
        ),
      ));
      expect(find.text('Next 654 321'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  }

  testWidgets('compact layout shows the same accounts in shorter cards', (t) async {
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
    vault.settings[layoutKey] = 'compact';
    await pumpHome(t);
    expect(find.text('GitHub'), findsOneWidget);
    expect(t.getSize(find.byType(AccountCard)).height, lessThan(100));
    expect(t.takeException(), isNull);
    await finish(t);
  });
}
