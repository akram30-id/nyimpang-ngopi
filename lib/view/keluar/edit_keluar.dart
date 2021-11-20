import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/brg_model.dart';
import 'package:http/http.dart' as http;

class EditKeluar extends StatefulWidget {
  final BarangKeluarModel model;
  final VoidCallback reload;

  EditKeluar(this.model, this.reload);

  @override
  _EditKeluarState createState() => _EditKeluarState();
}

class _EditKeluarState extends State<EditKeluar> {

  final _key = GlobalKey<FormState>();
  String nama_brg, jumlah, satuan;

  TextEditingController txtnamaBrg, txtjumlah, txtsatuan;

  setup() {
    txtnamaBrg = TextEditingController(text: widget.model.namaBrg);
    txtjumlah = TextEditingController(text: widget.model.jumlah);
    txtsatuan = TextEditingController(text: widget.model.satuan);
  }

  submit() async {
    final response = await http.post(Uri.parse(BaseUrl.editKeluar), body: {
      "nama_brg": nama_brg,
      "jumlah": jumlah,
      "satuan": satuan,
      "id": widget.model.id,
    });
    final data = jsonDecode(response.body);
    String pesan = data['message'];
    int value = data['value'];

    if (value == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
      Navigator.pop(context);
      widget.reload();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  cek() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {
      print(debugPrint);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
              padding: EdgeInsets.only(bottom: 10),
              icon: (Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: Colors.black,
              )),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
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
                      enabled: false,
                      controller: txtnamaBrg,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Nama Barang Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => nama_brg = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: Gelas Plastik"),
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
                      controller: txtjumlah,
                      validator: (e) {
                        if (int.parse(e) <= int.parse(widget.model.jumlah)) {
                          return "Seharusnya bertambah!";
                        }
                        return null;
                      },
                      onSaved: (e) => jumlah = e,
                      decoration: InputDecoration(hintText: "Contoh: 1000"),
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
                      controller: txtsatuan,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Satuan Barang Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => satuan = e,
                      decoration: InputDecoration(hintText: "Contoh: gram"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(161, 111, 35, 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    cek();
                  },
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}