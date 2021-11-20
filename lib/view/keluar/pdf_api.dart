import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nyimpang_ngopi/model/api.dart';
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
    final list = List<BarangKeluarModel>();

    final response = await http.get(Uri.parse(BaseUrl.lihatBrg_keluar));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = BarangKeluarModel(
          api['id'],
          api['id_brg'],
          api['nama_brg'],
          api['jumlah'],
          api['satuan'],
          api['tgl_keluar'],
        );
        list.add(ab);
      });
    }

    var h2 = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);

    pdf.addPage(pw.Page(
        build: (context) => pw.Column(children: [
              pw.Center(
                  child: pw.Text('Data Stok',
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
                      pw.Center(child: pw.Text('Nama Barang', style: h2)),
                      pw.Center(child: pw.Text('Tanggal Keluar', style: h2)),
                      pw.Center(child: pw.Text('Jumlah', style: h2)),
                    ])
                  ]),
              pw.Table(
                  defaultColumnWidth: pw.FixedColumnWidth(100),
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  border: pw.TableBorder.all(width: 1.0),
                  children: list.map((e) {
                    return pw.TableRow(children: [
                      pw.Center(child: pw.Text(e.namaBrg)),
                      pw.Center(child: pw.Text(e.tglKeluar)),
                      pw.Center(child: pw.Text(e.jumlah)),
                    ]);
                  }).toList()),
            ])));
    // }
    return saveDocument(name: 'BarangKeluar.pdf', pdf: pdf);
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
