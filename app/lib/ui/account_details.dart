import 'package:flutter/material.dart';

import '../core/account.dart';
import 'brand_icon.dart';
import 'code_view.dart';
import 'home.dart' show accountTitle, groupCode;
import 'theme.dart';
import '../l10n/l10n.dart';

/// The right-hand pane of the wide layout (900 px and up): one account with its code big, and everything
/// else about it. The home screen does the asking (Face ID for "ask first" accounts) behind each callback.
class AccountDetails extends StatelessWidget {
  const AccountDetails({
    super.key,
    required this.account,
    required this.code,
    required this.left,
    required this.hidden,
    required this.countdownStyle,
    required this.onCopy,
    required this.onReadAloud,
    required this.onShowQr,
    required this.onRecoveryCodes,
    required this.onEdit,
    required this.onNext,
  });

  final Account account;
  final String code;
  final int? left;
  final bool hidden;
  final String countdownStyle;
  final VoidCallback onCopy, onReadAloud, onShowQr, onRecoveryCodes, onEdit, onNext;

  @override
  Widget build(BuildContext context) {
    final a = account;
    final unused = a.recoveryCodes.where((r) => !r.used).length;
    // Notes can hold private things too, so an "ask first" account keeps them hidden with its code.
    final secret = hidden && a.requireAuth;
    Widget heading(String text) => Padding(padding: const EdgeInsets.only(top: 24, bottom: 8), child: CapsLabel(text));

    return ListView(
      key: const Key('detailsPane'),
      padding: const EdgeInsets.all(28),
      children: [
        Row(children: [
          IssuerAvatar(a, size: 52),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(accountTitle(a), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              if (a.issuer.isNotEmpty && a.label.isNotEmpty) Text(a.label, style: TextStyle(color: Palette.muted)),
            ]),
          ),
          IconButton(tooltip: l10n.detailsEditAccount, icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
        ]),
        const SizedBox(height: 28),
        Semantics(
          container: true,
          label: hidden ? l10n.homeCodeHidden : codeSemantics(code, left),
          excludeSemantics: true,
          child: Row(children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  hidden ? groupCode('•' * code.length) : groupCode(code),
                  key: const Key('detailsCode'),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: left != null && left! <= 5 ? Palette.red : Palette.text,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (left != null) Countdown(left: left!, period: a.period, style: countdownStyle, big: true),
          ]),
        ),
        const SizedBox(height: 20),
        Wrap(spacing: 10, runSpacing: 10, children: [
          FilledButton.icon(onPressed: onCopy, icon: const Icon(Icons.copy, size: 18), label: Text(l10n.detailsCopyCode)),
          if (left == null) OutlinedButton.icon(onPressed: onNext, icon: const Icon(Icons.refresh, size: 18), label: Text(l10n.homeNextCode)),
          if (readAloudSupported)
            OutlinedButton.icon(onPressed: onReadAloud, icon: const Icon(Icons.volume_up_outlined, size: 18), label: Text(l10n.detailsReadAloud)),
          OutlinedButton.icon(onPressed: onShowQr, icon: const Icon(Icons.qr_code_2, size: 18), label: Text(l10n.homeShowQr)),
          OutlinedButton.icon(
            onPressed: onRecoveryCodes,
            icon: const Icon(Icons.key_outlined, size: 18),
            label: Text(a.recoveryCodes.isEmpty ? l10n.homeRecoveryCodes : l10n.homeRecoveryCodesLeft(unused)),
          ),
        ]),
        if (a.folder != null || a.tags.isNotEmpty) ...[
          heading(l10n.detailsFolderAndTags),
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (a.folder != null) Pill(a.folder!, color: Palette.accent),
            for (final t in a.tags) Pill(t, color: Palette.muted),
          ]),
        ],
        if (a.domains.isNotEmpty) ...[
          heading(l10n.detailsWebsites),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final d in a.domains) Pill(d, color: Palette.green)]),
        ],
        heading(l10n.detailsNotes),
        Text(
          secret ? l10n.detailsNotesHidden : (a.notes.isEmpty ? l10n.detailsNoNotes : a.notes),
          style: TextStyle(height: 1.4, color: a.notes.isEmpty || secret ? Palette.muted : Palette.text),
        ),
      ],
    );
  }
}
