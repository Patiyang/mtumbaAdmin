import 'package:firebase_auth/firebase_auth.dart';
import 'package:mtumbaAdmin/models/users.dart';

class UserProvider {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _firebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _firebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      // return false;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
