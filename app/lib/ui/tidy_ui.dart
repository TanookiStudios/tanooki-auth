import 'package:flutter/material.dart';

import '../core/account.dart';
import '../core/tidy.dart';
import '../core/vault.dart';
import 'brand_icon.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// Settings > "Tidy account names": shows every name tidyName would change, old and new, with a tick box
/// each, and changes nothing until "Apply".
class TidyNamesScreen extends StatefulWidget {
  const TidyNamesScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<TidyNamesScreen> createState() => _TidyNamesScreenState();
}

class _TidyNamesScreenState extends State<TidyNamesScreen> {
  late final List<(Account, ({String issuer, String label}))> _changes = [
    for (final a in widget.vault.visible)
      if (tidyName(a.issuer, a.label, brandName: brandTitle) case final t when t.issuer != a.issuer || t.label != a.label) (a, t),
  ];
  late final Set<String> _on = {for (final (a, _) in _changes) a.id};

  String _show(String issuer, String label) =>
      [issuer, label].where((s) => s.isNotEmpty).join(' · ').ifEmpty(l10n.tidyNoName);

  Future<void> _apply() async {
    var n = 0;
    for (final (a, t) in _changes) {
      if (!_on.contains(a.id)) continue;
      a
        ..issuer = t.issuer
        ..label = t.label;
      n++;
    }
    await widget.vault.save();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.tidyDone(n))));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tidyTitle)),
      body: _changes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.tidyNothing, textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
              ),
            )
          : ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 96), children: [
              Text(
                l10n.tidyIntro,
                style: TextStyle(color: Palette.muted, height: 1.4),
              ),
              const SizedBox(height: 12),
              for (final (a, t) in _changes)
                Card(
                  child: CheckboxListTile(
                    value: _on.contains(a.id),
                    onChanged: (v) => setState(() => v == true ? _on.add(a.id) : _on.remove(a.id)),
                    title: Text(_show(t.issuer, t.label), style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(l10n.tidyWas(_show(a.issuer, a.label))),
                  ),
                ),
            ]),
      floatingActionButton: _changes.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _on.isEmpty ? null : _apply,
              icon: const Icon(Icons.auto_fix_high),
              label: Text(_on.isEmpty ? l10n.tidyNothingTicked : l10n.tidyApply(_on.length)),
            ),
    );
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}
