import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/view/stok/pdf_api.dart';

class TabelStok extends StatefulWidget {
  @override
  _TabelStokState createState() => _TabelStokState();
}

class _TabelStokState extends State<TabelStok> {
  var loading = false;
  final list = List<StokModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatStok() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.lihatBrg_stok));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = StokModel(
          api['nama_brg'],
          api['jumlah'],
          api['harga'],
          api['satuan'],
          api['id_brg'],
          api['tgl_masuk'],
          api['image'],
          api['id'],
          api['nama_supplier'],
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
    _lihatStok();
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
          onRefresh: _lihatStok,
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
                          0: FlexColumnWidth(1.5),
                          1: FlexColumnWidth(2),
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
                                      "Stok",
                                      textAlign: TextAlign.center,
                                      style: headerstyle,
                                    )),
                                TableCell(
                                    verticalAlignment: cellVertiacalAlignment,
                                    child: Text(
                                      "Harga",
                                      textAlign: TextAlign.center,
                                      style: headerstyle,
                                    )),
                                TableCell(
                                    verticalAlignment: cellVertiacalAlignment,
                                    child: Text(
                                      "Tgl Masuk",
                                      textAlign: TextAlign.center,
                                      style: headerstyle,
                                    )),
                                TableCell(
                                    verticalAlignment: cellVertiacalAlignment,
                                    child: Text(
                                      "Supplier",
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
                                    0: FlexColumnWidth(1.5),
                                    1: FlexColumnWidth(2),
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
                                        x.harga,
                                        textAlign: TextAlign.center,
                                        style: cellstyle,
                                      )),
                                      TableCell(
                                          child: Text(
                                        x.tglmasuk,
                                        textAlign: TextAlign.center,
                                        style: cellstyle,
                                      )),
                                      TableCell(
                                          child: Text(
                                        x.namaSup,
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
