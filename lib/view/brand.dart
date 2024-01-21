

import 'dart:developer';

import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/filter.dart';
import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:dinker_2023_12/controller/firestore.dart';
import 'package:dinker_2023_12/view/shared/menuItem.dart';
import 'package:dinker_2023_12/view/starbucks.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../controller/router.dart';
import '../model/menuItem.dart';
import 'login.dart';
import 'shared/upperBar.dart';
import 'shared/bottomBar.dart';

import '../controller/controlDB.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}


bool _subscribedStarbucks = false;

class _BrandPageState extends State<BrandPage> {

  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();
  final FilterController _filterController = FilterController();
  final FireStoreController _fireStoreController = FireStoreController();

  @override
  Widget build(BuildContext context) {
    String userId = _firebaseController.getUserId();

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey,
          title: const Text("Brand", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
          actions: [UpperBar()],
        )
      ),
      body: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        const Text("브랜드관", style: TextStyle(fontSize: 23)),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'asset/starbucks_logo.png', width: 40,),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/brand/starbucks');
                                    /*
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => StarbucksPage()),
                                    );
                                     */
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/brand/starbucks');
                                    /*
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => StarbucksPage()),
                                    );
                                     */
                                  },
                                  child: const Text("스타벅스", style: TextStyle(
                                      color: Colors.black87, fontSize: 20)),
                                ),
                                IconButton(
                                  icon: Icon(_subscribedStarbucks ? Icons.star : Icons.star_outline),
                                  onPressed: () async {
                                    setState(() {
                                      _subscribedStarbucks = !_subscribedStarbucks;
                                    });
                                    log("[Brand] Changed _subscribedStarbucks is $_subscribedStarbucks");

                                    _subscribedStarbucks
                                    ? _fireStoreController.addFav("favBrands", "starbucks", {"brandName" : "starbucks"})
                                    : _fireStoreController.removeFav("favBrands", "starbucks");
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        FutureBuilder(
                            future: _filterController.getIfNew(_connectDBController.getDrinkDB()),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                List<MenuItem> list = snapshot.data;
                                List<Widget> widgets = [];
                                for (final item in list) {
                                  widgets.add(starbucksCard(
                                      item.imgPath, item));
                                }
                                return SizedBox(
                                  height: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: widgets,
                                  ),
                                );
                              } else {
                                return const SizedBox(width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator());
                              }
                            }
                        )
                      ],
                    )
                )
              ]
          )
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  /*
  bool isFav = false;

  Widget starbucksCard(image, MenuItem menuItem) {
    FireStoreController _firestoreController = FireStoreController();

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
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FutureBuilder(
                                      future: _firestoreController.checkAlreadyExist("favMenus", menuItem.name),
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
                                                _firestoreController.addFav("favMenus", menuItem.name, {"menuName" : menuItem.name});

                                                showDialog(context: context, builder: (context) => AlertDialog(
                                                  content: Text("내 메뉴에 [${menuItem.name}] 추가!!\n 장바구니를 확인해보세요!", style: const TextStyle(
                                                    color: Color.fromRGBO(97, 90, 90, 1),
                                                    fontSize: 18,
                                                  )),
                                                ));
                                              } else {
                                                log("isFav is true");
                                                _firestoreController.removeFav("favMenus", menuItem.name);

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
                            ),
                          ],
                        )
                      ]
                  )
              )
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

   */

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
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          padding: new EdgeInsets.only(left: 5),
                          child: Text(
                            menuItem.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 10),),
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