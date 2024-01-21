import 'dart:developer';

import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<StatefulWidget> createState() => _BottomBar();
}

int _selectedIndex = 0;

class _BottomBar extends State<BottomBar> {

  FirebaseController _firebaseController = FirebaseController();

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home,size: 30,), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.store,size: 30,), label: '브랜드'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite,size: 30,), label: '찜'),
      ],
      onTap: (int index) {

        setState(() {
          _selectedIndex = index;
        });

        switch(index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/brand');
            break;
          case 2:
            if(_firebaseController.getUserId() != "Cannot find current user") {
              Navigator.pushNamed(context, '/favorite');
              break;
            } else {
              Navigator.pushNamed(context, '/login');
            }
          default:
        }
      },
    );
  }
}