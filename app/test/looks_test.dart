// Make your own theme and seasonal themes: the editor, the settings that use it, and screen-reader and
// contrast checks over the new themes. Every vault here lives in a temp folder; nothing touches the real one.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/l10n/l10n.dart';
import 'package:tanooki_auth/ui/premium.dart';
import 'package:tanooki_auth/ui/settings.dart';
import 'package:tanooki_auth/ui/theme.dart';
import 'package:tanooki_auth/ui/theme_editor.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('looks');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 5)));
    vault.settings[lastBackupKey] = DateTime.now().toUtc().add(const Duration(minutes: 1)).toIso8601String();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (c) async => null);
  });
  tearDown(() {
    premium.value = false;
    themeChoice.value = 'auto';
    customThemes.clear();
    dir.deleteSync(recursive: true);
  });

  /// Swatch labels are followed by the name under them, so match the start.
  Pattern startsWith(String label) => RegExp('^${RegExp.escape(label)}');

  Future<void> pump(WidgetTester t, Widget screen, {AppPalette palette = darkPalette, Size size = const Size(420, 1600)}) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(palette), home: screen));
    await t.pump();
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 31));
  }

  // Lets file writes (vault.save) finish, which fake time can't do on its own.
  Future<void> flushIo(WidgetTester t, bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await t.pump();
    }
  }

  testWidgets('a new theme is saved in the first free slot and put to use', (t) async {
    premium.value = true;
    await pump(t, ThemeEditorScreen(vault: vault));
    await t.tap(find.text(l10n.themeEditorAccent));
    await t.pump();
    await t.tap(find.bySemanticsLabel(l10n.themeEditorSwatch('#E2649A')));
    await t.pump();
    await t.tap(find.byKey(const Key('saveTheme')));
    await flushIo(t, () => themeChoice.value == 'custom1');
    expect(themeChoice.value, 'custom1');
    expect(vault.settings['theme'], 'custom1');
    expect((vault.settings[customThemesKey] as Map)['custom1']['accent'], 0xFFE2649A);
    expect(customThemes['custom1']!.accent, const Color(0xFFE2649A));
    await finish(t);
  });

  testWidgets('colors that can\'t be made readable are refused, and Save says why', (t) async {
    premium.value = true;
    await pump(t, ThemeEditorScreen(vault: vault));
    await t.tap(find.text(l10n.themeEditorBackground));
    await t.pump();
    await t.tap(find.bySemanticsLabel(l10n.themeEditorSwatch('#0B0B0D')));
    await t.tap(find.text(l10n.themeEditorCard));
    await t.pump();
    await t.tap(find.bySemanticsLabel(l10n.themeEditorSwatch('#FFFFFF')));
    await t.pump();
    expect(find.byKey(const Key('themeUnreadable')), findsOneWidget);
    expect(find.byKey(const Key('themePreview')), findsNothing);
    await t.tap(find.byKey(const Key('saveTheme')));
    await t.pump();
    expect(find.descendant(of: find.byType(SnackBar), matching: find.text(l10n.themeEditorUnreadable)), findsOneWidget);
    expect(vault.settings[customThemesKey], isNull);
    await finish(t);
  });

  testWidgets('hard-to-read text is adjusted, and the editor says so', (t) async {
    premium.value = true;
    await pump(t, ThemeEditorScreen(vault: vault));
    await t.tap(find.text(l10n.themeEditorText));
    await t.pump();
    await t.tap(find.bySemanticsLabel(l10n.themeEditorSwatch('#16161A'))); // dark text on the dark default
    await t.pump();
    expect(find.byKey(const Key('themeAdjusted')), findsOneWidget);
    await finish(t);
  });

  testWidgets('editing and deleting a saved theme', (t) async {
    premium.value = true;
    vault.settings[customThemesKey] = {
      'custom2': {'accent': 0xFF2F80FF, 'background': 0xFF0B0B0D, 'card': 0xFF16161A, 'text': 0xFFF2F2F5},
    };
    vault.settings['theme'] = 'custom2';
    loadCustomThemes(vault.settings);
    themeChoice.value = 'custom2';
    await pump(t, SettingsScreen(vault: vault), size: const Size(420, 5000));
    expect(find.bySemanticsLabel(startsWith(l10n.settingsThemeSemantic(l10n.themeCustom(2)))), findsOneWidget);
    await t.tap(find.byKey(const Key('editCustomTheme')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('deleteTheme')));
    await flushIo(t, () => themeChoice.value == 'auto');
    expect(themeChoice.value, 'auto');
    expect(vault.settings['theme'], 'auto');
    expect((vault.settings[customThemesKey] as Map).containsKey('custom2'), isFalse);
    expect(customThemes, isEmpty);
    await finish(t);
  });

  testWidgets('"Change with the seasons" switches to this season\'s theme; picking a theme turns it off', (t) async {
    premium.value = true;
    await pump(t, SettingsScreen(vault: vault), size: const Size(420, 5000));
    await t.tap(find.byKey(const Key('seasonalSwitch')));
    await flushIo(t, () => themeChoice.value != 'auto');
    expect(themeChoice.value, seasonFor(DateTime.now()) ?? 'auto');
    await t.tap(find.bySemanticsLabel(startsWith(l10n.settingsThemeSemantic(l10n.themePink))));
    await flushIo(t, () => themeChoice.value == 'pink');
    expect(vault.settings[seasonalThemeKey], isNull);
    await finish(t);
  });

  testWidgets('without Premium the new theme controls say Premium', (t) async {
    await pump(t, SettingsScreen(vault: vault), size: const Size(420, 5000));
    expect(find.text(l10n.settingsSeasonalPremium), findsOneWidget);
    expect(find.bySemanticsLabel(l10n.themeMakeOwnPremium), findsOneWidget);
    for (final id in seasonalThemes) {
      expect(find.bySemanticsLabel(startsWith(l10n.settingsThemeSemanticPremium(themeName(id)))), findsOneWidget);
    }
    await finish(t);
  });

  group('accessibility guidelines', () {
    Future<void> check(WidgetTester t) async {
      await expectLater(t, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(t, meetsGuideline(androidTapTargetGuideline));
      await expectLater(t, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(t, meetsGuideline(textContrastGuideline));
    }

    for (final id in [...seasonalThemes, 'custom']) {
      testWidgets('settings and the theme editor in $id', (t) async {
        final handle = t.ensureSemantics();
        premium.value = true;
        final p = id == 'custom'
            ? customPalette('custom1', accent: const Color(0xFFF0B429), background: const Color(0xFFFFF3F7), card: Colors.white, text: const Color(0xFF999999))!
            : themeChoices[id]!;
        await pump(t, SettingsScreen(vault: vault), palette: p, size: const Size(420, 5000));
        await check(t);
        await pump(t, ThemeEditorScreen(vault: vault), palette: p);
        await check(t);
        await finish(t);
        handle.dispose();
      });
    }
  });
}
