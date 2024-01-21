import 'dart:developer';

import 'package:dinker_2023_12/view/shared/bottomBar.dart';
import 'package:dinker_2023_12/view/shared/menuItem.dart';
import 'package:dinker_2023_12/view/shared/upperBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/connectDB.dart';
import '../controller/controlDB.dart';
import '../controller/filter.dart';
import '../controller/firebase.dart';
import '../controller/firestore.dart';
import '../model/menuItem.dart';

class StarbucksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarbucksPage();

}

class _StarbucksPage extends State<StarbucksPage> {
  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();
  final FilterController _filterController = FilterController();
  FireStoreController _firestoreController = FireStoreController();

  Widget filteredView(String category) {
    return SafeArea(
        child: SingleChildScrollView(
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
                      SingleChildScrollView(
                          child: Column(
                            children: [
                              FutureBuilder(
                                  future: _filterController.getMenuByCate(_connectDBController.getDrinkDB(), category),
                                  //future: _filterController.getAll(_connectDBController.getDrinkDB()),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if(snapshot.hasData) {
                                      Future.delayed(Duration.zero, () => _controlDBController.getAllCates(_connectDBController.getDrinkDB()));

                                      List<MenuItem> list = snapshot.data;
                                      List<Widget> widgets=[];
                                      for(final item in list) {
                                        widgets.add(starbucksCard(item.imgPath, item));
                                      }
                                      return GridView.builder(
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                        itemCount: widgets.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return starbucksCard(list[index].imgPath, list[index]);
                                        },
                                      );
                                    } else {
                                      return const SizedBox(width: 100, height: 100, child: CircularProgressIndicator());
                                    }
                                  }
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                )
              ]
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


  List<String> categories = [
    '전체', '신메뉴',
    '콜드 브루', '브루드 커피', '에스프레소', '블렌디드',
    '스타벅스 리프레셔', '스타벅스 피지오',
    '티(타바나)', '기타', '스타벅스 주스(병음료)',
  ];

  @override
  Widget build(BuildContext context) {
    List<Tab> myTabs = [];
    categories.forEach((element) {
      myTabs.add(Tab(text: element));
    });

    List<Widget> tabContents = [];
    categories.forEach((element) {
      tabContents.add(filteredView(element));
    });

      return MaterialApp(
        home: DefaultTabController(
            length: categories.length,
            child: Scaffold(
              backgroundColor: Color.fromRGBO(244, 243, 243, 1),

              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Colors.blueGrey,
                    title: const Text("Starbucks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                    actions: [UpperBar()],

                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.yellowAccent,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.white,
                      isScrollable: true,
                      tabs: myTabs,
                    ),
                  )
              ),
              body: TabBarView(
                children: tabContents,
              ),
            )
        ),
      );
  }
}