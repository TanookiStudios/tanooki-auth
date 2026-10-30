// Writes lib/core/guides_data.dart from the website's guide list (site/guides/data.json).
// Run from app/ whenever a guide is added or renamed:  dart run tool/make_guides.dart
// test/guides_test.dart fails if the two ever differ.
import 'dart:convert';
import 'dart:io';

const dataPath = '../site/guides/data.json';
const outPath = 'lib/core/guides_data.dart';

String guidesDartSource(String json) {
  String q(Object? s) => "'${'$s'.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$')}'";
  final rows = [
    for (final g in jsonDecode(json) as List)
      "  (slug: ${q(g['slug'])}, name: ${q(g['name'])}, domain: ${q(g['domain'])}),",
  ];
  return '''
// Made by tool/make_guides.dart from site/guides/data.json. Don't edit by hand: change data.json and run
// `dart run tool/make_guides.dart` from app/. test/guides_test.dart fails if this is out of date.
const guideData = <({String slug, String name, String domain})>[
${rows.join('\n')}
];
''';
}

void main() {
  File(outPath).writeAsStringSync(guidesDartSource(File(dataPath).readAsStringSync()));
  stdout.writeln('Wrote $outPath');
}
