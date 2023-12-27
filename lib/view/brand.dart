import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/filter.dart';
import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../controller/router.dart';
import '../model/menuItem.dart';
import 'shared/upperBar.dart';
import 'shared/bottomBar.dart';

import '../controller/controlDB.dart';

bool checkStarFilled(IconData iconData) {
  return iconData==Icons.star ? true : false;
}

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {

  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();
  final FilterController _filterController = FilterController();

  @override
  Widget build(BuildContext context) {
    String? userId = _firebaseController.getUserId();
    IconData subscribed = _controlDBController.getUserIfSub2(_connectDBController.getSessionDB(), userId!) ? Icons.star : Icons.star_outline;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('asset/logo.png'),
        actions: const [ UpperBar(), ],
      ),
      body: Row(
        children: [
          const Text("브랜드관"),
          Container(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(RouterController.brand),
              child: Column(
                children: [
                  Image.asset('asset/starbucks_logo.png'),
                  IconButton(
                      icon: Icon(subscribed),
                      onPressed: () =>
                        checkStarFilled(subscribed)
                          ? _controlDBController.updateIfSub(_connectDBController.getSessionDB(), userId, 'false')
                          : _controlDBController.updateIfSub(_connectDBController.getSessionDB(), userId, 'true')
                  ),
                  FutureBuilder(
                    future: _filterController.getIfNew(_connectDBController.getDrinkDB()),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData==false) {
                        return const CircularProgressIndicator();
                      } else if(snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      }
                      return const Text("Snapshot error");
                    },
                  ),
                ],
              ),
            ),
          ),
          const BottomBar(),
        ],
      ),
    );
  }
}

class StarbucksPage extends StatelessWidget {
  StarbucksPage({super.key});
  final ConnectDBController _connectDBController = ConnectDBController();
  final ControlDBController _controlDBController = ControlDBController();
  final FirebaseController _firebaseController = FirebaseController();
  final FilterController _filterController = FilterController();

  @override
  Widget build(BuildContext context) {
    String? userId = _firebaseController.getUserId();
    IconData subscribed = _controlDBController.getUserIfSub2(_connectDBController.getSessionDB(), userId!)
        ? Icons.star : Icons.star_outline;

    bool isMenu = true;
    bool isEvent = false;
    List<bool> selections = [isMenu, isEvent];

    bool isEntire = true;
    bool isSeason = false;
    bool isFav = false;
    List<bool> selections2 = [isEntire, isSeason, isFav];

    bool isColdBrew = true;
    bool isBrewedCoffee = false;
    bool isEspresso = false;
    bool isFrappuccino = false;
    bool isBlended = false;
    bool isRefressor = false;
    bool isPjo = false;
    bool isTea = false;
    bool isJuice = false;
    bool isOther = false;
    List<bool> selections3 = [isColdBrew, isBrewedCoffee, isEspresso, isFrappuccino, isBlended, isRefressor, isPjo, isTea, isJuice, isOther];

    return Row(
      children: [
        Column(
          children: [
            Image.asset("../asset/starbucks_logo.png"),
            const Text("스타벅스"),
            IconButton(
                icon: Icon(subscribed),
                onPressed: () =>
                checkStarFilled(subscribed)
                    ? _controlDBController.updateIfSub(_connectDBController.getSessionDB(), userId, 'false')
                    : _controlDBController.updateIfSub(_connectDBController.getSessionDB(), userId, 'true')
            ),
            ToggleButtons( //상품, 이벤트
              onPressed: (int index) {
                if(index==0) { //상품
                  Row(
                    children: [
                      ToggleButtons( //전체메뉴, 시즌메뉴, 찜
                        onPressed: (int index) {
                          if(index==0) { showIndex0(_connectDBController.getDrinkDB(), context); }
                          else if(index==1) { showIndex1(_connectDBController.getDrinkDB(), context); }
                          else if(index==2) { showIndex2(context); }
                        },
                        isSelected: selections2,
                        children: [
                          ToggleButtons( //종류
                                onPressed: (index) => _filterController.createFilteredView(index, context, _connectDBController.getDrinkDB()),
                                isSelected: selections3,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("콜드 브루"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("브루드 커피"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("에스프레소"),
                                    //cate_NAME: 라떼, 도피오, 에스프레소 마키아또, 아메리카노, 마키아또, 카푸치노, 모카, 리스트레또 비안코
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("프라푸치노"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("블렌디드"),
                                    //cate_NAME: 블렌디드 커피, 블렌디드 주스,블렌디드 후르츠
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("스타벅스 리프레셔"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("스타벅스 피지오"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("티(티바나)"),
                                    //cate_NAME: 아이스 티, 티 라떼, 브루드 티
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("기타"),
                                    //cate_NAME: 초콜릿, 기타
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("스타벅스 주스(병음료)"),
                                    //cate_NAME: 올가니카, 과일 과채, 요거트
                                  ),
                                ]
                              ),
                            ],
                          ),
                    ],
                  );
                }
                else {} //이벤트탭
              },
              isSelected: selections,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("상품"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("이벤트"),
                )
              ],
            ),
          ]
        )
      ]
    );
  }
}

FutureBuilder showIndex0(Database drinkDB, BuildContext context) {
  FilterController _filterController = FilterController();
  return FutureBuilder(
      future: _filterController.getAll(drinkDB),
      builder: (context, AsyncSnapshot snapshot1) {
        switch(snapshot1.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.done:
            if(snapshot1.hasError) {
              return Text('Error: ${snapshot1.error}');
            }
            List resultF1 = snapshot1.data ?? [];
            return FutureBuilder(
                future: _filterController.display(resultF1, context),
                builder: (context, AsyncSnapshot snapshot2) {
                  switch(snapshot2.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                      if(snapshot2.hasError) {
                        return Text('Error: ${snapshot1.error}');
                      }
                      List<Widget> result = snapshot2.data;
                      return GridView.count(
                        crossAxisCount: 3,
                        children: result,
                      );
                  }
                }
            );
        }
      }
  );
}

FutureBuilder showIndex1(Database drinkDB, BuildContext context) {
  FilterController _filterController = FilterController();
  return FutureBuilder(
      future: _filterController.getIfNew(drinkDB),
      builder: (context, AsyncSnapshot snapshot1) {
        switch(snapshot1.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.done:
            if(snapshot1.hasError) {
              return Text('Error: ${snapshot1.error}');
            }
            List resultF1 = snapshot1.data ?? [];
            return FutureBuilder(
                future: _filterController.display(resultF1, context),
                builder: (context, AsyncSnapshot snapshot2) {
                  switch(snapshot2.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                      if(snapshot2.hasError) {
                        return Text('Error: ${snapshot1.error}');
                      }
                      List<Widget> result = snapshot2.data;
                      return GridView.count(
                        crossAxisCount: 3,
                        children: result,
                      );
                  }
                }
            );
        }
      }
  );
}

FutureBuilder showIndex2(BuildContext context) {
  FilterController _filterController = FilterController();
  FirebaseController _firebaseController = FirebaseController();
  return FutureBuilder(
      future: _filterController.getFavMenus(_firebaseController.getUserId()!),
      builder: (context, AsyncSnapshot snapshot1) {
        switch(snapshot1.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.done:
            if(snapshot1.hasError) {
              return Text('Error: ${snapshot1.error}');
            }
            List resultF1 = snapshot1.data ?? [];
            return FutureBuilder(
                future: _filterController.display(resultF1, context),
                builder: (context, AsyncSnapshot snapshot2) {
                  switch(snapshot2.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                      if(snapshot2.hasError) {
                        return Text('Error: ${snapshot1.error}');
                      }
                      List<Widget> result = snapshot2.data;
                      return GridView.count(
                        crossAxisCount: 3,
                        children: result,
                      );
                  }
                }
            );
        }
      }
  );
}

class MenuItemPage extends StatelessWidget {
  final MenuItem menuItem;
  MenuItem getMenuItem() { return menuItem; }

  const MenuItemPage({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        Text(menuItem.name),
        Text(menuItem.content),
        ElevatedButton(
          child: const Text('제품 영양 정보'),
          onPressed: () => myDialog(context),
        )
      ],
    );
  }

  void myDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Row(
              children: [
                DataTable(
                    columns: const [
                      DataColumn(label: Text("영양성분")),
                      DataColumn(label: Text("함유량"), numeric: true),
                    ],
                    rows: [
                      const DataRow(
                        cells: [
                          DataCell(Text("칼로리")),
                          DataCell(Text("당류")),
                          DataCell(Text("카페인")),
                          DataCell(Text("단백질")),
                          DataCell(Text("포화지방")),
                          DataCell(Text("나트륨"))
                        ],
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text(menuItem.kcal as String)),
                            DataCell(Text(menuItem.sugars as String)),
                            DataCell(Text(menuItem.caffeine as String)),
                            DataCell(Text(menuItem.protein as String)),
                            DataCell(Text(menuItem.sat_fat as String)),
                            DataCell(Text(menuItem.sodium as String))
                          ]
                      )

                    ]
                )
              ]
          ),
        );
      }
    );
  }
}