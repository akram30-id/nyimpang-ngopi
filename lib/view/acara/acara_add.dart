import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/view/acara/datepick.dart';
import 'package:http/http.dart' as http;

class AcaraAdd extends StatefulWidget {
  final VoidCallback reload;
  AcaraAdd(this.reload);
  @override
  _AcaraAddState createState() => _AcaraAddState();
}

class _AcaraAddState extends State<AcaraAdd> {
  final _key = GlobalKey<FormState>();
  String nama_acara, deskripsi, tempat;

  submit() async {
    final response = await http.post(Uri.parse(BaseUrl.tambahAcara), body: {
      "nama_acara": nama_acara,
      "deskripsi": deskripsi,
      "tempat": tempat,
      "time": "$time",
    });
    final data = jsonDecode(response.body);
    String pesan = data['massage'];
    int value = data['value'];
    if (value == 1) {
      print(pesan);
      widget.reload();
      Navigator.pop(context);
    } else {
      print(pesan);
    }
  }

  String pilihTanggal, labelText;
  DateTime time = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
        pilihTanggal = new DateFormat('EEE, d/M/y').format(time);
      });
    } else {}
  }

  cek() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Acara"),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment(-1.0, 0.0),
                  child: Text(
                    "Nama Acara",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Masukkan Nama Acara";
                    }
                    return null;
                  },
                  onSaved: (e) => nama_acara = e,
                  decoration: InputDecoration(
                    hintText: "Contoh: Pelatihan Digital Marketing",
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment(-1.0, 0.0),
                  child: Text(
                    "Deskripsi Acara",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Masukkan Deskripsi Acara";
                    }
                    return null;
                  },
                  onSaved: (e) => deskripsi = e,
                  decoration: InputDecoration(
                    hintText: "Contoh: Harap datang tepat waktu",
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment(-1.0, 0.0),
                  child: Text(
                    "Lokasi",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Masukkan Lokasi";
                    }
                    return null;
                  },
                  onSaved: (e) => tempat = e,
                  decoration: InputDecoration(
                    hintText: "Contoh: Nyimpang Ngopi Cab.Bekasi",
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment(-1.0, 0.0),
                  child: Text(
                    "Tanggal Acara",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                DateDropDown(
                  labelText: labelText,
                  valueText: new DateFormat('EEE, d/M/y').format(time),
                  valueStyle: valueStyle,
                  onPressed: () {
                    _selectedDate(context);
                  },
                ),
                SizedBox(
                  height: 70,
                ),
                InkWell(
                  onTap: cek,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
