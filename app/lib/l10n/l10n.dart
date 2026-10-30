import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Vault setting for Settings > Language: 'en', 'es', 'fr', 'de', 'ja', or missing to follow the device.
const languageKey = 'language';

/// The Language choices, each in its own language (so anyone can find theirs). The empty key is "System".
const languageNames = {'en': 'English', 'es': 'Español', 'fr': 'Français', 'de': 'Deutsch', 'ja': '日本語'};

/// The Settings > Language choice; null follows the device.
final appLanguage = ValueNotifier<String?>(null);

/// `--dart-define=TA_LANG=en` pins the language. CI's integration tests use it because they look for English text.
const forcedLanguage = String.fromEnvironment('TA_LANG');

/// The language the app shows: the forced one, else the Settings choice, else the device's best match.
Locale appLocale([List<Locale>? device]) {
  final pick = forcedLanguage.isNotEmpty ? forcedLanguage : appLanguage.value;
  if (pick != null && languageNames.containsKey(pick)) return Locale(pick);
  return basicLocaleListResolution(device ?? _deviceLocales, AppLocalizations.supportedLocales);
}

List<Locale> get _deviceLocales {
  try {
    return WidgetsBinding.instance.platformDispatcher.locales;
  } on FlutterError {
    // No binding: plain Dart tests and background isolates (QR decoding, importers) still get words.
    return PlatformDispatcher.instance.locales;
  }
}

/// The app's words in the current language. A plain getter (no BuildContext) so dialogs, menus, notifications
/// and error messages built outside a widget use the same language; the app rebuilds every widget when it changes.
AppLocalizations get l10n => lookupAppLocalizations(appLocale());

/// Applies a stored Settings > Language value.
void loadLanguage(Map<String, Object?> settings) {
  final v = settings[languageKey];
  appLanguage.value = v is String && languageNames.containsKey(v) ? v : null;
}
