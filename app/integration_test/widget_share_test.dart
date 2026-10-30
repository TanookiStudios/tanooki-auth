import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/widget_share.dart';
import 'package:tanooki_auth/main.dart';

// Phones only. Run with: flutter test integration_test/widget_share_test.dart -d <device> --dart-define=TA_STORAGE=itest
// Checks that the favorites copy the widgets/watch read, and the native (Swift/Kotlin) code generator, give the
// same codes as the app. Leaves one favorite shared, so a paired watch simulator can be checked afterwards.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const native = MethodChannel('tanooki/extras');

  Future<List<List<String>>> widgetCodes() async => [
        for (final row in (await native.invokeListMethod<List<Object?>>('debugWidgetCodes'))!) row.cast<String>(),
      ];

  testWidgets('widgets get favorites only while sharing is on, with the app\'s codes', (t) async {
    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault; pass --dart-define=TA_STORAGE=itest');
    final v = await openVault();
    await v.resetToEmpty();
    v.accounts.addAll([
      Account(id: 'w1', issuer: 'Widget Test', label: 'me', secret: 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ', favorite: true),
      Account(id: 'w2', issuer: 'Not a favorite', secret: 'JBSWY3DPEHPK3PXP'),
    ]);
    await v.save();
    await publishSharedFavorites(v);
    expect(await widgetCodes(), isEmpty, reason: 'sharing is off by default');

    v.settings[shareCodesKey] = true;
    await v.save();
    await publishSharedFavorites(v);
    // Avoid comparing across a code change.
    while (DateTime.now().second % 30 > 27) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    final app = v.accounts.first.codeAt(DateTime.now());
    expect(await widgetCodes(), [
      ['Widget Test', app],
    ]);
    // ignore: avoid_print
    print('TA_PHONE_CODE ${DateTime.now().millisecondsSinceEpoch ~/ 1000} Widget Test=$app');
    // Give WatchConnectivity / the Wear Data Layer time to hand the list to a paired watch.
    await Future<void>.delayed(const Duration(seconds: 8));
  }, skip: !(Platform.isIOS || Platform.isAndroid));
}
