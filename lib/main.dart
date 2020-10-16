import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/screens/logInSignUp/Login.dart';
import 'package:mtumbaAdmin/styling.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Helvetica',
        scaffoldBackgroundColor: white,
        cursorColor: black,
        accentColor: orange,
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
    );
  }
}
