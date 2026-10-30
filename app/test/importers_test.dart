import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/importers.dart';
import 'package:tanooki_auth/core/scrypt.dart';
import 'package:tanooki_auth/core/totp.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
String hex(List<int> b) => b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();

void main() {
  test('scrypt matches the RFC 7914 test vectors', () {
    expect(hex(scrypt([], [], n: 16, r: 1, p: 1, dkLen: 64)),
        '77d6576238657b203b19ca42c18a0497f16b4844e3074ae8dfdffa3fede21442fcd0069ded0948f8326a753a0fc81f17e8d3e0fb2e0d3628cf35e20c38d18906');
    expect(hex(scrypt('password'.codeUnits, 'NaCl'.codeUnits, n: 1024, r: 8, p: 16, dkLen: 64)),
        'fdbabe1c9d3472007856e7190d01e9fe7c6ad7cbc8237830e77376634b3731622eaf30d92e22a3886ff109279d9830dac727afb94a83ee6d8360cbdfa2cc0640');
  });

  group('Aegis', () {
    void checkEntries(ImportResult r) {
      expect(r.accounts.map((a) => a.issuer), ['GitHub', 'Proton', 'Bank', 'Steam']);
      final gh = r.accounts[0];
      expect([gh.label, gh.secret, gh.favorite, gh.notes], ['octo@example.com', 'JBSWY3DPEHPK3PXP', true, 'work laptop']);
      final proton = r.accounts[1];
      expect([proton.algorithm, proton.digits, proton.period], [OtpAlgorithm.sha256, 8, 60]);
      expect([r.accounts[2].type, r.accounts[2].counter], [OtpType.hotp, 7]);
      final steam = r.accounts[3];
      expect([steam.type, steam.label, steam.secret, steam.digits], [OtpType.steam, 'gamer', 'MFRGGZDFMZTWQ2LK', 5]);
      expect(r.problems, isEmpty);
    }

    test('plain export', () async => checkEntries(await parseImport(ImportSource.aegis, fixture('import_aegis_plain.json'))));

    test('password-protected export: asks, rejects a wrong password, opens with the right one', () async {
      final text = fixture('import_aegis_encrypted.json');
      await expectLater(parseImport(ImportSource.aegis, text),
          throwsA(isA<ImportException>().having((e) => e.needsPassword, 'needsPassword', true)));
      await expectLater(parseImport(ImportSource.aegis, text, password: 'wrong'),
          throwsA(isA<ImportException>().having((e) => e.message, 'message', contains('Wrong password'))));
      checkEntries(await parseImport(ImportSource.aegis, text, password: 'test'));
    });

    test('not an Aegis file', () async {
      await expectLater(parseImport(ImportSource.aegis, '{"hello":1}'), throwsA(isA<ImportException>()));
      await expectLater(parseImport(ImportSource.aegis, 'garbage'), throwsA(isA<ImportException>()));
    });
  });

  group('2FAS', () {
    void check(ImportResult r) {
      expect(r.accounts.map((a) => '${a.issuer}|${a.label}|${a.secret}'),
          ['GitHub|octo@example.com|JBSWY3DPEHPK3PXP', 'Dropbox|demo@example.com|KRUGKIDROVUWG2ZA', 'Steam|gamer|MFRGGZDFMZTWQ2LK']);
      expect(r.accounts[2].type, OtpType.steam);
      expect(r.problems, isEmpty);
    }

    test('plain backup', () async => check(await parseImport(ImportSource.twoFas, fixture('import_2fas_plain.2fas'))));

    test('password-protected backup', () async {
      final text = fixture('import_2fas_encrypted.2fas');
      await expectLater(parseImport(ImportSource.twoFas, text),
          throwsA(isA<ImportException>().having((e) => e.needsPassword, 'needsPassword', true)));
      await expectLater(parseImport(ImportSource.twoFas, text, password: 'nope'),
          throwsA(isA<ImportException>().having((e) => e.message, 'message', contains('Wrong password'))));
      check(await parseImport(ImportSource.twoFas, text, password: 'test'));
    });
  });

  group('Authy', () {
    test('JSON from the community exporters', () async {
      final r = await parseImport(ImportSource.authy, fixture('import_authy.json'));
      expect(r.accounts.map((a) => '${a.issuer}|${a.label}'), ['GitHub|octo@example.com', 'Discord|', 'Twitch|']);
      final twitch = r.accounts[2];
      expect([twitch.secret, twitch.digits, twitch.period], [base32Encode([0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x21, 0xde, 0xad, 0xbe, 0xef]), 7, 10]);
      expect(r.problems.single, '"Broken": has no secret');
    });

    test('a list of otpauth links', () async {
      final r = await parseImport(ImportSource.authy, fixture('import_authy.txt'));
      expect(r.accounts.map((a) => a.issuer), ['GitHub', 'Discord']);
      expect(r.problems, isEmpty);
    });
  });

  group('Bitwarden', () {
    test('JSON: codes in and logins without codes ignored', () async {
      final r = await parseImport(ImportSource.bitwarden, fixture('import_bitwarden.json'));
      expect(r.accounts.map((a) => '${a.issuer}|${a.label}|${a.domains}'),
          ['GitHub|octo@example.com|[github.com]', 'AWS|root|[console.aws.amazon.com]', 'Steam|gamer|[]']);
      expect(r.accounts[1].secret, 'ONSWG4TFOQYTEMZU');
      expect([r.accounts[2].type, r.accounts[2].secret], [OtpType.steam, 'MFRGGZDFMZTWQ2LK']);
      expect(r.problems, isEmpty);
    });

    test('encrypted JSON is refused with how to fix it', () async {
      await expectLater(parseImport(ImportSource.bitwarden, '{"encrypted":true,"items":[]}'),
          throwsA(isA<ImportException>().having((e) => e.message, 'message', contains('export again'))));
    });

    test('CSV, including quoted commas and line breaks', () async {
      final r = await parseImport(ImportSource.bitwarden, fixture('import_bitwarden.csv'));
      expect(r.accounts.map((a) => '${a.issuer}|${a.label}|${a.domains}'),
          ['GitHub|octo@example.com|[github.com]', 'Dropbox, Inc|demo@example.com|[dropbox.com]']);
      expect(r.problems.single, startsWith('"Bad secret" has a one-time code Tanooki Auth can\'t read'));
    });
  });

  test('1Password CSV', () async {
    final r = await parseImport(ImportSource.onePassword, fixture('import_1password.csv'));
    expect(r.accounts.map((a) => '${a.issuer}|${a.label}|${a.domains}'),
        ['GitHub|octo@example.com|[github.com]', 'Discord|tanooki|[discord.com]']);
    expect(r.problems, isEmpty);
    await expectLater(parseImport(ImportSource.onePassword, 'Title,Url\nx,y\n'),
        throwsA(isA<ImportException>().having((e) => e.message, 'message', contains('no one-time code column'))));
  });

  group('Apple Passwords CSV', () {
    test('accounts with a code come in with tidy names; passwords without one are ignored', () async {
      final r = await parseImport(ImportSource.applePasswords, fixture('import_apple_passwords.csv'));
      expect(r.accounts.map((a) => '${a.issuer}|${a.label}|${a.domains}'),
          ['GitHub|octo@example.com|[github.com]', 'Discord|tanooki|[discord.com]', 'Steam|gamer|[store.steampowered.com]']);
      expect(r.accounts[2].type, OtpType.steam);
      expect(r.problems, isEmpty);
    });

    test('the OTPAuth column is found whatever its capitals', () async {
      final r = await parseImport(ImportSource.applePasswords,
          'title,url,username,password,notes,otpauth\nGitHub,https://github.com,octo,pw,,otpauth://totp/x?secret=JBSWY3DPEHPK3PXP\n');
      expect(r.accounts.single.secret, 'JBSWY3DPEHPK3PXP');
      await expectLater(parseImport(ImportSource.applePasswords, 'Title,URL,Username,Password,Notes\nx,y,z,w,\n'),
          throwsA(isA<ImportException>().having((e) => e.message, 'message', contains('Apple Passwords'))));
    });
  });

  test('pasting many links: good ones in, bad ones reported by line', () {
    final r = parseOtpauthLines('otpauth://totp/A:a?secret=JBSWY3DPEHPK3PXP\n\n'
        'https://example.com\notpauth://totp/B:b\r\notpauth://totp/C:c?secret=GEZDGNBVGY3TQOJQ&issuer=C\n');
    expect(r.accounts.map((a) => a.issuer), ['A', 'C']);
    expect(r.problems, ['Line 3: That is not an otpauth:// link.', 'Line 4: The link has no secret.']);
  });

  test('CSV parser', () {
    expect(parseCsv('a,"b,c","d ""e"""\r\n\n1,2,3'), [
      ['a', 'b,c', 'd "e"'],
      ['1', '2', '3'],
    ]);
  });
}
