// The decoy vault has to look like the real one, Premium included.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/store.dart';
import 'package:tanooki_auth/core/vault.dart';
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
}
