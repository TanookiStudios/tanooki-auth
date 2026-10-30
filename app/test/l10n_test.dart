import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/security.dart' show lastBackupKey;
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/l10n/l10n.dart';
import 'package:tanooki_auth/ui/about_maddie.dart';
import 'package:tanooki_auth/ui/add.dart';
import 'package:tanooki_auth/ui/help.dart';
import 'package:tanooki_auth/ui/home.dart';
import 'package:tanooki_auth/ui/premium.dart';
import 'package:tanooki_auth/ui/quick_pick.dart';
import 'package:tanooki_auth/ui/security_ui.dart';
import 'package:tanooki_auth/ui/settings.dart';
import 'package:tanooki_auth/ui/theme.dart';
import 'package:tanooki_auth/ui/trash.dart';

import 'vault_test.dart' show MemoryKeyStore;

const locales = ['en', 'es', 'fr', 'de', 'ja'];

Map<String, dynamic> readArb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map<String, dynamic>;

/// The argument names an ICU message uses, e.g. {name} and the {count} in {count, plural, =1{...} other{...}}.
/// Text inside plural/select cases is parsed too, so a placeholder used only in one case still counts.
Set<String> placeholdersOf(String message) {
  final found = <String>{};
  var i = 0;
  void parseMessage() {
    while (i < message.length && message[i] != '}') {
      if (message[i] == '{') {
        i++;
        final start = i;
        while (i < message.length && message[i] != ',' && message[i] != '}') {
          i++;
        }
        found.add(message.substring(start, i).trim());
        if (i < message.length && message[i] == ',') {
          // {name, plural|select, case{...} case{...}}
          i = message.indexOf(',', i + 1) + 1;
          while (i < message.length && message[i] != '}') {
            final open = message.indexOf('{', i);
            i = open + 1;
            parseMessage();
            i++; // the case's closing brace
            while (i < message.length && message[i] == ' ') {
              i++;
            }
          }
        }
        i++; // the argument's closing brace
      } else {
        i++;
      }
    }
  }

  parseMessage();
  return found;
}

void main() {
  group('translation files', () {
    final en = readArb('en');
    final keys = en.keys.where((k) => !k.startsWith('@')).toSet();

    test('the placeholder reader sees plural and nested arguments', () {
      expect(placeholdersOf('Hi {name}'), {'name'});
      expect(placeholdersOf('{count, plural, =1{One for {who}} other{{count} for {who}}}'), {'count', 'who'});
      expect(placeholdersOf('No arguments'), isEmpty);
    });

    for (final locale in locales.skip(1)) {
      test('$locale has every English key, nothing extra, and the same placeholders', () {
        final other = readArb(locale);
        final otherKeys = other.keys.where((k) => !k.startsWith('@')).toSet();
        expect(keys.difference(otherKeys), isEmpty, reason: 'keys missing from app_$locale.arb');
        expect(otherKeys.difference(keys), isEmpty, reason: 'keys in app_$locale.arb that English does not have');
        final mismatched = [
          for (final k in keys)
            if (!setEquals(placeholdersOf(en[k] as String), placeholdersOf(other[k] as String)))
              '$k: en ${placeholdersOf(en[k] as String)} vs $locale ${placeholdersOf(other[k] as String)}',
        ];
        expect(mismatched, isEmpty, reason: 'placeholders differ');
        final empty = [for (final k in keys) if ((other[k] as String).trim().isEmpty) k];
        expect(empty, isEmpty, reason: 'empty translations');
      });
    }
  });

  group('no hard-coded English left in Text widgets', () {
    // Text that is the same in every language. Keep this short: anything people read belongs in the .arb files.
    const allowlist = {
      'Tanooki Auth', // brand
      'Premium', // brand, stays as is in every language
      'Atkinson Hyperlegible', // font name
      'iCloud', // Apple's product name
      '© 2026 Maddie', // copyright line
      'TANOOKI', 'AUTH', // the sidebar wordmark (the brand name)
      'Google Authenticator', // Google's app name
    };
    test('every Text(...) in lib uses l10n', () {
      final offenders = <String>[];
      // A string literal right after Text( / Text.rich(TextSpan(text: ... with two or more letters in a row.
      final literal = RegExp(r'''\b(?:Text|SelectableText)\(\s*(?:'((?:[^'\\]|\\.)*)'|"((?:[^"\\]|\\.)*)")''');
      for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
        if (!f.path.endsWith('.dart') || f.path.contains('${Platform.pathSeparator}l10n${Platform.pathSeparator}')) continue;
        final src = f.readAsStringSync();
        for (final m in literal.allMatches(src)) {
          final text = (m.group(1) ?? m.group(2))!;
          // Interpolations like '$code' or '${a.issuer}' are data, not words.
          final words = text.replaceAll(RegExp(r'\$\{[^}]*\}|\$\w+'), '');
          if (!RegExp(r'[A-Za-z]{2,}').hasMatch(words) || allowlist.contains(text)) continue;
          final line = src.substring(0, m.start).split('\n').length;
          offenders.add('${f.path}:$line  $text');
        }
      }
      expect(offenders, isEmpty, reason: 'move these into lib/l10n/app_en.arb (and the other languages)');
    });
  });

  group('every language fits at phone width with large text', () {
    late Directory dir;
    late Vault vault;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('l10n_test');
      vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 9)));
      vault.settings[lastBackupKey] = DateTime.now().toUtc().add(const Duration(minutes: 1)).toIso8601String();
      vault.accounts.addAll([
        Account(id: 'a', issuer: 'GitHub', label: 'maddie@example.com', secret: 'JBSWY3DPEHPK3PXP', favorite: true, tags: ['work']),
        Account(id: 'b', issuer: 'A rather long service name, Inc.', label: 'someone.with.a.long.address@example.com', secret: 'GEZDGNBVGY3TQOJQ'),
        Account(id: 'c', issuer: 'Steam', label: 'player', secret: 'MFRGGZDFMZTWQ2LK', type: OtpType.steam, digits: 5),
      ]);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (c) async => null);
    });
    tearDown(() {
      appLanguage.value = null;
      dir.deleteSync(recursive: true);
    });

    final screens = <String, Widget Function(Vault)>{
      'home': (v) => HomeScreen(vault: v),
      'add': (v) => AddScreen(vault: v),
      'settings': (v) => SettingsScreen(vault: v),
      'premium': (v) => PremiumScreen(vault: v),
      'quick pick': (v) => QuickPickScreen(vault: v),
      'trash': (v) => TrashScreen(vault: v),
      'check-up': (v) => CheckupScreen(vault: v),
      'tour': (v) => TourScreen(vault: v),
      'what\'s new': (v) => const WhatsNewScreen(),
      'feedback': (v) => const FeedbackScreen(),
      'about Maddie': (v) => const AboutMaddieScreen(),
    };

    for (final locale in locales) {
      for (final screen in screens.entries) {
        testWidgets('${screen.key} in $locale', (t) async {
          appLanguage.value = locale;
          await t.binding.setSurfaceSize(const Size(360, 740));
          addTearDown(() => t.binding.setSurfaceSize(null));
          t.view.physicalSize = const Size(360, 740);
          t.view.devicePixelRatio = 1;
          addTearDown(t.view.reset);
          await t.pumpWidget(MaterialApp(
            theme: buildTheme(darkPalette),
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
            builder: (c, child) =>
                MediaQuery(data: MediaQuery.of(c).copyWith(textScaler: const TextScaler.linear(1.3)), child: child!),
            home: screen.value(vault),
          ));
          await t.pump();
          // Scroll every vertical list to the bottom so rows built lazily are laid out (and checked) too.
          final lists = find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down);
          for (var i = 0; i < lists.evaluate().length; i++) {
            for (var n = 0; n < 12; n++) {
              await t.drag(lists.at(i), const Offset(0, -600), warnIfMissed: false);
              await t.pump();
            }
          }
          // A RenderFlex overflow is reported as a test failure on its own; this catches anything else thrown.
          expect(t.takeException(), isNull);
          await t.pumpWidget(const SizedBox());
          await t.pump(const Duration(seconds: 31)); // let any clipboard or countdown timers finish
        });
      }
    }
  });
}
