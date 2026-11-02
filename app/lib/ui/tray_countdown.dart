import 'dart:io';

import 'package:flutter/services.dart';

import '../core/account.dart';
import '../core/totp.dart' show secondsLeft;
import '../core/vault.dart';
import '../l10n/l10n.dart';
import 'home.dart' show accountTitle;

/// Settings key: "Show countdown in menu bar" (Mac) / in the tray icon's tooltip (Windows).
const trayCountdownKey = 'trayCountdown';

bool get trayCountdownSupported => Platform.isMacOS || Platform.isWindows;

/// The favorite whose time is shown: the first time-based favorite in home-list order.
Account? trayFavorite(Vault v) =>
    homeOrder(v.visible, sort: sortOf(v.settings)).where((a) => a.favorite && a.timeBased).firstOrNull;

/// What the menu bar shows next to the icon ("17"), or null for just the icon. Never the code itself.
({String title, String tooltip})? trayCountdown(Vault v, DateTime now) {
  if (v.settings[trayCountdownKey] != true) return null;
  final a = trayFavorite(v);
  if (a == null) return null;
  final left = secondsLeft(now.millisecondsSinceEpoch ~/ 1000, period: a.period);
  return (title: '$left', tooltip: l10n.trayTooltip(accountTitle(a), left));
}

const _window = MethodChannel('tanooki/window');
String? _shown;

/// Puts [trayCountdown] on the menu bar / tray icon, or takes it off (pass null [v], e.g. when the app locks).
/// Only talks to the native side when the text changes.
Future<void> updateTrayCountdown(Vault? v, DateTime now) async {
  if (!trayCountdownSupported) return;
  final c = v == null ? null : trayCountdown(v, now);
  final key = c == null ? null : '${c.title}|${c.tooltip}';
  if (key == _shown) return;
  _shown = key;
  try {
    await _window.invokeMethod<void>('setTrayCountdown', c == null ? null : {'title': c.title, 'tooltip': c.tooltip});
  } on MissingPluginException {
    // Unit tests, or an older native side.
  }
}
