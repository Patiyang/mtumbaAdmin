import 'package:flutter/material.dart';

import '../styling.dart';
import 'manageItems/addProduct.dart';
import 'home.dart';
import 'profile.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = [Home(), AddProduct(), Profile()];
    return SafeArea(
          child: Scaffold(
        body: tabs[currentIndex],
        bottomNavigationBar: SizedBox(
          height: 45,
          child: BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 10,
            elevation: 0,
            iconSize: 15,
            currentIndex: currentIndex,
            backgroundColor: grey[100],
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home'), backgroundColor: grey[100]),
              BottomNavigationBarItem(icon: Icon(Icons.call_to_action), title: Text('AddProduct'), backgroundColor: grey[100]),
              BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile'), backgroundColor: grey[100]),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
