import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'product';

  void uploadProduct(String category, String brand, String productName, double productPrice, String productDescription,
      int productCount, String status, List<String> size, List<String> images) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var brandId = prefs.getString(User.id);
    _firestore.collection(ref).document(brandId).setData({
      'id': brandId,
      'category': category,
      'brand': brand,
      'name': productName,
      'price': productPrice,
      'description': productDescription,
      'quantity': productCount,
      'status': status,
      'size': size,
      'images': images
    });
  }

}
