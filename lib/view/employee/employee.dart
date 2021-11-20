import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/employee_model.dart';
import 'package:nyimpang_ngopi/view/employee/employee_add.dart';
import 'package:nyimpang_ngopi/view/employee/employee_detail.dart';
import 'package:nyimpang_ngopi/view/employee/employee_edit.dart';

class Employee extends StatefulWidget {
  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  var loading = false;
  final list = List<EmployeeModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatPegawai() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.seeEmployee));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = EmployeeModel(
          api['id'],
          api['nama'],
          api['email'],
          api['address'],
          api['phone'],
          api['username'],
          api['password'],
          api['image'],
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
    _lihatPegawai();
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
              return EmployeeAdd(_lihatPegawai);
            }));
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("My Employee"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Ketuk 1x untuk melihat detail \natau tahan untuk mengedit",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatPegawai,
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
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EmployeeDetail(x, _lihatPegawai);
                            }));
                          },
                          onLongPress: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EmployeeEdit(_lihatPegawai, x);
                            }));
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                                      child: Text(x.address),
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
                                      Icons.phone_android,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Text(x.phone),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 250,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mail,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        x.email,
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
}
