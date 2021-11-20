import 'package:flutter/material.dart';
import 'package:nyimpang_ngopi/model/pesanan_model.dart';

class DetailPesanan extends StatefulWidget {
  final PesananModel model;

  DetailPesanan(this.model);

  @override
  _DetailPesananState createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  var h2 =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600);
  var h3 =
      TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Pesanan " + widget.model.pemesan),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.model.barang,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 25,
                    width: 170,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(161, 111, 35, 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Text(
                        "Invoice : #" + widget.model.invoice,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Total : Rp." + widget.model.total,
                style: TextStyle(color: Color.fromRGBO(161, 111, 35, 1), fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal Pemesanan',
                    style: h2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.tgl,
                    style: h3,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah Pesanan',
                    style: h2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.jumlah,
                    style: h3,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Harga',
                    style: h2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.harga,
                    style: h3,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat',
                    style: h2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.alamat,
                    style: h3,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Telepon',
                    style: h2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.telp,
                    style: h3,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin',
                    style: h2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.nama,
                    style: h3,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
