import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyimpang_ngopi/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class EmployeeAdd extends StatefulWidget {
  final VoidCallback reload;
  EmployeeAdd(this.reload);

  @override
  _EmployeeAddState createState() => _EmployeeAddState();
}

class _EmployeeAddState extends State<EmployeeAdd> {
  final _key = GlobalKey<FormState>();
  File _imageFile;
  String nama, email, username, password, phone, address;
  bool _secureText = true;

  _pilihGalery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 1280, maxWidth: 720);
    setState(() {
      _imageFile = File(image.path);
      print(_imageFile.path);
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
      submit();
    }
  }

  submit() async {
    try {
      var stream = http.ByteStream(DelegatingStream(_imageFile.openRead()));
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.addEmployee);
      final request = http.MultipartRequest("POST", uri);

      request.fields['email'] = email.replaceAll(".", "");
      request.fields['phone'] = phone;
      request.fields['address'] = address;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['nama'] = nama;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: context.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Upload Success");
        setState(() {
          widget.reload();
          Navigator.pop(this.context);
        });
      } else {
        print("Upload Failed");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      margin: EdgeInsets.symmetric(horizontal: 100),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
        image: DecorationImage(
          image: AssetImage('img/boss.png'),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Employee"),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  child: InkWell(
                    onTap: () {
                      _pilihGalery();
                    },
                    child: _imageFile == null
                        ? placeholder
                        : Image.file(
                            _imageFile,
                            // fit: BoxFit.fill,
                          ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Nama",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Nama Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => nama = e,
                      decoration: InputDecoration(hintText: "Contoh: Avriza"),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Alamat",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Alamat Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => address = e,
                      decoration: InputDecoration(
                          hintText: "Contoh: Jl.P. Sawu Raya No.376"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Email Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => email = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: avriza@gmail.com"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Nomor Telepon",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Nomor Telepon Harus Diisi";
                        }
                        return null;
                      },
                      onSaved: (e) => phone = e,
                      decoration:
                          InputDecoration(hintText: "Contoh: 08123456789"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Username",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Username Harus Diisi";
                        }
                        return null;
                      },
                      decoration:
                          InputDecoration(hintText: "Contoh: Muhammad Ali"),
                      onSaved: (e) => username = e,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Password Harus Diisi";
                        }
                        return null;
                      },
                      obscureText: _secureText,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                        icon: _secureText
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: showHide,
                      )),
                      onSaved: (e) => password = e,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    check();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(161, 111, 35, 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
