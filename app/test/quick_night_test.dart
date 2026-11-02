// Items 5, 7, 8, 14, 19, 49 and 50: shared QR pictures, desktop keyboard, menu bar countdown, accounts you never
// use, paper backup in two halves, health check, and the keyboard shortcuts list. Every vault here is a temp file.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/backup.dart';
import 'package:tanooki_auth/core/clock_check.dart';
import 'package:tanooki_auth/core/health.dart';
import 'package:tanooki_auth/core/paper_backup.dart';
import 'package:tanooki_auth/core/paper_halves.dart';
import 'package:tanooki_auth/core/phone_link.dart' show phoneLinksKey;
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/unused.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/add.dart';
import 'package:tanooki_auth/ui/health_ui.dart';
import 'package:tanooki_auth/ui/home.dart';
import 'package:tanooki_auth/ui/keys.dart';
import 'package:tanooki_auth/ui/paper_halves_ui.dart';
import 'package:tanooki_auth/ui/quick_pick.dart';
import 'package:tanooki_auth/ui/security_ui.dart';
import 'package:tanooki_auth/ui/settings.dart';
import 'package:tanooki_auth/ui/theme.dart';
import 'package:tanooki_auth/ui/tray_countdown.dart';
import 'package:tanooki_auth/ui/unused_ui.dart';

import 'qr_image_test.dart' show renderQr;
import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;
  final clipboard = <String>[];

  setUpAll(() => initializeDateFormatting()); // the app gets this from its localization delegates

  setUp(() {
    dir = Directory.systemTemp.createTempSync('quick_night');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 9)));
    vault.settings[lastBackupKey] = DateTime.now().toUtc().toIso8601String(); // keeps the backup card away
    clipboard.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (c) async {
      if (c.method == 'Clipboard.setData') clipboard.add((c.arguments as Map)['text'] as String);
      return null;
    });
  });
  tearDown(() {
    ClockCheck.instance.checkedAt = null;
    ClockCheck.instance.warning.value = null;
    dir.deleteSync(recursive: true);
  });

  Account acct(String issuer, String secret, {DateTime? created, DateTime? used, bool fav = false}) =>
      Account(id: issuer, issuer: issuer, label: '', secret: secret, createdAt: created, favorite: fav)..lastUsedAt = used;

  Future<void> pump(WidgetTester t, Widget screen, {Size size = const Size(420, 1200)}) async {
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

  Future<void> flushIo(WidgetTester t, bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await t.pump();
    }
  }

  // ---------------------------------------------------------------- 14. accounts you never use

  group('accounts you never use', () {
    final now = DateTime(2026, 11, 2, 12);
    test('6 months or more since the last copy, or since it was added if never used', () {
      final list = [
        acct('UsedLongAgo', 'A', created: DateTime(2025, 1, 1), used: DateTime(2026, 4, 1)),
        acct('UsedRecently', 'B', created: DateTime(2025, 1, 1), used: DateTime(2026, 9, 1)),
        acct('NeverOld', 'C', created: DateTime(2025, 3, 1)),
        acct('NeverNew', 'D', created: DateTime(2026, 10, 25)),
        acct('JustOver', 'E', created: DateTime(2025, 1, 1), used: DateTime(2026, 5, 1, 12)),
        acct('JustUnder', 'F', created: DateTime(2025, 1, 1), used: DateTime(2026, 5, 3)),
        acct('Trashed', 'G', created: DateTime(2020, 1, 1))..deletedAt = DateTime(2026, 11, 1),
      ];
      expect(unusedAccounts(list, now).map((a) => a.issuer), ['NeverOld', 'UsedLongAgo', 'JustOver']);
    });

    testWidgets('tick, then move to Trash (with undo) or tag', (t) async {
      final old = DateTime.now().subtract(const Duration(days: 400));
      vault.accounts.addAll([acct('Old1', 'JBSWY3DPEHPK3PXP', created: old), acct('Old2', 'GEZDGNBVGY3TQOJQ', created: old), acct('Fresh', 'MZXW6YTBOI======')]);
      await pump(t, UnusedAccountsScreen(vault: vault));
      expect(find.text('Old1'), findsOneWidget);
      expect(find.text('Fresh'), findsNothing);
      await t.tap(find.byKey(const Key('unusedTrash')));
      await t.pump();
      expect(find.text('Tick one or more accounts first.'), findsOneWidget); // nothing ticked: says why

      await t.tap(find.text('Old1'));
      await t.pump();
      await t.tap(find.byKey(const Key('unusedTrash')));
      await flushIo(t, () => find.text('Old1').evaluate().isEmpty);
      expect(vault.accounts.first.trashed, isTrue);
      expect(vault.accounts[1].trashed, isFalse);
      expect(find.text('Old1'), findsNothing);

      await t.tap(find.text('Select all'));
      await t.pump();
      await t.tap(find.text('Add a tag'));
      await t.pump();
      await t.tap(find.text('Add tag'));
      await flushIo(t, () => find.textContaining('unused').evaluate().length > 1);
      expect(vault.accounts[1].tags, ['unused']);
      await finish(t);
    });

    testWidgets('the security check-up links to it when there are some', (t) async {
      vault.accounts.add(acct('Old1', 'JBSWY3DPEHPK3PXP', created: DateTime.now().subtract(const Duration(days: 400))));
      await pump(t, CheckupScreen(vault: vault));
      expect(find.text('1 account you never use'), findsOneWidget);
      await t.tap(find.text('Review them'));
      await t.pumpAndSettle();
      expect(find.byType(UnusedAccountsScreen), findsOneWidget);
      await finish(t);
    });
  });

  // ---------------------------------------------------------------- 19. paper backup in two halves

  group('paper backup in two halves', () {
    test('XOR split and join round trip; halves are the same length', () {
      final data = utf8.encode('the quick brown fox ' * 50);
      final (a, b) = xorSplit(data);
      expect(a.length, data.length);
      expect(xorJoin(a, b), data);
      expect(() => xorJoin(a, b.sublist(1)), throwsFormatException);
    });

    test('one half alone looks uniform and leaks nothing of the backup', () {
      // The worst case for leaking: a very repetitive input.
      final data = List.filled(256 * 400, 0x41);
      final (a, b) = xorSplit(data, random: Random(1));
      for (final half in [a, b]) {
        final counts = List.filled(256, 0);
        for (final x in half) {
          counts[x]++;
        }
        const expected = 400.0;
        final chi = counts.fold(0.0, (s, c) => s + (c - expected) * (c - expected) / expected);
        expect(chi, lessThan(340), reason: 'chi-square with 255 degrees of freedom, 99.9th percentile is about 330'); // uniform
        final same = [for (var i = 0; i < data.length; i++) if (half[i] == data[i]) 1].length;
        expect(same / data.length, closeTo(1 / 256, 0.002)); // no more matches with the input than chance
      }
      // Half A never depends on the backup at all: the same randomness gives the same half A for any input.
      final (a2, _) = xorSplit(List.filled(data.length, 0x00), random: Random(1));
      expect(a2, a);
    });

    test('a real backup goes through the codes, in any order, and opens with its passphrase', () async {
      final accounts = [for (var i = 0; i < 25; i++) Account(id: 'id$i', issuer: 'Site $i', label: 'me$i@example.com', secret: 'JBSWY3DPEHPK3PXP')];
      final text = await exportBackup(accounts, 'correct horse battery', iterations: 1000);
      final halves = splitBackupText(text);
      expect(halves.a.length, greaterThan(1));
      expect(halves.a.length, halves.b.length);
      for (final code in [...halves.a, ...halves.b]) {
        expect(code.startsWith(halfPrefix), isTrue);
        expect(code.length, lessThan(900)); // small enough to print and scan
      }
      final c = HalfCollector();
      final all = [...halves.a, ...halves.b]..shuffle(Random(4));
      for (final code in all) {
        expect(c.add(code), isNull);
        if (code != all.last) expect(c.complete, isFalse);
      }
      expect(c.add(all.first), HalfProblem.duplicate);
      expect(c.add('otpauth://totp/x?secret=AAAA'), HalfProblem.notAHalf);
      expect(c.add(splitBackupText(text).a.first), HalfProblem.otherSet); // another printout
      expect(c.complete, isTrue);
      expect(c.join(), text);
      final back = await importBackup(c.join(), 'correct horse battery');
      expect(back.map((a) => a.issuer), accounts.map((a) => a.issuer));
    });

    test('halves from two different printouts do not fit together', () {
      final one = splitBackupText('backup one', setId: 'SAMEID01');
      final two = splitBackupText('backup two', setId: 'SAMEID01');
      final c = HalfCollector();
      for (final code in [...one.a, ...two.b]) {
        expect(c.add(code), isNull);
      }
      expect(c.join, throwsFormatException);
    });

    test('each half is its own PDF labeled "Half A of 2" / "Half B of 2"', () async {
      final halves = splitBackupText('x' * 3000);
      final a = await buildHalfPaper('A', halves.a, compress: false);
      final b = await buildHalfPaper('B', halves.b, compress: false);
      expect(latin1.decode(a.sublist(0, 4)), '%PDF');
      expect(latin1.decode(a), contains('Half A of 2'));
      expect(latin1.decode(b), contains('Half B of 2'));
      expect(latin1.decode(a), isNot(contains('Half B of 2')));
    });

    testWidgets('restore screen: progress per half, then the restore button', (t) async {
      final text = await t.runAsync(() => exportBackup([Account(id: 'x', issuer: 'GitHub', label: '', secret: 'JBSWY3DPEHPK3PXP')], 'passphrase1', iterations: 1000));
      final halves = splitBackupText(text!);
      final c = HalfCollector();
      for (final code in halves.a) {
        c.add(code);
      }
      await pump(t, HalvesRestoreScreen(vault: vault, collector: c));
      expect(find.text('Half A of 2: ${halves.a.length} of ${halves.a.length} codes'), findsOneWidget);
      expect(find.text('Half B of 2: no codes scanned yet'), findsOneWidget);
      expect(find.byKey(const Key('halvesRestore')), findsNothing);
      for (final code in halves.b) {
        c.add(code);
      }
      await pump(t, HalvesRestoreScreen(vault: vault, collector: c));
      expect(find.byKey(const Key('halvesRestore')), findsOneWidget);
      await finish(t);
    });
  });

  // ---------------------------------------------------------------- 49. health check

  group('health check', () {
    final now = DateTime.utc(2026, 11, 2, 12);
    HealthItem item(List<HealthItem> all, HealthKind k) => all.firstWhere((h) => h.kind == k);

    test('a fresh vault: everything worth a look except recovery codes (no accounts)', () {
      vault.settings.remove(lastBackupKey);
      final h = healthCheck(vault, now, phone: true);
      expect(h.map((x) => x.kind), HealthKind.values);
      expect(item(h, HealthKind.sync).ok, isFalse);
      expect(item(h, HealthKind.sync).set, isFalse);
      expect(item(h, HealthKind.backup).set, isFalse);
      expect(item(h, HealthKind.clock).set, isFalse);
      expect(item(h, HealthKind.phoneLink).ok, isFalse);
      expect(item(h, HealthKind.lock).ok, isFalse);
      expect(item(h, HealthKind.recoveryCodes).ok, isTrue);
      expect(healthCheck(vault, now, phone: false).any((x) => x.kind == HealthKind.phoneLink), isFalse);
    });

    test('all green, then each one going stale', () {
      vault.settings
        ..[Vault.syncKey] = {'lastSync': now.subtract(const Duration(hours: 2)).toIso8601String()}
        ..[lastBackupKey] = now.subtract(const Duration(days: 3)).toIso8601String()
        ..[phoneLinksKey] = [{'room': 'r'}]
        ..[lockKey] = true;
      vault.accounts.add(acct('A', 'JBSWY3DPEHPK3PXP')..recoveryCodes.add(RecoveryCode('1234')));
      var h = healthCheck(vault, now, phone: true, clockCheckedAt: now);
      expect(h.every((x) => x.ok), isTrue, reason: h.where((x) => !x.ok).map((x) => x.kind).join(','));
      expect(item(h, HealthKind.recoveryCodes).count, 1);

      vault.settings
        ..[Vault.syncKey] = {'lastSync': now.subtract(const Duration(days: 5)).toIso8601String()}
        ..[lastBackupKey] = now.subtract(const Duration(days: 40)).toIso8601String();
      vault.accounts.add(acct('B', 'GEZDGNBVGY3TQOJQ'));
      h = healthCheck(vault, now, phone: true, clockCheckedAt: now, clockWarning: 'Your clock is 3 minutes off');
      expect(item(h, HealthKind.sync).ok, isFalse);
      expect(item(h, HealthKind.sync).set, isTrue);
      expect(item(h, HealthKind.backup).ok, isFalse);
      expect(item(h, HealthKind.clock).ok, isFalse);
      expect(item(h, HealthKind.recoveryCodes).ok, isFalse);
      expect((item(h, HealthKind.recoveryCodes).count, item(h, HealthKind.recoveryCodes).total), (1, 2));
    });

    testWidgets('the screen shows every row with its button, and opens from Settings', (t) async {
      vault.accounts.add(acct('A', 'JBSWY3DPEHPK3PXP'));
      await pump(t, SettingsScreen(vault: vault), size: const Size(420, 6000));
      await t.tap(find.byKey(const Key('healthCheck')));
      await t.pumpAndSettle();
      expect(find.byType(HealthScreen), findsOneWidget);
      for (final k in [HealthKind.sync, HealthKind.backup, HealthKind.clock, HealthKind.lock, HealthKind.recoveryCodes]) {
        expect(find.byKey(ValueKey('health-${k.name}')), findsOneWidget);
      }
      expect(find.text('Not set up. Sync keeps your accounts the same on all your devices.'), findsOneWidget);
      expect(find.text('0 of 1 accounts have recovery codes saved.'), findsOneWidget);
      expect(find.text('Check now'), findsOneWidget);
      expect(find.text('Add codes'), findsOneWidget);
      await finish(t);
    });
  });

  // ---------------------------------------------------------------- 8. menu bar countdown

  group('menu bar countdown', () {
    test('off by default; on, it shows the first time-based favorite\'s seconds and never the code', () {
      final a = acct('GitHub', 'JBSWY3DPEHPK3PXP', fav: true);
      vault.accounts.addAll([acct('Plain', 'GEZDGNBVGY3TQOJQ'), a]);
      final at = DateTime.fromMillisecondsSinceEpoch(1699999993 * 1000); // 13 s into a 30 s step
      expect(trayCountdown(vault, at), isNull);
      vault.settings[trayCountdownKey] = true;
      final c = trayCountdown(vault, at)!;
      expect(c.title, '17');
      expect(c.tooltip, 'Tanooki Auth: GitHub, 17 s left');
      expect(c.tooltip.contains(a.codeAt(at)), isFalse);
      a.favorite = false;
      expect(trayCountdown(vault, at), isNull); // no favorite: just the icon
      a
        ..favorite = true
        ..type = OtpType.hotp;
      expect(trayCountdown(vault, at), isNull); // counter codes have no countdown
    });

    testWidgets('the home list sends it to the menu bar each second, and clears it when it closes', (t) async {
      final sent = <Object?>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(const MethodChannel('tanooki/window'), (c) async {
        if (c.method == 'setTrayCountdown') sent.add(c.arguments);
        return null;
      });
      addTearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(const MethodChannel('tanooki/window'), null));
      vault.settings[trayCountdownKey] = true;
      vault.accounts.add(acct('GitHub', 'JBSWY3DPEHPK3PXP', fav: true));
      await pump(t, HomeScreen(vault: vault));
      await t.pump(const Duration(seconds: 2));
      await finish(t);
      if (!trayCountdownSupported) return expect(sent, isEmpty); // Linux: no menu bar or tray
      expect(sent.first, isA<Map<Object?, Object?>>());
      expect(sent.last, isNull);
    });
  });

  // ---------------------------------------------------------------- 7 and 50. keyboard

  group('keyboard', () {
    testWidgets('home: arrows move, Enter copies, typing searches, Esc clears', (t) async {
      final a = acct('Alpha', 'JBSWY3DPEHPK3PXP'), b = acct('Bravo', 'GEZDGNBVGY3TQOJQ'), g = acct('Golf', 'MZXW6YTBOI======');
      vault.accounts.addAll([a, b, g, acct('Hotel', 'JBSWY3DPEHPK3PXQ')]);
      await pump(t, HomeScreen(vault: vault), size: const Size(1200, 900));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(clipboard.last, b.codeAt(DateTime.now()));

      await t.sendKeyEvent(LogicalKeyboardKey.keyG);
      await t.pump();
      expect(find.widgetWithText(TextField, 'g'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
      await t.sendKeyEvent(LogicalKeyboardKey.enter); // the only match
      await t.pump();
      expect(clipboard.last, g.codeAt(DateTime.now()));

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();
      expect(find.widgetWithText(TextField, 'g'), findsNothing);
      expect(find.text('Alpha'), findsWidgets);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp); // back on the list, keys still work
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(clipboard.last, a.codeAt(DateTime.now()));
      await finish(t);
    });

    testWidgets('Quick pick: arrows move the highlight, Enter copies it, Esc clears the search', (t) async {
      final a = acct('Alpha', 'JBSWY3DPEHPK3PXP')..lastUsedAt = DateTime.now();
      final b = acct('Bravo', 'GEZDGNBVGY3TQOJQ');
      vault.accounts.addAll([a, b]);
      await pump(t, QuickPickScreen(vault: vault));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(clipboard.last, b.codeAt(DateTime.now()));
      await t.enterText(find.byType(TextField), 'alp');
      await t.pump();
      expect(find.text('Bravo'), findsNothing);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();
      expect(find.text('Bravo'), findsOneWidget);
      await finish(t);
    });

    testWidgets('⌘/ (Ctrl+/ off the Mac) opens the shortcuts list, also from Settings > Help', (t) async {
      t.view.physicalSize = const Size(420, 6000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final nav = GlobalKey<NavigatorState>();
      await t.pumpWidget(MaterialApp(
        navigatorKey: nav,
        theme: buildTheme(darkPalette),
        builder: (c, child) => CallbackShortcuts(
            bindings: shortcutsSheetBindings(() => showShortcutsSheet(nav.currentState!.overlay!.context)), child: child!),
        home: SettingsScreen(vault: vault),
      ));
      await t.pump();
      final mod = Platform.isMacOS ? LogicalKeyboardKey.metaLeft : LogicalKeyboardKey.controlLeft;
      await t.sendKeyDownEvent(mod);
      await t.sendKeyEvent(LogicalKeyboardKey.slash);
      await t.sendKeyUpEvent(mod);
      await t.pumpAndSettle();
      expect(find.text('Keyboard shortcuts'), findsWidgets);
      expect(find.text('Copy the highlighted code'), findsOneWidget);
      Navigator.of(nav.currentContext!).pop();
      await t.pumpAndSettle();
      expect(find.text('Copy the highlighted code'), findsNothing);
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        await t.scrollUntilVisible(find.byKey(const Key('keyboardShortcuts')), 300,
            scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
        await t.ensureVisible(find.byKey(const Key('keyboardShortcuts')));
        await t.pumpAndSettle();
        await t.tap(find.byKey(const Key('keyboardShortcuts')));
        await t.pumpAndSettle();
        expect(find.text('Copy the highlighted code'), findsOneWidget);
      }
      await finish(t);
    });
  });

  // ---------------------------------------------------------------- 5. shared QR pictures

  testWidgets('a shared picture: decoded, the copy deleted, and nothing added until confirmed', (t) async {
    const uri = 'otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP&issuer=GitHub';
    final file = File('${dir.path}/shared-image')..writeAsBytesSync(img.encodePng(renderQr(uri)));
    await pump(t, AddScreen(vault: vault, sharedImage: file.path));
    await flushIo(t, () => find.byType(AlertDialog).evaluate().isNotEmpty);
    expect(file.existsSync(), isFalse);
    expect(vault.accounts, isEmpty);
    expect(find.text('GitHub'), findsWidgets);
    await t.tap(find.widgetWithText(FilledButton, 'Add'));
    await flushIo(t, () => vault.accounts.isNotEmpty);
    expect(vault.accounts.single.secret, 'JBSWY3DPEHPK3PXP');
    await finish(t);
  });

  testWidgets('a shared picture with no QR code says so and adds nothing', (t) async {
    final file = File('${dir.path}/shared-image')..writeAsBytesSync(img.encodePng(img.Image(width: 60, height: 60)));
    await pump(t, AddScreen(vault: vault, sharedImage: file.path));
    await flushIo(t, () => find.byType(SnackBar).evaluate().isNotEmpty);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(file.existsSync(), isFalse);
    expect(vault.accounts, isEmpty);
    await finish(t);
  });
}
