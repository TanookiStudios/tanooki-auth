import 'package:flutter/material.dart';

import '../core/vault.dart';
import '../l10n/l10n.dart';
import 'premium.dart' show themeChoice;
import 'theme.dart';

/// Make your own theme (Premium): four colors, each from preset swatches or a hue slider, with a live
/// preview. Colors that would be hard to read are adjusted (see [customPalette]); ones that can't be are
/// refused. Saved in the vault's settings under [customThemesKey], up to three.
class ThemeEditorScreen extends StatefulWidget {
  const ThemeEditorScreen({super.key, required this.vault, this.slot});
  final Vault vault;

  /// The custom theme being edited, or null for a new one.
  final String? slot;

  @override
  State<ThemeEditorScreen> createState() => _ThemeEditorScreenState();
}

const _presets = <String, List<int>>{
  'accent': [0xFF2F80FF, 0xFFE2649A, 0xFF8565DD, 0xFF239E78, 0xFFE8673A, 0xFFD9364F, 0xFF1A9BB0, 0xFFF0B429],
  'background': [0xFF0B0B0D, 0xFF0A0F1F, 0xFF1A0F1E, 0xFF0D1612, 0xFFF5F5F7, 0xFFFFF3F7, 0xFFF1F6FF, 0xFFF0FAF6],
  'card': [0xFF16161A, 0xFF131C33, 0xFF26172F, 0xFF15251E, 0xFFFFFFFF, 0xFFFFF8FB, 0xFFF8FBFF, 0xFFF7FDFA],
  'text': [0xFFF2F2F5, 0xFFEAF0FF, 0xFFFFF1EA, 0xFFEAF5EE, 0xFF16161A, 0xFF3A2230, 0xFF1E2A3A, 0xFF173228],
};

class _ThemeEditorScreenState extends State<ThemeEditorScreen> {
  late final Map<String, Color> _picks;
  String _role = 'accent';

  Map<String, dynamic> get _saved => ((widget.vault.settings[customThemesKey] as Map?) ?? {}).cast<String, dynamic>();

  @override
  void initState() {
    super.initState();
    final old = widget.slot == null ? null : _saved[widget.slot] as Map?;
    final now = Palette.current;
    final start = {'accent': now.accent, 'background': now.background, 'card': now.card, 'text': now.text};
    _picks = {for (final r in customRoles) r: old?[r] is int ? Color(old![r] as int) : start[r]!};
  }

  AppPalette? get _palette => customPalette(widget.slot ?? '',
      accent: _picks['accent']!, background: _picks['background']!, card: _picks['card']!, text: _picks['text']!);

  Future<void> _save() async {
    final slot = widget.slot ?? customSlots.firstWhere((s) => !_saved.containsKey(s));
    widget.vault.settings[customThemesKey] = {
      ..._saved,
      slot: {for (final r in customRoles) r: _picks[r]!.toARGB32()},
    };
    widget.vault.settings['theme'] = slot;
    widget.vault.settings.remove(seasonalThemeKey);
    await widget.vault.save();
    loadCustomThemes(widget.vault.settings);
    // Saving the theme already in use changes no id, so step off it for a moment to repaint.
    if (themeChoice.value == slot) themeChoice.value = 'auto';
    themeChoice.value = slot;
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final slot = widget.slot!;
    widget.vault.settings[customThemesKey] = {..._saved}..remove(slot);
    if (widget.vault.settings['theme'] == slot) widget.vault.settings['theme'] = 'auto';
    await widget.vault.save();
    loadCustomThemes(widget.vault.settings);
    if (themeChoice.value == slot) themeChoice.value = 'auto';
    if (mounted) Navigator.pop(context);
  }

  void _pick(Color c) => setState(() => _picks[_role] = c);

  String _roleName(String r) => switch (r) {
        'background' => l10n.themeEditorBackground,
        'card' => l10n.themeEditorCard,
        'text' => l10n.themeEditorText,
        _ => l10n.themeEditorAccent,
      };

  @override
  Widget build(BuildContext context) {
    final p = _palette;
    final picked = _picks[_role]!;
    final hsl = HSLColor.fromColor(picked);
    final adjusted = p != null && (p.text != _picks['text'] || p.accent != _picks['accent']);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.themeEditorTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        CapsLabel(l10n.themeEditorPreview),
        const SizedBox(height: 8),
        if (p != null) _Preview(p),
        const SizedBox(height: 8),
        if (p == null)
          Text(l10n.themeEditorUnreadable, key: const Key('themeUnreadable'), style: TextStyle(color: Palette.red, height: 1.4))
        else if (adjusted)
          Text(l10n.themeEditorAdjusted, key: const Key('themeAdjusted'), style: TextStyle(color: Palette.muted, height: 1.4)),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final r in customRoles)
            ChoiceChip(label: Text(_roleName(r)), selected: _role == r, onSelected: (_) => setState(() => _role = r)),
        ]),
        const SizedBox(height: 14),
        Wrap(spacing: 10, runSpacing: 10, children: [
          for (final v in _presets[_role]!) _swatch(Color(v), picked.toARGB32() == v),
        ]),
        const SizedBox(height: 10),
        Text(l10n.themeEditorHue, style: TextStyle(color: Palette.muted)),
        Slider(
          key: const Key('hueSlider'),
          label: l10n.themeEditorHue,
          value: hsl.hue,
          max: 360,
          activeColor: buttonFill(Palette.accent),
          // A gray has no hue to turn, so give it some color first.
          onChanged: (h) => _pick(hsl.withHue(h).withSaturation(hsl.saturation < 0.25 ? 0.5 : hsl.saturation).toColor()),
        ),
        const SizedBox(height: 12),
        FilledButton(
          key: const Key('saveTheme'),
          // Still pressable when the colors don't work, so it can say why.
          onPressed: p != null
              ? _save
              : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.themeEditorUnreadable))),
          child: Text(l10n.themeEditorSave),
        ),
        if (widget.slot != null) ...[
          const SizedBox(height: 10),
          OutlinedButton(key: const Key('deleteTheme'), onPressed: _delete, child: Text(l10n.themeEditorDelete)),
        ],
      ]),
    );
  }

  Widget _swatch(Color c, bool selected) {
    final hex = '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    return Semantics(
      button: true,
      selected: selected,
      label: l10n.themeEditorSwatch(hex),
      excludeSemantics: true, // which drops the InkWell's tap too, so it is offered here
      onTap: () => _pick(c),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _pick(c),
        child: Container(
          width: 48, // the smallest comfortable tap target
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c,
            border: Border.all(color: selected ? Palette.accent : Palette.lineBright, width: selected ? 3 : 1),
          ),
        ),
      ),
    );
  }
}

/// A home-screen card drawn in the draft colors (not through the app theme, which stays as it is until saved).
class _Preview extends StatelessWidget {
  const _Preview(this.p);
  final AppPalette p;

  @override
  Widget build(BuildContext context) => Container(
        key: const Key('themePreview'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: p.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.line)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: p.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.themeEditorSample, style: TextStyle(color: p.text, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 2),
            Text(l10n.themeEditorSampleHint, style: TextStyle(color: p.muted, fontSize: 13)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Text('482 139',
                    style: TextStyle(color: p.text, fontSize: 30, fontWeight: FontWeight.w700, fontFeatures: const [FontFeature.tabularFigures()])),
              ),
              Text('12', style: TextStyle(color: p.accent, fontSize: 16, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: buttonFill(p.accent), borderRadius: BorderRadius.circular(6)),
              child: Text(l10n.commonCopy, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      );
}
