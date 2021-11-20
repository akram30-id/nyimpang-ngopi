import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/balance_sheet_model.dart';
import 'package:nyimpang_ngopi/model/employee_model.dart';
import 'package:nyimpang_ngopi/model/total_branch_model.dart';
import 'package:nyimpang_ngopi/view/acara/acara.dart';
import 'package:nyimpang_ngopi/view/acara/acara_employee.dart';
import 'package:nyimpang_ngopi/view/balance_sheet/balance_sheet.dart';
import 'package:nyimpang_ngopi/view/branch/branch.dart';
import 'package:nyimpang_ngopi/view/branch/branch_user.dart';
import 'package:nyimpang_ngopi/view/inventori.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/view/my_account/my_account.dart';
import 'package:nyimpang_ngopi/view/pelanggan/pelanggan.dart';
import 'package:nyimpang_ngopi/view/pesanan/pesanan.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenuUsers extends StatefulWidget {
  final VoidCallback signOut;
  MenuUsers(this.signOut);
  int index;
  List list;

  @override
  _MenuUsersState createState() => _MenuUsersState();
}

class _MenuUsersState extends State<MenuUsers> {
  String nama = "", username = "";

  String total = "0";
  final ex = List<TotalBranchModel>();
  _totalBranch() async {
    ex.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalBranch));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = TotalBranchModel(api['total_branch']);
      ex.add(exp);
      setState(() {
        total = exp.totalItems;
      });
      print(total);
    });
  }

  String totalSales = "0";
  final es = List<TotalSalesModel>();
  _totalSales() async {
    es.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalSales));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final esp = TotalSalesModel(api['total_sales']);
      es.add(esp);
      setState(() {
        totalSales = esp.totalSales;
      });
      print(totalSales);
    });
  }

  String totalEmployee = "0";
  final em = List<TotalEmployeeModel>();
  _totalEmployee() async {
    em.clear();
    final response = await http.get(Uri.parse(BaseUrl.totalEmployee));
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final emp = TotalEmployeeModel(api['total_employee']);
      em.add(emp);
      setState(() {
        totalEmployee = emp.totalItems;
      });
      print(totalEmployee);
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      username = preferences.getString("username");
    });
  }

  _lihatNama(
    String nama,
  ) async {
    var response =
        await http.post(Uri.parse(BaseUrl.user), body: {"nama": nama});
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _totalBranch();
    _totalSales();
    _totalEmployee();
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            Container(
              child: Stack(
                children: [
                  Positioned(
                    top: 20.0,
                    left: 20.0,
                    child: FutureBuilder(
                        future: _lihatNama(nama),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data);
                            var snapNama = snapshot.data['nama'].toString();
                            return Text(
                              snapNama,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            );
                          } else {
                            return Text(
                              "null",
                              style: TextStyle(color: Colors.white),
                            );
                          }
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/sales2.png",
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(
                                    "Sales",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  totalSales == "0"
                                      ? Text(
                                          "Rp. 0",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text(
                                          "Rp. " + totalSales,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/employee.png",
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(
                                    "Employee",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  totalEmployee == "0"
                                      ? Text(
                                          "0",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text(
                                          totalEmployee,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/home.png",
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(
                                    "Branch",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  total == "0"
                                      ? Text(
                                          "0",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text(
                                          total,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 200),
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Text("Employee Dashboard",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: MyAccount(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/boss.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "My Account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Akses dilarang")));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/employee.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "My Employee",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: BranchUser(_totalBranch),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/home.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Branch",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Inventori(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/inventori.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Inventori",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Pelanggan(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/customer.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Data Pelanggan",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Pesanan(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/pesanan.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Data Pesanan",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AcaraEmployee(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 23, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/schedule.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Jadwal Acara",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: BalanceSheet(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.brown[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(223, 212, 195, 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "img/balance.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Balance Sheet",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signOut();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
