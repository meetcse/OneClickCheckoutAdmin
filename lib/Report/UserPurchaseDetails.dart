import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPurchaseDetails extends StatefulWidget {
  String path;
  String paymentId;

  UserPurchaseDetails(this.path, this.paymentId);

  @override
  _UserPurchaseDetailsState createState() =>
      _UserPurchaseDetailsState(path, paymentId);
}

class _UserPurchaseDetailsState extends State<UserPurchaseDetails> {
  String _path;
  String _paymentId;
  List<String> _itemName = List<String>();

  List<double> _itemPrice = List<double>();
  double _totalPrice = 0;
  List<double> _itemQuantity = List<double>();
  List<String> _dateCreated = List<String>();
  QuerySnapshot _snapshot;
  bool isLoading = true;
  _UserPurchaseDetailsState(this._path, this._paymentId);

  getAllPurchaseDetails(String firestorePath, String _userPaymentId) {
    Firestore.instance.collection(firestorePath).getDocuments().then((value) {
      _snapshot = value;
      int i;
      for (i = 0; i < _snapshot.documents.length; i++) {
        if (_snapshot.documents[i].data["Payment Id"] == _userPaymentId) {
          _itemName.add(_snapshot.documents[i].data["name"]);
          _itemPrice.add(_snapshot.documents[i].data["price"]);
          _totalPrice =
              double.parse(_snapshot.documents[i].data["total"].toString());
          _itemQuantity.add(
              double.parse(_snapshot.documents[i].data["quantity"].toString()));
          _dateCreated.add(_snapshot.documents[i].data["Date Created"]);
        }
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPurchaseDetails(_path, _paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Purchase Details"),
      ),
      body: Container(
        child: (isLoading)
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.purple,
                strokeWidth: 6,
              ))
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                    thickness: 1,
                  );
                },
                itemCount: _itemName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "${_itemName[index]}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "x" + _itemQuantity[index].toString(),
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(4)),
                        Container(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            "Price:" + _itemPrice[index].toString(),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Purchased On: " + _dateCreated[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "PayMent Id: " + _paymentId,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 12.0, top: 12.0, left: 10.0, right: 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Total Purchase:  ₹" + _totalPrice.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                  // fontStyle: FontStyle.italic
                ),
              ),
            ],
          ),
        ),
        color: Colors.indigoAccent,
      ),
    );
  }
}
