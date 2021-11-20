import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyimpang_ngopi/home.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:nyimpang_ngopi/ubahPassword.dart';
import 'package:nyimpang_ngopi/view/my_account/my_account.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menuUsers.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, SignIn, SignInUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  bool _secureText = true;
  final _key = GlobalKey<FormState>();

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      setState(() {
        preferences.setInt("value", 2);
        preferences.setString("level", "3");
        _loginStatus = LoginStatus.notSignIn;
        Navigator.pop(context);
      });
      preferences.commit();
    });
  }

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
    try {
      final response = await http.post(Uri.parse(BaseUrl.login), body: {
        "username": username,
        "password": password,
      }).timeout(Duration(seconds: 5), onTimeout: () {
        throw TimeoutException("Connection Timeout, please try again");
      });
      final data = jsonDecode(response.body);
      int value = data['value'];
      String pesan = data['message'];
      String usernameAPI = data['username'];
      String namaAPI = data['nama'];
      String id = data['id'];
      String level = data['level'];

      if (value == 1) {
        if (level == "1") {
          setState(() {
            _loginStatus = LoginStatus.SignIn;
            savePref(value, usernameAPI, namaAPI, id, level);
            Navigator.push(
                context,
                PageTransition(
                    child: Home(signOut),
                    type: PageTransitionType.rightToLeft));
          });
        } else if (level == "2") {
          setState(() {
            _loginStatus = LoginStatus.SignInUsers;
            savePref(value, usernameAPI, namaAPI, id, level);
            Navigator.push(
                this.context,
                PageTransition(
                    child: MenuUsers(signOut),
                    type: PageTransitionType.rightToLeft));
          });
        } else if (level == "3") {
          _loginStatus = LoginStatus.notSignIn;
          savePref(value, usernameAPI, namaAPI, id, level);
        }
        print(pesan);
      } else {
        showDialog(
            context: this.context,
            builder: (context) {
              return Dialog(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.0),
                  children: [
                    Text(
                      'Login gagal!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Username dan password salah',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 10),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
            });
        print(pesan);
      }
      print(data);
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  savePref(
      int value, String username, String nama, String id, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("nama", nama);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  parseData(String nama) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("nama", nama);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");

      _loginStatus = value == "1"
          ? LoginStatus.SignIn
          : value == "2"
              ? LoginStatus.SignInUsers
              : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: Colors.black),
          home: Scaffold(
            body: Form(
              key: _key,
              child: SingleChildScrollView(
                child: (Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "img/bg_login.png",
                      width: double.infinity,
                      height: 200.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.only(left: 30, top: 20),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.only(left: 30, top: 10),
                        child: Text(
                          "Please SignIn to continue",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert username";
                          }
                          return null;
                        },
                        onSaved: (e) => username = e,
                        decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        obscureText: _secureText,
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Password",
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        check();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MyAccount();
                        }));
                      },
                      child: Text(
                        "Ubah Password",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                )),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.SignIn:
        return Home(signOut);
        break;
      case LoginStatus.SignInUsers:
        return MenuUsers(signOut);
        break;
    }
    return null;
  }
}
