import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';
import 'package:nyimpang_ngopi/model/totalMasukModel.dart';
import 'package:nyimpang_ngopi/view/inventori.dart';
import 'package:http/http.dart' as http;
import 'list_stok.dart' as list_stok;
import 'tbl_stok.dart' as tbl_stok;

class Stok extends StatefulWidget {
  @override
  _StokState createState() => _StokState();
}

class _StokState extends State<Stok> with SingleTickerProviderStateMixin {
  TabController controller;

  String total = "0";
  final ex = List<TotalStokModel>();
  _totalStok() async {
    ex.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalStok));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = TotalStokModel(api['total_jumlah']);
      ex.add(exp);
      setState(() {
        total = exp.total;
      });
      print(total);
    });
  }

  String totalItems = "0";
  final lx = List<TotalitemMasukModel>();
  _totalItems() async {
    lx.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalItems));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final lxp = TotalitemMasukModel(api['total_items']);
      lx.add(lxp);
      setState(() {
        totalItems = lxp.totalItems;
      });
      print(totalItems);
    });
  }

  @override
  void initState() {
    controller = new TabController(length: 2, vsync: this);
    _totalItems();
    _totalStok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Stack(
              children: [
                Center(
                    child: Container(
                  width: double.infinity,
                  height: 150,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(60)),
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                )),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return Inventori(signOut);
                        // }));
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        margin: EdgeInsets.only(left: 10, top: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black.withOpacity(0.5)),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 35),
                      child: Text(
                        "Stok Barang",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    width: 350,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0.0, 0.0),
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              totalItems == "0"
                                  ? Text(
                                      "0",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      totalItems,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Total Items",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              total == "0"
                                  ? Text(
                                      "0",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      total,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Total Stok",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TabBar(
              indicatorColor: Color.fromRGBO(161, 111, 35, 1),
              unselectedLabelColor: Colors.black,
              labelColor: Color.fromRGBO(161, 111, 35, 1),
              controller: controller,
              tabs: [
                Tab(
                  text: "List View",
                ),
                Tab(
                  text: "Table View",
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  list_stok.ListStok(),
                  tbl_stok.TabelStok(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
