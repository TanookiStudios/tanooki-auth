// Phase F: 2FA guide links, the first-run tour, What's new and feedback. Every vault here lives in a temp
// folder with a memory key; nothing touches the real one, and feedback never reaches the network.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/feedback.dart';
import 'package:tanooki_auth/core/guides.dart';
import 'package:tanooki_auth/core/guides_data.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/about_maddie.dart' show appVersion;
import 'package:tanooki_auth/ui/add.dart';
import 'package:tanooki_auth/ui/help.dart';
import 'package:tanooki_auth/ui/settings.dart';
import 'package:tanooki_auth/ui/theme.dart';

import '../tool/make_guides.dart' as make_guides;
import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('phase_f');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 7)));
    vault.settings[lastBackupKey] = DateTime.now().toUtc().add(const Duration(minutes: 1)).toIso8601String();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (c) async => null);
  });
  tearDown(() => dir.deleteSync(recursive: true));

  Future<void> pump(WidgetTester t, Widget screen, {Size size = const Size(420, 1400)}) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: screen));
    await t.pump();
  }

  // Lets real file writes and fake network calls finish, which fake time can't do on its own.
  Future<void> waitFor(WidgetTester t, Finder f) async {
    for (var i = 0; i < 100 && f.evaluate().isEmpty; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await t.pump(const Duration(milliseconds: 100));
    }
    await t.pump(const Duration(seconds: 1)); // let a page slide in all the way
    expect(f, findsWidgets);
  }

  group('guides', () {
    test('the bundled list is exactly what site/guides/data.json makes', () {
      final json = File('../site/guides/data.json').readAsStringSync();
      // Windows checkouts may turn line endings into \r\n; the content is what matters.
      expect(File(make_guides.outPath).readAsStringSync().replaceAll('\r\n', '\n'), make_guides.guidesDartSource(json),
          reason: 'run `dart run tool/make_guides.dart` in app/');
      final site = [for (final g in jsonDecode(json) as List) (slug: g['slug'], name: g['name'], domain: g['domain'])];
      expect(guideData, site);
      expect(guideData.length, greaterThanOrEqualTo(40));
    });

    test('the tour\'s three starter guides exist', () {
      expect([for (final g in starterGuides) g.name], ['Google', 'Facebook', 'PayPal']);
      expect(guideUrl(starterGuides.first), 'https://auth.tanookistudios.com/guides/google/');
    });

    test('matches by website, then by service name', () {
      expect(guideFor('', ['accounts.google.com'])?.slug, 'google');
      expect(guideFor('Whatever', ['github.com'])?.slug, 'github');
      expect(guideFor('GitHub', [])?.slug, 'github');
      expect(guideFor('AWS', [])?.slug, 'aws');
      expect(guideFor('Amazon Web Services', [])?.slug, 'aws');
      expect(guideFor('Docker', [])?.slug, 'dockerhub');
      expect(guideFor('Linode', [])?.slug, 'linode');
      expect(guideFor('WordPress', [])?.slug, 'wordpress');
      expect(guideFor('Amazon', ['amazon.com']), isNull, reason: 'amazon.com is not the AWS guide');
      expect(guideFor('Microsoft', []), isNull);
      expect(guideFor('', []), isNull);
      expect(guideFor('', ['notgithub.com']), isNull);
    });

    testWidgets('add/edit shows the guide link only when there is a guide, and follows typing', (t) async {
      final a = Account(id: 'a', issuer: 'GitHub', label: 'me', secret: 'JBSWY3DPEHPK3PXP');
      await pump(t, Builder(builder: (c) => Scaffold(body: TextButton(onPressed: () => showAccountDialog(c, a, title: 'Edit', confirm: 'Save'), child: const Text('go')))));
      await t.tap(find.text('go'));
      await t.pump();
      expect(find.text('How to turn on 2FA for GitHub'), findsOneWidget);
      await t.enterText(find.widgetWithText(TextField, 'Service (e.g. GitHub)'), 'My Local Bank');
      await t.pump();
      expect(find.byKey(const Key('guideLink')), findsNothing);
      await t.enterText(find.widgetWithText(TextField, 'Website (optional)'), 'www.paypal.com');
      await t.pump();
      expect(find.text('How to turn on 2FA for PayPal'), findsOneWidget);
      await t.tap(find.text('Cancel'));
      await t.pump(const Duration(seconds: 1));
    });
  });

  group('versions', () {
    test('app version, pubspec and the newest What\'s new entry agree', () {
      final pubspec = RegExp(r'^version: (\S+)\+\d+$', multiLine: true).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1);
      expect(appVersion, pubspec);
      expect(changelog.first.version, appVersion);
      expect(changelog.every((v) => v.items.isNotEmpty), isTrue);
    });
  });

  group('tour and What\'s new', () {
    Future<void> open(WidgetTester t) async {
      await pump(t, Builder(builder: (c) => Scaffold(body: TextButton(onPressed: () => showTourOrWhatsNew(c, vault), child: const Text('unlock')))));
      await t.tap(find.text('unlock'));
    }

    Future<void> settle(WidgetTester t) async {
      for (var i = 0; i < 20; i++) {
        await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
        await t.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('fresh install: the tour once, never What\'s new', (t) async {
      await open(t);
      await waitFor(t, find.text('Welcome to Tanooki Auth'));
      expect(vault.settings[tourShownKey], isTrue);
      expect(vault.settings[whatsNewSeenKey], appVersion);
      await t.tap(find.byKey(const Key('tourSkip')));
      await settle(t);
      expect(find.text('unlock'), findsOneWidget);
      await t.tap(find.text('unlock'));
      await settle(t);
      expect(find.text('Welcome to Tanooki Auth'), findsNothing);
      expect(find.text('What\'s new'), findsNothing);
    });

    testWidgets('update with accounts: What\'s new once, no tour', (t) async {
      vault.accounts.add(Account(id: 'a', issuer: 'GitHub', secret: 'JBSWY3DPEHPK3PXP'));
      vault.settings[whatsNewSeenKey] = '0.2.0';
      await open(t);
      await waitFor(t, find.text('What\'s new'));
      expect(find.text('Version $appVersion (this version)'), findsOneWidget);
      expect(find.text('Welcome to Tanooki Auth'), findsNothing);
      expect(vault.settings[whatsNewSeenKey], appVersion);
      await t.pageBack();
      await settle(t);
      await t.tap(find.text('unlock'));
      await settle(t);
      expect(find.text('What\'s new'), findsNothing);
    });

    testWidgets('an update from before What\'s new existed (no version stored, has accounts) shows it', (t) async {
      vault.accounts.add(Account(id: 'a', issuer: 'GitHub', secret: 'JBSWY3DPEHPK3PXP'));
      vault.settings[tourShownKey] = true;
      await open(t);
      await waitFor(t, find.text('What\'s new'));
    });

    testWidgets('the tour walks three steps, links the guides, and is readable wide and with a screen reader', (t) async {
      final handle = t.ensureSemantics();
      await pump(t, TourScreen(vault: vault), size: const Size(1400, 900));
      for (final title in ['Welcome to Tanooki Auth', 'Add your first account', 'Popular sites to protect first']) {
        expect(find.text(title), findsOneWidget);
        expect(find.bySemanticsLabel(title), findsOneWidget);
        await expectLater(t, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(t, meetsGuideline(androidTapTargetGuideline));
        await expectLater(t, meetsGuideline(textContrastGuideline));
        if (title != 'Popular sites to protect first') {
          await t.tap(find.byKey(const Key('tourNext')));
          await t.pump();
        }
      }
      for (final name in ['Google', 'Facebook', 'PayPal']) {
        expect(find.text(name), findsOneWidget);
      }
      expect(find.text('All 2FA guides'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.byKey(const Key('tourSkip')), findsNothing);
      await t.tap(find.text('Back'));
      await t.pump();
      expect(find.text('Add your first account'), findsOneWidget);
      expect(find.text('Scan a QR code or paste a link'), findsOneWidget);
      expect(find.text('Import from another app'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('Settings has Help (guides, tour, feedback) and What\'s new', (t) async {
      await pump(t, SettingsScreen(vault: vault));
      for (final s in ['All 2FA guides', 'Show the welcome tour', 'Send feedback', 'What\'s new']) {
        await t.scrollUntilVisible(find.text(s), 300, scrollable: find.byType(Scrollable).first);
        expect(find.text(s), findsOneWidget, reason: s);
      }
      await t.ensureVisible(find.text('Show the welcome tour'));
      await t.pumpAndSettle();
      await t.tap(find.text('Show the welcome tour'));
      await t.pumpAndSettle();
      expect(find.text('Welcome to Tanooki Auth'), findsOneWidget);
    });
  });

  group('feedback', () {
    List<int>? sent;
    Object reply = 201;
    setUp(() {
      sent = null;
      reply = 201;
      feedbackPost = (bytes) async {
        sent = bytes;
        if (reply is Exception) throw reply;
        return reply as int;
      };
    });

    testWidgets('never sends anything from the vault', (t) async {
      final now = DateTime.now();
      vault.accounts.addAll([
        Account(
          id: 'acct-zorblax-1',
          issuer: 'Zorblax Bank',
          label: 'secret.person@example.org',
          secret: 'JBSWY3DPEHPK3PXP',
          domains: ['zorblax-bank.example'],
          tags: ['quuxtag'],
          notes: 'my hidden note about the vault',
          recoveryCodes: [RecoveryCode('RC-ABCD-9999')],
        ),
        Account(id: 'acct-plonk-2', issuer: 'Plonkworks', label: 'plonk-user-88', secret: 'GEZDGNBVGY3TQOJQ', tags: ['wibbletag'], notes: 'second note'),
        Account(id: 'acct-steam-3', type: OtpType.steam, issuer: 'Steam', label: 'gamer-name-xyz', secret: 'MFRGGZDFMZTWQ2LK', digits: 5),
      ]);
      await t.runAsync(vault.save);
      final vaultStrings = <String>{
        for (final a in vault.accounts) ...[
          a.id, a.issuer, a.label, a.secret, a.codeAt(now), a.notes, ...a.tags, ...a.domains,
          for (final r in a.recoveryCodes) r.code,
        ],
      };
      vaultStrings.remove('');
      List<String> leaks(String text) => [for (final s in vaultStrings) if (text.contains(s)) s];
      // The check itself can go red: the vault's own contents are full of leaks.
      expect(leaks(jsonEncode(vault.accounts.map((a) => a.toJson()).toList())), isNotEmpty);

      await pump(t, SettingsScreen(vault: vault));
      await t.scrollUntilVisible(find.text('Send feedback'), 300, scrollable: find.byType(Scrollable).first);
      await t.ensureVisible(find.text('Send feedback'));
      await t.pumpAndSettle();
      await t.tap(find.text('Send feedback'));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('feedbackMessage')), 'The tour was lovely but the font is small');
      await t.enterText(find.byKey(const Key('feedbackContact')), 'reply.here@example.com');
      await t.tap(find.byKey(const Key('feedbackSend')));
      await waitFor(t, find.byKey(const Key('feedbackStatus')));

      final body = utf8.decode(sent!);
      expect(leaks(body), isEmpty, reason: body);
      expect(jsonDecode(body), {
        'message': 'The tour was lovely but the font is small',
        'platform': Platform.operatingSystem,
        'appVersion': appVersion,
        'contact': 'reply.here@example.com',
      });
      expect(find.text('Sent. Thank you! Maddie reads every message.'), findsOneWidget);
    });

    testWidgets('unticking the box leaves out the version and device type', (t) async {
      await pump(t, const FeedbackScreen());
      await t.enterText(find.byKey(const Key('feedbackMessage')), 'hello');
      await t.tap(find.byKey(const Key('feedbackDevice')));
      await t.pump();
      await t.tap(find.byKey(const Key('feedbackSend')));
      await waitFor(t, find.byKey(const Key('feedbackStatus')));
      expect(jsonDecode(utf8.decode(sent!)), {'message': 'hello', 'platform': 'not shared', 'appVersion': 'not shared'});
    });

    testWidgets('an empty message says why instead of sending', (t) async {
      await pump(t, const FeedbackScreen());
      await t.tap(find.byKey(const Key('feedbackSend')));
      await t.pump();
      expect(find.text('Type a message first.'), findsOneWidget);
      expect(sent, isNull);
    });

    final cases = <String, Object>{
      'too long': 413,
      'too many': 429,
      'server error': 503,
      'offline': const SocketException('no network'),
    };
    final messages = <String, String>{};
    for (final c in cases.entries) {
      testWidgets('one message for: ${c.key}', (t) async {
        reply = c.value;
        await pump(t, const FeedbackScreen());
        await t.enterText(find.byKey(const Key('feedbackMessage')), 'hello');
        await t.tap(find.byKey(const Key('feedbackSend')));
        await waitFor(t, find.byKey(const Key('feedbackStatus')));
        final text = t.widget<Text>(find.byKey(const Key('feedbackStatus'))).data!;
        expect(text, isNot(contains('Sent')));
        expect(messages.values, isNot(contains(text)), reason: 'each failure has its own message');
        messages[c.key] = text;
        expect(find.text('hello'), findsOneWidget, reason: 'the message stays so it can be sent again');
      });
    }

    test('too long is caught before sending', () async {
      expect(await sendFeedback({'message': 'x' * 4001, 'platform': 'ios', 'appVersion': appVersion}), FeedbackResult.tooLong);
      expect(await sendFeedback({'message': 'é' * 2100, 'platform': 'ios', 'appVersion': appVersion}), FeedbackResult.tooLong,
          reason: 'over 4 KB once encoded');
      expect(sent, isNull);
    });
  });
}
