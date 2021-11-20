import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:http/http.dart' as http;

class User {
  final String namaBrg;
  final String tglMasuk;
  final String jumlah;
  final String harga;
  final String supplier;

  const User(
      {this.namaBrg, this.tglMasuk, this.jumlah, this.harga, this.supplier});
}

class PdfApi {
  static Future<File> generateTable() async {
    final pdf = pw.Document();
    final list = List<BarangModel>();

    final response = await http.get(Uri.parse(BaseUrl.lihatBrg));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = BarangModel(
          api['nama_brg'],
          api['jumlah'],
          api['harga'],
          api['satuan'],
          api['id_pg'],
          api['tgl_masuk'],
          api['image'],
          api['id'],
          api['nama_supplier'],
          api['nama'],
        );
        list.add(ab);
      });
    }

    var h2 = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);

    pdf.addPage(pw.Page(
        build: (context) => pw.Column(children: [
              pw.Center(
                  child: pw.Text('Data Barang Masuk',
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
                      pw.Center(child: pw.Text('Tanggal Masuk', style: h2)),
                      pw.Center(child: pw.Text('Jumlah', style: h2)),
                      pw.Center(child: pw.Text('Harga', style: h2)),
                      pw.Center(child: pw.Text('Supplier', style: h2))
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
                      pw.Center(child: pw.Text(e.tglmasuk)),
                      pw.Center(child: pw.Text(e.jumlah)),
                      pw.Center(child: pw.Text(e.harga)),
                      pw.Center(child: pw.Text(e.namaSup))
                    ]);
                  }).toList()),
            ])));
    // }
    return saveDocument(name: 'BarangMasuk.pdf', pdf: pdf);
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
