import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/vault.dart';

/// Premium alternate app icons, in picker order: the blue shield, then the shield recolored per theme.
/// Images come from tool/make_app_icons.cjs. Each non-default id needs an iOS `AppIcon-<id>` icon set and an
/// Android `.AppIcon_<id>` activity-alias; test/app_icon_test.dart checks they all exist.
const appIcons = <String, String>{
  'default': 'Classic',
  'pink': 'Pastel Pink',
  'blue': 'Pastel Blue',
  'lavender': 'Lavender',
  'mint': 'Mint',
  'midnight': 'Midnight',
  'sunset': 'Sunset',
};

/// Settings key for the Mac Dock icon (macOS forgets it when the app quits, so it is set again at launch).
/// Phones remember the icon themselves; there the system is asked instead.
const appIconKey = 'appIcon';

const _channel = MethodChannel('tanooki/extras');

/// iPhone and Android switch the home-screen icon for good; the Mac only changes the Dock icon while open.
bool get appIconsSupported => Platform.isIOS || Platform.isAndroid || Platform.isMacOS;

String appIconAsset(String id) => 'assets/app_icons/$id.png';

/// The icon in use now.
Future<String> currentAppIcon(Vault vault) async {
  if (Platform.isMacOS) return vault.settings[appIconKey] as String? ?? 'default';
  try {
    final id = await _channel.invokeMethod<String>('getAppIcon');
    return appIcons.containsKey(id) ? id! : 'default';
  } on MissingPluginException {
    return 'default';
  }
}

/// Switches the icon. Throws [PlatformException] if the system refused.
Future<void> setAppIcon(Vault vault, String id) async {
  assert(appIcons.containsKey(id));
  if (Platform.isMacOS) {
    await _setDockIcon(id);
    vault.settings[appIconKey] = id;
    await vault.save();
    return;
  }
  await _channel.invokeMethod<void>('setAppIcon', id);
  debugPrint('App icon set to $id');
}

/// Puts the chosen Dock icon back after launch. Mac only; does nothing for the default.
Future<void> restoreDockIcon(Vault vault, {required bool premium}) async {
  final id = vault.settings[appIconKey];
  if (!Platform.isMacOS || id is! String || id == 'default' || !premium || !appIcons.containsKey(id)) return;
  try {
    await _setDockIcon(id);
  } on PlatformException catch (e) {
    debugPrint('Restoring the Dock icon failed: ${e.code}');
  }
}

Future<void> _setDockIcon(String id) async {
  final png = id == 'default' ? null : (await rootBundle.load(appIconAsset(id))).buffer.asUint8List();
  await const MethodChannel('tanooki/window').invokeMethod<void>('setDockIcon', png);
}
