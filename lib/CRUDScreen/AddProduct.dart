import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _scanQrCode = "";
  String _scanQrCode1 = "";
  String _scanQrCode2 = "";
  String _scanQrCode3 = "";
  String _name;
  double _price;
  int _quantity;
  int _buttonPressedCounter = 0;

  Future _qrCodeScan(int id) async {
    // _buttonPressedCounter = _buttonPressedCounter + 1;

    switch (id) {
      case 1:
        // setState(() async {
        _scanQrCode = (await BarcodeScanner.scan());
        setState(() {
          _scanQrCode1 = _scanQrCode;
        });
        print(_scanQrCode1);
        // });
        break;
      case 2:
        _scanQrCode = (await BarcodeScanner.scan());
        setState(() {
          _scanQrCode2 = _scanQrCode;
        });
        break;
      case 3:
        _scanQrCode = (await BarcodeScanner.scan());
        setState(() {
          _scanQrCode3 = _scanQrCode;
        });
        break;
    }
    // return _scanQrCode;
  }

  addItemsToFireBase(
      String bNo, String name, double price, int quantity) async {
    if (_scanQrCode1.isEmpty ||
        _scanQrCode2.isEmpty ||
        _scanQrCode3.isEmpty ||
        price.toString().isEmpty ||
        name.toString().isEmpty ||
        quantity.toString().isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "ERROR",
                style: TextStyle(
                  color: Colors.red,
                  // backgroundColor: Colors.red
                ),
              ),
              content: Text(
                "ALL FIELDS ARE REQUIRED",
                style: TextStyle(fontSize: 16.0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return;
    }

    if (_scanQrCode3 == _scanQrCode2 &&
        _scanQrCode3 == _scanQrCode1 &&
        _scanQrCode1 == _scanQrCode2) {
      await Firestore.instance
          .collection("BarcodeNumber")
          .document(bNo)
          .setData(
        {"name": name, "price": price, "quantity": quantity},
        merge: true,
      );
      Fluttertoast.showToast(
          msg: "ADDED",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "ERROR",
                style: TextStyle(
                  color: Colors.red,
                  // backgroundColor: Colors.red
                ),
              ),
              content: Text(
                "ALL 3 BARCODES ARE NOT SAME",
                style: TextStyle(fontSize: 16.0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Products"),
      ),
      body: Card(
        borderOnForeground: true,
        elevation: 50,
        color: Color(0xffEAF0F1),
        margin: EdgeInsets.all(8),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Tap to Scan BarCode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                controller: TextEditingController(
                  text: _scanQrCode1,
                ),

                // onChanged: (input) => _scanQrCode1 = input,

                onTap: () {
                  this._qrCodeScan(1);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Again Scan BarCode ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                controller: TextEditingController(
                  text: _scanQrCode2,
                ),
                // onChanged: (input) => _scanQrCode1 = input,

                onTap: () {
                  this._qrCodeScan(2);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Last Time Scan BarCode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                controller: TextEditingController(
                  text: _scanQrCode3,
                ),
                // onChanged: (input) => _scanQrCode1 = input,

                onTap: () {
                  this._qrCodeScan(3);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Enter Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (input) => _name = input,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (input) => _price = double.parse(input),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Quantity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (input) => _quantity = int.parse(input),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 8),
              child: RaisedButton(
                  color: Color(0xff0A79DF),
                  padding: EdgeInsets.all(25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    addItemsToFireBase(_scanQrCode3, _name, _price, _quantity);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
