import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/screens/logInSignUp/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrders extends StatefulWidget {
  @override
  NewOrdersState createState() => NewOrdersState();
}

class NewOrdersState extends State<NewOrders> {
  UserProvider provider = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: logout,
      child: Text('data'),
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString(User.email, '');
    });
    await provider.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
  }
}
