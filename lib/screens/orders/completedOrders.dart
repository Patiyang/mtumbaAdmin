import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../styling.dart';
import 'orderDetails.dart';

class CompletedOrders extends StatefulWidget {
  @override
  _CompletedOrdersState createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
    Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: firestore.collection('orders').where('status', isEqualTo: 'COMPLETED').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot snap = snapshot.data.documents[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          color: grey.withOpacity(.1),
                        ),
                        child: ListTile(
                          subtitle: Text('Order ID: ${snap['id']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => OrderDetails(
                                          orderItems: snap['cart'],
                                          orderId: snap['id'],
                                          price: snap['total'],
                                          orderStatus: snap['status'],
                                          
                                        )));
                          },
                          title: Text(
                            snap['description'],
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .3),
                          ),
                          trailing: Text('Ksh. ${snap['total'].toString()}'),
                        ),
                      ),
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
