import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/breaches.dart';

const sample = '''[
 {"Name":"Adobe","Title":"Adobe","Domain":"adobe.com","BreachDate":"2013-10-04","DataClasses":["Email addresses","Passwords"],"IsFabricated":false,"IsSpamList":false},
 {"Name":"Fake","Title":"Fake","Domain":"github.com","BreachDate":"2020-01-01","IsFabricated":true},
 {"Name":"Spam","Title":"Spam list","Domain":"dropbox.com","BreachDate":"2020-01-01","IsSpamList":true},
 {"Name":"NoDomain","Title":"Collection","Domain":"","BreachDate":"2019-01-01"},
 {"Name":"Dropbox","Title":"Dropbox","Domain":"dropbox.com","BreachDate":"2012-07-01"}
]''';

void main() {
  Account acct(String issuer, List<String> domains, {DateTime? deletedAt}) =>
      Account(id: issuer, issuer: issuer, secret: 'JBSWY3DPEHPK3PXP', domains: domains, deletedAt: deletedAt);

  test('fetch is a plain GET of the public list, through the injected fetcher', () async {
    Uri? asked;
    final list = await fetchBreaches(fetch: (url) async {
      asked = url;
      return sample;
    });
    expect(asked.toString(), 'https://haveibeenpwned.com/api/v3/breaches');
    expect(asked!.query, isEmpty, reason: 'nothing about the user is sent');
    expect(list.map((b) => b.name), ['Adobe', 'Dropbox'], reason: 'fabricated, spam and domainless entries dropped');
  });

  test('matches saved domains and their subdomains only', () {
    final matches = matchBreaches(parseBreaches(sample), [
      acct('Adobe', ['login.adobe.com']),
      acct('Lookalike', ['notadobe.com']),
      acct('Dropbox', ['www.dropbox.com']),
      acct('GitHub', ['github.com']),
      acct('Old Dropbox', ['dropbox.com'], deletedAt: DateTime.now()),
      acct('No site', []),
    ]);
    expect(matches.map((m) => '${m.account.issuer}:${m.breach.name}'), ['Adobe:Adobe', 'Dropbox:Dropbox']);
  });

  test('a failed fetch is an error, not an empty list', () async {
    await expectLater(fetchBreaches(fetch: (_) async => throw Exception('offline')), throwsException);
  });
}
