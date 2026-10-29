import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

Timer? _clearTimer;

/// Copies a code and clears the clipboard 30 s later if it still holds that code.
Future<void> copyCode(String code) async {
  await Clipboard.setData(ClipboardData(text: code));
  _clearTimer?.cancel();
  _clearTimer = Timer(const Duration(seconds: 30), () async {
    // Reading the clipboard on iOS pops a "paste from" banner, so clear without checking there.
    if (!Platform.isIOS) {
      final now = await Clipboard.getData(Clipboard.kTextPlain);
      if (now?.text != code) return;
    }
    await Clipboard.setData(const ClipboardData(text: ''));
  });
}
