import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserDataBase {
  Firestore _firestore = Firestore.instance;
  String users = 'users';
  // String profile = 'adminProfile';

  createUser(String firstName, String lastName, String emailAddress, String password, String profilePicture, String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = Uuid();
    String userId = id.v1();
    prefs.setString(User.id, userId);
    try {
      return _firestore.collection(users).document(userId).setData({
        User.firstName: firstName,
        User.lastName: lastName,
        User.password: password,
        User.email: emailAddress,
        User.id: userId,
        User.profilePicture: profilePicture,
        User.phoneNumber:phoneNumber
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateProfile(String backgroundImage, String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileId = prefs.getString(User.id);
    try {
      return _firestore.collection(users).document(profileId).updateData({
        User.backgroundImage: backgroundImage,
        User.phoneNumber: phoneNumber,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  deleteUser(String id) {
    try {
      return _firestore.collection(users).document(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  getUserByEmail(String email) {
    return _firestore.collection(users).where(User.email, isEqualTo: email).getDocuments();
  }

 
}
