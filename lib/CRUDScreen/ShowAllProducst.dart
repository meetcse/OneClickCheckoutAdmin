import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/DeleteProduct.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/UpdateProduct.dart';

class ShowAllProducts extends StatefulWidget {
  @override
  _ShowAllProductsState createState() => _ShowAllProductsState();
}

class _ShowAllProductsState extends State<ShowAllProducts> {
  int _itemCount;
  QuerySnapshot _allProducts;
  bool isLoading = true;

  navigateToUpdateScreen(String barcode) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UpdateProduct(barcode);
    }));
  }

  navigateToDeleteScreen(String barcode) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DeleteProduct(barcode);
    }));
  }

  getAllDocuments() {
    Firestore.instance.collection("BarcodeNumber").getDocuments().then((value) {
      var list = value;
      _allProducts = value;
      setState(() {
        _itemCount = list.documents.length;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Available Products",
        ),
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
                itemCount: _itemCount,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: <Widget>[
                        Text(
                          "${_allProducts.documents[index].data["name"]}",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.update,
                                    color: Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  String barcode =
                                      _allProducts.documents[index].documentID;
                                  navigateToUpdateScreen(barcode);
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.delete,
                                  size: 27,
                                ),
                                onTap: () {
                                  String barcode =
                                      _allProducts.documents[index].documentID;
                                  navigateToDeleteScreen(barcode);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _allProducts.documents[index].data["price"]
                              .toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Text(
                          "x" +
                              _allProducts.documents[index].data["quantity"]
                                  .toString(),
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
