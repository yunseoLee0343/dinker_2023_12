import 'dart:developer';

import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/filter.dart';
import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:dinker_2023_12/controller/firestore.dart';
import 'package:dinker_2023_12/view/shared/bottomBar.dart';
import 'package:dinker_2023_12/view/shared/menuItem.dart';
import 'package:dinker_2023_12/view/shared/upperBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/menuItem.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  FireStoreController _fireStoreController = FireStoreController();
  FirebaseController _firebaseController = FirebaseController();
  FilterController _filterController = FilterController();
  ConnectDBController _connectDBController = ConnectDBController();

  Future<List<MenuItem?>> getFavMenus() async {
    List<MenuItem?> items=[];
    Database drinkDB = _connectDBController.getDrinkDB();

    var data = await _fireStoreController.getFav("favMenus", _firebaseController.getUserId());

    data.forEach((e) async {
      if(e != "sample") {
        MenuItem? data2 = await _filterController.getMenuItemByName(drinkDB, e);
        items.add(data2);
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueGrey,
            title: const Text("Favorite", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
            actions: [UpperBar()],
          ),
      ),
      bottomNavigationBar: const BottomBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: getFavMenus(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null) {
              return CircularProgressIndicator();
            } else if(snapshot.data.isEmpty){
              return Text("찜한 메뉴가 없습니다.", style: TextStyle(fontSize: 20),);
            } else if(snapshot.data.isNotEmpty) {
              List<MenuItem?> items = snapshot.data;

              return Column(
                children: [
                  GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return starbucksCard(items[index]?.imgPath, items[index]!);
                    },
                  ),
                ],
              );
            } else if(snapshot.hasError) {
              log("[FavoritePage]--- snapshot has error.");
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  bool isFav = false;

  Widget changeLikeView(MenuItem menuItem) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FutureBuilder(
              future: _fireStoreController.checkAlreadyExist("favMenus", menuItem.name),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Text("error");
                } else if(snapshot.data == null) {
                  return const CircularProgressIndicator(color: Colors.white);
                } else {
                  return IconButton(
                    icon: Icon(snapshot.data ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      log("current isFav is $isFav");
                      setState(() {
                        isFav = !isFav;
                      });

                      if(isFav == true) {
                        log("isFav is false");
                        _fireStoreController.addFav("favMenus", menuItem.name, {"menuName" : menuItem.name});

                        showDialog(context: context, builder: (context) => AlertDialog(
                          content: Text("내 메뉴에 [${menuItem.name}] 추가!!\n 장바구니를 확인해보세요!", style: const TextStyle(
                            color: Color.fromRGBO(97, 90, 90, 1),
                            fontSize: 18,
                          )),
                        ));
                      } else {
                        log("isFav is true");
                        _fireStoreController.removeFav("favMenus", menuItem.name);

                        showDialog(context: context, builder: (context) => AlertDialog(
                          content: Text("내 메뉴에서 [${menuItem.name}]를 삭제했습니다.", style: const TextStyle(
                            color: Color.fromRGBO(97, 90, 90, 1),
                            fontSize: 18,
                          )),
                        ));
                      }
                    },
                  );
                }
              }
          ),
        ],
      ),
    );
  }

  Widget starbucksCard(image, MenuItem menuItem) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: IconButton(
        icon: Container(
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(image),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                stops: [0.1, 0.9],
                colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.1),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      changeLikeView(menuItem),
                    ],
                  ),
                  SizedBox(height: 130),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          padding: new EdgeInsets.only(right: 10, left: 10),
                          child: Text(
                            menuItem.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white,),),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuItemPage(menuItem: menuItem)),
          );
        },
      ),
    );
  }
}