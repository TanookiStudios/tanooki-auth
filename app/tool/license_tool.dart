// Makes Tanooki Auth Premium license keys. Pure Dart (no Flutter), so run with `dart run`:
//   dart run tool/license_tool.dart init            # once: creates the signing key outside the repo
//   dart run tool/license_tool.dart issue <orderId> [seats] # prints a license key; seats 5 = family plan
// The private key lives in ~/.tanooki-auth-signing/license_ed25519.json and must never be committed.
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

final _keyFile = File('${Platform.environment['HOME']}/.tanooki-auth-signing/license_ed25519.json');

Future<void> main(List<String> args) async {
  final algo = Ed25519();
  if (args.isEmpty) {
    stderr.writeln('usage: init | issue <orderId> [seats]');
    exit(64);
  }
  if (args.first == 'init') {
    if (_keyFile.existsSync()) {
      stderr.writeln('Refusing to overwrite ${_keyFile.path}: every key already sold depends on it.');
      exit(1);
    }
    final pair = await algo.newKeyPair();
    final seed = await pair.extractPrivateKeyBytes();
    final pub = (await pair.extractPublicKey()).bytes;
    _keyFile.parent.createSync(recursive: true);
    _keyFile.writeAsStringSync(jsonEncode({'seed': base64.encode(seed), 'public': base64.encode(pub)}));
    await Process.run('chmod', ['600', _keyFile.path]);
    stdout.writeln('Public key (paste into lib/core/license.dart): ${base64.encode(pub)}');
    return;
  }
  if (args.first == 'issue' && (args.length == 2 || args.length == 3)) {
    final seats = args.length == 3 ? int.parse(args[2]) : 1;
    final k = jsonDecode(_keyFile.readAsStringSync()) as Map<String, dynamic>;
    final pair = await algo.newKeyPairFromSeed(base64.decode(k['seed'] as String));
    final now = DateTime.now().toUtc();
    final payload = utf8.encode('1|${args[1]}|${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${seats > 1 ? '|$seats' : ''}');
    final sig = await algo.sign(payload, keyPair: pair);
    String b(List<int> x) => base64Url.encode(x).replaceAll('=', '');
    stdout.writeln('TA1.${b(payload)}.${b(sig.bytes)}');
    return;
  }
  stderr.writeln('usage: init | issue <orderId> [seats]');
  exit(64);
}
