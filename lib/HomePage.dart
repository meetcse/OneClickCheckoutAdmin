import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/AddProduct.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/DeleteProduct.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/ShowAllProducst.dart';
import 'package:oneclickcheckoutadmin/CRUDScreen/UpdateProduct.dart';
import 'package:oneclickcheckoutadmin/GetBarcode.dart';
import 'package:oneclickcheckoutadmin/Report/TodaysSell.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _adminDashboardItems = [
    "Add Products",
    "Update Product",
    "Delete Product",
    "Show Products",
    "Today's Sell"
  ];

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SigninPage");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentication();
  }

  //Navigate to selected Screens
  navigateToScreen(int id) {
    switch (id) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (contxt) {
          return AddProduct();
        }));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (contxt) {
          return GetBarcode("Update");
        }));
        break;

      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (contxt) {
          return GetBarcode("Delete");
        }));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (contxt) {
          return ShowAllProducts();
        }));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (contxt) {
          return TodaysSell();
        }));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("1 Click Checkout Admin"),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1),
          padding: EdgeInsets.all(10),
          itemCount: _adminDashboardItems.length,
          itemBuilder: (context, index) {
            return SizedBox(
                child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Color(0xff0A79DF),
                  borderRadius: BorderRadius.circular(40)),
              child: GestureDetector(
                child: Center(
                    child: Text(
                  _adminDashboardItems[index],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                onTap: () {
                  navigateToScreen(index);
                },
              ),
            ));
          }),
    );
  }
}
