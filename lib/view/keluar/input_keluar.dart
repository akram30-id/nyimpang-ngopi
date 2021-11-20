import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';

class InputKeluar extends StatefulWidget {
  final VoidCallback reload;

  InputKeluar(this.reload);

  @override
  _InputKeluarState createState() => _InputKeluarState();
}

class _InputKeluarState extends State<InputKeluar> {
  final _key = GlobalKey<FormState>();
  String nama_brg, jumlah, satuan, id_brg;
  final list = List<StokModel>();
  var loading = false;

  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     id_pg = preferences.getString("id");
  //   });
  // }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {
      print("ERROR");
    }
  }

  submit() async {
    final response = await http.post(Uri.parse(BaseUrl.brgKeluar), body: {
      'nama_brg': nama_brg,
      'jumlah': jumlah,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
      widget.reload();
      Navigator.pop(context);
    } else if (value == 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
    }
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
    // getPref();
    _lihatStok();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Input Barang Keluar",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: Stack(
          children: [
            Form(
              key: _key,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment(-1.0, 0.0),
                            child: Text(
                              "Nama Barang",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // TextFormField(
                          //   validator: (e) {
                          //     if (e.isEmpty) {
                          //       return "Nama Barang Harus Diisi";
                          //     }
                          //     return null;
                          //   },
                          //   onSaved: (e) => nama_brg = e,
                          //   decoration: InputDecoration(
                          //       hintText: "Contoh: Gelas Plastik"),
                          // ),

                          Align(
                            alignment: Alignment(-1.0, 0.0),
                            child: Container(
                              width: 200,
                              child: DropdownButton(
                                hint: Text('Pilih Barang'),
                                items: list.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value.namaBrg),
                                    value: value.namaBrg,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    nama_brg = value;
                                    print(nama_brg);
                                  });
                                },
                                value: nama_brg,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment(-1.0, 0.0),
                            child: Text(
                              "Jumlah",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Jumlah Barang Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => jumlah = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 1000"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      // Column(
                      //   children: [
                      //     Align(
                      //       alignment: Alignment(-1.0, 0.0),
                      //       child: Text(
                      //         "Satuan",
                      //         style: TextStyle(
                      //             fontSize: 20, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     TextFormField(
                      //       validator: (e) {
                      //         if (e.isEmpty) {
                      //           return "Satuan Barang Harus Diisi";
                      //         }
                      //         return null;
                      //       },
                      //       onSaved: (e) => satuan = e,
                      //       decoration:
                      //           InputDecoration(hintText: "Contoh: gram"),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, 1.0),
              child: InkWell(
                onTap: () {
                  check();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(161, 111, 35, 1)),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
