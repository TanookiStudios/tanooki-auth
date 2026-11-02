// The decoy vault has to look like the real one, Premium included.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/spotlight.dart';
import 'package:tanooki_auth/core/store.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/core/widget_share.dart';
import 'package:tanooki_auth/main.dart' show decoyLookAlikeKeys;

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  test('a decoy made from a Google Play / App Store buyer\'s vault has Premium too', () async {
    final dir = Directory.systemTemp.createTempSync('decoy');
    addTearDown(() => dir.deleteSync(recursive: true));
    Vault make(String name) => Vault(File('${dir.path}/$name.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 1)));
    final real = make('real')..settings.addAll({storePurchaseKey: {'product': premiumProductId, 'store': 'google'}, 'theme': 'midnight'});
    final decoy = make('decoy');
    for (final k in decoyLookAlikeKeys) {
      if (real.settings.containsKey(k)) decoy.settings[k] = real.settings[k];
    }
    expect(await hasPremium(real), isTrue);
    expect(await hasPremium(decoy), isTrue, reason: 'otherwise its Premium theme falls back to Auto and gives the decoy away');
  });

  test('Spotlight: opening the decoy empties the index; opening the real vault fills it again', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS; // publishSpotlight only talks to iPhone, iPad and Mac
    final sent = <List<String>>[];
    const channel = MethodChannel('tanooki/spotlight');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'index') sent.add([for (final i in jsonDecode(call.arguments as String) as List) i['issuer'] as String]);
      return null;
    });
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });
    final dir = Directory.systemTemp.createTempSync('decoy_spotlight');
    addTearDown(() => dir.deleteSync(recursive: true));
    final real = Vault(File('${dir.path}/real.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 1)))
      ..accounts.add(Account(id: '1', issuer: 'Bank', secret: 'JBSWY3DPEHPK3PXP'));

    await spotlightVaultOpened(real, decoy: false);
    expect(sent.last, ['Bank']);
    await spotlightVaultOpened(real, decoy: true);
    expect(sent.last, isEmpty, reason: 'the decoy is open: Spotlight must not list the real vault');
    real.accounts.add(Account(id: '2', issuer: 'Mail', secret: 'JBSWY3DPEHPK3PXP'));
    await publishSpotlight(real); // a background save of the real vault (sync) while the decoy is open
    expect(sent.last, isEmpty, reason: 'still the decoy on screen');
    await spotlightVaultOpened(real, decoy: false);
    expect(sent.last, ['Bank', 'Mail']);
    real.settings[spotlightKey] = false;
    await spotlightVaultOpened(real, decoy: false);
    expect(sent.last, isEmpty, reason: 'setting off: the real vault does not re-index');
  });

  test('AutoFill and widgets: opening the decoy empties them; the real vault fills them again', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final autofill = <int>[];
    const channel = MethodChannel('tanooki/extras');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'setAutofill') autofill.add((jsonDecode(call.arguments as String) as List).length);
      return null;
    });
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });
    final dir = Directory.systemTemp.createTempSync('decoy_autofill');
    addTearDown(() => dir.deleteSync(recursive: true));
    final real = Vault(File('${dir.path}/real.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 1)))
      ..accounts.add(Account(id: '1', issuer: 'Bank', secret: 'JBSWY3DPEHPK3PXP', domains: ['bank.com']));
    real.settings[autofillKey] = true;

    await sharesVaultOpened(real, decoy: false);
    expect(autofill.last, 1);
    await sharesVaultOpened(real, decoy: true);
    expect(autofill.last, 0, reason: 'the decoy is open: AutoFill must not offer the real codes');
    await publishAutofill(real); // a background save of the real vault while the decoy is open
    expect(autofill.last, 0);
    await sharesVaultOpened(real, decoy: false);
    expect(autofill.last, 1);
  });
}
