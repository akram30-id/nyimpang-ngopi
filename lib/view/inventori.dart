import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/home.dart';
import 'package:nyimpang_ngopi/menuUsers.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';
import 'package:nyimpang_ngopi/model/totalKeluarModel.dart';
import 'package:nyimpang_ngopi/model/totalMasukModel.dart';
import 'package:nyimpang_ngopi/view/bom/bom.dart';
import 'package:nyimpang_ngopi/view/keluar/keluar.dart';
import 'package:nyimpang_ngopi/view/masuk/masuk.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/view/stok/stok.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inventori extends StatefulWidget {
  @override
  _InventoriState createState() => _InventoriState();
}

class _InventoriState extends State<Inventori> {
  String total = "0";
  final ex = List<TotalitemStokModel>();
  _totalItems() async {
    ex.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalItems));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = TotalitemStokModel(api['total_items']);
      ex.add(exp);
      setState(() {
        total = exp.totalItems;
      });
      print(total);
    });
  }

  String totalKeluar = "0";
  final el = List<TotalitemKeluarModel>();
  _totalItemsKeluar() async {
    el.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalItems_keluar));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final elp = TotalitemKeluarModel(api['total_items']);
      el.add(elp);
      setState(() {
        totalKeluar = elp.totalItems;
      });
      print(totalKeluar);
    });
  }

  String totalMasuk = "0";
  final em = List<TotalitemMasukModel>();
  _totalItemsMasuk() async {
    em.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalItems_masuk));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final emp = TotalitemMasukModel(api['total']);
      em.add(emp);
      setState(() {
        totalMasuk = emp.totalItems;
      });
      print(totalMasuk);
    });
  }

  String level;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      level = preferences.getString('level');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _totalItems();
    _totalItemsKeluar();
    _totalItemsMasuk();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment(-0.97, 0.0),
                child: InkWell(
                  onTap: () {
                    // level == '1'
                    //     ? Navigator.push(
                    //         context,
                    //         PageTransition(
                    //             child: Home(signOut),
                    //             type: PageTransitionType.leftToRight))
                    //     : Navigator.push(
                    //         context,
                    //         PageTransition(
                    //             child: MenuUsers(signOut),
                    //             type: PageTransitionType.leftToRight));
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    margin: EdgeInsets.only(top: 20),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 7),
                  child: Text(
                    "Inventory Manager",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50.0,
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("img/inventori.png"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              total == "0"
                                  ? Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      total,
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                              Text(
                                "Bill of Material",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return BOM();
                                  }));
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 25,
                                  offset: Offset(-5, 5),
                                )
                              ], borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50.0,
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("img/input.png"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              total == "0"
                                  ? Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      total,
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                              Text(
                                "Stok Barang",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Stok();
                                  }));
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 25,
                                  offset: Offset(-5, 5),
                                )
                              ], borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50.0,
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("img/masuk.png"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              totalMasuk == "0"
                                  ? Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      totalMasuk,
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                              Text(
                                "Barang Masuk",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Masuk();
                                  }));
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 25,
                                  offset: Offset(-5, 5),
                                )
                              ], borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50.0,
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("img/keluar.png"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              totalKeluar == "0"
                                  ? Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      totalKeluar,
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                              Text(
                                "Barang Keluar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Keluar();
                                  }));
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 25,
                                  offset: Offset(-5, 5),
                                )
                              ], borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
