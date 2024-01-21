import 'dart:developer';

import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:dinker_2023_12/controller/login.dart';
import 'package:flutter/material.dart';

import '../login.dart';
import '../favorite.dart';

class UpperBar extends StatelessWidget {
  final FirebaseController _firebaseController = FirebaseController();
  final LoginController _loginController = LoginController();

  UpperBar({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = _firebaseController.getUserId();
    bool ifLogin = (userId=="Cannot find current user") ? false : true;

    return Row(
        children: <Widget>[
          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Badge(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(5),
                    label: Text("?", style: TextStyle(color: Colors.white)),
                    child: InkWell(
                        onTap: () {},
                        child: IconButton(
                          icon: const Icon(Icons.notifications, size: 30, color: Colors.white),
                          onPressed: () {
                            ifLogin
                                ? Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => NotificationPage())
                                  )
                                : Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => LoginPage())
                                  );
                          }
                    ),
                  )
                ),
              ),
            ],
          ),
           */

          Container(
            padding: EdgeInsets.only(left: 20),
            child: IconButton(
              icon: ifLogin
                  ? const Icon(Icons.logout, size: 30, color: Colors.white)
                  : const Icon(Icons.login, size: 30, color: Colors.white),
              onPressed: () {
                log("ifLogin: $ifLogin");

                ifLogin
                    ? _loginController.signOut()
                    : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            ),
          ),
        ],
    );
  }
}