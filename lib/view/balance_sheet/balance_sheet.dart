import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/home.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/model/balance_sheet_model.dart';
import 'package:nyimpang_ngopi/model/branch_model.dart';
import 'package:nyimpang_ngopi/view/balance_sheet/add_balance_sheet.dart';
import 'package:nyimpang_ngopi/view/balance_sheet/balance_sheet_detail.dart';
import 'package:nyimpang_ngopi/view/balance_sheet/pdf_api.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class BalanceSheet extends StatefulWidget {
  @override
  _BalanceSheetState createState() => _BalanceSheetState();
}

class _BalanceSheetState extends State<BalanceSheet> {
  var loading = false;
  final list = List<BalanceSheetModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  String lastDate;

  maxDate() async {
    final response = await http
        .get(Uri.parse(BaseUrl.maxDate), headers: {'maxDate': lastDate});
    final data = jsonDecode(response.body);
    print(data);
  }

  Future<void> _lihatBranch() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.listBranch));
    if (response.contentLength == 3) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final see = BalanceSheetModel(
          api['id_branch'],
          api['kecamatan'],
          api['image'],
          api['pemasukan'],
          api['pengeluaran'],
          api['modal'],
          api['tgl'],
          api['id'],
        );
        list.insert(0, see);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _delete(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.deleteBs), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
        _lihatBranch();
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
                  "Apakah Anda yakin ingin menghapus branch ini ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40.0,
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
    _lihatBranch();
    maxDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 550),
          child: Column(
            children: [
              Expanded(
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.print),
                  onPressed: () async {
                    final pdfFile = await PdfApi.generateTable();
                    PdfApi.openFile(pdfFile);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AddBalanceSheet(_lihatBranch),
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomRight,
                            duration: Duration(milliseconds: 600)));
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Balance Sheet"),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 20,
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: BalanceSheetDetail(x, _lihatBranch),
                                    type: PageTransitionType.scale,
                                    alignment: Alignment.topCenter,
                                    duration: Duration(milliseconds: 600)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(200, 200)),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                BaseUrl.imgBranch + x.image),
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Branch " + x.kecamatan,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Tanggal Laporan : " + x.tgl)
                                        ],
                                      ),
                                      SizedBox(
                                        width: 70,
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(Icons.delete_rounded),
                                          onPressed: () {
                                            dialogDelete(x.id);
                                          },
                                        ),
                                      )
                                    ],
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
        ));
  }

  void signOut() {}
}
