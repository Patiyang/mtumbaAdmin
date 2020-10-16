import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtumbaAdmin/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'product';
  String users = 'adminUsers';
  QuerySnapshot snapshot;
  String location = '';
  String shopName = '';
  String shopId = '';
  String phoneNumber = '';

  void uploadProduct(String category, String brand, String productName, double productPrice, String productDescription,
      int productCount, String status, List<String> size, List<String> images, double deliveryPrice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString(User.email);
    await _firestore.collection(users).where(User.email, isEqualTo: email).getDocuments().then((snap) {
      snapshot = snap;
      location = snap.documents[0].data[User.location];
      shopName = snap.documents[0].data[User.shopName];
      shopId = snap.documents[0].data[User.id];
      phoneNumber = snap.documents[0].data[User.phoneNumber];
    });
    String productId;
    var id = Uuid();
    productId = id.v1();
    _firestore.collection(ref).document(productId).setData({
      'id': productId,
      'category': category,
      'brand': brand,
      'name': productName,
      'price': productPrice,
      'description': productDescription,
      'quantity': productCount,
      'status': status,
      'size': size,
      'images': images,
      'delivery': deliveryPrice,
      'location': location,
      'shopName': shopName,
      'shopId': shopId,
      'phone':phoneNumber
    });
  }
}
