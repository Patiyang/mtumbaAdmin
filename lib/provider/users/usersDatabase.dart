import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:uuid/uuid.dart';

class UserDataBase {
  Firestore _firestore = Firestore.instance;
  String users = 'users';

  createUser(String firstName, String lastName, String emailAddress, String password) {
    var id = Uuid();
    String userId = id.v1();
    try {
      return _firestore.collection(users).document(userId).setData({
        User.firstName: firstName,
        User.lastName: lastName,
        User.password: password,
        User.email: emailAddress,
        User.id: userId
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
