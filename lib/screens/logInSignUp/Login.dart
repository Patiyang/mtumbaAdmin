import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/provider/users/usersDatabase.dart';
import 'package:mtumbaAdmin/screens/logInSignUp/recover.dart';
import 'package:mtumbaAdmin/screens/logInSignUp/signUp.dart';
import 'package:mtumbaAdmin/widgets/customText.dart';
import 'package:mtumbaAdmin/widgets/loading.dart';
import 'package:mtumbaAdmin/widgets/textField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styling.dart';
import '../homeNavigation.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  UserDataBase userDataBase = new UserDataBase();
  UserProvider userProvider = new UserProvider();
  String email = '';
  String password = '';
  String id;
  String names = '';
  String profilePicture = '';
  QuerySnapshot snapshot;
  @override
  void initState() {
    // email = '';
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: email == null
            ? Stack(
                children: <Widget>[
                  Container(
                    child: Image.asset('images/mtumbaAdmin.jpeg',
                        fit: BoxFit.cover, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [grey.withOpacity(.6), black.withOpacity(.9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        addAutomaticKeepAlives: false,
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: Column(
                              children: <Widget>[
                                CustomText(
                                    text: 'Welcome Back',
                                    size: 35,
                                    fontWeight: FontWeight.w400,
                                    color: white,
                                    textAlign: TextAlign.left),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomText(text: 'Sign Into Your Store', size: 17, fontWeight: FontWeight.w700, color: white)
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
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
                              // containerColor: white.withOpacity(.8),
                              // iconOne: Icons.email,
                              hint: 'Email',
                              controller: emailController,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                            child: CustomTextField(
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Password field cannot be left empty';
                                }
                                if (v.length < 6) {
                                  return 'the password length must be greather than 6';
                                }
                                return null;
                              },
                              // containerColor: white.withOpacity(.8),
                              // iconOne: Icons.lock,
                              hint: 'Password',
                              controller: passwordController,
                              obscure: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Recover())),
                              child: CustomText(
                                  textAlign: TextAlign.right,
                                  text: 'Recover Password?',
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                  size: 17),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [white, orange]),
                                    ),
                                    child: MaterialButton(
                                      splashColor: orange,
                                      minWidth: MediaQuery.of(context).size.width * .6,
                                      height: 40,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                      onPressed: signIn,
                                      child: CustomText(text: 'Sign In'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: RichText(
                                text: TextSpan(text: 'Don\'t have an account? ', children: <TextSpan>[
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Register()));
                                    },
                                  text: 'Create One',
                                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline))
                            ])),
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(visible: loading == true, child: Loading())
                ],
              )
            : HomeNavigation());
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email == null) {
      setState(() {
        email = '';
        print('the email length is ${email.length}');
      });
    } else {
      setState(() {
        email = prefs.getString(User.email);
      });
    }
  }

  signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      await userDataBase.getUserByEmail(emailController.text).then((QuerySnapshot snap) async {
        snapshot = snap;
        if (snap.documents.length > 0) {
          password = snap.documents[0].data[User.password];
          email = snap.documents[0].data[User.email];
          id = snap.documents[0].data[User.id];
          names = '${snap.documents[0].data[User.firstName]} ' + '${snap.documents[0].data[User.lastName]}';
          profilePicture = '${snap.documents[0].data[User.profilePicture]}';

          if (email == emailController.text && password == passwordController.text) {
            prefs.setString(User.email, email);
            prefs.setString(User.id, id);
            prefs.setString('names', names);
            prefs.setString(User.profilePicture, profilePicture);
            await userProvider
                .signIn(emailController.text, passwordController.text)
                .then((value) => () async {
                      email = value == true ? prefs.getString(User.email) : '';
                    })
                .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeNavigation())));
          }
        }
        if (snap.documents.length < 1 || password != passwordController.text) {
          setState(() {
            loading = false;
            prefs.setString(User.email, '');
          });
          Fluttertoast.showToast(msg: 'Wrong Email Or Password');
        }
      });
    }
  }
}
