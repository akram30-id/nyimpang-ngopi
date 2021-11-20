import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/branch_model.dart';
import 'package:http/http.dart' as http;
// import 'package:pdf/widgets.dart';

class BOM extends StatefulWidget {
  @override
  _BOMState createState() => _BOMState();
}

class _BOMState extends State<BOM> {
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
    return MaterialApp(
      home: Scaffold(
        appBar: (AppBar(
          title: Text(
            'Pilih Branch',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )),
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
                            height: 40,
                          ),
                          InkWell(
                            onTap: (){},
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundImage:
                                  NetworkImage(BaseUrl.imgBranch + x.image),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            x.kecamatan,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
