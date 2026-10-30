// Phase D: countdown styles, color/emoji per account, read aloud, the easy-to-read font, screen readers,
// and the wide layout. Every vault here lives in a temp folder; nothing touches the real one.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/core/widget_share.dart';
import 'package:tanooki_auth/ui/add.dart';
import 'package:tanooki_auth/ui/code_view.dart';
import 'package:tanooki_auth/ui/home.dart';
import 'package:tanooki_auth/ui/premium.dart';
import 'package:tanooki_auth/ui/quick_pick.dart';
import 'package:tanooki_auth/ui/security_ui.dart';
import 'package:tanooki_auth/ui/settings.dart';
import 'package:tanooki_auth/ui/theme.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;
  final spoken = <String>[];

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('phase_d');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 7)));
    vault.settings[lastBackupKey] = DateTime.now().toUtc().add(const Duration(minutes: 1)).toIso8601String();
    spoken.clear();
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (c) async => null);
    messenger.setMockMethodCallHandler(const MethodChannel('flutter_tts'), (c) async {
      if (c.method == 'speak') spoken.add(c.arguments as String);
      return 1;
    });
  });
  tearDown(() {
    confirmItsYouOverride = null;
    premium.value = false;
    easyFont.value = false;
    dir.deleteSync(recursive: true);
  });

  Account acct(String issuer, String secret, {String label = ''}) => Account(id: issuer, issuer: issuer, label: label, secret: secret);

  Future<void> pump(WidgetTester t, Widget screen, {Size size = const Size(420, 1400)}) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: screen));
    await t.pump();
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 31));
  }

  // Lets file writes (vault.save) finish, which fake time can't do on its own.
  Future<void> flushIo(WidgetTester t, bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await t.pump();
    }
  }

  group('spoken codes', () {
    test('screen readers hear the on-screen groups, one character at a time', () {
      expect(spokenCode('482139'), '4 8 2, 1 3 9');
      expect(spokenCode('12345678'), '1 2 3 4, 5 6 7 8');
      expect(spokenCode('PV9M4'), 'P V 9 M 4');
      expect(codeSemantics('482139', 12), 'Code 4 8 2, 1 3 9, 12 seconds left');
      expect(codeSemantics('482139', 1), 'Code 4 8 2, 1 3 9, 1 second left');
      expect(codeSemantics('482139', null), 'Code 4 8 2, 1 3 9');
    });

    test('read aloud goes in pairs, and spells Steam codes letter by letter', () {
      expect(readAloudText('482139'), '4 8, 2 1, 3 9');
      expect(readAloudText('1234567'), '1 2, 3 4, 5 6, 7');
      expect(readAloudText('PV9M4', letters: true), 'P, V, 9, M, 4');
    });
  });

  test('widgets and the watch get the color and emoji, only when set', () {
    vault.settings[shareCodesKey] = true;
    vault.accounts.addAll([
      Account(id: '1', issuer: 'Steam', secret: 'JBSWY3DPEHPK3PXP', favorite: true, color: 0xFF239E78, emoji: '🎮'),
      Account(id: '2', issuer: 'Plain', secret: 'JBSWY3DPEHPK3PXP', favorite: true, emoji: '  '),
    ]);
    final shared = sharedFavorites(vault);
    expect(shared.first['color'], 0xFF239E78);
    expect(shared.first['emoji'], '🎮');
    expect(shared.last.containsKey('color'), isFalse);
    expect(shared.last.containsKey('emoji'), isFalse, reason: 'blank emoji is not sent');
  });

  for (final style in ['ring', 'bar', 'number']) {
    testWidgets('countdown style "$style" shows on home cards and in Quick pick', (t) async {
      vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
      vault.settings[countdownKey] = style;
      final key = Key('countdown${style[0].toUpperCase()}${style.substring(1)}');
      await pump(t, HomeScreen(vault: vault));
      expect(find.byKey(key), findsOneWidget);
      await finish(t);
      await pump(t, QuickPickScreen(vault: vault));
      expect(find.byKey(key), findsOneWidget);
      await finish(t);
    });
  }

  testWidgets('Settings switches the countdown style and the easy-to-read font', (t) async {
    await pump(t, SettingsScreen(vault: vault), size: const Size(420, 4000));
    await t.tap(find.text('Bar'));
    await t.pump();
    expect(vault.settings[countdownKey], 'bar');
    expect(easyFont.value, isFalse);
    expect(buildTheme(darkPalette).textTheme.bodyMedium!.fontFamily, isNot(easyFontFamily));
    await t.tap(find.byKey(const Key('easyFontSwitch')));
    await t.pump();
    expect(easyFont.value, isTrue);
    expect(vault.settings[easyFontKey], isTrue);
    final theme = buildTheme(darkPalette);
    expect(theme.textTheme.bodyMedium!.fontFamily, easyFontFamily);
    expect(theme.appBarTheme.titleTextStyle!.fontFamily, easyFontFamily);
    await finish(t);
  });

  test('the font is bundled with its license', () {
    expect(File('assets/fonts/AtkinsonHyperlegible-Regular.ttf').existsSync(), isTrue);
    expect(File('assets/fonts/AtkinsonHyperlegible-Bold.ttf').existsSync(), isTrue);
    expect(File('assets/fonts/OFL.txt').readAsStringSync(), contains('SIL Open Font License'));
    expect(File('pubspec.yaml').readAsStringSync(), contains('family: AtkinsonHyperlegible'));
  });

  testWidgets('edit window: pick a color and an emoji; the avatar shows the emoji', (t) async {
    final a = acct('GitHub', 'JBSWY3DPEHPK3PXP');
    vault.accounts.add(a);
    await pump(t, HomeScreen(vault: vault), size: const Size(420, 2400));
    await t.tap(find.byTooltip('More'));
    await t.pumpAndSettle();
    await t.tap(find.text('Edit'));
    await t.pumpAndSettle();
    await t.ensureVisible(find.byKey(Key('color-${accountColors[6]}')));
    await t.tap(find.byKey(Key('color-${accountColors[6]}')));
    await t.tap(find.text('🎮'));
    await t.pump();
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
    expect(a.color, accountColors[6]);
    expect(a.emoji, '🎮');
    await flushIo(t, () => find.descendant(of: find.byType(CircleAvatar), matching: find.text('🎮')).evaluate().isNotEmpty);
    expect(find.descendant(of: find.byType(CircleAvatar), matching: find.text('🎮')), findsOneWidget);

    // Typing more than one emoji keeps just the first; "No color" clears the color.
    await t.tap(find.byTooltip('More'));
    await t.pumpAndSettle();
    await t.tap(find.text('Edit'));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('emojiField')), '🏦🏠 bank');
    await t.ensureVisible(find.byKey(const Key('color-none')));
    await t.tap(find.byKey(const Key('color-none')));
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
    expect(a.emoji, '🏦');
    expect(a.color, isNull);
    await finish(t);
  });

  testWidgets('Linux has no text-to-speech, so no speaker buttons there', (t) async {
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP'));
    await pump(t, HomeScreen(vault: vault));
    expect(find.byTooltip('Read code aloud'), Platform.isLinux ? findsNothing : findsOneWidget);
    await finish(t);
  });

  testWidgets('read aloud speaks in pairs; an "ask first" account says nothing until confirmed', skip: Platform.isLinux, (t) async {
    final plain = acct('GitHub', 'JBSWY3DPEHPK3PXP');
    final guarded = acct('Bank', 'GEZDGNBVGY3TQOJQ')..requireAuth = true;
    vault.accounts.addAll([plain, guarded]);
    var allow = false, asked = 0;
    confirmItsYouOverride = (_, _, _) async {
      asked++;
      return allow;
    };
    await pump(t, HomeScreen(vault: vault));
    final speakers = find.byTooltip('Read code aloud');
    expect(speakers, findsNWidgets(2));

    await t.tap(speakers.first);
    await t.pump();
    expect(spoken, [readAloudText(plain.codeAt(DateTime.now()))]);
    expect(asked, 0);

    spoken.clear();
    await t.tap(speakers.last);
    await t.pump();
    expect(asked, 1);
    expect(spoken, isEmpty, reason: 'refused: nothing read');

    allow = true;
    await t.tap(speakers.last);
    await t.pump();
    expect(asked, 2);
    expect(spoken, [readAloudText(guarded.codeAt(DateTime.now()))]);
    await finish(t);
  });

  testWidgets('a card is one screen-reader item: name, code groups, time left, and its actions', (t) async {
    final handle = t.ensureSemantics();
    vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP', label: 'me@example.com'));
    await pump(t, HomeScreen(vault: vault));
    final code = vault.accounts.single.codeAt(DateTime.now());
    final node = t.getSemantics(find.byType(AccountCard));
    expect(node.label, startsWith('GitHub. me@example.com. Code ${spokenCode(code)}, '));
    expect(node.label, contains('seconds left'));
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    final actions = node.getSemanticsData().customSemanticsActionIds!.map((id) => CustomSemanticsAction.getAction(id)!.label);
    expect(actions, containsAll([if (!Platform.isLinux) 'Read code aloud', 'More options']));
    expect(node.mergeAllDescendantsIntoThisNode || node.childrenCount == 0, isTrue, reason: 'no separate inner nodes');
    await finish(t);
    handle.dispose();
  });

  group('wide layout', () {
    testWidgets('900 px and up: list on the left, details on the right that follow the selection', (t) async {
      final a = acct('Alpha', 'JBSWY3DPEHPK3PXP')..notes = 'Work laptop only';
      a.tags.add('work');
      a.recoveryCodes.addAll(RecoveryCode.parseList('aaaa-1111\nbbbb-2222'));
      vault.accounts.addAll([a, acct('Bravo', 'GEZDGNBVGY3TQOJQ')]);
      await pump(t, HomeScreen(vault: vault), size: const Size(1200, 900));
      expect(t.takeException(), isNull);
      final pane = find.byKey(const Key('detailsPane'));
      expect(pane, findsOneWidget);
      expect(find.descendant(of: pane, matching: find.text('Alpha')), findsOneWidget);
      expect(find.descendant(of: pane, matching: find.text('Work laptop only')), findsOneWidget);
      expect(find.descendant(of: pane, matching: find.text('Recovery codes (2 left)')), findsOneWidget);
      if (!Platform.isLinux) expect(find.descendant(of: pane, matching: find.text('Read aloud')), findsOneWidget);
      expect(find.descendant(of: pane, matching: find.text('Show QR code')), findsOneWidget);
      expect(find.descendant(of: pane, matching: find.text(groupCode(a.codeAt(DateTime.now())))), findsOneWidget);

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(find.descendant(of: pane, matching: find.text('Bravo')), findsOneWidget);
      if (!Platform.isLinux) {
        await t.tap(find.descendant(of: pane, matching: find.text('Read aloud')));
        await t.pump();
        expect(spoken, hasLength(1));
      }
      await finish(t);
    });

    testWidgets('an "ask first" account keeps its code and notes hidden in the details pane', (t) async {
      vault.accounts.add(acct('Bank', 'JBSWY3DPEHPK3PXP')
        ..requireAuth = true
        ..notes = 'PIN hint');
      await pump(t, HomeScreen(vault: vault), size: const Size(1200, 900));
      final pane = find.byKey(const Key('detailsPane'));
      expect(find.descendant(of: pane, matching: find.text('••• •••')), findsOneWidget);
      expect(find.descendant(of: pane, matching: find.text('PIN hint')), findsNothing);
      await finish(t);
    });

    testWidgets('narrow screens keep the single list with no details pane', (t) async {
      vault.accounts.add(acct('Alpha', 'JBSWY3DPEHPK3PXP'));
      await pump(t, HomeScreen(vault: vault), size: const Size(420, 900));
      expect(find.byKey(const Key('detailsPane')), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      await finish(t);
    });
  });

  group('accessibility guidelines', () {
    Future<void> check(WidgetTester t) async {
      await expectLater(t, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(t, meetsGuideline(androidTapTargetGuideline));
      await expectLater(t, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(t, meetsGuideline(textContrastGuideline));
    }

    void seed() => vault.accounts.addAll([
          acct('GitHub', 'JBSWY3DPEHPK3PXP', label: 'me@example.com')..favorite = true,
          acct('Steam', 'GEZDGNBVGY3TQOJQ')..type = OtpType.steam,
          acct('Bank', 'MFRGGZDFMZTWQ2LK')..requireAuth = true,
          acct('Counter', 'JBSWY3DPEHPK3PXP')..type = OtpType.hotp,
        ]);

    for (final theme in ['dark', 'light']) {
      testWidgets('home ($theme, phone and wide)', (t) async {
        final handle = t.ensureSemantics();
        seed();
        for (final size in [const Size(420, 1400), const Size(1200, 1000)]) {
          t.view.physicalSize = size;
          t.view.devicePixelRatio = 1;
          await t.pumpWidget(MaterialApp(theme: buildTheme(theme == 'dark' ? darkPalette : lightPalette), home: HomeScreen(vault: vault)));
          await t.pump();
          await check(t);
        }
        t.view.reset();
        await finish(t);
        handle.dispose();
      });
    }

    testWidgets('add', (t) async {
      final handle = t.ensureSemantics();
      await pump(t, AddScreen(vault: vault));
      await check(t);
      await finish(t);
      handle.dispose();
    });

    testWidgets('edit', (t) async {
      final handle = t.ensureSemantics();
      final a = acct('GitHub', 'JBSWY3DPEHPK3PXP');
      await pump(t, Builder(builder: (c) => Scaffold(body: Center(child: TextButton(onPressed: () => showAccountDialog(c, a, title: 'Edit account', confirm: 'Save'), child: const Text('Open'))))),
          size: const Size(420, 2400));
      await t.tap(find.text('Open'));
      await t.pumpAndSettle();
      await check(t);
      await finish(t);
      handle.dispose();
    });

    testWidgets('settings', (t) async {
      final handle = t.ensureSemantics();
      await pump(t, SettingsScreen(vault: vault), size: const Size(420, 1400));
      await check(t);
      await finish(t);
      handle.dispose();
    });

    testWidgets('quick pick', (t) async {
      final handle = t.ensureSemantics();
      seed();
      await pump(t, QuickPickScreen(vault: vault));
      await check(t);
      await finish(t);
      handle.dispose();
    });
  });
}
