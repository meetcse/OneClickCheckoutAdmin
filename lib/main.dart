import 'package:flutter/material.dart';
import 'package:oneclickcheckoutadmin/Authentication/SigninPage.dart';
import 'package:oneclickcheckoutadmin/Authentication/SignupPage.dart';
import 'package:oneclickcheckoutadmin/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Click Checkout Admin',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
          primaryColor: Color(0xFF3C40C6), bottomAppBarColor: Colors.purple),
      routes: <String, WidgetBuilder>{
        "/SigninPage": (BuildContext context) => SigninPage(),
        "/SignupPage": (BuildContext context) => SignupPage(),
        "/HomePage": (BuildContext context) => HomePage(),
      },
    );
  }
}
