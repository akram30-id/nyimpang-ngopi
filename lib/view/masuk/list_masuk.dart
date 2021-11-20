import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:nyimpang_ngopi/model/totalMasukModel.dart';
import 'package:nyimpang_ngopi/view/masuk/edit_masuk.dart';
import 'package:nyimpang_ngopi/view/masuk/input_masuk.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListMasuk extends StatefulWidget {

  @override
  _ListMasukState createState() => _ListMasukState();
}

class _ListMasukState extends State<ListMasuk> {
  final money = NumberFormat("#,##0", "en_US");

  var loading = false;
  final list = List<BarangModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  String idPg;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPg = preferences.getString('id');
      print(idPg);
    });
  }

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

  // String total = "0";
  // final ex = List<TotalStokMasukModel>();
  // _totalItems() async {
  //   ex.clear();
  //   final response = await http.get(Uri.parse(BaseUrl.totalStok_masuk));
  //   final data = jsonDecode(response.body);
  //   data.forEach((api) {
  //     final exp = TotalStokMasukModel(api['total_jumlah']);
  //     ex.add(exp);
  //     setState(() {
  //       total = exp.total;
  //     });
  //   });
  // }

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deleteItems_masuk), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        _lihatBarang();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatBarang();
    // _totalItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return InputMasuk(_lihatBarang);
            }));
          },
        ),
        body: RefreshIndicator(
          onRefresh: _lihatBarang,
          key: _refresh,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return DetailMasuk(x, _lihatBarang);
                            // }));
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
                                      "Supplier : " + x.namaSup,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromRGBO(161, 111, 35, 1),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    IconButton(
                                        icon: (Icon(
                                          Icons.edit,
                                          size: 20,
                                          color:
                                              Color.fromRGBO(161, 111, 35, 1),
                                        )),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return EditMasuk(x, _lihatBarang);
                                          }));
                                        }),
                                    IconButton(
                                        icon: (Icon(
                                          Icons.delete_rounded,
                                          size: 20,
                                          color:
                                              Color.fromRGBO(161, 111, 35, 1),
                                        )),
                                        onPressed: () {
                                          dialogDelete(x.id);
                                        })
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      x.namaBrg,
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          x.jumlah,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          x.satuan,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 190,
                                    ),
                                    Expanded(
                                      child: Text(
                                        x.tglmasuk,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Uploaded by : ",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      x.nama,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  }),
        ),
      ),
    );
  }
}
