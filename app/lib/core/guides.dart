import 'guides_data.dart';

typedef Guide = ({String slug, String name, String domain});

const guidesIndexUrl = 'https://auth.tanookistudios.com/guides/';
String guideUrl(Guide g) => '$guidesIndexUrl${g.slug}/';

/// The guides the first-run tour suggests: email, social and money, the accounts most worth protecting first.
List<Guide> get starterGuides => [for (final s in ['google', 'facebook', 'paypal']) guideData.firstWhere((g) => g.slug == s)];

String _flat(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

/// The website's 2FA guide for an account, matched by its website first, then by its service name.
Guide? guideFor(String issuer, Iterable<String> domains) {
  for (final g in guideData) {
    if (domains.any((d) => d == g.domain || d.endsWith('.${g.domain}'))) return g;
  }
  final i = _flat(issuer);
  if (i.isEmpty) return null;
  for (final g in guideData) {
    if (i == _flat(g.name) || i == _flat(g.slug) || i == _flat(g.domain.split('.').first)) return g;
  }
  return null;
}
