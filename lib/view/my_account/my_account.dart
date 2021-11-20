import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/view/my_account/reset.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String email, password;
  bool _secureText = true;
  final _key = GlobalKey<FormState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(Uri.parse(BaseUrl.confirm), body: {
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      print(pesan);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Reset(email);
      }));
    } else if (value == 0) {
      print(pesan);
      AlertDialog(
        title: Text("Email dan password salah"),
      );
    }
    print(pesan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black,
          title: Text("Reset Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Harap Masukkan Email dan Password anda untuk melanjutkan",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Email wajib diisi";
                      }
                      return null;
                    },
                    onSaved: (e) => email = e,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    obscureText: _secureText,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Password wajib diisi";
                      }
                      return null;
                    },
                    onSaved: (e) => password = e,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        suffixIcon: IconButton(
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: showHide)),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  InkWell(
                    onTap: () {
                      check();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
