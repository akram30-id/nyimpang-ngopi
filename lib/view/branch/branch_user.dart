import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/branch_model.dart';
import 'package:page_transition/page_transition.dart';

class BranchUser extends StatefulWidget {
  final VoidCallback reload;
  BranchUser(this.reload);

  @override
  _BranchUserState createState() => _BranchUserState();
}

class _BranchUserState extends State<BranchUser> {
  var loading = false;
  final list = List<BranchModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatBranch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
            widget.reload();
          },
        ),
        title: Text("Branch"),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatBranch,
        key: _refresh,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Image.network(
                                          BaseUrl.imgBranch + x.image))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      x.jalan +
                                          ", RT." +
                                          x.rt +
                                          ", RW." +
                                          x.rw +
                                          ", Kel." +
                                          x.kelurahan,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      x.kecamatan + ", " + x.kota,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    x.kode_pos,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ],
                              ),
                            ],
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
