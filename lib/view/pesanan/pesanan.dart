import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/home.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/pesanan_model.dart';
import 'package:nyimpang_ngopi/view/pesanan/detail_pesanan.dart';
import 'package:nyimpang_ngopi/view/pesanan/input_pesanan.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pesanan extends StatefulWidget {
  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  var loading = false;
  final list = List<PesananModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  String id_pg;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_pg = preferences.getString('id');
    });
  }

  Future<void> _lihatPesanan() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.seePesanan));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = PesananModel(
          api['id'],
          api['id_pg'],
          api['nama'],
          api['pemesan'],
          api['barang'],
          api['jumlah'],
          api['harga'],
          api['tgl'],
          api['alamat'],
          api['telp'],
          api['invoice'],
          api['status'],
          api['total'],
        );
        list.add(see);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deletePesanan), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        _lihatPesanan();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
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
                  "Are you sure to delete this item ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40.0,
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
                      width: 16.0,
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

  _status(String id, status) async {
    final response = await http.post(Uri.parse(BaseUrl.editPesanan), body: {
      "id": id,
      "status": status,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        _lihatPesanan();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  dialogStatus(String id, status) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  "Ubah status pesanan ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Column(
                  children: [
                    InkWell(
                      child: Text("Diproses"),
                      onTap: () {
                        _status(id, status = "Proses");
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    InkWell(
                      child: Text("Terkirim"),
                      onTap: () {
                        _status(id, status = "Terkirim");
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    InkWell(
                      child: Text("Batal"),
                      onTap: () {
                        _status(id, status = "Batal");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatPesanan();
    // status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                  child: InputPesanan(_lihatPesanan),
                  type: PageTransitionType.scale,
                  alignment: Alignment.bottomRight,
                  duration: Duration(milliseconds: 600)),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text("Data Pesanan"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatPesanan,
        key: _refresh,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: DetailPesanan(x),
                                  type: PageTransitionType.scale,
                                  alignment: Alignment.bottomCenter,
                                  duration: Duration(milliseconds: 600)),
                            );
                          },
                          child: Container(
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
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      x.barang,
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_rounded),
                                      onPressed: () {
                                        dialogDelete(x.id);
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Pemesan : "),
                                    Expanded(
                                      child: Text(x.pemesan),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Text(x.jumlah),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.request_page_rounded,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Text("#" + x.invoice),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                x.status == "Proses"
                                    ? InkWell(
                                        onTap: () {
                                          dialogStatus(x.id, x.status);
                                        },
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  161, 111, 35, 1),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.pending_actions_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                x.status,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : x.status == "Terkirim"
                                        ? InkWell(
                                            onTap: () {
                                              dialogStatus(x.id, x.status);
                                            },
                                            child: Container(
                                              width: 250,
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    x.status,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              dialogStatus(x.id, x.status);
                                            },
                                            child: Container(
                                              width: 250,
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    x.status,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  void signOut() {}
}
