import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oneclickcheckoutadmin/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteProduct extends StatefulWidget {
  String _barcode;
  DeleteProduct(this._barcode);
  @override
  _DeleteProductState createState() => _DeleteProductState(_barcode);
}

class _DeleteProductState extends State<DeleteProduct> {
  String _barcode;
  bool isBarcodePresent = false;

  _DeleteProductState(this._barcode);

  String _name;

  deleteProduct(String barcode) {
    Firestore.instance.collection("BarcodeNumber").document(barcode).delete();

    Fluttertoast.showToast(
        msg: "DELETED",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  getProductName() async {
    Firestore.instance
        .collection("BarcodeNumber")
        .document(_barcode)
        .snapshots()
        .listen((event) {
      if (!event.exists) {
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
                  "BARCODE NOT PRESENT",
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
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }), (route) => false);
                    },
                  ),
                ],
              );
            });
      } else {
        String name = event.data["name"];
        isBarcodePresent = true;
        setState(() {
          _name = name;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: (isBarcodePresent)
              ? AlertDialog(
                  title: Text(
                    "Delete...",
                    style: TextStyle(
                      color: Colors.red,
                      // backgroundColor: Colors.red
                    ),
                  ),
                  content: Text(
                    "Are You Sure you want to delete $_name??",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "NO",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "YES",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }), (route) => false);
                        deleteProduct(_barcode);
                      },
                    ),
                  ],
                )
              : Text("")),
    );
  }
}
