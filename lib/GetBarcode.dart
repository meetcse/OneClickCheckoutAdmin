import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/DeleteProduct.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/UpdateProduct.dart';

class GetBarcode extends StatefulWidget {
  String _navigate;

  GetBarcode(this._navigate);

  @override
  _GetBarcodeState createState() => _GetBarcodeState(_navigate);
}

class _GetBarcodeState extends State<GetBarcode> {
  String _navigateRoute;

  _GetBarcodeState(this._navigateRoute);

  String _barcode = "";

  Future scanBarcode() async {
    String result = await BarcodeScanner.scan();
    setState(() {
      _barcode = result;
    });
    navigate(_barcode);
  }

  navigate(String barcode) {
    switch (_navigateRoute) {
      case "Update":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UpdateProduct(barcode);
        }));

        break;
      case "Delete":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DeleteProduct(barcode);
        }));

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcode"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: TextEditingController(text: _barcode),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Write Barcode Or Scan to Get"),
              onChanged: (input) => _barcode = input,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 8),
            child: RaisedButton(
                child: Text(
                  "SCAN BARCODE",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Color(0xff0A79DF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                padding: EdgeInsets.all(20),
                onPressed: () {
                  scanBarcode();
                }),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 8),
            child: RaisedButton(
                color: Color(0xff0A79DF),
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  _navigateRoute,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  navigate(_barcode);
                }),
          ),
        ],
      ),
    );
  }
}
