import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BrandService {
  Firestore firestore = Firestore.instance;
  String ref = 'brands';

  newBrand(String brandName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var brandId = prefs.getString(User.id);
    var myEmail = prefs.getString(User.email);
    firestore.collection(ref).document(brandId).collection(myEmail).document().setData({
      'brandName': brandName,
      'id': brandId,
    });
  }

  getBrands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var brandId = prefs.getString(User.id);
    var myEmail = prefs.getString(User.email);
    return firestore.collection(ref).document(brandId).collection(myEmail).snapshots();
  }

  checkExisting(String brand) {
    return firestore.collection(ref).where('brandName', isEqualTo: brand).getDocuments();
  }
}
