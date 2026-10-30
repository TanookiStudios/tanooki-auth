import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/exporters.dart';
import 'package:tanooki_auth/core/google_migration.dart';
import 'package:tanooki_auth/core/importers.dart';
import 'package:tanooki_auth/core/totp.dart';

/// Every way a code can be set up, so a round trip that drops or bends any setting fails.
List<Account> sample() => [
      Account(id: '1', issuer: 'GitHub', label: 'octo@example.com', secret: 'JBSWY3DPEHPK3PXP', favorite: true, notes: 'work laptop', folder: 'Work'),
      Account(id: '2', issuer: 'Proton', label: 'me@example.com', secret: 'GEZDGNBVGY3TQOJQ', algorithm: OtpAlgorithm.sha256, digits: 8),
      Account(id: '3', issuer: 'Bank', label: 'card', secret: 'NBSWY3DPO5XXE3DE', type: OtpType.hotp, counter: 7),
      Account(id: '4', issuer: 'Big Corp', label: 'admin', secret: 'KRUGKIDROVUWG2ZA', algorithm: OtpAlgorithm.sha512, digits: 8, period: 60),
      Account(id: '5', issuer: 'Steam', label: 'gamer', secret: 'MFRGGZDFMZTWQ2LK', type: OtpType.steam, digits: 5),
      Account(id: '6', issuer: '', label: 'just-a-label', secret: 'ONSWG4TFOQYTEMZU', digits: 7),
    ];

/// What must survive: everything that makes the codes, plus the name.
String sig(Account a) =>
    '${a.issuer}|${a.label}|${a.secret}|${a.type.name}|${a.algorithm.name}|${a.digits}|${a.timeBased ? a.period : a.counter}';

void main() {
  test('Aegis, not encrypted: our Aegis importer reads back the same accounts, favorites, notes and folders', () async {
    final text = exportAegisPlain(sample());
    final r = await parseImport(ImportSource.aegis, text);
    expect(r.problems, isEmpty);
    expect(r.accounts.map(sig), sample().map(sig));
    expect([r.accounts[0].favorite, r.accounts[0].notes, r.accounts[0].folder], [true, 'work laptop', 'Work']);
    expect(r.accounts[1].folder, isNull);
    final db = jsonDecode(text)['db'] as Map;
    expect(db['version'], 3);
    expect((db['groups'] as List).single['name'], 'Work');
  });

  test('Aegis, password-protected: only the right password opens it, and it opens to the same accounts', () async {
    // Small scrypt cost so the test is fast; the real export uses Aegis's own N=32768 (checked below).
    final text = await exportAegisEncrypted(sample(), 'correct horse', scryptN: 1024);
    expect(text, isNot(contains('JBSWY3DPEHPK3PXP')));
    await expectLater(parseImport(ImportSource.aegis, text),
        throwsA(isA<ImportException>().having((e) => e.needsPassword, 'needsPassword', true)));
    await expectLater(parseImport(ImportSource.aegis, text, password: 'wrong'),
        throwsA(isA<ImportException>().having((e) => e.message, 'message', contains('Wrong password'))));
    final r = await parseImport(ImportSource.aegis, text, password: 'correct horse');
    expect(r.accounts.map(sig), sample().map(sig));
  });

  test('Aegis, password-protected, with the real scrypt settings', () async {
    final text = await exportAegisEncrypted(sample().take(1).toList(), 'pw');
    final slot = (jsonDecode(text)['header']['slots'] as List).single as Map;
    expect([slot['type'], slot['n'], slot['r'], slot['p']], [1, 32768, 8, 1]);
    expect((await parseImport(ImportSource.aegis, text, password: 'pw')).accounts.map(sig), [sig(sample().first)]);
  });

  test('2FAS: our 2FAS importer reads back the same accounts', () async {
    final text = export2fas(sample());
    final r = await parseImport(ImportSource.twoFas, text);
    expect(r.problems, isEmpty);
    expect(r.accounts.map(sig), sample().map(sig));
    expect(jsonDecode(text)['schemaVersion'], 4);
  });

  group('Google Authenticator QR', () {
    test('reads back through our Google importer; accounts Google can\'t hold are left out by name', () {
      final codes = buildGoogleMigration(sample());
      expect(codes, hasLength(1));
      final back = parseGoogleMigration(codes.single);
      // Google can't do 60-second, Steam, or 7-digit codes.
      expect(back.map(sig), [sample()[0], sample()[1], sample()[2]].map(sig));
      expect([for (final a in sample()) googleCantTake(a)],
          [null, null, null, 'codes that change every 60 seconds', 'Steam codes', '7-digit codes']);
    });

    test('splits into several codes when there are many accounts, and nothing is lost', () {
      final many = [
        for (var i = 0; i < 23; i++) Account(id: '$i', issuer: 'Site $i', label: 'me$i@example.com', secret: base32Encode([i, 1, 2, 3, 4, 5, 6, 7, 8, 9])),
      ];
      final codes = buildGoogleMigration(many, batchId: 42);
      expect(codes, hasLength(3));
      final back = [for (final c in codes) ...parseGoogleMigration(c)];
      expect(back.map(sig), many.map(sig));
      expect(codes.every((c) => c.length < 1500), isTrue, reason: 'each QR must stay small enough for a phone camera');
    });

    test('a name with a colon and non-English letters survives', () {
      final a = Account(id: 'x', issuer: 'Café', label: 'zoë:work', secret: 'JBSWY3DPEHPK3PXP');
      expect(parseGoogleMigration(buildGoogleMigration([a]).single).map(sig), [sig(a)]);
    });
  });
}
