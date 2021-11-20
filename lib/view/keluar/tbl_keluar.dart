import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/view/keluar/pdf_api.dart';

class TabelKeluar extends StatefulWidget {
  @override
  _TabelKeluarState createState() => _TabelKeluarState();
}

class _TabelKeluarState extends State<TabelKeluar> {
  var loading = false;
  final list = List<BarangKeluarModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatBarang() async {
    list.clear();
    setState(() {
      loading = true;
    });
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
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatBarang();
  }

  @override
  Widget build(BuildContext context) {
    var cellstyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w500);
    var headerstyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    var cellVertiacalAlignment = TableCellVerticalAlignment.middle;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.print),
          onPressed: () async {
            final pdfFile = await PdfApi.generateTable();
            PdfApi.openFile(pdfFile);
          },
        ),
        body: RefreshIndicator(
          onRefresh: _lihatBarang,
          key: _refresh,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        border: TableBorder.all(width: 1),
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(161, 111, 35, 1),
                              ),
                              children: [
                                TableCell(
                                    verticalAlignment: cellVertiacalAlignment,
                                    child: Text(
                                      "Nama Barang",
                                      textAlign: TextAlign.center,
                                      style: headerstyle,
                                    )),
                                TableCell(
                                    verticalAlignment: cellVertiacalAlignment,
                                    child: Text(
                                      "Jumlah Keluar",
                                      textAlign: TextAlign.center,
                                      style: headerstyle,
                                    )),
                                TableCell(
                                    verticalAlignment: cellVertiacalAlignment,
                                    child: Text(
                                      "Tanggal Keluar",
                                      textAlign: TextAlign.center,
                                      style: headerstyle,
                                    )),
                              ]),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                  },
                                  border: TableBorder.all(width: 1),
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        x.namaBrg,
                                        textAlign: TextAlign.center,
                                        style: cellstyle,
                                      )),
                                      TableCell(
                                          child: Text(
                                        x.jumlah + " " + x.satuan,
                                        textAlign: TextAlign.center,
                                        style: cellstyle,
                                      )),
                                      TableCell(
                                          child: Text(
                                        x.tglKeluar,
                                        textAlign: TextAlign.center,
                                        style: cellstyle,
                                      )),
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
