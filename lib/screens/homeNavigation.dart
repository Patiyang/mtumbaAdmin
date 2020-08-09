import 'package:flutter/material.dart';

import '../styling.dart';
import 'addProduct.dart';
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
    return Scaffold(
        body: tabs[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 15,
          unselectedFontSize: 13,
          elevation: 0,
          iconSize: 20,
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
        ));
  }
}
