import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tanooki_auth/main.dart';
import 'package:tanooki_auth/ui/app_icon.dart';

// Phones only. Run with: flutter test integration_test/app_icon_test.dart -d <device> --dart-define=TA_STORAGE=itest
// Switches the real home-screen icon through the native code and reads it back from the system.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> expectIcon(String id) async {
    final until = DateTime.now().add(const Duration(seconds: 15));
    while (await currentAppIcon(await openVault()) != id && DateTime.now().isBefore(until)) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    expect(await currentAppIcon(await openVault()), id);
  }

  // A plain test, not testWidgets: iOS's alert turns on accessibility, which testWidgets reports as a leak.
  test('app icon switches and reads back on the device', () async {
    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault; pass --dart-define=TA_STORAGE=itest');
    final v = await openVault();
    if (Platform.isIOS) {
      // iOS shows its own "You have changed the icon" alert, and both finishing the call and reading the icon
      // back wait until someone taps OK. So an unattended run starts a switch, and the NEXT run (a fresh
      // launch) checks the system kept it. Install once and launch twice (flutter test reinstalls, which resets
      // the icon): flutter build ios --simulator --debug -t integration_test/app_icon_test.dart
      // --dart-define=TA_STORAGE=itest, then xcrun simctl install + simctl launch --console, twice.
      final now = await currentAppIcon(v);
      final marker = File('${v.file.parent.path}/itest_app_icon.txt');
      final asked = marker.existsSync() ? marker.readAsStringSync() : null;
      if (asked != null) expect(now, asked, reason: 'the switch the previous run asked for did not stick');
      final want = now == 'pink' ? 'midnight' : 'pink';
      marker
        ..parent.createSync(recursive: true)
        ..writeAsStringSync(want);
      Object? failed;
      unawaited(setAppIcon(v, want).catchError((Object e) => failed = e));
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(failed, isNull);
      // ignore: avoid_print
      print('app icon: was $now${asked != null ? ' (as the last run asked)' : ''}, asked for $want');
      return;
    }
    for (final id in ['pink', 'midnight', 'default']) {
      await setAppIcon(v, id);
      await expectIcon(id);
    }
  });
}
