import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/balance_sheet_model.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:http/http.dart' as http;

class User {
  final String namaBrg;
  final String tglKeluar;
  final String jumlah;

  const User(
      {this.namaBrg, this.tglKeluar, this.jumlah});
}

class PdfApi {
  static Future<File> generateTable() async {
    final pdf = pw.Document();
    final list = List<BalanceSheetModel>();

    final response = await http.get(Uri.parse(BaseUrl.listBranch));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = BalanceSheetModel(
          api['id_branch'],
          api['kecamatan'],
          api['image'],
          api['pemasukan'],
          api['pengeluaran'],
          api['modal'],
          api['tgl'],
          api['id'],
        );
        list.insert(0, see);
      });
    }

    var h2 = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);

    pdf.addPage(pw.Page(
        build: (context) => pw.Column(children: [
              pw.Center(
                  child: pw.Text('Data Keuangan',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 20))),
              pw.SizedBox(height: 20),
              pw.Table(
                  border: pw.TableBorder.all(width: 1.0),
                  defaultColumnWidth: pw.FixedColumnWidth(100),
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.TableRow(children: [
                      pw.Center(child: pw.Text('Branch', style: h2)),
                      pw.Center(child: pw.Text('Modal', style: h2)),
                      pw.Center(child: pw.Text('Pemasukan', style: h2)),
                      pw.Center(child: pw.Text('Pengeluaran', style: h2)),
                      pw.Center(child: pw.Text('Tanggal', style: h2)),
                    ])
                  ]),
              pw.Table(
                  defaultColumnWidth: pw.FixedColumnWidth(100),
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  border: pw.TableBorder.all(width: 1.0),
                  children: list.map((e) {
                    return pw.TableRow(children: [
                      pw.Center(child: pw.Text(e.kecamatan)),
                      pw.Center(child: pw.Text(e.modal)),
                      pw.Center(child: pw.Text(e.pemasukan)),
                      pw.Center(child: pw.Text(e.pengeluaran)),
                      pw.Center(child: pw.Text(e.tgl)),
                    ]);
                  }).toList()),
            ])));
    // }
    return saveDocument(name: 'DataKeuangan.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String name,
    pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}


