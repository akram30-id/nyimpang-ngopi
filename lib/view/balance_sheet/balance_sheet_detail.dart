import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/balance_sheet_model.dart';
import 'package:nyimpang_ngopi/view/balance_sheet/balance_sheet.dart';
import 'package:http/http.dart' as http;

class BalanceSheetDetail extends StatefulWidget {
  final BalanceSheetModel model;
  final VoidCallback reload;

  BalanceSheetDetail(this.model, this.reload);

  @override
  _BalanceSheetDetailState createState() => _BalanceSheetDetailState();
}

class _BalanceSheetDetailState extends State<BalanceSheetDetail> {
  rugiMethod() {
    if (int.parse(widget.model.pemasukan) <
        int.parse(widget.model.pengeluaran)) {
      int rugi = int.parse(widget.model.pengeluaran) -
          int.parse(widget.model.pemasukan);
      return rugi;
    } else {
      return '0';
    }
  }

  untungMethod() {
    if (int.parse(widget.model.pemasukan) >
        int.parse(widget.model.pengeluaran)) {
      int untung = int.parse(widget.model.pemasukan) -
          int.parse(widget.model.pengeluaran);
      return untung;
    } else {
      return '0';
    }
  }

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deleteBs), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        print(pesan);
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  "Are you sure to delete this employee ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text("No"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    InkWell(
                      child: Text("Yes"),
                      onTap: () {
                        _delete(id);
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var h2 = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: 25,
    );
    var h3 = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 16,
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.black,
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.model.kecamatan,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Hero(
                  tag: widget.model.id,
                  child: Image.network(
                    BaseUrl.imgBranch + widget.model.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ];
        },
        body: Stack(
          children: [
            Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 180,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: Offset(0.0, 5.0))
                              ],
                              border: Border.all(
                                color: Color.fromRGBO(161, 111, 35, 1),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text("Modal ", style: h2),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Rp. " + widget.model.modal,
                                style: h3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0.0, 5.0))
                                ],
                                border: Border.all(
                                  color: Color.fromRGBO(161, 111, 35, 1),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Pemasukan ", style: h2),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Rp. " + widget.model.pemasukan,
                                  style: h3,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              width: 180,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(0.0, 5.0))
                                  ],
                                  border: Border.all(
                                    color: Color.fromRGBO(161, 111, 35, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Pengeluaran ", style: h2),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Rp. " + widget.model.pengeluaran,
                                    style: h3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 180,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(0.0, 5.0))
                                  ],
                                  border: Border.all(
                                    color: Color.fromRGBO(161, 111, 35, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Laba ", style: h2),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Rp. " + untungMethod().toString(),
                                    style: h3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 180,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0.0, 5.0))
                                ],
                                border: Border.all(
                                  color: Color.fromRGBO(161, 111, 35, 1),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Rugi ", style: h2),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Rp. " + rugiMethod().toString(),
                                  style: h3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                children: [
                  Container(
                    width: 300.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 0,
                      color: Color.fromRGBO(161, 111, 35, 1),
                      borderRadius: BorderRadius.circular(10.0),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 80.0,
                      child: Material(
                        elevation: 0,
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: MaterialButton(
                            onPressed: () {
                              dialogDelete(widget.model.id);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
