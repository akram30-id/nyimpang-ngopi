import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/home.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/pelanggan_model.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/view/pelanggan/add_pelanggan.dart';
import 'package:nyimpang_ngopi/view/pelanggan/edit_pelanggan.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class Pelanggan extends StatefulWidget {
  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  var loading = false;
  final list = List<PelangganModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatPelanggan() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.seePelanggan));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = PelangganModel(
          api['id'],
          api['nama'],
          api['alamat'],
          api['telp'],
        );
        list.add(see);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deletePelanggan), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        _lihatPelanggan();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  "Apakah Anda yakin ingin menghapus pelanggan ini ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text("No"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                      child: Text("Yes"),
                      onTap: () {
                        _delete(id);
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddPelanggan(_lihatPelanggan);
            }));
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Data Pelanggan"),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatPelanggan,
        key: _refresh,
        child: loading
            ? Center(
                child: Text(
                  "No Data Found",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  final telp = x.telp;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return EmployeeDetail(x, _lihatPegawai);
                            // }));
                          },
                          onLongPress: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return EmployeeEdit(_lihatPegawai, x);
                            // }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0.0, 5.0))
                                ],
                                border: Border.all(
                                  color: Color.fromRGBO(161, 111, 35, 1),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      x.nama,
                                      style: TextStyle(
                                          fontSize: 25,
                                          color:
                                              Color.fromRGBO(161, 111, 35, 1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color.fromRGBO(161, 111, 35, 1),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: EditPelanggan(
                                                    _lihatPelanggan, x),
                                                type: PageTransitionType
                                                    .rightToLeft));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_rounded,
                                        color: Color.fromRGBO(161, 111, 35, 1),
                                      ),
                                      onPressed: () {
                                        dialogDelete(x.id);
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.supervisor_account_rounded,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Text(x.nama),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Text(x.alamat),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print(telp);
                                    launch('tel://$telp');
                                  },
                                  child: Container(
                                    width: 250,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          x.telp,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  void signOut() {}
}
