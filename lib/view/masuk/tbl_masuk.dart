import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/view/masuk/pdf_api.dart';


class TabelMasuk extends StatefulWidget {
  @override
  _TabelMasukState createState() => _TabelMasukState();
}

class _TabelMasukState extends State<TabelMasuk> {
  var loading = false;
  final list = List<BarangModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatBarang() async {
    list.clear();
    setState(() {
      loading = true;
    });
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.print),
          onPressed: () async{
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
                                    child: Text(
                                  "Nama Barang",
                                  textAlign: TextAlign.center,
                                  style: headerstyle,
                                )),
                                TableCell(
                                    child: Text(
                                  "Stok",
                                  textAlign: TextAlign.center,
                                  style: headerstyle,
                                )),
                                TableCell(
                                    child: Text(
                                  "Harga",
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
