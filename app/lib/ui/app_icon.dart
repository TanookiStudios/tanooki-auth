import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/vault.dart';
import '../l10n/l10n.dart';
import 'theme.dart' show seasonFor, seasonalThemeKey, seasonalThemes;

/// The app icons, grouped the way the picker shows them. Pastel Pink and Pastel Blue come right after the
/// original; spooky, cozy and spring double as the seasonal theme ids. Everything but 'default' is Premium.
/// Images come from tool/make_app_icons.cjs. Each non-default id needs an iOS `AppIcon-<id>` icon set and an
/// Android `.AppIcon_<id>` activity-alias; test/app_icon_test.dart checks they all exist.
List<(String, Map<String, String>)> get appIconGroups => [
      (l10n.appIconGroupColors, {
        'default': l10n.appIconClassic,
        'pink': l10n.appIconPink,
        'blue': l10n.appIconBlue,
        'hotpink': l10n.appIconHotpink,
        'red': l10n.appIconRed,
        'orange': l10n.appIconOrange,
        'gold': l10n.appIconGold,
        'green': l10n.appIconGreen,
        'cyan': l10n.appIconCyan,
        'purple': l10n.appIconPurple,
        'monochrome': l10n.appIconMonochrome,
        'blackgold': l10n.appIconBlackgold,
      }),
      (l10n.appIconGroupHolidays, {
        'spring': l10n.appIconSpring,
        'summer': l10n.appIconSummer,
        'spooky': l10n.appIconSpooky,
        'thanksgiving': l10n.appIconThanksgiving,
        'cozy': l10n.appIconCozy,
        'christmas': l10n.appIconChristmas,
        'valentines': l10n.appIconValentines,
        'stpatricks': l10n.appIconStpatricks,
        'independence': l10n.appIconIndependence,
      }),
      (l10n.appIconGroupPride, {
        'rainbow': l10n.appIconRainbow,
        'progress': l10n.appIconProgress,
        'transgender': l10n.appIconTransgender,
        'lesbian': l10n.appIconLesbian,
        'bisexual': l10n.appIconBisexual,
        'pansexual': l10n.appIconPansexual,
        'nonbinary': l10n.appIconNonbinary,
        'asexual': l10n.appIconAsexual,
        'genderfluid': l10n.appIconGenderfluid,
      }),
    ];

/// Every icon in picker order.
Map<String, String> get appIcons => {for (final g in appIconGroups) ...g.$2};

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

/// With "Change with the seasons" on, someone already using a seasonal icon gets this season's one (in
/// summer it stays put). Anyone on a non-seasonal icon keeps it. Premium is checked by the caller.
Future<void> followSeasonIcon(Vault vault, DateTime now) async {
  final season = seasonFor(now);
  if (!appIconsSupported || vault.settings[seasonalThemeKey] != true || season == null) return;
  try {
    final current = await currentAppIcon(vault);
    if (seasonalThemes.contains(current) && current != season) await setAppIcon(vault, season);
  } on PlatformException catch (e) {
    debugPrint('Seasonal app icon failed: ${e.code}');
  }
}
