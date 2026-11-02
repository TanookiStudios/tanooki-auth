import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import 'theme.dart';

/// Desktop keyboard for an account list with a search box (home list and Quick pick): up/down move the
/// highlight, Enter copies it, typing a letter jumps into the search box, Esc clears the search.
/// [inSearch]: the search box has the keyboard. [onType] gets the typed letter while it doesn't; null when
/// there's no search box. [onEscape] returns false when it had nothing to do (the key then goes on).
KeyEventResult listKey(
  KeyEvent e, {
  required bool inSearch,
  required void Function(int delta) onMove,
  required VoidCallback onEnter,
  required bool Function() onEscape,
  void Function(String letter)? onType,
}) {
  if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
  final hw = HardwareKeyboard.instance;
  if (hw.isMetaPressed || hw.isControlPressed || hw.isAltPressed) return KeyEventResult.ignored; // shortcuts, e.g. ⌘/
  final k = e.logicalKey;
  // Left and right still move the cursor inside the search box.
  if (k == LogicalKeyboardKey.arrowDown || (!inSearch && k == LogicalKeyboardKey.arrowRight)) {
    onMove(1);
    return KeyEventResult.handled;
  }
  if (k == LogicalKeyboardKey.arrowUp || (!inSearch && k == LogicalKeyboardKey.arrowLeft)) {
    onMove(-1);
    return KeyEventResult.handled;
  }
  if (e is KeyRepeatEvent) return KeyEventResult.ignored; // holding Enter or Esc does it once
  if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
    onEnter();
    return KeyEventResult.handled;
  }
  if (k == LogicalKeyboardKey.escape) return onEscape() ? KeyEventResult.handled : KeyEventResult.ignored;
  final ch = e.character;
  if (!inSearch && onType != null && ch != null && ch.isNotEmpty && ch.codeUnitAt(0) > 0x20 && ch.codeUnitAt(0) != 0x7f) {
    onType(ch);
    return KeyEventResult.handled;
  }
  return KeyEventResult.ignored;
}

/// Puts [letter] at the end of the search box and gives it the keyboard.
void typeInto(TextEditingController field, FocusNode focus, String letter) {
  field.value = TextEditingValue(text: field.text + letter, selection: TextSelection.collapsed(offset: field.text.length + letter.length));
  focus.requestFocus();
}

bool get _mac => Platform.isMacOS || Platform.isIOS;

/// ⌘/ on a Mac (and iPad), Ctrl+/ on Windows and Linux: opens [showShortcutsSheet].
Map<ShortcutActivator, VoidCallback> shortcutsSheetBindings(VoidCallback open) => {
      SingleActivator(LogicalKeyboardKey.slash, meta: _mac, control: !_mac): open,
      // Keyboards where "/" needs Shift (German, Spanish, French...).
      CharacterActivator('/', meta: _mac, control: !_mac): open,
    };

/// Every keyboard shortcut, as (keys, what it does).
List<(String, String)> get keyboardShortcuts {
  final mod = _mac ? '⌘' : 'Ctrl+';
  return [
    ('↑ ↓', l10n.keysMove),
    (l10n.keysEnter, l10n.keysCopy),
    (l10n.keysAnyLetter, l10n.keysSearch),
    (l10n.keysEsc, l10n.keysClear),
    ('$mod/', l10n.keysShowList),
  ];
}

bool _sheetOpen = false;

/// The list of keyboard shortcuts, as a sheet from the bottom.
Future<void> showShortcutsSheet(BuildContext context) async {
  if (_sheetOpen) return;
  _sheetOpen = true;
  try {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(l10n.keysTitle, style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(l10n.keysWhere, style: TextStyle(color: Palette.muted)),
            const SizedBox(height: 12),
            for (final (keys, what) in keyboardShortcuts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 96),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Palette.line),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(keys, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(what)),
                ]),
              ),
          ]),
        ),
      ),
    );
  } finally {
    _sheetOpen = false;
  }
}
