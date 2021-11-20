import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nyimpang_ngopi/custom/currency.dart';
import 'package:nyimpang_ngopi/custom/date_pick.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/balance_sheet_model.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/branch_model.dart';

class AddBalanceSheet extends StatefulWidget {
  final VoidCallback reload;

  AddBalanceSheet(this.reload);

  @override
  _AddBalanceSheetState createState() => _AddBalanceSheetState();
}

class _AddBalanceSheetState extends State<AddBalanceSheet> {
  final _key = GlobalKey<FormState>();
  final list = List<BranchModel>();
  var loading = false;

  String kecamatan, image, pemasukan, pengeluaran, modal, id_branch;

  Future<void> _lihatBranch() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.seeBranch));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = BranchModel(
          api['jalan'],
          api['rt'],
          api['rw'],
          api['kelurahan'],
          api['kecamatan'],
          api['kode_pos'],
          api['kota'],
          api['image'],
          api['id'],
        );
        list.add(see);
      });
      setState(() {
        loading = false;
      });
    }
  }

  input() async {
    final response = await http.post(Uri.parse(BaseUrl.inputBs), body: {
      'kecamatan': kecamatan,
      'pemasukan': pemasukan.replaceAll(",", ""),
      'pengeluaran': pengeluaran.replaceAll(",", ""),
      'tgl': '$tgl',
      'modal': modal.replaceAll(",", ""),
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

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      input();
    } else {
      print("ERROR");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatBranch();
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
            "Input Laporan Keuangan",
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
                              "Tanggal Laporan",
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
                        children: [
                          Align(
                            alignment: Alignment(-1.0, 0.0),
                            child: Text(
                              "Branch",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment(-1.0, 0.0),
                            child: Container(
                              width: 200,
                              child: DropdownButton(
                                hint: Text('Pilih Branch'),
                                items: list.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value.kecamatan),
                                    value: value.kecamatan,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    kecamatan = value;
                                    print(kecamatan);
                                  });
                                },
                                value: kecamatan,
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
                              "Modal Masuk",
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
                                return "Modal Harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => modal = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 1,000,000"),
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
                              "Pemasukan",
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
                                return "Pemasukan harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => pemasukan = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 1,000,000"),
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
                              "Pengeluaran",
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
                                return "Pengeluaran harus Diisi";
                              }
                              return null;
                            },
                            onSaved: (e) => pengeluaran = e,
                            decoration:
                                InputDecoration(hintText: "Contoh: 1,000,000"),
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
