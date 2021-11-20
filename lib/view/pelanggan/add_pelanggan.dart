import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/api.dart';

class AddPelanggan extends StatefulWidget {
  final VoidCallback reload;
  AddPelanggan(this.reload);

  @override
  _AddPelangganState createState() => _AddPelangganState();
}

class _AddPelangganState extends State<AddPelanggan> {
  String nama, alamat, telp;
  final _key = GlobalKey<FormState>();

  addPelanggan() async {
    final response = await http.post(Uri.parse(BaseUrl.addPelanggan),
        body: {'nama': nama, 'alamat': alamat, 'telp': telp});
    final data = jsonDecode(response.body);
    String pesan = data['message'];
    int value = data['value'];

    if (value == 1) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
      widget.reload();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  submit() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      addPelanggan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Employee"),
      ),
      body: Form(
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
                        "Nama Pelanggan",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Nama Pelanggan Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => nama = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: Donald Trump"),
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
                        "Alamat",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Alamat Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => alamat = e,
                      decoration: InputDecoration(
                          hintText: "Contoh: Jl. Pulau Sumba Raya"),
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
                        "Nomor Telepon",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Nomor Telepon Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => telp = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: 08123456789"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
                InkWell(
                  onTap: () {
                    submit();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(161, 111, 35, 1),
                        borderRadius: BorderRadius.circular(25)),
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
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
