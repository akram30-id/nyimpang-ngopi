import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/stok_model.dart';
import 'package:http/http.dart' as http;

class DetailStok extends StatefulWidget {
  final StokModel model;
  final VoidCallback reload;

  DetailStok(this.model, this.reload);

  @override
  _DetailStokState createState() => _DetailStokState();
}

class _DetailStokState extends State<DetailStok> {

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deleteItems), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
      });
      Navigator.pop(context);
      widget.reload();
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
                  "Are you sure to delete this item ?",
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
                      width: 8.0,
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
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: Colors.black,
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.model.namaBrg,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Hero(
                  tag: widget.model.idBrg,
                  child: Image.network(
                    BaseUrl.imgItems + widget.model.image,
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
                        Icons.inventory,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.jumlah,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.model.satuan,
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
                        Icons.monetization_on,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.harga,
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
                        Icons.calendar_today_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.tglmasuk,
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
                        Icons.corporate_fare_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.model.namaSup,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 5.0,
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
                          "Close",
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
