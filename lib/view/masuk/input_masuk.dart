import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyimpang_ngopi/custom/currency.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:nyimpang_ngopi/view/masuk/masuk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';

class InputMasuk extends StatefulWidget {
  final VoidCallback reload;

  InputMasuk(this.reload);

  @override
  _InputMasukState createState() => _InputMasukState();
}

class _InputMasukState extends State<InputMasuk> {
  final _key = GlobalKey<FormState>();
  File _imageFile;
  String nama_brg, jumlah, satuan, harga, id_pg, nama_supplier;
  final list = List<BarangModel>();
  var loading = false;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_pg = preferences.getString("id");
    });
  }


  _pilihGalery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 1280, maxWidth: 720);
    setState(() {
      _imageFile = File(image.path);
      print(_imageFile.path);
    });
  }

  _pilihKamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1280, maxWidth: 720);
    setState(() {
      _imageFile = File(image.path);
      print(_imageFile);
    });
  }

  pilihMode() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return Dialog(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: [
                Center(
                  child: Text(
                    "Ambil gambar melalui :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 80,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Kamera',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () {
                        _pilihKamera();
                      },
                    ),
                    SizedBox(
                      width: 64.0,
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 80,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Galeri',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () {
                        _pilihGalery();
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  Future<void> _lihatStok() async {
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

  submit() async {
    try {
      var stream = http.ByteStream(DelegatingStream(_imageFile.openRead()));
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.brgMasuk);
      final request = http.MultipartRequest("POST", uri);

      request.fields['id_pg'] = id_pg;
      request.fields['nama_brg'] = nama_brg;
      request.fields['jumlah'] = jumlah;
      request.fields['harga'] = harga.replaceAll(",", "");
      request.fields['satuan'] = satuan;
      request.fields['nama_supplier'] = nama_supplier;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: context.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Upload Success");
        ScaffoldMessenger.of(this.context)
            .showSnackBar(SnackBar(content: Text('Item berhasil ditambahkan')));
        widget.reload();
        Navigator.push(this.context, MaterialPageRoute(builder: (context) {
          return Masuk();
        }));
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text('Gagal Ditambahkan'),
          backgroundColor: Colors.red,
        ));
        print("Upload Failed");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatStok();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset("img/placeholder.png"),
    );

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
            "Input Barang Masuk",
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
                        height: 30,
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
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Nama Barang Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => nama_brg = e,
                            decoration: InputDecoration(
                                hintText: "Contoh: Gelas Plastik"),
                          ),
                          // DropdownButton(
                          //   hint: Text('Pilih Barang'),
                          //   items: list.map((item) {
                          //     return DropdownMenuItem(
                          //       child: Text(item.namaBrg),
                          //       value: item.id.toString(),
                          //     );
                          //   }).toList(),
                          //   onChanged: (newItem) {
                          //     setState(() {
                          //       nama_brg = newItem;
                          //     });
                          //   },
                          //   value: nama_brg,
                          // )
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
                      Column(
                        children: [
                          Align(
                            alignment: Alignment(-1.0, 0.0),
                            child: Text(
                              "Satuan",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Satuan Barang Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => satuan = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: gram"),
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
                              "Harga Beli",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              // ignore: deprecated_member_use
                              WhitelistingTextInputFormatter.digitsOnly,
                              CurrencyFormat()
                            ],
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Harga Barang Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => harga = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 30,000"),
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
                              "Supplier",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Ketik - jika tidak menggunakan supplier";
                              }
                              return null;
                            },
                            onSaved: (e) => nama_supplier = e,
                            decoration: InputDecoration(
                                hintText: "Contoh: PT. Adaro Energy"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: InkWell(
                          onTap: () {
                            pilihMode();
                          },
                          child: _imageFile == null
                              ? placeholder
                              : Image.file(
                                  _imageFile,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Upload Image",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
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
