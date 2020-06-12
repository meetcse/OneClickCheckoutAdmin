import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'UserPurchaseDetails.dart';

class TodaysSell extends StatefulWidget {
  @override
  _TodaysSellState createState() => _TodaysSellState();
}

class _TodaysSellState extends State<TodaysSell> {
  double _totalSell = 0;
  DocumentReference _dateReference;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  QuerySnapshot _snapshot;
  int length = 0;
  String _date;
  DateTime dateTime = DateTime.now();
  List<String> userIds = List<String>();
  bool isLoading = true;
  int _itemCount = 0;
  List<String> _userIdsForEachPaymentId = List<String>();
  List<String> _paymentIds = List<String>();
  List<double> _totalPerPaymentId = List<double>();

  countTotalSell() async {
    String pId1 = "";
    String pId2 = "";
    String collectionId;
    int i;

    for (i = 0; i < userIds.length; i++) {
      await Firestore.instance
          .collection("Payments")
          .document(_date)
          .collection(userIds[i])
          .getDocuments()
          .then((value) {
        _snapshot = value;

        for (int j = 0; j < _snapshot.documents.length; j++) {
          pId1 = _snapshot.documents[j].data["Payment Id"];

          if (pId1 != pId2) {
            _paymentIds.add(pId1);
            _totalPerPaymentId.add(_snapshot.documents[j].data["total"]);
            _userIdsForEachPaymentId.add(userIds[i]);

            setState(() {
              _totalSell = _totalSell + _snapshot.documents[j].data["total"];
              _itemCount = _itemCount + 1;
            });
          }

          pId2 = _snapshot.documents[j].data["Payment Id"];
        }
        pId1 = "";
        pId2 = "";
      });
    }

    isLoading = false;
  }

  navigateToDetailsPage(String userId, String paymentId) {
    String firestorePath = "Payments/" + _date + "/" + userId;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserPurchaseDetails(firestorePath, paymentId);
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _date = DateFormat.yMd().format(dateTime);

    databaseReference
        .child("Payment")
        .child("${dateTime.month}")
        .child("${dateTime.day}")
        .child("${dateTime.year}")
        .onValue
        .listen((element) {
      Map<dynamic, dynamic> map = element.snapshot.value;

      map.values.forEach((element) {
        if (userIds.contains(element["userId"].toString())) {
        } else {
          userIds.add(element["userId"].toString());
        }
      });

      countTotalSell();
    });

    _dateReference = Firestore.instance.collection("Payments").document(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Sell"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple,
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                    thickness: 1,
                  );
                },
                itemCount: _paymentIds.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToDetailsPage(
                          _userIdsForEachPaymentId[index], _paymentIds[index]);
                    },
                    child: ListTile(
                      selected: true,
                      title: Row(
                        children: <Widget>[
                          Divider(),
                          Text(
                            "${_userIdsForEachPaymentId[index]}",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "₹" + _totalPerPaymentId[index].toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 10,
                          ),
                        ],
                      ),
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
                "TODAY's Total SELL :  ₹" + _totalSell.toString(),
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
