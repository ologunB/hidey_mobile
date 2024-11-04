import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<void> generateReceipt(String path, String privateKey) async {
  Invoice invoice = Invoice();
  return await invoice.buildPdf(privateKey, path);
}

class Invoice {
  String? _logo;

  Future<void> buildPdf(String privateKey, String path) async {
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/images/logo.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: await _buildTheme(PdfPageFormat.a4),
        header: _buildHeader,
        build: (context) => [_contentBody(context, privateKey)],
      ),
    );

    try {
      String _path = path + '/HideyKey.pdf';
      final File file = File(_path);
      await file.writeAsBytes(await doc.save());

      Share.shareXFiles(
        [XFile(_path)],
        text: 'Share Key',
        subject: 'Share Key',
      );
    } catch (e) {
      print(e);
    }
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.SvgImage(svg: _logo!, height: 50),
              ),
            )
          ],
        ),
        pw.Text(
          'Powered On Hidey',
          style: const pw.TextStyle(fontSize: 18, color: PdfColors.black),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _contentBody(pw.Context context, String privateKey) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(fontSize: 16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 120),
                pw.SizedBox(
                  height: 260,
                  child: pw.BarcodeWidget(
                    data: privateKey,
                    barcode: pw.Barcode.qrCode(),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  privateKey,
                  style: pw.TextStyle(
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<pw.PageTheme> _buildTheme(PdfPageFormat pageFormat) async {
    return pw.PageTheme(
      pageFormat: pageFormat,
      buildBackground: (context) => pw.FullPage(ignoreMargins: true),
    );
  }
}
