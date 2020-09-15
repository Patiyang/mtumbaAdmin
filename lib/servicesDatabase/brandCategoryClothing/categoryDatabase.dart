import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  Firestore firestore = Firestore.instance;
  static final String ref = 'categories';

  newCategory(String categoryName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString(User.id);
    var myEmail = prefs.getString(User.email);
    firestore.collection(ref).document(catId).collection(myEmail).document().setData({
      'categoryName': categoryName,
      'id': catId,
    });
  }

  checkExisting(String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString(User.id);
    var myEmail = prefs.getString(User.email);
    return firestore.collection(ref).document(catId).collection(myEmail).where('categoryName', isEqualTo: category).getDocuments();
  }

  Future<List<DocumentSnapshot>> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString(User.id);
    var myEmail = prefs.getString(User.email);
    return firestore.collection(ref).document(catId).collection(myEmail).getDocuments().then((snaps) => snaps.documents);
  }
}
