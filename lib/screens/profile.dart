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
  final TextEditingController descriptionController = new TextEditingController();
  final TextEditingController shopNameController = new TextEditingController();
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
  QuerySnapshot snapshot;

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
            stream: _firestore.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot snap = snapshot.data.documents[0];
                // profileImage = snap[User.profilePicture];
                email = snap[User.email];
                names = '${snap[User.firstName]} ' + '${snap[User.lastName]}';
                
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('object');
                            selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
                            setState(() {
                              backGround = null;
                            });
                          },
                          child: backGround == null || snap[User.backgroundImage] == ''
                              ? displayChild1()
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  child: Container(
                                    height: 250,
                                    color: orange[300],
                                    child: snapshot.connectionState == ConnectionState.waiting
                                        ? Loading(
                                            indicatorColor: AlwaysStoppedAnimation<Color>(black),
                                          )
                                        : Image.network(
                                            snap[User.backgroundImage],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                  ),
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 190),
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage('${snap[User.profilePicture]}'),
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
                        iconOne: Icons.email,
                        hint: email,
                        hintColor: black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        keyBoardType: TextInputType.numberWithOptions(),
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'Phone Number cannot be empty';
                          }
                          return null;
                        },
                        // containerColor: white.withOpacity(.8),
                        iconOne: Icons.phone,
                        hint: '${snap[User.phoneNumber]}',
                        controller: phoneController,
                        hintColor: grey[700],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'LOcation cannot be empty';
                          }
                          return null;
                        },
                        // containerColor: white.withOpacity(.8),
                        iconOne: Icons.location_on,
                        hint: '${snap[User.location]}',
                        controller: locationController,
                        hintColor: grey[700],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'ShopName cannot be empty';
                          }
                          return null;
                        },
                        // containerColor: white.withOpacity(.8),
                        iconOne: Icons.store,
                        hint: '${snap[User.shopName]}',
                        controller: shopNameController,
                        hintColor: grey[700],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25),
                      child: CustomTextField(
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        keyBoardType: TextInputType.multiline,
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'Description cannot be empty';
                          }
                          return null;
                        },
                        // containerColor: white.withOpacity(.8),
                        iconOne: Icons.person,
                        hint: '${snap[User.description]}',
                        controller: descriptionController,
                        hintColor: grey[700],
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (backGroundImage == null && backGround == null) {
      Fluttertoast.showToast(msg: 'Failed!! Please choose a background Image', backgroundColor: black);
    }
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      String backImage;
      String imageName = '$email' + '${DateTime.now().millisecondsSinceEpoch}.jpg';
      if (backGround == null) {
        StorageTaskSnapshot snap = await storage.child('backgroundImages/$imageName').putFile(backGroundImage).onComplete;
        if (snap.error == null) {
          backImage = await snap.ref.getDownloadURL();
          backGround = backImage;
          dataBase.updateProfile(
              backImage, phoneController.text, locationController.text, shopNameController.text, descriptionController.text);
          print('profile updated with image');
        }
      } else {
        ///this section is for when the user just wants to update the phone Number
        ///the same logic can also be applied to updating the profile picture
        email = prefs.getString(User.email);
        dataBase.getUserByEmail(email).then((snap) {
          snapshot = snap;
          backGround = snap.documents[0].data[User.backgroundImage];
          dataBase.updateProfile(
              backGround, phoneController.text, locationController.text, shopNameController.text, descriptionController.text);
          print('profile updated without');
        });
      }

      setState(() {
        loading = false;
      });
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(User.email, null);
    });
    await userProvider.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(User.id);
      if (backGround == null) {
        backGround = '';
      }
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
