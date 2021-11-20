import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/bom_model.dart';

class ListBom extends StatefulWidget {
  @override
  _ListBomState createState() => _ListBomState();
}

class _ListBomState extends State<ListBom> {
  var loading = false;
  final list = List<BomModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatBarang() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.lihatBrg_bom));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = BomModel(
          api['id'],
          api['id_branch'],
          api['nama_barang'],
          api['jumlah'],
          api['satuan'],
          api['harga_beli'],
          api['harga_satuan'],
          api['tgl'],
        );
        list.add(ab);
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
    _lihatBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _lihatBarang,
        key: _refresh,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return SingleChildScrollView();
                }),
      ),
    );
  }
}
