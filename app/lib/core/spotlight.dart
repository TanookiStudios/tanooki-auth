import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vault.dart';

/// Settings key: list account names in Spotlight search (iPhone, iPad, Mac). On unless set to false.
const spotlightKey = 'spotlight';

/// Native side: app/packages/tanooki_cloud/darwin/.../Spotlight.swift.
const _channel = MethodChannel('tanooki/spotlight');

/// What Spotlight gets: names only (issuer and label), never codes or secrets. Trashed and travel-hidden
/// accounts are left out, and everything is left out when the setting is off.
List<Map<String, String>> spotlightItems(Vault v) => v.settings[spotlightKey] == false
    ? const []
    : [
        for (final a in v.live)
          if (!a.travelHidden) {'id': a.id, 'issuer': a.issuer, 'label': a.label},
      ];

String? _lastSent;

/// Replaces the Spotlight index with [spotlightItems]. An empty list removes every item.
/// Called after every save of the real vault, so adds, edits, deletes and travel mode show up right away.
Future<void> publishSpotlight(Vault v) async {
  if (!Platform.isIOS && !Platform.isMacOS) return;
  final json = jsonEncode(spotlightItems(v));
  if (json == _lastSent) return;
  try {
    await _channel.invokeMethod<void>('index', json);
    _lastSent = json;
  } on MissingPluginException {
    // Not wired (unit tests).
  } on PlatformException catch (e) {
    debugPrint('Updating Spotlight failed: ${e.code}'); // retried on the next save
  }
}

/// The account id from a Spotlight result the user tapped and the app hasn't handled yet, or null.
Future<String?> takeSpotlightOpen() async {
  try {
    return await _channel.invokeMethod<String>('takeOpen');
  } on MissingPluginException {
    return null;
  }
}

/// [onOpen] runs when a Spotlight result is tapped while the app is already running.
void listenForSpotlight(VoidCallback onOpen) {
  _channel.setMethodCallHandler((call) async {
    if (call.method == 'open') onOpen();
  });
}
