import 'package:flutter/material.dart';
import 'package:mtumbaAdmin/provider/users/userProvider.dart';
import 'package:mtumbaAdmin/screens/orders/cancelledOrders.dart';
import 'package:mtumbaAdmin/screens/orders/completedOrders.dart';
import 'package:mtumbaAdmin/screens/orders/newOrders.dart';
import 'package:mtumbaAdmin/screens/orders/ongoingOrders.dart';
import 'package:mtumbaAdmin/screens/orders/pastOrders.dart';

enum Pages { canceledOrders, completedOrders, newOrders, ongoingOrders, pastOrders }

class Home extends StatefulWidget {
  // String appBarTitle;
  // Home({this.appBarTitle});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  UserProvider userProvider = new UserProvider();
  String appBarTitle;
  TabController _tabController;
  final List<String> titles = ['New Orders', 'Ongoing Orders', 'Completed Orders', 'Canceled Orders', 'Past Orders'];
  int currentTab = 0;

  @override
  void initState() {
    appBarTitle = titles[0];
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(changeTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Text(appBarTitle),
            pinned: true,
            floating: true,
            bottom: TabBar(controller: _tabController,
                onTap: (index) {
                  setState(() {
                    appBarTitle = titles[index];
                  });
                },
                isScrollable: true,
                tabs: [
                  Tab(text: 'New Orders'),
                  Tab(text: 'Ongoing Orders'),
                  Tab(text: 'Completed Orders'),
                  Tab(text: 'Canceled Orders'),
                  Tab(text: 'Past Orders')
                ]),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(controller: _tabController,
                children: [
                  NewOrders(),
                  OngoingOrders(),
                  CompletedOrders(),
                  CancelledOrders(),
                  PastOrders(),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  

  changeTitle() {
    setState(() {
      appBarTitle = titles[_tabController.index];
    });
  }
}
