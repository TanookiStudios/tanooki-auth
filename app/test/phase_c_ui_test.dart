// Phase C on screen: ask-first accounts on the home list and in Quick pick, travel mode on the list and in
// Settings, the account window's two new switches, and the backup reminder card.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/clock_check.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/add.dart';
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
  final clipboard = <String>[];

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('phase_c_ui');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 5)));
    // Backed up just now, so the reminder card stays out of the way unless a test wants it.
    vault.settings[lastBackupKey] = DateTime.now().toUtc().add(const Duration(minutes: 1)).toIso8601String();
    clipboard.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (c) async {
      if (c.method == 'Clipboard.setData') clipboard.add((c.arguments as Map)['text'] as String);
      return null;
    });
  });
  tearDown(() {
    confirmItsYouOverride = null;
    premium.value = false;
    ClockCheck.instance.warning.value = null;
    dir.deleteSync(recursive: true);
  });

  Account acct(String issuer, String secret) => Account(id: issuer, issuer: issuer, label: '', secret: secret);

  Future<void> pump(WidgetTester t, Widget screen) async {
    t.view.physicalSize = const Size(420, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: screen));
    await t.pump();
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 31));
  }

  testWidgets('home: an ask-first account shows dots, and copying asks first', (t) async {
    final bank = acct('Bank', 'JBSWY3DPEHPK3PXP')..requireAuth = true;
    vault.accounts.addAll([bank, acct('Game', 'GEZDGNBVGY3TQOJQ')]);
    var allow = false, asked = 0;
    confirmItsYouOverride = (_, _, reason) async {
      asked++;
      expect(reason, 'Copy the code for Bank');
      return allow;
    };
    await pump(t, HomeScreen(vault: vault));
    final code = groupCode(bank.codeAt(DateTime.now()));
    expect(find.text(code), findsNothing, reason: 'hidden until Face ID');
    expect(find.text('••• •••'), findsOneWidget);
    expect(find.text(groupCode(vault.accounts[1].codeAt(DateTime.now()))), findsOneWidget, reason: 'ordinary accounts unchanged');

    await t.tap(find.text('Bank'));
    await t.pump();
    expect(asked, 1);
    expect(clipboard, isEmpty, reason: 'refused: nothing copied');

    allow = true;
    await t.tap(find.text('Bank'));
    await t.pump();
    expect(asked, 2);
    expect(clipboard, [bank.codeAt(DateTime.now())]);
    expect(find.text(groupCode(bank.codeAt(DateTime.now()))), findsOneWidget, reason: 'shown for a while after Face ID');
    await finish(t);
  });

  testWidgets('home: travel mode takes hidden accounts off the list, the count and search', (t) async {
    vault.accounts.addAll([acct('Bank', 'JBSWY3DPEHPK3PXP')..travelHidden = true, acct('Game', 'GEZDGNBVGY3TQOJQ')]);
    for (var i = 0; i < 3; i++) {
      vault.accounts.add(acct('Other$i', 'MFRGGZDFMZTWQ2LK'));
    }
    vault.settings[Vault.travelModeKey] = true;
    await pump(t, HomeScreen(vault: vault));
    expect(find.text('Bank'), findsNothing);
    expect(find.text('Game'), findsOneWidget);
    expect(find.text('4'), findsOneWidget, reason: 'the count badge leaves it out too');
    await t.enterText(find.byType(TextField), 'bank');
    await t.pump();
    expect(find.text('No accounts match your search.'), findsOneWidget);
    await finish(t);
  });

  testWidgets('Quick pick: never shows an ask-first code, asks before copying, hides travel accounts', (t) async {
    final bank = acct('Bank', 'JBSWY3DPEHPK3PXP')..requireAuth = true;
    vault.accounts.addAll([bank, acct('Trip', 'GEZDGNBVGY3TQOJQ')..travelHidden = true, acct('Game', 'MFRGGZDFMZTWQ2LK')]);
    vault.settings[Vault.travelModeKey] = true;
    var asked = 0;
    confirmItsYouOverride = (_, _, _) async {
      asked++;
      return false;
    };
    await pump(t, QuickPickScreen(vault: vault));
    expect(find.text('Trip'), findsNothing);
    expect(find.text(groupCode(bank.codeAt(DateTime.now()))), findsNothing);
    expect(find.text('••• •••  (asks first)'), findsOneWidget);
    await t.tap(find.text('Bank'));
    await t.pump();
    expect(asked, 1);
    expect(clipboard, isEmpty);
    await finish(t);
  });

  testWidgets('account window: the ask-first switch saves; travel hiding is Premium and says so', (t) async {
    final a = acct('Bank', 'JBSWY3DPEHPK3PXP');
    late Future<bool> result;
    await pump(t, Builder(builder: (c) => TextButton(onPressed: () => result = showAccountDialog(c, a, title: 'Edit', confirm: 'Save'), child: const Text('go'))));
    await t.tap(find.text('go'));
    await t.pumpAndSettle();
    await t.ensureVisible(find.byKey(const Key('travelHiddenSwitch')));
    await t.tap(find.byKey(const Key('requireAuthSwitch')));
    await t.tap(find.byKey(const Key('travelHiddenSwitch')));
    await t.pump();
    expect(find.textContaining('Travel mode is part of Premium'), findsOneWidget);
    premium.value = true;
    await t.tap(find.byKey(const Key('travelHiddenSwitch')));
    await t.pump();
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
    expect(await result, isTrue);
    expect((a.requireAuth, a.travelHidden), (true, true));
    await finish(t);
  });

  testWidgets('Settings: turning travel mode off asks first; refusing keeps it on', (t) async {
    premium.value = true;
    vault.settings[Vault.travelModeKey] = true;
    await t.runAsync(vault.save);
    var allow = false, asked = 0;
    confirmItsYouOverride = (_, _, reason) async {
      asked++;
      expect(reason, 'Turn off travel mode');
      return allow;
    };
    WidgetController.hitTestWarningShouldBeFatal = true;
    addTearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);
    await pump(t, SettingsScreen(vault: vault));
    final sw = find.byKey(const Key('travelModeSwitch'));
    await t.scrollUntilVisible(sw, 200, scrollable: find.byType(Scrollable).first);
    await t.ensureVisible(sw);
    await t.pump();
    await t.tap(sw);
    await t.pump();
    expect(asked, 1);
    expect(vault.travelMode, isTrue, reason: 'refused');
    allow = true;
    await t.tap(sw);
    await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await t.pump();
    expect(asked, 2);
    expect(vault.travelMode, isFalse);
    await finish(t);
  });

  testWidgets('home: the backup reminder shows after changes and "Not now" puts it off', (t) async {
    vault.settings.remove(lastBackupKey);
    vault.accounts.add(acct('Game', 'GEZDGNBVGY3TQOJQ'));
    await pump(t, HomeScreen(vault: vault));
    expect(find.byKey(const Key('backupNudge')), findsOneWidget);
    await t.tap(find.text('Not now'));
    await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await t.pump();
    expect(find.byKey(const Key('backupNudge')), findsNothing);
    expect(showBackupNudge(vault, DateTime.now().add(const Duration(days: 8))), isTrue);
    await finish(t);
  });

  testWidgets('home: a wrong clock shows the plain warning', (t) async {
    vault.accounts.add(acct('Game', 'GEZDGNBVGY3TQOJQ'));
    ClockCheck.instance.warning.value = clockProblem(const Duration(minutes: 4));
    await pump(t, HomeScreen(vault: vault));
    expect(find.text('Your device clock is about 4 minutes off, so codes won\'t work. Turn on automatic time in Settings.'), findsOneWidget);
    await finish(t);
  });
}
