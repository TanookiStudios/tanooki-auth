import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/core/widget_share.dart';

void main() {
  Vault vault() {
    final v = Vault(File('unused'), _NoKeys());
    v.accounts.addAll([
      Account(id: '1', issuer: 'GitHub', label: 'me', secret: 'JBSWY3DPEHPK3PXP', favorite: true),
      Account(id: '2', issuer: 'Plain', secret: 'JBSWY3DPEHPK3PXP'),
      Account(id: '3', issuer: 'Counter', secret: 'JBSWY3DPEHPK3PXP', type: OtpType.hotp, favorite: true),
      Account(id: '5', issuer: 'Steam', label: 'gamer', secret: 'MFRGGZDFMZTWQ2LK', type: OtpType.steam, digits: 5, favorite: true),
      Account(id: '4', issuer: 'Trashed', secret: 'JBSWY3DPEHPK3PXP', favorite: true, deletedAt: DateTime.now()),
    ]);
    return v;
  }

  test('nothing is shared until the setting is on', () {
    expect(sharedFavorites(vault()), isEmpty);
  });

  test('only live time-based favorites are shared', () {
    final v = vault()..settings[shareCodesKey] = true;
    final shared = sharedFavorites(v);
    expect(shared.map((f) => f['issuer']), ['GitHub', 'Steam']);
    expect(shared.last['type'], 'steam'); // the widget switches to Steam Guard's letters on this
    expect(shared.first, {
      'type': 'totp',
      'issuer': 'GitHub',
      'label': 'me',
      'secret': 'JBSWY3DPEHPK3PXP',
      'algorithm': 'sha1',
      'digits': 6,
      'period': 30,
    });
  });
}

class _NoKeys implements KeyStore {
  @override
  Future<String?> read() async => null;
  @override
  Future<void> write(String value) async {}
}
