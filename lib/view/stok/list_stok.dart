import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';
import 'package:nyimpang_ngopi/view/stok/detail_stok.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListStok extends StatefulWidget {
  @override
  _ListStokState createState() => _ListStokState();
}

class _ListStokState extends State<ListStok> {
  var loading = false;
  final list = List<StokModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  String id;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString('id');
    });
  }

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
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.black,
        //   child: Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) {
        //       return InputStok(_lihatStok);
        //     }));
        //   },
        // ),
        body: RefreshIndicator(
          onRefresh: _lihatStok,
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailStok(x, _lihatStok);
                            }));
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
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    // IconButton(
                                    //     icon: (Icon(
                                    //       Icons.edit,
                                    //       size: 20,
                                    //       color:
                                    //           Color.fromRGBO(161, 111, 35, 1),
                                    //     )),
                                    //     onPressed: () {
                                    //       // Navigator.push(context,
                                    //       //     MaterialPageRoute(
                                    //       //         builder: (context) {
                                    //       //   return EditMasuk(x, _lihatBarang);
                                    //       // }));
                                    //     })
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
                                      width: 200,
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
