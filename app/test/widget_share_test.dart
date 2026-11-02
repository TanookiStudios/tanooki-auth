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

  group('AutoFill', () {
    Vault autofillVault() => vault()
      ..accounts.addAll([
        Account(id: '6', issuer: 'Bank', secret: 'JBSWY3DPEHPK3PXP', domains: ['bank.example'], requireAuth: true),
        Account(id: '7', issuer: 'Secret club', secret: 'JBSWY3DPEHPK3PXP', travelHidden: true),
        Account(id: '8', issuer: 'Club, hidden and asks', secret: 'JBSWY3DPEHPK3PXP', travelHidden: true, requireAuth: true),
      ])
      ..accounts.first.domains.add('github.com');

    test('nothing is shared until the setting is on', () {
      expect(autofillAccounts(autofillVault()), isEmpty);
      final v = autofillVault()..settings[shareCodesKey] = true; // the widgets switch is not this one
      expect(autofillAccounts(v), isEmpty);
    });

    test('every live time-based account, not just favorites; never HOTP, trashed or travel-hidden', () {
      final v = autofillVault()..settings[autofillKey] = true;
      final shared = autofillAccounts(v);
      expect(shared.map((a) => a['id']), ['1', '2', '5', '6']);
      expect(shared.first, {
        'id': '1',
        'type': 'totp',
        'issuer': 'GitHub',
        'label': 'me',
        'secret': 'JBSWY3DPEHPK3PXP',
        'algorithm': 'sha1',
        'digits': 6,
        'period': 30,
        'domains': ['github.com'],
      });
      expect(shared[2]['type'], 'steam');
      // Ask-first accounts go, marked, so the phone asks for Face ID / fingerprint before filling them.
      expect(shared.last['requireAuth'], true);
      expect(shared.where((a) => a['requireAuth'] == true).map((a) => a['id']), ['6']);
    });

    test('travel-hidden accounts stay out with travel mode on or off', () {
      for (final travel in [false, true]) {
        final v = autofillVault()
          ..settings[autofillKey] = true
          ..settings[Vault.travelModeKey] = travel;
        final ids = autofillAccounts(v).map((a) => a['id']);
        expect(ids, isNot(contains('7')));
        expect(ids, isNot(contains('8')));
      }
    });
  });
}

class _NoKeys implements KeyStore {
  @override
  Future<String?> read() async => null;
  @override
  Future<void> write(String value) async {}
}
