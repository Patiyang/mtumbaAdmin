import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/provider/users/usersDatabase.dart';
import 'package:mtumbaAdmin/widgets/customText.dart';
import 'package:mtumbaAdmin/widgets/loading.dart';
import 'package:mtumbaAdmin/widgets/textField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styling.dart';
import '../home.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneNumberController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  UserProvider userProvider = new UserProvider();
  UserDataBase userDataBase = new UserDataBase();
  QuerySnapshot snapshot;
  Firestore firestore = Firestore.instance;
  String userName;
  String userEmail;
  String phoneNumber;
  // String userId;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset('images/mtumbaAdmin.jpeg',
                fit: BoxFit.cover, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              grey.withOpacity(.6),
              black.withOpacity(.9),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CircleAvatar(radius: 50, child: Icon(Icons.image, size: 30)),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                        child: CustomTextField(
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'FirstName field cannot be left empty';
                            }

                            return null;
                          },
                          // containerColor: white.withOpacity(.8),
                          iconOne: Icons.person,
                          hint: 'FirstName',
                          controller: firstNameController,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                        child: CustomTextField(
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'laseName field cannot be left empty';
                            }
                            return null;
                          },
                          // containerColor: white.withOpacity(.8),
                          hint: 'LastName',
                          controller: lastNameController,
                        ),
                      ),
                      SizedBox(height: 8),
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
                          iconOne: Icons.email,
                          hint: 'Email',
                          controller: emailController,
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
                          iconOne: Icons.lock,
                          hint: 'Password',
                          controller: passwordController,
                          obscure: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
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
                              onPressed: signUp,
                              child: CustomText(text: 'Sign Up'),
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
                            text: TextSpan(text: 'Already have an account? ', children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
                                },
                              text: 'Sign In',
                              style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline))
                        ])),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(visible: loading == true, child: Loading())
        ],
      )),
    );
  }

  signUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(User.email, emailController.text);
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      userDataBase.getUserByEmail(emailController.text).then((QuerySnapshot snap) async {
        if (snap.documents.length < 1) {
          await userDataBase.createUser(
              firstNameController.text, lastNameController.text, emailController.text, passwordController.text);
          await userProvider
              .signUp(emailController.text, passwordController.text)
              .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home())));
        } else {
          setState(() {
            formKey.currentState.reset();
            loading = false;
          });
          Fluttertoast.showToast(msg: 'Email already in use');
        }
      });
    }
  }
}
