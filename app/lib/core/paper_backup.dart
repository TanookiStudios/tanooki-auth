import 'dart:typed_data';
import 'dart:ui' show Locale;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../l10n/l10n.dart';
import 'account.dart';
import 'otpauth_uri.dart';

/// A printable PDF: one block per account with its setup QR code, name, and unused recovery codes.
/// Anyone holding the paper can make the codes, which the confirmation before this says plainly.
Future<Uint8List> buildPaperBackup(List<Account> accounts, {DateTime? now, bool compress = true}) {
  final date = (now ?? DateTime.now()).toIso8601String().substring(0, 10);
  // The PDF's built-in Helvetica has no Japanese letters, so a Japanese paper backup is printed in English.
  final t = appLocale().languageCode == 'ja' ? lookupAppLocalizations(const Locale('en')) : l10n;
  final doc = pw.Document(compress: compress, title: t.paperBackupTitle, author: 'Tanooki Auth');
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.letter,
    margin: const pw.EdgeInsets.all(36),
    header: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(t.paperBackupHeader(date), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.Text(t.paperBackupWarning,
          style: const pw.TextStyle(fontSize: 9)),
      pw.SizedBox(height: 12),
    ]),
    build: (_) => [
      for (final a in accounts)
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 14),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey600, width: 0.5)),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: toOtpauthUri(a), width: 110, height: 110),
            pw.SizedBox(width: 14),
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(a.issuer.isEmpty ? a.label : a.issuer, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                if (a.issuer.isNotEmpty && a.label.isNotEmpty) pw.Text(a.label, style: const pw.TextStyle(fontSize: 10)),
                if (a.domains.isNotEmpty) pw.Text(a.domains.join(', '), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                pw.SizedBox(height: 4),
                pw.Text(t.paperBackupSetupKey(a.secret), style: pw.TextStyle(fontSize: 8, font: pw.Font.courier())),
                if (a.recoveryCodes.any((r) => !r.used)) ...[
                  pw.SizedBox(height: 6),
                  pw.Text(t.paperBackupRecoveryCodes, style: const pw.TextStyle(fontSize: 9)),
                  pw.Wrap(spacing: 12, runSpacing: 2, children: [
                    for (final r in a.recoveryCodes.where((r) => !r.used))
                      pw.Text(r.code, style: pw.TextStyle(fontSize: 9, font: pw.Font.courier())),
                  ]),
                ],
              ]),
            ),
          ]),
        ),
    ],
  ));
  return doc.save();
}
