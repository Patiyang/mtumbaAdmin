import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  Firestore firestore = Firestore.instance;
  static final String ref = 'categories';

  newCategory(String categoryName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString(User.id);
    firestore.collection(ref).document(catId).setData({
      'categoryName': categoryName,
      'id': catId,
    });
  }

  checkExisting(String category) async {
    return firestore.collection(ref).where('categoryName', isEqualTo: category).getDocuments();
  }

  Future<List<DocumentSnapshot>> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString(User.id);
    return firestore.collection(ref).where('id', isEqualTo: catId).getDocuments().then((snaps) => snaps.documents);
  }
}
