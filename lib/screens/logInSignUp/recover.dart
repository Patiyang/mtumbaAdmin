import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mtumbaAdmin/screens/logInSignUp/Login.dart';
import 'package:mtumbaAdmin/services/users/userProvider.dart';
import 'package:mtumbaAdmin/services/users/usersDatabase.dart';

import 'package:mtumbaAdmin/widgets/customText.dart';
import 'package:mtumbaAdmin/widgets/loading.dart';
import 'package:mtumbaAdmin/widgets/textField.dart';

import '../../styling.dart';

class Recover extends StatefulWidget {
  @override
  _RecoverState createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {
  final TextEditingController recoveryEmail = new TextEditingController();
  UserProvider userProvider = new UserProvider();
  UserDataBase userDataBase = new UserDataBase();
  final formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Form(
              key: formkey,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  addAutomaticKeepAlives: false,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () => Navigator.pop(context), child: Icon(CupertinoIcons.clear, size: 60, color: orange)),
                    SizedBox(height: 100),
                    Icon(Icons.lock, color: Colors.green, size: 60),
                    CustomText(
                        textAlign: TextAlign.center,
                        text: 'Forgot\nYour Password',
                        color: black,
                        size: 25,
                        maxLines: 2,
                        letterSpacing: 1),
                    SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: CustomText(
                          textAlign: TextAlign.center,
                          text: 'Enter your email address below to receive instructions on how to reset your password',
                          color: grey,
                          size: 15,
                          maxLines: 3,
                          letterSpacing: 1),
                    ),
                    // SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 19),
                      child: Column(
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: CustomTextField(
                                  validator: (v) {
                                    if (v.isEmpty) {
                                      return 'Email Cannot be empty';
                                    }
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(v))
                                      return 'Please make sure your email address is valid';
                                    else
                                      return null;
                                  },
                                  controller: recoveryEmail,
                                  containerColor: grey[300],
                                  hintColor: grey[700],
                                  hint: 'Recovery Email'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(color: orange),
                              child: MaterialButton(
                                splashColor: orange,
                                minWidth: MediaQuery.of(context).size.width * .6,
                                height: 20,
                                onPressed: recoverPassword,
                                child: CustomText(text: 'Send Password', size: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: loading == true,
              child: Loading(text: 'Working on It', color: black.withOpacity(.7)),
            )
          ],
        ),
      ),
    );
  }

  recoverPassword() async {
    if (formkey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      await userDataBase.getUserByEmail(recoveryEmail.text).then((QuerySnapshot snap) async {
        if (snap.documents.length > 0) {
          await userProvider.resetPassword(recoveryEmail.text);
          setState(() {
            loading = false;
            Fluttertoast.showToast(msg: 'recovery Email has been sent')
                .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
          });
        }
        if (snap.documents.length < 1) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: 'The Email does not exist', textColor: black);
        }
      });
    }
  }
}
