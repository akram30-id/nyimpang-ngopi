import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/branch_model.dart';
import 'package:http/http.dart' as http;

class EditBranch extends StatefulWidget {
  final BranchModel model;
  final VoidCallback reload;

  EditBranch(this.model, this.reload);

  @override
  _EditBranchState createState() => _EditBranchState();
}

class _EditBranchState extends State<EditBranch> {
  final _key = GlobalKey<FormState>();
  String jalan, rt, rw, kelurahan, kecamatan, kode_pos, kota;

  TextEditingController txtJalan,
      txtRt,
      txtRw,
      txtKelurahan,
      txtKecamatan,
      txtKodePos,
      txtKota;

  setup() {
    txtJalan = TextEditingController(text: widget.model.jalan);
    txtRt = TextEditingController(text: widget.model.rt);
    txtRw = TextEditingController(text: widget.model.rw);
    txtKelurahan = TextEditingController(text: widget.model.kelurahan);
    txtKecamatan = TextEditingController(text: widget.model.kecamatan);
    txtKodePos = TextEditingController(text: widget.model.kode_pos);
    txtKota = TextEditingController(text: widget.model.kota);
  }

  submit() async {
    final response = await http.post(Uri.parse(BaseUrl.editBranch), body: {
      "id": widget.model.id,
      "jalan": jalan,
      "rt": rt,
      "rw": rw,
      "kelurahan": kelurahan,
      "kecamatan": kecamatan,
      "kode_pos": kode_pos,
      "kota": kota,
    });
    final data = jsonDecode(response.body);
    String pesan = data['message'];
    int value = data['value'];

    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        Navigator.pop(context);
        widget.reload();        
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
      });
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
      appBar: AppBar(
        title: Text("Edit Branch"),
        backgroundColor: Colors.black,
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
                        "Nama Jalan",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      controller: txtJalan,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Nama Jalan Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => jalan = e,
                      decoration: InputDecoration(
                          hintText: "Contoh: Jalan Pulau Sawu Raya No 14"),
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
                        "RT",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: txtRt,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "RT Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => rt = e,
                      decoration: InputDecoration(hintText: "Contoh: 007"),
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
                      controller: txtRw,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "RW Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => rw = e,
                      decoration: InputDecoration(hintText: "Contoh: 010"),
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
                      controller: txtKelurahan,
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
                      controller: txtKecamatan,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Kecamatan Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => kecamatan = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: Bekasi Timur"),
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
                      controller: txtKodePos,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Kode POS harus diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => kode_pos = e,
                      decoration: InputDecoration(hintText: "Contoh: 17111"),
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
                      controller: txtKota,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Kota harus diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => kota = e,
                      decoration: InputDecoration(hintText: "Contoh: Bekasi"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
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
