import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/firebase.dart';
import '../../controller/firestore.dart';
import '../../model/menuItem.dart';
import '../login.dart';

class MenuItemPage extends StatefulWidget {
  final MenuItem menuItem;
  MenuItemPage({super.key, required this.menuItem});

  MenuItem getMenuItem() { return menuItem; }

  @override
  State<StatefulWidget> createState() => _MenuItemPage(menuItem);
}

class _MenuItemPage extends State<MenuItemPage> {
  late MenuItem menuItem;
  bool _nutritionVisible = true; //삽질 20240109.1605. !build안에 넣으면 안 된다. 계속 갱신되서.
  var _firestoreController = FireStoreController();
  var _firebaseController = FirebaseController();

  _MenuItemPage(MenuItem menuItem) {
    this.menuItem = menuItem;
  }

  bool instruction = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: mediaQuery.size.height / 3,
            child: Container(
              padding: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Image.asset(menuItem.imgPath),
            )
          ),
          Positioned(
            top: 50,
            right: 10,
            child: IconButton(
              onPressed: () {
                //
              },
              icon: Icon(Icons.shopping_cart_rounded, color: Colors.white,),
            )
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
            )
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: mediaQuery.size.height / 1.55,
            child: Container(
              padding: EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(menuItem.brandName, style: const TextStyle(
                      color: Color.fromRGBO(97, 90, 90, .54),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                    SizedBox(height: 10,),
                    Text(menuItem.name, style: const TextStyle(
                      color: Color.fromRGBO(97, 90, 90, 1),
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    )),
                    SizedBox(height: 10,),
                    Text(menuItem.content, style: const TextStyle(
                      color: Color.fromRGBO(51, 51, 51, .54),
                      fontSize: 18,
                      height: 1.4,
                    )),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey)),
                          child: const Text('제품 영양 정보', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              _nutritionVisible = !_nutritionVisible;
                              //삽질 20240109.1605. _nutritionVisible != _nutritionVisible은 잘못된 표현이다.
                            });
                          },
                        ),
                        SizedBox(width: 20),

                        FutureBuilder<bool>(
                          future: _firestoreController.checkAlreadyExist("favMenus", menuItem.name),
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            String? userId = _firebaseController.auth.currentUser?.uid;
                            log("userId: $userId");

                            if (snapshot.data == true && instruction==false) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                child: const Text("내 메뉴 제거", style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  _firestoreController.removeFav("favMenus", menuItem.name);
                                  Future.delayed(Duration.zero, () {
                                    showDialog(context: context, builder: (context) => AlertDialog(
                                      content: Text("내 메뉴에서 [${menuItem.name}] 제거됨", style: const TextStyle(
                                        color: Color.fromRGBO(97, 90, 90, 1),
                                        fontSize: 18,
                                      )),
                                    ));

                                    setState(() {
                                      instruction = !instruction;
                                    });
                                  });
                                }
                              );
                            } else if(snapshot.data == false && userId != null && instruction==true) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                child: const Text('내 메뉴 추가', style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                    _firestoreController.addFav("favMenus", menuItem.name, {"menuName" : menuItem.name});
                                    Future.delayed(Duration.zero, () {
                                      showDialog(context: context, builder: (context) => AlertDialog(
                                        content: Text("내 메뉴에 [${menuItem.name}] 추가!!\n 장바구니를 확인해보세요!", style: const TextStyle(
                                          color: Color.fromRGBO(97, 90, 90, 1),
                                          fontSize: 18,
                                        )),
                                      ));

                                      setState(() {
                                        instruction = !instruction;
                                      });
                                    });
                                  },
                              );
                            } else if(snapshot.data == false && instruction==false) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                child: const Text('내 메뉴 추가', style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  _firestoreController.addFav("favMenus", menuItem.name, {"menuName" : menuItem.name});
                                  Future.delayed(Duration.zero, () {
                                    showDialog(context: context, builder: (context) => AlertDialog(
                                      content: Text("내 메뉴에 [${menuItem.name}] 추가!!", style: const TextStyle(
                                        color: Color.fromRGBO(97, 90, 90, 1),
                                        fontSize: 18,
                                      )),
                                    ));

                                    setState(() {
                                      instruction = !instruction;
                                    });
                                  });
                                },
                              );
                            } else if(snapshot.data == true && instruction==true) {
                              return ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                  child: const Text("내 메뉴 제거", style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    _firestoreController.removeFav("favMenus", menuItem.name);
                                    Future.delayed(Duration.zero, () {
                                      showDialog(context: context, builder: (context) => AlertDialog(
                                        content: Text("내 메뉴에서 [${menuItem.name}] 제거됨", style: const TextStyle(
                                          color: Color.fromRGBO(97, 90, 90, 1),
                                          fontSize: 18,
                                        )),
                                      ));

                                      setState(() {
                                        instruction = !instruction;
                                      });
                                    });
                                  }
                              );
                            } else if(snapshot.data == false && userId == null) {
                              Future.delayed(Duration.zero, () => showDialog(context: context, builder: (context) => MyDialog()));
                            }
                            return CircularProgressIndicator(color: Colors.blueGrey,);
                            }
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Visibility(
                      visible: _nutritionVisible,
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("영양성분")),
                            DataColumn(label: Text("함유량")),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text("칼로리")),
                              DataCell(Text(menuItem.kcal.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("당류")),
                              DataCell(Text(menuItem.sugars.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("카페인")),
                              DataCell(Text(menuItem.caffeine.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("단백질")),
                              DataCell(Text(menuItem.protein.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("포화지방")),
                              DataCell(Text(menuItem.sat_fat.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("나트륨")),
                              DataCell(Text(menuItem.sodium.toString())),
                            ]),
                          ]
                      ),
                    ),
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }

  Widget MyDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: const Icon(Icons.report_problem, size: 40,),
      content: const Text("로그인이 필요한 서비스입니다.\n 로그인을 하시겠습니까?", style: TextStyle(
        color: Color.fromRGBO(97, 90, 90, 1),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      )),
      contentPadding: EdgeInsets.all(20.0),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage())
            );
          },
          child: const Text("예"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("아니오"),
        ),
      ],
    );
  }

  /*
  Widget DupMenuDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: const Text("이미 추가된 메뉴입니다", style: TextStyle(
        color: Color.fromRGBO(97, 90, 90, 1),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      )),
      contentPadding: EdgeInsets.all(20.0),
    );
  }

   */
}
