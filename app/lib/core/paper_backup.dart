import 'dart:typed_data';
import 'dart:ui' show Locale;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../l10n/l10n.dart';
import 'account.dart';
import 'otpauth_uri.dart';

// The PDF's built-in Helvetica has no Japanese, Korean or Chinese letters, so those paper backups are printed in English.
AppLocalizations _paperWords() =>
    const {'ja', 'ko', 'zh'}.contains(appLocale().languageCode) ? lookupAppLocalizations(const Locale('en')) : l10n;

/// A printable PDF: one block per account with its setup QR code, name, and unused recovery codes.
/// Anyone holding the paper can make the codes, which the confirmation before this says plainly.
Future<Uint8List> buildPaperBackup(List<Account> accounts, {DateTime? now, bool compress = true}) {
  final date = (now ?? DateTime.now()).toIso8601String().substring(0, 10);
  final t = _paperWords();
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

/// One half of a two-half paper backup ([which] is 'A' or 'B'; [codes] from splitBackupText): a header that says
/// which half it is and what it's for, then every code with its part number.
Future<Uint8List> buildHalfPaper(String which, List<String> codes, {DateTime? now, bool compress = true}) {
  final date = (now ?? DateTime.now()).toIso8601String().substring(0, 10);
  final t = _paperWords();
  final title = which == 'A' ? t.halvesHalfA : t.halvesHalfB;
  final doc = pw.Document(compress: compress, title: title, author: 'Tanooki Auth');
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.letter,
    margin: const pw.EdgeInsets.all(36),
    header: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(title, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.Text(t.halvesPdfHeader(date), style: const pw.TextStyle(fontSize: 11)),
      pw.SizedBox(height: 4),
      pw.Text(t.halvesPdfExplain, style: const pw.TextStyle(fontSize: 9)),
      pw.SizedBox(height: 12),
    ]),
    footer: (c) => pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(t.halvesPdfPage(title, c.pageNumber, c.pagesCount), style: const pw.TextStyle(fontSize: 9)),
    ),
    build: (_) => [
      pw.Wrap(spacing: 18, runSpacing: 18, children: [
        for (var i = 0; i < codes.length; i++)
          pw.Container(
            width: 160,
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey600, width: 0.5)),
            child: pw.Column(children: [
              pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: codes[i], width: 148, height: 148),
              pw.SizedBox(height: 4),
              pw.Text(t.halvesPart(which, i + 1, codes.length), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ]),
          ),
      ]),
    ],
  ));
  return doc.save();
}
