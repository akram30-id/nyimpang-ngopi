import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeeDetail extends StatefulWidget {
  final EmployeeModel model;
  final VoidCallback reload;
  EmployeeDetail(this.model, this.reload);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deleteEmployee), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        print(pesan);
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
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
                  "Are you sure to delete this employee ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.0,
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
                      width: 15.0,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.model.nama,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Hero(
                  tag: widget.model.id,
                  child: Image.network(
                    BaseUrl.pict + widget.model.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ];
        },
        body: Stack(
          children: [
            Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.email,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.phone,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.password,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Text(
                          widget.model.address,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                children: [
                  Container(
                    width: 300.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 0,
                      color: Color.fromRGBO(161, 111, 35, 1),
                      borderRadius: BorderRadius.circular(10.0),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 80.0,
                      child: Material(
                        elevation: 0,
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: MaterialButton(
                            onPressed: () {
                              dialogDelete(widget.model.id);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
