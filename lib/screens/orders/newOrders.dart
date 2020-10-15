import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/services/users/userProvider.dart';

class NewOrders extends StatefulWidget {
  @override
  NewOrdersState createState() => NewOrdersState();
}

class NewOrdersState extends State<NewOrders> {
  UserProvider provider = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return Text('data');
  }
}
