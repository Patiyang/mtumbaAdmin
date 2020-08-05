import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/screens/logInSignUp/Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserProvider userProvider = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        body: IconButton(icon: Icon(Icons.exit_to_app), onPressed: () => logout()),
      ),
    );
  }

  logout() async {
    await userProvider.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
  }
}
