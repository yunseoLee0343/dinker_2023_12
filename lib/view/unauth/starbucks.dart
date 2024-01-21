import 'dart:developer';

import 'package:dinker_2023_12/view/shared/bottomBar.dart';
import 'package:dinker_2023_12/view/shared/menuItem.dart';
import 'package:dinker_2023_12/view/shared/upperBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/connectDB.dart';
import '../../controller/controlDB.dart';
import '../../controller/filter.dart';
import '../../controller/firebase.dart';
import '../../model/menuItem.dart';

class UnAuthStarbucksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UnAuthStarbucksPage();

}

class _UnAuthStarbucksPage extends State<UnAuthStarbucksPage> {
  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();
  final FilterController _filterController = FilterController();

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

  Widget starbucksCard(String imagePath, MenuItem menuItem) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: IconButton(
        icon: Container(
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(imagePath),
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
            //
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuItemPage(menuItem: menuItem)),
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
            appBar: AppBar(
              title: const Text("스타벅스"),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(30.0),
                child: TabBar(
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  tabs: myTabs,
                ),
              ),
            ),
            body: TabBarView(
              children: tabContents,
            ),
            /*
              FutureBuilder(
                future: _filterController.getIfNew(_connectDBController.getDrinkDB()),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  categories.forEach((element) async {
                    if (element == "신메뉴") {
                      List<MenuItem> items = snapshot.data;
                      items.forEach((e) =>
                          tabContents.add(starbucksCard(e.imgPath, e)));
                      print("--2. tabContents's size is ${tabContents.length}");
                    } else {
                      tabContents.add(filteredView(element));
                    }
                  });

               */
          )
      ),
    );
  }
}