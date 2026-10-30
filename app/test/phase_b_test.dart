// Phase B: Spotlight names, watch complication pick, copy on open, paste once (Mac), Spotlight opening
// an account on the home list, and the phone link's add-request / add-result.
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/bridge/server.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/phone_link.dart';
import 'package:tanooki_auth/core/spotlight.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/core/widget_share.dart';
import 'package:tanooki_auth/ui/clipboard.dart';
import 'package:tanooki_auth/ui/home.dart';
import 'package:tanooki_auth/ui/theme.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('phase_b_test');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 7)));
  });
  tearDown(() => dir.deleteSync(recursive: true));

  Account acct(String id, {String secret = 'JBSWY3DPEHPK3PXP', DateTime? used, bool fav = false}) =>
      Account(id: id, issuer: id, label: '$id@me', secret: secret, lastUsedAt: used, favorite: fav);

  test('Spotlight gets names only, never trashed or travel-hidden accounts, nothing when off', () {
    vault.accounts.addAll([
      acct('GitHub'),
      acct('Hidden')..travelHidden = true,
      acct('Gone')..deletedAt = DateTime.now().toUtc(),
    ]);
    final items = spotlightItems(vault);
    expect(items, [
      {'id': 'GitHub', 'issuer': 'GitHub', 'label': 'GitHub@me'},
    ]);
    expect(jsonEncode(items).contains('JBSWY3DPEHPK3PXP'), isFalse);
    vault.settings[spotlightKey] = false;
    expect(spotlightItems(vault), isEmpty, reason: 'off removes every item');
  });

  test('watch complication flag only on the chosen favorite, and only with Premium; travel-hidden left out', () {
    vault.settings[shareCodesKey] = true;
    vault.settings[complicationKey] = 'B';
    vault.accounts.addAll([acct('A', fav: true), acct('B', fav: true), acct('C', fav: true)..travelHidden = true]);
    expect(sharedFavorites(vault).map((f) => f['issuer']), ['A', 'B']);
    expect(sharedFavorites(vault).any((f) => f.containsKey('complication')), isFalse);
    final premium = sharedFavorites(vault, premium: true);
    expect([for (final f in premium) if (f['complication'] == true) f['issuer']], ['B']);
  });

  test('copy on open picks the most recently used account it may copy', () {
    final t = DateTime.utc(2026, 10, 30, 12);
    vault.accounts.addAll([
      acct('Old', used: t),
      acct('Locked', used: t.add(const Duration(hours: 3)))..requireAuth = true,
      acct('Travel', used: t.add(const Duration(hours: 2)))..travelHidden = true,
      Account(id: 'Bank', issuer: 'Bank', type: OtpType.hotp, secret: 'GEZDGNBVGY3TQOJQ', lastUsedAt: t.add(const Duration(hours: 4))),
      acct('Newest', used: t.add(const Duration(hours: 1))),
      acct('Never'),
    ]);
    expect(copyOnOpenPick(vault), isNull, reason: 'off by default');
    vault.settings[copyOnOpenKey] = true;
    expect(copyOnOpenPick(vault)!.id, 'Newest');
    vault.accounts.removeWhere((a) => a.id == 'Newest' || a.id == 'Old');
    expect(copyOnOpenPick(vault), isNull);
  });

  test('paste once on a Mac hands the code to the native promise, then clears it after 30 s', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('tanooki/window'), (c) async => calls.add(c));
    addTearDown(() => pasteOnce = false);
    await TestAsyncUtils.guard(() async {
      pasteOnce = true;
      await copyCode('123456');
    });
    expect(calls.single.method, 'copyOnce');
    expect(calls.single.arguments, '123456');
  }, skip: !Platform.isMacOS);

  testWidgets('a tapped Spotlight result narrows the home list to that account', (t) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
    vault.accounts.addAll([for (final n in ['Alpha', 'Bravo', 'Charlie', 'Delta', 'Echo']) acct(n)]);
    t.view.physicalSize = const Size(420, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: HomeScreen(vault: vault)));
    await t.pump();
    expect(find.text('Charlie'), findsOneWidget);
    openAccountRequest.value = 'Delta';
    await t.pump();
    expect(find.text('Delta'), findsWidgets);
    expect(find.text('Charlie'), findsNothing);
    expect(openAccountRequest.value, isNull, reason: 'handled once');
    await t.pumpWidget(const SizedBox());
  });

  test('phone link: add-request from the browser is confirmed, saved, and answered with add-result', () => HttpOverrides.runWithHttpOverrides(() async {
    // A stand-in relay: hands out one encrypted add-request and records what the phone sends back.
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final ext = await X25519().newKeyPair();
    final link = BrowserLink({
      'relay': 'http://127.0.0.1:${server.port}',
      'room': 'room1',
      'extPub': b64u((await ext.extractPublicKey()).bytes),
      'secret': b64u(randomBytes(32)),
      'seed': b64u(randomBytes(32)),
      'phonePub': 'p',
      'token': 't',
      'pairedAt': DateTime.now().toIso8601String(),
    });
    final keys = await link.keys();
    const uri = 'otpauth://totp/Slack:maddie?secret=KRUGKIDROVUWG2ZAMJZG653OEBTG66BAN52XE&issuer=Slack';
    final request = await seal(keys.e2p, {'t': 'add-request', 'uri': uri, 'id': 'req1', 'ts': DateTime.now().millisecondsSinceEpoch},
        'TA-LINK-1|room1|e2p');
    final sent = <Map<String, dynamic>>[];
    server.listen((req) async {
      final body = await utf8.decoder.bind(req).join();
      if (req.method == 'GET') {
        req.response.write(jsonEncode({
          'messages': [
            {'id': 5, 'from': 'ext', 'ciphertext': request},
          ],
        }));
      } else if (req.method == 'POST') {
        sent.add(await open(keys.p2e, (jsonDecode(body) as Map)['ciphertext'] as String, 'TA-LINK-1|room1|p2e'));
        req.response.statusCode = 201;
        req.response.write('{}');
      } else {
        req.response.write('{}');
      }
      await req.response.close();
    });

    final requests = <FillRequest>[];
    await link.poll(requests.add);
    expect(requests.single.addUri, uri);

    List<Account>? asked;
    await link.answerAdd(requests.single, await addFromUri(vault, requests.single.addUri, (a) async {
      asked = a;
      return false;
    }));
    expect(asked!.single.issuer, 'Slack');
    expect(vault.accounts, isEmpty);
    expect(sent.last, containsPair('t', 'add-result'));
    expect(sent.last, containsPair('re', 'req1'));
    expect(sent.last, containsPair('accepted', false));
    expect(sent.last, containsPair('reason', 'declined'));

    await link.answerAdd(requests.single, await addFromUri(vault, uri, (_) async => true));
    expect(sent.last['accepted'], isTrue);
    expect(vault.accounts.single.issuer, 'Slack');
    expect(jsonEncode(sent).contains('KRUGKIDROVUWG2ZAMJZG653OEBTG66BAN52XE'), isFalse);
  }, _RealHttp()));
}

/// The widget test binding fakes every HTTP request with a 400; this test talks to its own local relay.
class _RealHttp extends HttpOverrides {}
