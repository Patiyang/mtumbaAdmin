import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OngoingOrders extends StatefulWidget {
  @override
  _OngoingOrdersState createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> {
  Firestore firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: firestore.collection('orders').where('status', isEqualTo: 'Pending Delivery').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot snap = snapshot.data.documents[index];
                    print('Brand is${snap['id']}');
                    return ListTile(
                      title: Text(snap['brandName']),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
