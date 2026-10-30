// Not the app. A tiny Mac program built only by `scripts/release-mac.sh --probe-icloud` and signed exactly
// like the real download, to prove a Developer ID build can open iCloud Drive. It never opens a vault.
// Exit code 0: iCloud folder works (wrote, read back, deleted a file). Anything else: the reason is printed.
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tanooki_auth/core/sync/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final problem = await ICloudFolder.problem();
  if (problem != null) {
    stdout.writeln('ICLOUD-PROBE FAIL $problem');
    exit(2);
  }
  final f = ICloudFolder();
  final name = 'probe-${DateTime.now().millisecondsSinceEpoch}.txt';
  try {
    await f.write(name, 'hello');
    final back = await f.read(name);
    await f.delete(name);
    final ok = back == 'hello';
    stdout.writeln('ICLOUD-PROBE ${ok ? 'OK' : 'FAIL read back "$back"'}');
    exit(ok ? 0 : 3);
  } catch (e) {
    stdout.writeln('ICLOUD-PROBE FAIL $e');
    exit(4);
  }
}
