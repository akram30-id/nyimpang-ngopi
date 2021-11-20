import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/login.dart';
import 'package:nyimpang_ngopi/model/api.dart';

class Reset extends StatefulWidget {
  final String email;
  Reset(this.email);

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final key = GlobalKey<FormState>();
  bool _secureText = true;
  String password;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  cek() {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      change();
    }
  }

  change() async {
    final response = await http.post(Uri.parse(BaseUrl.reset),
        body: {"password": password, "email": widget.email});
    final data = jsonDecode(response.body);
    String pesan = data['message'];
    int value = data['value'];

    if (value == 1) {
      print(pesan);
      SnackBar(
        content: Text(pesan),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    } else {
      print(pesan);
      SnackBar(content: Text(pesan));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Reset Password"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: key,
                child: TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    suffixIcon: IconButton(
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: showHide),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  cek();
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
    );
  }
}
