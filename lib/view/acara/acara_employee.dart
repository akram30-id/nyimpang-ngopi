import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/acara_model.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:http/http.dart' as http;

class AcaraEmployee extends StatefulWidget {
  @override
  _AcaraEmployeeState createState() => _AcaraEmployeeState();
}

class _AcaraEmployeeState extends State<AcaraEmployee> {
  var loading = false;
  final list = List<AcaraModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatAcara() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.lihatAcara));
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = AcaraModel(
          api['id'],
          api['nama_acara'],
          api['deskripsi'],
          api['tempat'],
          api['time'],
        );
        list.add(see);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatAcara();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Jadwal Acara"),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatAcara,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return SingleChildScrollView(
                    child: Column(children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 250,
                                  child: Text(
                                    x.nama_acara,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                  child: Text(x.tempat),
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
                                  Icons.sticky_note_2,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(x.deskripsi),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 250,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    x.time,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ]),
                  );
                }),
      ),
    );
  }
}
