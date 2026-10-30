import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/tidy.dart';

String t(String issuer, String label, {String? Function(String)? brand}) {
  final r = tidyName(issuer, label, brandName: brand);
  return '${r.issuer}|${r.label}';
}

void main() {
  test('the example from the plan', () {
    expect(t('', 'google.com:maddie@gmail.com (Personal)'), 'Google|maddie@gmail.com');
  });

  test('already tidy names are left alone', () {
    for (final (i, l) in [
      ('GitHub', 'octo@example.com'),
      ('Discord', ''),
      ('', 'just-a-label'),
      ('Node.js', 'me'),
      ('Proton', 'me@proton.me'),
      ('Steam', 'gamer'),
      ('My Bank', 'card 1'),
    ]) {
      expect(t(i, l), '$i|$l', reason: '$i / $l');
    }
  });

  test('web addresses become the site name', () {
    expect(t('google.com', 'me'), 'Google|me');
    expect(t('https://www.github.com/login', 'octo'), 'GitHub|octo');
    expect(t('accounts.google.com', 'me'), 'Google|me');
    expect(t('bbc.co.uk', 'me'), 'Bbc|me');
    expect(t('paypal.com', 'me'), 'PayPal|me');
    expect(t('x.com', 'me'), 'X|me');
    expect(t('', 'discord.com'), 'Discord|');
  });

  test('bundled brand names win over guessing', () {
    String? brand(String d) => {'linkedin.com': 'LinkedIn', 'npmjs.com': 'npm'}[d];
    expect(t('www.linkedin.com', 'me', brand: brand), 'LinkedIn|me');
    expect(t('registry.npmjs.com', 'me', brand: brand), 'npm|me');
    expect(t('unknown-site.io', 'me', brand: brand), 'Unknown-site|me');
  });

  test('"Issuer:label" packed into the label is split', () {
    expect(t('', 'GitHub:octo'), 'GitHub|octo');
    expect(t('', 'GitHub: octo'), 'GitHub|octo');
    expect(t('GitHub', 'GitHub:octo'), 'GitHub|octo');
    expect(t('Work', 'Other:thing'), 'Work|Other:thing'); // different issuer: not ours to guess
  });

  test('password-manager titles like "github.com (octo@example.com)"', () {
    expect(t('github.com (octo@example.com)', ''), 'GitHub|octo@example.com');
    expect(t('github.com (octo@example.com)', 'octo@example.com'), 'GitHub|octo@example.com');
    expect(t('Google (Work)', 'me@x.com'), 'Google|me@x.com');
  });

  test('a label that repeats the issuer is dropped', () {
    expect(t('GitHub', 'GitHub'), 'GitHub|');
    expect(t('Discord', 'discord'), 'Discord|');
  });

  test('extra spaces are squashed', () {
    expect(t('  GitHub  ', '  octo   cat '), 'GitHub|octo cat');
  });

  test('things that only look like addresses stay as typed', () {
    expect(t('', 'john.doe'), '|john.doe');
    expect(t('Ruby', 'me@ruby.lang'), 'Ruby|me@ruby.lang');
    expect(t('', 'maddie@gmail.com'), '|maddie@gmail.com');
  });

  test('never empties a name completely', () {
    expect(t('', ''), '|');
    expect(t('', '(Personal)'), '|(Personal)');
  });

  test('running it twice changes nothing more (idempotent)', () {
    for (final (i, l) in [
      ('', 'google.com:maddie@gmail.com (Personal)'),
      ('github.com (octo@example.com)', ''),
      ('https://www.github.com/login', 'GitHub:octo'),
      ('Google (Work)', 'me (main)'),
      ('', 'discord.com'),
    ]) {
      final once = tidyName(i, l);
      expect(t(once.issuer, once.label), '${once.issuer}|${once.label}', reason: '$i / $l');
    }
  });

  test('tidyAll keeps the web address as the account\'s website', () {
    final a = Account(id: '1', issuer: '', label: 'google.com:maddie@gmail.com (Personal)', secret: 'JBSWY3DPEHPK3PXP');
    final b = Account(id: '2', issuer: 'github.com (octo@example.com)', label: '', secret: 'JBSWY3DPEHPK3PXP', domains: ['github.com']);
    tidyAll([a, b]);
    expect([a.issuer, a.label, a.domains], ['Google', 'maddie@gmail.com', ['google.com']]);
    expect([b.issuer, b.label, b.domains], ['GitHub', 'octo@example.com', ['github.com']]);
  });
}
