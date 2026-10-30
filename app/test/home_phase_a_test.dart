// Phase A on the home list: select many, folders, sort, Show QR, HOTP "Next code", and the Advanced settings.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/totp.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/add.dart';
import 'package:tanooki_auth/ui/home.dart';
import 'package:tanooki_auth/ui/security_ui.dart';
import 'package:tanooki_auth/ui/theme.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('home_a_test');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 3)));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });
  tearDown(() {
    confirmItsYouOverride = null;
    dir.deleteSync(recursive: true);
  });

  Account acct(String issuer, String secret, {String? folder, List<String> tags = const []}) =>
      Account(id: issuer, issuer: issuer, label: '', secret: secret, folder: folder, tags: [...tags]);

  Future<void> pumpHome(WidgetTester t) async {
    t.view.physicalSize = const Size(420, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: HomeScreen(vault: vault)));
    await t.pump();
  }

  Future<void> flushIo(WidgetTester t, bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await t.pump();
    }
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 31));
  }

  double y(WidgetTester t, String text) => t.getTopLeft(find.text(text)).dy;

  testWidgets('select many: favorite several at once, then trash several with one undo', (t) async {
    vault.accounts.addAll([acct('Alpha', 'JBSWY3DPEHPK3PXP'), acct('Bravo', 'GEZDGNBVGY3TQOJQ'), acct('Charlie', 'MFRGGZDFMZTWQ2LK')]);
    await pumpHome(t);
    await t.tap(find.byTooltip('Select accounts'));
    await t.pump();
    // Buttons with nothing selected say why instead of doing nothing.
    await t.tap(find.byTooltip('Add to favorites'));
    await t.pump();
    expect(find.text('Select some accounts first: tap them in the list.'), findsOneWidget);

    await t.tap(find.text('Alpha'));
    await t.tap(find.text('Charlie'));
    await t.pump();
    expect(find.text('2 selected'), findsOneWidget);
    expect(vault.accounts.every((a) => a.lastUsedAt == null), isTrue, reason: 'tapping while selecting must not copy');
    await t.tap(find.byTooltip('Add to favorites'));
    await t.pump();
    await flushIo(t, () => find.byTooltip('Select accounts').evaluate().isNotEmpty);
    expect(vault.accounts.map((a) => a.favorite), [true, false, true]);

    await t.tap(find.byTooltip('Select accounts'));
    await t.pump();
    await t.tap(find.text('Alpha'));
    await t.tap(find.text('Bravo'));
    await t.pump();
    await t.tap(find.byTooltip('Move to Trash'));
    await t.pump();
    await flushIo(t, () => find.text('Alpha').evaluate().isEmpty);
    expect(vault.live.map((a) => a.issuer), ['Charlie']);
    expect(find.textContaining('Moved 2 accounts to Trash'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 600));
    await t.tap(find.text('Undo'));
    await t.pump();
    await flushIo(t, () => find.text('Alpha').evaluate().isNotEmpty);
    expect(vault.live, hasLength(3));
    await finish(t);
  });

  testWidgets('select many: tag and move to a new folder', (t) async {
    vault.accounts.addAll([acct('Alpha', 'JBSWY3DPEHPK3PXP'), acct('Bravo', 'GEZDGNBVGY3TQOJQ')]);
    await pumpHome(t);
    await t.tap(find.byTooltip('Select accounts'));
    await t.pump();
    await t.tap(find.byTooltip('Select all'));
    await t.pump();
    await t.tap(find.byTooltip('Add a tag'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField).last, 'work');
    await t.tap(find.text('Add tag'));
    await t.pump();
    await flushIo(t, () => find.byTooltip('Select accounts').evaluate().isNotEmpty);
    expect(vault.accounts.map((a) => a.tags), [['work'], ['work']]);

    await t.tap(find.byTooltip('Select accounts'));
    await t.pump();
    await t.tap(find.text('Bravo'));
    await t.pump();
    await t.tap(find.byTooltip('Move to folder'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField).last, 'Games');
    await t.tap(find.text('Move to new folder'));
    await t.pump();
    await flushIo(t, () => vault.accounts[1].folder == 'Games');
    expect([vault.accounts[0].folder, vault.accounts[1].folder], [null, 'Games']);
    expect(find.text('Games'), findsWidgets);
    expect(find.text('No folder'), findsOneWidget);
    await finish(t);
  });

  testWidgets('folders: collapsible sections, and tags still filter inside them', (t) async {
    vault.accounts.addAll([
      acct('Alpha', 'JBSWY3DPEHPK3PXP', folder: 'Work', tags: ['main']),
      acct('Bravo', 'GEZDGNBVGY3TQOJQ', folder: 'Work'),
      acct('Charlie', 'MFRGGZDFMZTWQ2LK', tags: ['main']),
    ]);
    await pumpHome(t);
    expect(y(t, 'Work'), lessThan(y(t, 'Alpha')));
    expect(y(t, 'Bravo'), lessThan(y(t, 'No folder')));
    expect(y(t, 'No folder'), lessThan(y(t, 'Charlie')));

    await t.tap(find.text('Work'));
    await t.pump();
    await flushIo(t, () => find.text('Alpha').evaluate().isEmpty);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Bravo'), findsNothing);
    expect(vault.settings[collapsedFoldersKey], ['Work']);
    await t.tap(find.text('Work'));
    await t.pump();
    await flushIo(t, () => find.text('Alpha').evaluate().isNotEmpty);

    await t.tap(find.widgetWithText(ChoiceChip, 'main'));
    await t.pump();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Bravo'), findsNothing);
    expect(find.text('Charlie'), findsOneWidget);
    await finish(t);
  });

  testWidgets('folders: pressing and holding a card and dropping it under another folder moves it there', (t) async {
    vault.accounts.addAll([
      acct('Alpha', 'JBSWY3DPEHPK3PXP', folder: 'Work'),
      acct('Delta', 'ONSWG4TFOQYTEMZU', folder: 'Work'),
      acct('Bravo', 'GEZDGNBVGY3TQOJQ'),
      acct('Charlie', 'MFRGGZDFMZTWQ2LK'),
    ]);
    await pumpHome(t);
    final g = await t.startGesture(t.getCenter(find.text('Alpha')));
    await t.pump(const Duration(milliseconds: 700)); // press and hold
    await g.moveBy(Offset(0, y(t, 'Charlie') - y(t, 'Alpha') + 20), timeStamp: const Duration(milliseconds: 800));
    for (var i = 0; i < 10; i++) {
      await g.moveBy(const Offset(0, 5));
      await t.pump(const Duration(milliseconds: 50));
    }
    await g.up();
    await t.pumpAndSettle();
    await flushIo(t, () => vault.accounts.any((a) => a.issuer == 'Alpha' && a.folder == null));
    expect(vault.accounts.firstWhere((a) => a.issuer == 'Alpha').folder, isNull);
    expect(y(t, 'Work'), lessThan(y(t, 'Delta')));
    expect(y(t, 'Delta'), lessThan(y(t, 'No folder')));
    expect(y(t, 'No folder'), lessThan(y(t, 'Alpha')));
    await finish(t);
  });

  testWidgets('wide layout: folder titles above grids of cards', (t) async {
    vault.accounts.addAll([
      acct('Alpha', 'JBSWY3DPEHPK3PXP', folder: 'Work'),
      acct('Bravo', 'GEZDGNBVGY3TQOJQ'),
    ]);
    t.view.physicalSize = const Size(1200, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: HomeScreen(vault: vault)));
    await t.pump();
    expect(y(t, 'Work'), lessThan(y(t, 'Alpha')));
    expect(y(t, 'No folder'), lessThan(y(t, 'Bravo')));
    expect(find.text('Select'), findsOneWidget);
    expect(t.takeException(), isNull);
    await finish(t);
  });

  testWidgets('sort: A to Z, custom order, and the old "recently used" switch', (t) async {
    vault.accounts.addAll([acct('Charlie', 'JBSWY3DPEHPK3PXP'), acct('alpha', 'GEZDGNBVGY3TQOJQ'), acct('Bravo', 'MFRGGZDFMZTWQ2LK')]);
    vault.settings[sortKey] = 'name';
    await pumpHome(t);
    expect(y(t, 'alpha'), lessThan(y(t, 'Bravo')));
    expect(y(t, 'Bravo'), lessThan(y(t, 'Charlie')));
    expect(find.byType(ReorderableListView), findsNothing, reason: 'dragging only in Custom');
    await finish(t);

    vault.settings[sortKey] = 'custom';
    await pumpHome(t);
    expect(y(t, 'Charlie'), lessThan(y(t, 'alpha')));
    expect(find.byType(ReorderableListView), findsOneWidget);
    await finish(t);
  });

  testWidgets('Show QR code asks first, and hides itself after 30 seconds', (t) async {
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
    var asked = 0;
    var allow = false;
    confirmItsYouOverride = (_, _, _) async {
      asked++;
      return allow;
    };
    await pumpHome(t);
    Future<void> openQr() async {
      await t.tap(find.byTooltip('More'));
      await t.pumpAndSettle();
      await t.tap(find.text('Show QR code'));
      await t.pumpAndSettle();
    }

    await openQr();
    expect(asked, 1);
    expect(find.byType(AccountQrScreen), findsNothing, reason: 'refused: no QR');

    allow = true;
    await openQr();
    expect(find.byType(AccountQrScreen), findsOneWidget);
    expect(find.text('Hides in 30 seconds'), findsOneWidget);
    await t.pump(const Duration(seconds: 10));
    expect(find.text('Hides in 20 seconds'), findsOneWidget);
    await t.pump(const Duration(seconds: 20));
    await t.pumpAndSettle();
    expect(find.byType(AccountQrScreen), findsNothing);
    await finish(t);
  });

  testWidgets('HOTP: "Next code" moves the counter on and saves it', (t) async {
    vault.accounts.add(Account(id: 'h', issuer: 'Bank', secret: 'JBSWY3DPEHPK3PXP', type: OtpType.hotp, counter: 4));
    await pumpHome(t);
    final before = hotp(base32Decode('JBSWY3DPEHPK3PXP'), 4);
    expect(find.text(groupCode(before)), findsOneWidget);
    await t.tap(find.text('Next code'));
    await t.pump();
    await flushIo(t, () => vault.accounts.single.counter == 5 && vault.file.existsSync());
    expect(find.text(groupCode(hotp(base32Decode('JBSWY3DPEHPK3PXP'), 5))), findsOneWidget);
    final saved = Vault(vault.file, vault.keyStore);
    await t.runAsync(saved.load);
    expect(saved.accounts.single.counter, 5);
    await finish(t);
  });

  testWidgets('Advanced settings: live preview follows the choices; nothing changes until Save', (t) async {
    final a = Account(id: 'a', issuer: 'Steam', label: 'gamer', secret: 'MFRGGZDFMZTWQ2LK');
    t.view.physicalSize = const Size(420, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    late BuildContext ctx;
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    })));
    String preview() => (t.widget<Text>(find.byKey(const Key('previewCode')))).data!.replaceAll(' ', '');

    Future<bool> open() {
      final done = showAccountDialog(ctx, a, title: 'Edit account', confirm: 'Save', existing: true);
      return done;
    }

    var result = open();
    await t.pumpAndSettle();
    expect(preview(), matches(RegExp(r'^\d{6}$')));
    await t.tap(find.text('Advanced'));
    await t.pumpAndSettle();
    expect(find.textContaining('Only change these if the website told you to'), findsOneWidget);
    await t.tap(find.text('Time-based (normal)'));
    await t.pumpAndSettle();
    await t.tap(find.text('Steam Guard').last);
    await t.pumpAndSettle();
    expect(preview(), matches(RegExp('^[$steamAlphabet]{5}\$')));
    expect(find.text('Digits'), findsNothing, reason: 'Steam codes are always 5 characters');
    expect(a.type, OtpType.totp, reason: 'the real account is untouched until Save');
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    expect(await result, isFalse);
    expect(a.type, OtpType.totp);

    result = open();
    await t.pumpAndSettle();
    await t.tap(find.text('Advanced'));
    await t.pumpAndSettle();
    await t.tap(find.text('6'));
    await t.pumpAndSettle();
    await t.tap(find.text('8').last);
    await t.pumpAndSettle();
    expect(preview(), matches(RegExp(r'^\d{8}$')));
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
    expect(await result, isTrue);
    expect([a.type, a.digits], [OtpType.totp, 8]);
    expect(find.byKey(const Key('previewCode')), findsNothing, reason: 'dialog closed');
  });
}
