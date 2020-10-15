import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersService {
  Firestore _firestore = Firestore.instance;
  markAsCompleted(String id) {
    return _firestore.collection('orders').document(id).updateData({'status': 'COMPLETED'});
  }
}
