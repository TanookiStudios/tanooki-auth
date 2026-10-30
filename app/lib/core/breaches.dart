import 'dart:convert';
import 'dart:io';

import 'account.dart';
import 'otpauth_uri.dart';

/// The public list of known data breaches. No key, no account data: a plain GET of the whole list.
/// This (when the user turns breach alerts on) is the app's only internet request besides sync and purchases.
final breachesUrl = Uri.parse('https://haveibeenpwned.com/api/v3/breaches');

typedef BreachFetch = Future<String> Function(Uri url);

class Breach {
  Breach({required this.name, required this.title, required this.domain, required this.breachDate, this.dataClasses = const []});
  final String name, title, domain;
  final DateTime? breachDate;
  final List<String> dataClasses;
}

class BreachMatch {
  BreachMatch(this.breach, this.account);
  final Breach breach;
  final Account account;
}

/// Downloads and reads the list. [fetch] is swapped out in tests.
Future<List<Breach>> fetchBreaches({BreachFetch fetch = _httpGet}) async => parseBreaches(await fetch(breachesUrl));

List<Breach> parseBreaches(String json) => [
      for (final b in (jsonDecode(json) as List).whereType<Map>())
        // Fabricated and spam-list "breaches" aren't a reason to change a password.
        if (b['IsFabricated'] != true && b['IsSpamList'] != true && '${b['Domain'] ?? ''}'.isNotEmpty)
          Breach(
            name: '${b['Name']}',
            title: '${b['Title'] ?? b['Name']}',
            domain: normalizeDomain('${b['Domain']}'),
            breachDate: DateTime.tryParse('${b['BreachDate']}'),
            dataClasses: [for (final d in (b['DataClasses'] as List? ?? const [])) '$d'],
          ),
    ];

/// Saved accounts whose website (or a subdomain of it) appears in a breach. Trash is ignored.
List<BreachMatch> matchBreaches(List<Breach> breaches, Iterable<Account> accounts) {
  final byDomain = <String, List<Breach>>{};
  for (final b in breaches) {
    byDomain.putIfAbsent(b.domain, () => []).add(b);
  }
  final out = <BreachMatch>[];
  for (final a in accounts.where((a) => !a.trashed)) {
    final seen = <String>{};
    for (final d in {...a.domains, if (a.iconDomain != null) a.iconDomain!}.map(normalizeDomain)) {
      // "login.adobe.com" matches a breach of "adobe.com"; "notadobe.com" doesn't.
      final parts = d.split('.');
      for (var i = 0; i < parts.length - 1; i++) {
        for (final b in byDomain[parts.sublist(i).join('.')] ?? const <Breach>[]) {
          if (seen.add(b.name)) out.add(BreachMatch(b, a));
        }
      }
    }
  }
  return out;
}

Future<String> _httpGet(Uri url) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
  try {
    final req = await client.getUrl(url);
    req.headers.set(HttpHeaders.userAgentHeader, 'Tanooki-Auth'); // HIBP refuses requests without one
    final res = await req.close();
    if (res.statusCode != 200) throw HttpException('Breach list answered ${res.statusCode}', uri: url);
    return await res.transform(utf8.decoder).join();
  } finally {
    client.close();
  }
}
