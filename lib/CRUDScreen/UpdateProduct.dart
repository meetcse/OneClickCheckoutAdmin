import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oneclickcheckoutadmin/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProduct extends StatefulWidget {
  String _barcode;

  UpdateProduct(this._barcode);

  @override
  _UpdateProductState createState() => _UpdateProductState(_barcode);
}

class _UpdateProductState extends State<UpdateProduct> {
  TextEditingController _barCodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  String _barCode;
  String _name;
  double _price;
  int _quantity;
  _UpdateProductState(this._barCode);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getDetails(_barCode);
  }

  getDetails(String barcode) {
    Firestore.instance
        .collection("BarcodeNumber")
        .document(barcode)
        .snapshots()
        .listen((event) {
      _barCodeController.text = event.documentID;
      _nameController.text = event.data["name"];
      _quantityController.text = event.data["quantity"].toString();
      _priceController.text = event.data["price"].toString();

      setState(() {
        _barCode = event.documentID;
        _name = event.data["name"];
        _price = event.data["price"];
        _quantity = event.data["quantity"];
      });
    });
  }

  updateProduct(String barcode) async {
    if (_barCode.isEmpty ||
        _price.toString().isEmpty ||
        _name.toString().isEmpty ||
        _quantity.toString().isEmpty) {
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

    await Firestore.instance
        .collection("BarcodeNumber")
        .document(barcode)
        .updateData({"name": _name, "price": _price, "quantity": _quantity});
    Fluttertoast.showToast(
        msg: "UPDATED",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
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
            //Barcode Diplay - not editable
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _barCodeController,
                decoration: InputDecoration(
                    labelText: "Barcode",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                enabled: false,
              ),
            ),

            //Name Display
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (input) => _name = input,
              ),
            ),

            //Price Display
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (input) => _price = double.parse(input),
                keyboardType: TextInputType.number,
              ),
            ),

            //Quantity Display
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (input) => _quantity = int.parse(input),
                keyboardType: TextInputType.number,
              ),
            ),

            //Submit Button
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 8),
              child: RaisedButton(
                  color: Color(0xff0A79DF),
                  padding: EdgeInsets.all(25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    "UPDATE",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    updateProduct(_barCode);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
