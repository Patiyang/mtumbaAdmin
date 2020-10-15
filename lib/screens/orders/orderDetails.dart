import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtumbaAdmin/services/orders.dart';
import 'package:mtumbaAdmin/widgets/customText.dart';
import 'package:mtumbaAdmin/widgets/favoritesButton.dart';

import '../../styling.dart';


class OrderDetails extends StatefulWidget {
  final List orderItems;
  final String orderId;
  final double price;
  final String orderStatus;
  const OrderDetails({Key key, this.orderItems, this.orderId, this.price, this.orderStatus}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrdersService _ordersService = new OrdersService();
  // String orderStatus = '';
  @override
  Widget build(BuildContext context) {
    var orderItem = widget.orderItems;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ID: ${widget.orderId}',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.orderItems.length,
        itemBuilder: (BuildContext context, int index) {
          Map singleOrderItem = orderItem[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  color: white,
                  boxShadow: [BoxShadow(color: black.withOpacity(0.2), offset: Offset(3, 2), blurRadius: 10)]),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                    child: Image.network(
                      singleOrderItem['image'],
                      height: 120,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                            text: singleOrderItem['name'].toUpperCase(),
                            size: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .3),
                        CustomText(text: 'Price: Ksh.'+singleOrderItem['price'].toString(), size: 16, letterSpacing: .3),
                        CustomText(text: 'Size: '+singleOrderItem['size'], size: 16, letterSpacing: .3),
                        Spacer(),
                        CustomText(
                            text: 'Ksh. ${singleOrderItem['price'].toString()}',
                            size: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Stack(
        children: [
          Visibility(
            visible: widget.orderStatus == 'ONGOING',
            child: Container(
              color: grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CartItemRich(
                    lightFont: 'Total Order: ',
                    boldFont: 'Ksh. ${widget.price.toString()}',
                    boldFontSize: 15,
                  ),
                  FavoriteButton(
                      callback: () {
                        _ordersService.markAsCompleted(widget.orderId);
                        Fluttertoast.showToast(msg: 'ORDER COMPLETED');
                        Navigator.pop(context);
                      },
                      text: 'Mark as Completed',
                      icon: Icons.done,
                      color: orange)
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.orderStatus == 'COMPLETED',
            child: Container(
              height: 50,width: MediaQuery.of(context).size.width,
              color: grey[100],
              child: Center(
                child: CartItemRich(
                  lightFont: 'Total Order Amounted to: ',
                  boldFont: 'Ksh. ${widget.price.toString()}',
                  boldFontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
