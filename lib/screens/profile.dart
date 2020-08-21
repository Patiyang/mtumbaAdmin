import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logInSignUp/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProvider provider = UserProvider();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(onPressed: logout, child: Text('logout')),
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
