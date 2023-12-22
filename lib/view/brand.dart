import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:flutter/material.dart';
import 'shared/upperBar.dart';
import 'shared/bottomBar.dart';

import '../controller/controlDB.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();

  bool checkStarFilled(IconData iconData) {
    return iconData==Icons.star ? true : false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconData subscribed = getUserIfSub2(_connectDBController.getSessionDB(), uid) ? Icons.star : Icons.star_outline;
    String userId = _firebaseController.getUserId();

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('asset/logo.png'),
        actions: const [ UpperBar(), ],
      ),
      body: Row(
        children: [
          const Text("브랜드관"),
          Container(
            child: Column(
              children: [
                Image.asset('asset/starbucks_logo.png'),
                IconButton(
                  icon: Icon(subscribed),
                    onPressed: () => {
                    if(checkStarFilled(subscribed)) {
                      _controlDBController.updateIfSub(sessionDB, userId, 'false');
                    } else {
                      _controlDBController.updateIfSub(sessionDB, userId, 'true');
                    }
                  }
                ),
                Container(
                  child: const Row(
                    children: [
                      Text("시즌메뉴"),
                      Column(
                        children: [
                          _controlDBController.getIfNew(drinkDB)
                        ],
                      )
                    ],
                  )
                )
              ],
            )
          )
        ]
      )
    );
  }
}
