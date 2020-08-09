import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/screens/orders/cancelledOrders.dart';
import 'package:mtumbaAdmin/screens/orders/newOrders.dart';
import 'package:mtumbaAdmin/screens/orders/ongoingOrders.dart';
import 'package:mtumbaAdmin/screens/orders/pastOrders.dart';
import 'package:mtumbaAdmin/styling.dart';
import 'package:mtumbaAdmin/widgets/customButton.dart';

enum Pages { canceledOrders, completedOrders, newOrders, ongoingOrders, pastOrders }

class Home extends StatefulWidget {
  String appBarTitle;
  Home({this.appBarTitle});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserProvider userProvider = new UserProvider();
  Pages _selectedPage = Pages.newOrders;
  String appBarTitle = 'New Orders';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(appBarTitle),
          backgroundColor: orange[500],
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Container(
              color: grey[100],
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        icon: Icons.attach_money,
                        callback: () {
                          setState(() {
                            _selectedPage = Pages.newOrders;
                            appBarTitle = 'New Orders';
                          });
                        },
                        buttonColor: _selectedPage == Pages.newOrders ? white.withOpacity(.5) : grey[100],
                        color: _selectedPage == Pages.newOrders ? orange : black,
                        text: 'New Orders'),
                    CustomButton(
                        icon: Icons.access_time,
                        callback: () {
                          setState(() {
                            _selectedPage = Pages.ongoingOrders;
                            appBarTitle = 'Ongoing Orders';
                          });
                        },
                        buttonColor: _selectedPage == Pages.ongoingOrders ? white.withOpacity(.5) : grey[100],
                        text: 'Ongoing Orders'),
                    CustomButton(
                        icon: Icons.done,
                        callback: () {
                          setState(() {
                            _selectedPage = Pages.completedOrders;
                            appBarTitle = 'Completed Orders';
                          });
                        },
                        buttonColor: _selectedPage == Pages.completedOrders ? white.withOpacity(.5) : grey[100],
                        color: _selectedPage == Pages.completedOrders ? orange : black,
                        text: 'Completed Orders'),
                    CustomButton(
                        icon: Icons.cancel,
                        callback: () {
                          setState(() {
                            _selectedPage = Pages.canceledOrders;
                            appBarTitle = 'Canceled Orders';
                          });
                        },
                        buttonColor: _selectedPage == Pages.canceledOrders ? white.withOpacity(.5) : grey[100],
                        color: _selectedPage == Pages.canceledOrders ? orange : black,
                        text: 'Canceled Orders'),
                    CustomButton(
                        icon: Icons.av_timer,
                        callback: () {
                          setState(() {
                            _selectedPage = Pages.pastOrders;
                            appBarTitle = 'Past Orders';
                          });
                        },
                        buttonColor: _selectedPage == Pages.pastOrders ? white.withOpacity(.5) : grey[100],
                        color: _selectedPage == Pages.pastOrders ? orange : black,
                        text: 'Past Orders')
                  ],
                ),
              ),
            ),
            selectedWidget()
          ],
        ),
      ),
    );
  }

  // logout() async {
  //   await userProvider.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login())));
  // }

  Widget selectedWidget() {
    switch (_selectedPage) {
      case Pages.newOrders:
        return NewOrders();
        break;
      case Pages.canceledOrders:
        return CancelledOrders();
        break;
      case Pages.completedOrders:
        return CancelledOrders();
        break;
      case Pages.ongoingOrders:
        return OngoingOrders();
        break;
      case Pages.pastOrders:
        return PastOrders();
      default:
        return Container();
    }
  }
}
