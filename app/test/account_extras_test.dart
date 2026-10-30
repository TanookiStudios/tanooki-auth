import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/backup.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/brand_icon.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late File file;
  late MemoryKeyStore keys;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('extras_test');
    file = File('${dir.path}/vault.json');
    keys = MemoryKeyStore()..value = base64.encode(List.filled(32, 9));
  });
  tearDown(() => dir.deleteSync(recursive: true));

  Future<void> writeVault(String body) async =>
      file.writeAsStringSync(await Vault.seal(base64.decode(keys.value!), utf8.encode(body)));

  test('a vault saved by 0.1.0 loads, with every new field defaulted', () async {
    await writeVault(File('test/fixtures/vault_v0_1_0.json').readAsStringSync());
    final v = Vault(file, keys);
    await v.load();
    expect(v.accounts.map((a) => a.issuer), ['GitHub', 'Bank']);
    final a = v.accounts.first;
    expect(a.secret, 'JBSWY3DPEHPK3PXP');
    expect(a.domains, ['github.com']);
    expect(a.favorite, isFalse);
    expect(a.tags, isEmpty);
    expect(a.notes, '');
    expect(a.recoveryCodes, isEmpty);
    expect(a.lastUsedAt, isNull);
    expect(a.iconDomain, isNull);
    expect(a.deletedAt, isNull);
    expect([a.folder, a.color, a.emoji, a.requireAuth, a.travelHidden], [null, null, null, false, false]);
    expect(v.accounts[1].counter, 3);
    expect(v.settings['theme'], 'dark');
    expect(v.live, hasLength(2));
  });

  test('a vault from before Phase A (no folder, color, emoji, requireAuth, travelHidden) loads with defaults', () async {
    await writeVault(File('test/fixtures/vault_before_phase_a.json').readAsStringSync());
    final v = Vault(file, keys);
    await v.load();
    expect(v.accounts.map((a) => a.issuer), ['GitHub', 'Bank']);
    for (final a in v.accounts) {
      expect([a.folder, a.color, a.emoji, a.requireAuth, a.travelHidden], [null, null, null, false, false]);
    }
    final gh = v.accounts.first;
    expect([gh.favorite, gh.tags, gh.notes, gh.domains], [true, ['work'], 'main', ['github.com']]);
    expect(gh.updatedAt, DateTime.utc(2026, 10, 28, 9));
    expect([v.accounts[1].type, v.accounts[1].counter], [OtpType.hotp, 12]);
    // The old "Recently used first" switch still means the same thing under the new sort setting.
    expect(sortOf(v.settings), 'recent');
  });

  test('Phase A fields survive a save and load, and an old vault saves them once set', () async {
    await writeVault(File('test/fixtures/vault_before_phase_a.json').readAsStringSync());
    final v = Vault(file, keys);
    await v.load();
    v.accounts.first
      ..folder = 'Work'
      ..color = 0xFF3366CC
      ..emoji = '🐙'
      ..requireAuth = true
      ..travelHidden = true;
    v.accounts.add(parseOtpauthUri('steam://MFRGGZDFMZTWQ2LK'));
    await v.save();
    final v2 = Vault(file, keys);
    await v2.load();
    final a = v2.accounts.first;
    expect([a.folder, a.color, a.emoji, a.requireAuth, a.travelHidden], ['Work', 0xFF3366CC, '🐙', true, true]);
    expect([v2.accounts[1].folder, v2.accounts[1].requireAuth], [null, false]);
    expect([v2.accounts[2].type, v2.accounts[2].digits], [OtpType.steam, 5]);
  });

  test('new fields survive a save and load', () async {
    final v = Vault(file, keys);
    await writeVault('{"accounts":[],"settings":{}}');
    await v.load();
    final used = DateTime.utc(2026, 10, 29, 8);
    v.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP')
      ..favorite = true
      ..tags.addAll(['work', 'code'])
      ..notes = 'Main account'
      ..recoveryCodes.addAll([RecoveryCode('aaaa-bbbb'), RecoveryCode('cccc-dddd', used: true)])
      ..lastUsedAt = used
      ..iconDomain = 'github.com');
    await v.save();

    final v2 = Vault(file, keys);
    await v2.load();
    final a = v2.accounts.single;
    expect(a.favorite, isTrue);
    expect(a.tags, ['work', 'code']);
    expect(a.notes, 'Main account');
    expect([for (final r in a.recoveryCodes) '${r.code}:${r.used}'], ['aaaa-bbbb:false', 'cccc-dddd:true']);
    expect(a.lastUsedAt, used);
    expect(a.iconDomain, 'github.com');
    expect(a.deletedAt, isNull);
  });

  test('trash: hidden from live, purged after 30 days on load', () async {
    final now = DateTime.utc(2026, 10, 29);
    final v = Vault(file, keys);
    await writeVault('{"accounts":[],"settings":{}}');
    await v.load();
    Account acct(String name, int? daysAgo) =>
        parseOtpauthUri('otpauth://totp/$name?secret=JBSWY3DPEHPK3PXP&issuer=$name')
          ..deletedAt = daysAgo == null ? null : now.subtract(Duration(days: daysAgo));
    v.accounts.addAll([acct('Kept', null), acct('Recent', 29), acct('Old', 31)]);
    await v.save();
    expect(v.live.map((a) => a.issuer), ['Kept']);
    expect(v.trash.map((a) => a.issuer), ['Recent', 'Old']);

    final v2 = Vault(file, keys);
    await v2.load(now: now);
    expect(v2.accounts.map((a) => a.issuer), ['Kept', 'Recent']);
    // The purge was written to disk, not just dropped from memory.
    final v3 = Vault(file, keys);
    await v3.load(now: now);
    expect(v3.accounts.map((a) => a.issuer), ['Kept', 'Recent']);
  });

  test('home order: favorites first, then recently used when turned on, else user order', () {
    Account acct(String name, {bool fav = false, int? usedMin, bool trashed = false}) => Account(
          id: name,
          issuer: name,
          secret: 'JBSWY3DPEHPK3PXP',
          favorite: fav,
          lastUsedAt: usedMin == null ? null : DateTime.utc(2026, 1, 1, 0, usedMin),
          deletedAt: trashed ? DateTime.utc(2026) : null,
        );
    final list = [
      acct('A'),
      acct('B', usedMin: 5),
      acct('C', fav: true),
      acct('D', usedMin: 9),
      acct('E', fav: true, usedMin: 1),
      acct('F', trashed: true),
      acct('G'),
    ];
    String names(List<Account> l) => l.map((a) => a.issuer).join();
    expect(names(homeOrder(list)), 'CEABDG');
    expect(names(homeOrder(list, sort: 'recent')), 'ECDBAG');
  });

  test('recovery codes: pasted lists split by line, comma or column; numbering dropped', () {
    final codes = RecoveryCode.parseList('1. abcd-efgh\n2) 1234 5678\n\n  wxyz-0000, qqqq-rrrr\nAAAA\tBBBB');
    expect(codes.map((r) => r.code), ['abcd-efgh', '1234 5678', 'wxyz-0000', 'qqqq-rrrr', 'AAAA', 'BBBB']);
    expect(codes.every((r) => !r.used), isTrue);
  });

  test('importing an account that is in Trash replaces the trashed copy', () {
    final trashed = parseOtpauthUri('otpauth://totp/x?secret=JBSWY3DPEHPK3PXP')..deletedAt = DateTime.now();
    final into = [trashed];
    final again = parseOtpauthUri('otpauth://totp/x?secret=JBSWY3DPEHPK3PXP');
    expect(mergeAccounts(into, [again]), (1, 0));
    expect(into.single, same(again));
    expect(mergeAccounts(into, [parseOtpauthUri('otpauth://totp/y?secret=JBSWY3DPEHPK3PXP')]), (0, 1));
  });

  test('every bundled logo parses and draws on the 24x24 grid', () {
    final icons = parseBrandIcons(File('assets/brand_icons/icons.json').readAsStringSync());
    expect(icons.length, greaterThan(100));
    for (final e in icons.entries) {
      final b = parseSvgPath(e.value.path).getBounds(); // includes curve control points, hence the slack
      expect(b.width, greaterThan(4), reason: e.key);
      expect(b.left >= -6 && b.top >= -6 && b.right <= 30 && b.bottom <= 30 && (b.center - const Offset(12, 12)).distance < 4, isTrue, reason: '${e.key} $b');
    }
    brandIcons = icons;
    Account a({String issuer = '', List<String> domains = const [], String? icon}) =>
        Account(id: 'x', issuer: issuer, secret: 'JBSWY3DPEHPK3PXP', domains: [...domains], iconDomain: icon);
    expect(brandIconFor(a(domains: ['github.com']))?.title, 'GitHub');
    expect(brandIconFor(a(domains: ['accounts.google.com']))?.title, 'Google');
    expect(brandIconFor(a(issuer: 'Discord'))?.title, 'Discord');
    expect(brandIconFor(a(issuer: 'Discord', icon: 'github.com'))?.title, 'GitHub');
    expect(brandIconFor(a(issuer: 'My Tiny Bank')), isNull);
  });
}
