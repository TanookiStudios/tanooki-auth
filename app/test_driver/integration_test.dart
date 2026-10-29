import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

// Saves screenshots taken by integration_test/screenshots_test.dart into build/screenshots/<SHOTS_DEVICE>/.
Future<void> main() => integrationDriver(
      onScreenshot: (name, bytes, [args]) async {
        final dir = Directory('build/screenshots/${Platform.environment['SHOTS_DEVICE'] ?? 'device'}')
          ..createSync(recursive: true);
        File('${dir.path}/$name.png').writeAsBytesSync(bytes);
        return true;
      },
    );
