import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dinker_2023_12/view/unauth/starbucks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/connectDB.dart';
import '../../controller/controlDB.dart';
import '../../controller/filter.dart';
import '../../controller/firebase.dart';
import '../../controller/router.dart';
import '../../model/menuItem.dart';
import '../brand.dart';
import '../login.dart';
import '../shared/bottomBar.dart';
import '../shared/menuItem.dart';
import '../shared/upperBar.dart';
import '../starbucks.dart';

class UnAuthBrandPage extends StatefulWidget {
  const UnAuthBrandPage({super.key});

  @override
  State<UnAuthBrandPage> createState() => _UnAuthBrandPageState();
}

class _UnAuthBrandPageState extends State<UnAuthBrandPage> {
  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();
  final FilterController _filterController = FilterController();

  showLoginDialog() async {
    await Future.delayed(Duration(microseconds: 1));

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
          title: const Text("Brand", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
          actions: [UpperBar()],
        ),
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
                              icon: Image.asset('asset/starbucks_logo.png', width: 40,),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => UnAuthStarbucksPage()),
                                );
                              },
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => StarbucksPage()),
                                );
                              },
                              child: const Text("스타벅스", style: TextStyle(color: Colors.black87, fontSize: 20)),
                          ),
                          IconButton(
                              icon: const Icon(Icons.star_outline),
                              onPressed: () => showDialog(
                                    context: context, builder: (context) => MyDialog()
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: _filterController.getIfNew(_connectDBController.getDrinkDB()),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData) {
                        List<MenuItem> list = snapshot.data;
                        List<Widget> widgets=[];
                        for(final item in list) {
                          widgets.add(starbucksCard(item.imgPath, item));
                        }
                        return SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: widgets,
                          ),
                        );
                      } else {
                        return const SizedBox(width: 100, height: 100, child: CircularProgressIndicator());
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

  Widget starbucksCard(image, menuItem) {
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
            ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuItemPage(menuItem: menuItem)),
          );
        },
      ),


          /*
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ],
                )
              ]
            )
          )
           */
    );
  }

  Widget MyDialog() {
    return AlertDialog(
        content: const Text("로그인이 필요한 서비스입니다.\n 로그인을 하시겠습니까?", style: const TextStyle(fontSize: 20),),
        contentPadding: EdgeInsets.all(20),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage())
              );
            },
            child: const Text("예"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("아니오"),
          ),
        ],
    );
  }
}

class ImageSlider extends StatelessWidget {
  List<MenuItem> menuItems = [];
  final FilterController _filterController = FilterController();
  final ConnectDBController _connectDBController = ConnectDBController();

  ImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: _filterController.displayNew(
          _connectDBController.getDrinkDB(), context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CarouselSlider(
            items: snapshot.data,
            options: CarouselOptions(autoPlay: false),
          );
        } else {
          return const SizedBox(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}