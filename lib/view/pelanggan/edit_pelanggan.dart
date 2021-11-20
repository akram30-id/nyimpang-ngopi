import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/pelanggan_model.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/view/pelanggan/pelanggan.dart';
import 'package:page_transition/page_transition.dart';

class EditPelanggan extends StatefulWidget {
  final PelangganModel model;
  final VoidCallback reload;
  EditPelanggan(this.reload, this.model);

  @override
  _EditPelangganState createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  final _key = GlobalKey<FormState>();
  String nama, telp, alamat;

  TextEditingController txtNama, txtTelp, txtAlamat;

  setup() {
    txtNama = TextEditingController(text: widget.model.nama);
    txtTelp = TextEditingController(text: widget.model.telp);
    txtAlamat = TextEditingController(text: widget.model.alamat);
  }

  editPelanggan() async {
    final response = await http.post(Uri.parse(BaseUrl.editPelanggan), body: {
      'id': widget.model.id,
      'nama': nama,
      'alamat': alamat,
      'telp': telp
    });
    final data = jsonDecode(response.body);
    String pesan = data['message'];
    int value = data['value'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        widget.reload();
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
      });
    }
  }

  submit() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      editPelanggan();
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
    final namaPelanggan = widget.model.nama;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: Pelanggan(), type: PageTransitionType.leftToRight));
          },
        ),
        backgroundColor: Colors.black,
        title: Text("Edit Data $namaPelanggan"),
      ),
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
                        "Nama",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      controller: txtNama,
                      onSaved: (e) => nama = e,
                      decoration: InputDecoration(hintText: "Contoh: Avriza"),
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
                      controller: txtAlamat,
                      onSaved: (e) => alamat = e,
                      decoration: InputDecoration(
                          hintText: "Contoh: Jl. P. Sumba Raya"),
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
                      controller: txtTelp,
                      onSaved: (e) => telp = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: 0812xxxxx"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
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
