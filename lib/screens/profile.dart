import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/provider/users/usersDatabase.dart';
import 'package:mtumbaAdmin/styling.dart';
import 'package:mtumbaAdmin/widgets/favoritesButton.dart';
import 'package:mtumbaAdmin/widgets/loading.dart';
import 'package:mtumbaAdmin/widgets/textField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logInSignUp/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProvider userProvider = UserProvider();
  Firestore _firestore = Firestore.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController locationController = new TextEditingController();
  UserDataBase dataBase = new UserDataBase();
  StorageReference storage = FirebaseStorage.instance.ref();

  Stream profileInfo;
  String email = '';
  String names = '';
  String id = '';
  String profileImage = '';
  String backGround = '';
  String phoneNumber = '';
  bool loading = false;
  File backGroundImage;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: StreamBuilder(
            stream: profileInfo,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot snap = snapshot.data.documents[0];
                // backGround = snap[User.backgroundImage];
                print('the name is ${snap[User.email]}');
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('object');
                            backGround = '';
                            print(backGround.length);
                            selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
                          },
                          child: backGround.length > 0
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  child: Container(
                                    height: 250,
                                    color: orange[300],
                                    child: Image.network(
                                      snap[User.backgroundImage],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                )
                              : displayChild1(),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 190),
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(profileImage),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        readOnly: true,
                        iconOne: Icons.person,
                        hint: names,
                        hintColor: black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        readOnly: true,
                        iconOne: Icons.person,
                        hint: email,
                        hintColor: black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'Phone Number cannot be empty';
                          }
                          return null;
                        },
                        // containerColor: white.withOpacity(.8),
                        iconOne: Icons.person,
                        hint: 'PhoneNumber',
                        controller: phoneController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: FavoriteButton(
                        callback: updateInfo,
                        text: 'Update Info',
                        icon: Icons.update,
                        color: orange[300],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child: FavoriteButton(
                        callback: logout,
                        text: 'Logout',
                        icon: Icons.exit_to_app,
                        color: orange[300],
                      ),
                    )
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          ),
        ),
        Visibility(visible: loading == true, child: Loading())
      ],
    );
  }

  updateInfo() async {
    if (backGroundImage == null) {
      Fluttertoast.showToast(msg: 'Failed!! Please choose a background Image');
    }
    if (formKey.currentState.validate() && backGroundImage != null) {
      setState(() {
        loading = true;
      });
      String backImage;
      String imageName = '$email' + '${DateTime.now().millisecondsSinceEpoch}.jpg';
      StorageTaskSnapshot snap = await storage.child('backgroundImages/$imageName').putFile(backGroundImage).onComplete;
      if (snap.error == null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        backImage = await snap.ref.getDownloadURL();
        backGround = backImage;
        print(backGround);
        preferences.setString(User.backgroundImage, backGround);
        backGround = preferences.getString(User.backgroundImage);
        dataBase.updateProfile(backImage, phoneController.text);
      }
      setState(() {
        loading = false;
      });
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(User.email, '');
    });
    await userProvider.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString(User.email);
      names = prefs.getString('names');
      id = prefs.getString(User.id);
      profileImage = prefs.getString(User.profilePicture);
      backGround = prefs.getString(User.backgroundImage);
      
      profileInfo = _firestore.collection('adminProfile').document(id).collection(email).getDocuments().asStream();
    });
  }

  selectImage(Future<File> pickImage) async {
    File fileImage = await pickImage;
    setState(() {
      backGroundImage = fileImage;
    });
  }

  Widget displayChild1() {
    if (backGroundImage == null) {
      return ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Container(
            height: 250,
            color: orange[300],
            child: Center(
              child: Icon(Icons.photo_camera, color: grey),
            )),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Image.file(
          backGroundImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
        ),
      );
    }
  }
}
