import 'account.dart';

/// Brand names whose capitals can't be guessed from the domain.
const _knownNames = {
  'github': 'GitHub',
  'gitlab': 'GitLab',
  'paypal': 'PayPal',
  'linkedin': 'LinkedIn',
  'youtube': 'YouTube',
  'dropbox': 'Dropbox',
  'icloud': 'iCloud',
  'appleid': 'Apple',
  'live': 'Microsoft',
  'outlook': 'Microsoft',
  'microsoftonline': 'Microsoft',
  'amazonaws': 'AWS',
  'aws': 'AWS',
  'npmjs': 'npm',
  'digitalocean': 'DigitalOcean',
  'cloudflare': 'Cloudflare',
  'wordpress': 'WordPress',
  'coinbase': 'Coinbase',
  'tiktok': 'TikTok',
  'x': 'X',
  'ea': 'EA',
  'twitch': 'Twitch',
  'epicgames': 'Epic Games',
  'playstation': 'PlayStation',
  'bitwarden': 'Bitwarden',
  '1password': '1Password',
  'protonmail': 'Proton',
  'proton': 'Proton',
};

final _domain = RegExp(r'^(?:[a-z][a-z0-9+.-]*://)?(?:www\.)?((?:[a-z0-9-]+\.)+([a-z]{2,}))(?:[:/?#].*)?$', caseSensitive: false);
// Only these endings count as a web address, so "john.doe" or "Node.js" stay as typed.
const _tlds = {
  'com', 'net', 'org', 'io', 'dev', 'app', 'co', 'me', 'us', 'uk', 'de', 'fr', 'ca', 'au', 'nz', 'ie', 'gg', 'tv', 'ai',
  'xyz', 'info', 'biz', 'edu', 'gov', 'eu', 'nl', 'jp', 'es', 'it', 'se', 'no', 'dk', 'fi', 'ch', 'at', 'be', 'pl', 'br',
  'in', 'cloud', 'so', 'sh', 'to', 'cc', 'ly', 'fm', 'gl', 'im', 'ru', 'cn', 'kr', 'mx',
};
// Second-level parts that are really part of the country ending, as in "bbc.co.uk".
const _countrySecond = {'co', 'com', 'org', 'net', 'gov', 'ac'};

/// The web address in [s] ("https://www.github.com/login" -> "github.com"), or null when it isn't one.
String? domainIn(String s) {
  final m = _domain.firstMatch(s.trim());
  return m == null || !_tlds.contains(m.group(2)!.toLowerCase()) ? null : m.group(1)!.toLowerCase();
}

/// "google.com" / "https://accounts.google.com/x" -> "Google". Null when [s] isn't a web address.
String? _brandFromDomain(String s, String? Function(String domain)? brandName) {
  final m = _domain.firstMatch(s.trim());
  if (m == null || !_tlds.contains(m.group(2)!.toLowerCase())) return null;
  final host = m.group(1)!.toLowerCase();
  final parts = host.split('.');
  // Bundled logo titles know the right spelling; try the full host and each parent ("accounts.google.com", "google.com").
  for (var i = 0; i < parts.length - 1; i++) {
    final hit = brandName?.call(parts.sublist(i).join('.'));
    if (hit != null && hit.isNotEmpty) return hit;
  }
  var at = parts.length - 2;
  if (at > 0 && _countrySecond.contains(parts[at]) && parts.last.length == 2) at--;
  final word = parts[at];
  return _knownNames[word] ?? word[0].toUpperCase() + word.substring(1);
}

String _squash(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

/// Cleans up the messy names other apps and websites leave behind, without inventing anything:
/// "google.com:maddie@gmail.com (Personal)" -> issuer "Google", label "maddie@gmail.com".
/// Pure and idempotent: running it on its own output changes nothing.
({String issuer, String label}) tidyName(String issuer, String label, {String? Function(String domain)? brandName}) {
  var i = _squash(issuer), l = _squash(label);
  // A trailing note in brackets, as password managers add: "(Personal)", "(maddie@x.com)" when it repeats.
  String dropNote(String s) {
    final m = RegExp(r'^(.*\S)\s*\(([^()]*)\)$').firstMatch(s);
    return m == null ? s : m.group(1)!.trim();
  }

  // Apple Passwords and others: "github.com (maddie@x.com)" as the title, with the login in the label.
  final userInIssuer = RegExp(r'^(.*\S)\s*\(([^()]*@[^()]*)\)$').firstMatch(i);
  if (userInIssuer != null) {
    if (l.isEmpty) l = userInIssuer.group(2)!.trim();
    i = userInIssuer.group(1)!.trim();
  }
  i = dropNote(i);
  i = _brandFromDomain(i, brandName) ?? i;
  // "Issuer:label" or "Issuer: label" packed into the label.
  final colon = l.indexOf(':');
  if (colon > 0 && !l.contains('://')) {
    final before = l.substring(0, colon).trim(), after = l.substring(colon + 1).trim();
    if (after.isNotEmpty && (i.isEmpty || before.toLowerCase() == i.toLowerCase() || _brandFromDomain(before, brandName) != null)) {
      if (i.isEmpty) i = _brandFromDomain(before, brandName) ?? before;
      l = after;
    }
  }
  l = dropNote(l);
  // A label that just repeats the issuer adds nothing: "GitHub" / "GitHub" -> "GitHub" / "".
  if (i.isNotEmpty && l.toLowerCase() == i.toLowerCase()) l = '';
  if (i.isEmpty && l.isNotEmpty) {
    final brand = _brandFromDomain(l, brandName);
    if (brand != null) (i, l) = (brand, '');
  }
  if (i.isEmpty && l.isEmpty) return (issuer: _squash(issuer), label: _squash(label));
  return (issuer: i, label: l);
}

/// Runs [tidyName] over freshly imported accounts, in place. A web address that was the name is kept as
/// the account's website, so the browser extension still matches it.
void tidyAll(Iterable<Account> accounts, {String? Function(String domain)? brandName}) {
  for (final a in accounts) {
    final site = domainIn(a.issuer.replaceFirst(RegExp(r'\s*\(.*\)$'), '')) ??
        (a.issuer.isEmpty ? domainIn(a.label.split(':').first) : null);
    if (site != null && a.domains.isEmpty) a.domains.add(site.startsWith('www.') ? site.substring(4) : site);
    final t = tidyName(a.issuer, a.label, brandName: brandName);
    a
      ..issuer = t.issuer
      ..label = t.label;
  }
}
