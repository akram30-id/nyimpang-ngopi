import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nyimpang_ngopi/custom/currency.dart';
import 'package:nyimpang_ngopi/custom/date_pick.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/view/pesanan/pesanan.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class InputPesanan extends StatefulWidget {
  final VoidCallback reload;

  InputPesanan(this.reload);

  @override
  _InputPesananState createState() => _InputPesananState();
}

class _InputPesananState extends State<InputPesanan> {
  final _key = GlobalKey<FormState>();
  List _status = ['Proses', 'Terkirim', 'Batal'];

  String idPg, barang, pemesan, jumlah, harga, alamat, telp, invoice, status;
  var random = math.Random().nextInt(1000000);

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPg = preferences.getString('id');
    });
  }

  input() async {
    final response = await http.post(Uri.parse(BaseUrl.addPesanan), body: {
      'id_pg': idPg,
      'pemesan': pemesan,
      'barang': barang,
      'jumlah': jumlah,
      'harga': harga.replaceAll(",", ""),
      'tgl': "$tgl",
      'alamat': alamat,
      'telp': telp,
      'invoice': random.toString(),
      'status': status
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

  // randomInvoice() {
  //   var rnd = math.Random();
  //   var next = rnd.nextInt(1000000);
  //   // while (next < 1000000000000000) {
  //   //   next *= 10;
  //   // }
  //   print(next);
  //   setState(() {
  //     return next;
  //   });
  // }

  String pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: tgl,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    }
  }

  submit() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      input();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Pesanan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Form(
            key: _key,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
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
                          "Nama Pemesan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Ketik - jika ingin mengosongkan";
                          }
                          return null;
                        },
                        onSaved: (e) => pemesan = e,
                        decoration:
                            InputDecoration(hintText: "Contoh: Barrack Obama"),
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
                          "Nama Barang",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Nama Barang wajib diisi";
                          }
                          return null;
                        },
                        onSaved: (e) => barang = e,
                        decoration:
                            InputDecoration(hintText: "Contoh: Kopsus Aren"),
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
                          "Harga",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          CurrencyFormat()
                        ],
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Harga wajib diisi";
                          }
                          return null;
                        },
                        onSaved: (e) => harga = e,
                        decoration: InputDecoration(hintText: "Contoh: 50,000"),
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
                          "Jumlah Pesanan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Jumlah Pesanan wajib diisi";
                          }
                          return null;
                        },
                        onSaved: (e) => jumlah = e,
                        decoration: InputDecoration(hintText: "Contoh: 100"),
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
                          "Alamat Pesanan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Alamat Pesanan wajib diisi";
                          }
                          return null;
                        },
                        onSaved: (e) => alamat = e,
                        decoration: InputDecoration(
                            hintText: "Contoh: Jl. Pulau Sumba Raya No.1"),
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
                            return "Nomor Telepon wajib diisi";
                          }
                          return null;
                        },
                        onSaved: (e) => telp = e,
                        decoration:
                            InputDecoration(hintText: "Contoh: 0876357833987"),
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
                          "Tanggal Pesanan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DateDropDown(
                        labelText: labelText,
                        valueText: new DateFormat.yMd().format(tgl),
                        valueStyle: valueStyle,
                        onPressed: () {
                          _selectedDate(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment(-1.0, 0.0),
                        child: Text(
                          "Status Pesanan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: DropdownButton(
                          hint: Text(
                            'Pilih Status',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          value: status,
                          items: _status.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              status = value;
                              print(status);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: InkWell(
              onTap: () {
                submit();
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
    );
  }
}
