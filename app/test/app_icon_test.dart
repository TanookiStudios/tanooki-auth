import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/ui/app_icon.dart';

/// Every app icon id in lib/ui/app_icon.dart needs files on each platform; a missing one would make the
/// switch fail on a phone (or leave a blank launcher icon), so check them all here.
void main() {
  final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
  final kotlin = File('android/app/src/main/kotlin/com/tanookistudios/tanooki_auth/MainActivity.kt').readAsStringSync();
  const res = 'android/app/src/main/res';

  test('pastel pink and pastel blue come first', () {
    expect(appIcons.keys.take(3), ['default', 'pink', 'blue']);
    expect(appIcons.length, greaterThanOrEqualTo(7));
  });

  for (final id in appIcons.keys) {
    test('icon "$id" has every platform file', () {
      expect(File(appIconAsset(id)).existsSync(), isTrue, reason: 'picker preview / Dock image');
      expect(manifest, contains('android:name=".AppIcon_$id"'));
      expect(kotlin, contains('"$id"'));
      if (id == 'default') return;
      expect(File('ios/Runner/Assets.xcassets/AppIcon-$id.appiconset/icon.png').existsSync(), isTrue);
      expect(File('$res/mipmap-anydpi-v26/ic_launcher_$id.xml').existsSync(), isTrue);
      expect(File('$res/drawable-nodpi/ic_launcher_${id}_foreground.png').existsSync(), isTrue);
      expect(File('$res/mipmap-xxxhdpi/ic_launcher_$id.png').existsSync(), isTrue);
      expect(File('$res/values/app_icon_colors.xml').readAsStringSync(), contains('ic_launcher_${id}_background'));
    });
  }

  test('exactly one launcher alias is on at install, and it is the default', () {
    final aliases = RegExp(r'<activity-alias([\s\S]*?)</activity-alias>').allMatches(manifest).map((m) => m[1]!).toList();
    expect(aliases.length, appIcons.length);
    final on = aliases.where((a) => a.contains('android:enabled="true"')).toList();
    expect(on, hasLength(1));
    expect(on.single, contains('.AppIcon_default"'));
  });

  test('iOS build includes the alternate icon sets', () {
    final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    expect('ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS = YES'.allMatches(pbx).length, 3); // Debug, Release, Profile
  });
}
