import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanooki_auth/ui/about_maddie.dart' show appVersion;
import 'package:tanooki_auth/ui/help.dart' show tourShownKey, whatsNewSeenKey;
import 'package:tanooki_auth/core/auto_backup.dart';
import 'package:tanooki_auth/core/backup.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/security.dart';
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
    // findsWidgets: from 900 px wide (the Linux window) the details pane shows the code a second time.
    expect(find.text(expectedCode()), findsWidgets);
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
    final skipKit = find.text('Skip for now');
    for (var i = 0; i < 100 && notNow.evaluate().isEmpty && skipKit.evaluate().isEmpty; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    if (notNow.evaluate().isNotEmpty) {
      await t.tap(notNow); // phone first-run lock question; biometrics can't be automated
      await settle(t);
    }
    await waitFor(t, find.text('Your recovery kit')); // shown once, on first run
    await t.tap(skipKit);
    await settle(t);
    await waitFor(t, find.text('Welcome to Tanooki Auth')); // first-run tour, also only once
    await t.tap(find.byKey(const Key('tourSkip')));
    await settle(t);
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
    expect(find.text('octo@example.com'), findsWidgets);
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
    // The Settings list builds lazily, so on a short window Trash isn't built yet: scroll the vertical list to it.
    await t.scrollUntilVisible(find.text('Trash (1)'), 300,
        scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
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

  testWidgets('passcode lock: wrong, decoy opens an empty vault, real passcode opens the real one', (t) async {
    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault; pass --dart-define=TA_STORAGE=itest');
    final real = await openVault();
    await real.resetToEmpty();
    real.accounts.add(parseOtpauthUri(uri));
    real.settings.addAll({lockKey: false, kitShownKey: true, tourShownKey: true, whatsNewSeenKey: appVersion, passcodeKey: await hashPasscode('482916')});
    await real.save();
    await createDecoyVault(real, await hashPasscode('730514'));

    Future<void> typePin(String pin) async {
      await waitFor(t, find.text('Tanooki Auth is locked'));
      await t.enterText(find.byType(TextField), pin);
      await t.pump();
      expect(t.widget<TextField>(find.byType(TextField)).controller!.text, pin, reason: 'typed into the passcode field');
      await t.tap(find.text('Unlock'));
      await t.pump();
      for (var i = 0; i < 300 && find.text('Tanooki Auth is locked').evaluate().isNotEmpty && find.text('Wrong passcode.').evaluate().isEmpty; i++) {
        await t.pump(const Duration(milliseconds: 100));
      }
      await settle(t);
    }

    await t.pumpWidget(const TanookiAuthApp(key: ValueKey('lock1')));
    await typePin('000000');
    expect(find.text('Wrong passcode.'), findsOneWidget);
    await typePin('730514');
    await waitFor(t, find.textContaining('No accounts yet'));
    expect(find.text('GitHub'), findsNothing);
    // Using the decoy (adding an account there) never touches the real file.
    final realFile = (await openVault()).file;
    final realBefore = realFile.readAsBytesSync();
    final decoy = await openVault(second: true);
    await decoy.load();
    expect(decoy.accounts, isEmpty);
    decoy.accounts.add(parseOtpauthUri('otpauth://totp/Decoy:me?secret=MFRGGZDFMZTWQ2LK&issuer=Decoy'));
    await decoy.save();
    expect(realFile.readAsBytesSync(), realBefore);

    await t.pumpWidget(const SizedBox());
    await t.pumpWidget(const TanookiAuthApp(key: ValueKey('lock2')));
    await typePin('482916');
    await waitFor(t, find.text('GitHub'));
    await expectCurrentCode(t);
    final after = await openVault();
    await after.load();
    expect(after.live.single.issuer, 'GitHub');
    expect(after.settings[failedPasscodesKey], isNull, reason: 'right passcode resets the wrong-try count');
    stdout.writeln('PROOF passcode-wrong=refused decoy=empty real=GitHub platform=${Platform.operatingSystem}');
  });

  // macOS: the real native bookmark path (create, resolve, start/stop security-scoped access) on a test folder inside
  // the app's own container, injected by path so no folder picker is shown.
  testWidgets('automatic backup through a security-scoped bookmark', (t) async {
    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault; pass --dart-define=TA_STORAGE=itest');
    final vault = await openVault();
    await vault.resetToEmpty();
    vault.accounts.add(parseOtpauthUri(uri));
    vault.settings.addAll({lockKey: false, kitShownKey: true, tourShownKey: true, whatsNewSeenKey: appVersion});
    final dir = Directory('${(await getApplicationSupportDirectory()).path}/$storageName/auto-backup-folder');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    dir.createSync(recursive: true);
    for (var d = 1; d <= 12; d++) {
      File('${dir.path}/${autoBackupName(DateTime(2020, 1, d))}').writeAsStringSync('old');
    }
    File('${dir.path}/notes.txt').writeAsStringSync('not ours');

    final picked = (await folderCall<Map>('bookmark', {'path': dir.path}))!;
    expect(picked['name'], 'auto-backup-folder');
    vault.settings[autoBackupKey] = {'folder': picked['ref'], 'folderName': picked['name'], 'passphrase': 'itest passphrase'};
    await vault.save();

    final runner = AutoBackupRunner(iterations: 1000)..isPremium = () => true;
    expect(await runner.runNow(vault), isTrue, reason: '${runner.failure.value}');
    final today = File('${dir.path}/${autoBackupName(DateTime.now())}');
    expect(today.existsSync(), isTrue);
    expect((await importBackup(today.readAsStringSync(), 'itest passphrase')).single.secret, vault.live.single.secret);
    final names = dir.listSync().map((e) => e.uri.pathSegments.last).toList();
    expect(names.where(isAutoBackupName).length, autoBackupsKept);
    expect(names, contains('notes.txt'));
    final reloaded = await openVault();
    await reloaded.load();
    expect(backupIsRecent(reloaded.settings, DateTime.now()), isTrue, reason: 'panic wipe and the check-up see the backup');

    // The Settings row shows the folder and the time.
    await t.pumpWidget(const TanookiAuthApp(key: ValueKey('autobackup')));
    await waitFor(t, find.text('GitHub'));
    await t.tap(find.byTooltip('Settings').evaluate().isNotEmpty ? find.byTooltip('Settings') : find.text('Settings'));
    await settle(t);
    final row = find.textContaining('On, to auto-backup-folder. Last backup: Today at');
    await t.scrollUntilVisible(row, 300,
        scrollable: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first);
    expect(row, findsOneWidget);

    // Folder deleted: the bookmark no longer resolves and the failure says so.
    dir.deleteSync(recursive: true);
    expect(await runner.runNow(vault), isFalse);
    expect(runner.failure.value!.failure, AutoBackupFailure.folderGone, reason: runner.failure.value!.detail);
    stdout.writeln('PROOF auto-backup bookmark=ok file=${today.path} kept=$autoBackupsKept notes=kept gone=folderGone platform=${Platform.operatingSystem}');
  }, skip: !Platform.isMacOS);
}
