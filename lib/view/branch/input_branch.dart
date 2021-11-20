import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nyimpang_ngopi/custom/currency.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/branch_model.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class InputBranch extends StatefulWidget {
  final VoidCallback reload;

  InputBranch(this.reload);

  @override
  _InputBranchState createState() => _InputBranchState();
}

class _InputBranchState extends State<InputBranch> {
  final _key = GlobalKey<FormState>();
  File _imageFile;
  String jalan, rt, rw, kelurahan, kecamatan, kode_pos, kota;
  final list = List<BranchModel>();
  var loading = false;

  _pilihGalery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 1280, maxWidth: 720);
    setState(() {
      _imageFile = File(image.path);
      print(_imageFile.path);
    });
  }

  submit() async {
    try {
      var stream = http.ByteStream(DelegatingStream(_imageFile.openRead()));
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.addBranch);
      final request = http.MultipartRequest("POST", uri);

      request.fields['jalan'] = jalan;
      request.fields['rt'] = rt;
      request.fields['rw'] = rw;
      request.fields['kelurahan'] = kelurahan;
      request.fields['kecamatan'] = kecamatan;
      request.fields['kode_pos'] = kode_pos;
      request.fields['kota'] = kota;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: context.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Upload Success");
        setState(() {
          ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(content: Text('Item berhasil ditambahkan')));
          widget.reload();
          Navigator.pop(this.context);
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
            content: Text('Gagal Ditambahkan'),
            backgroundColor: Colors.red,
          ));
        });
        print("Upload Failed");
      }
    } catch (e) {
      print(e);
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
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
            "Input Branch",
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
                              "Nama Jalan",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Nama Jalan Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => jalan = e,
                            decoration: InputDecoration(
                                hintText:
                                    "Contoh: Jalan Pulau Sawu Raya No 14"),
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
                              "RT",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "RT Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => rt = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 007"),
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
                              "RW",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "RW Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => rw = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 010"),
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
                              "Kelurahan",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Kelurahan Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => kelurahan = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: Aren Jaya"),
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
                              "Kecamatan",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Kecamatan Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => kecamatan = e,
                            decoration: InputDecoration(
                                hintText: "Contoh: Bekasi Timur"),
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
                              "Kode POS",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Kode POS harus diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => kode_pos = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 17111"),
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
                              "Kota",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Kota harus diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => kota = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: Bekasi"),
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
                            _pilihGalery();
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
