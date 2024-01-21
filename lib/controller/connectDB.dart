import 'dart:async';

import 'package:dinker_2023_12/controller/controlDB.dart';
import 'package:dinker_2023_12/controller/fetch.dart';
import 'package:dinker_2023_12/model/fetch/originMenu.dart';
import 'package:dinker_2023_12/model/menuItem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ConnectDBController {
  static late Database drinkDB;
  ControlDBController controlDBController = ControlDBController();

  Database getDrinkDB() {
    return drinkDB;
  }

  Future<void> deleteDB(String path) async {
    await deleteDatabase(path);
  }

  Future<void> connectSqflite() async {
    var path1 = await getDatabasesPath();
    drinkDB = await openDatabase(
      join(path1, 'drink.db'),
    );

    await initialCreate();
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000171.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000060.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000003.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000004.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000005.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000422.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000061.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000075.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000053.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000062.js");
    await insertInitial("https://www.starbucks.co.kr/upload/json/menu/W0000471.js");
  }

  Future<void> initialCreate() async {
    await drinkDB.execute(
        '''CREATE TABLE Brands (
      id INTEGER PRIMARY KEY,
      brandName TEXT NOT NULL );
    '''
    );

    await drinkDB.execute(
        '''CREATE TABLE MenuItems (
    id INTEGER PRIMARY KEY,
    brandName TEXT NOT NULL,
    ifNew TEXT NOT NULL,
    name TEXT NOT NULL,
    content TEXT NOT NULL,
    cate TEXT NOT NULL,
    imgPath TEXT NOT NULL,
    kcal INT NOT NULL,
    sat_fat INT NOT NULL,
    protein INT NOT NULL,
    sodium INT NOT NULL,
    caffeine INT NOT NULL,
    sugars INT NOT NULL );'''
    );
  }

  Future<void> insertInitial(String url) async {
    FetchController fetchController = FetchController();
    await controlDBController.insertBrand(drinkDB, "starbucks");
    List<OriginMenu>? originMenus=[];
    List<MenuItem> menuItems=[];
    originMenus = await fetchController.fetchData(url);
    originMenus?.forEach((element) {
      var data = fetchController.convert(element);
      menuItems.add(data);
    });
    menuItems.forEach((element) async {
      await controlDBController.insertMenuItem(drinkDB, element);
    });

    menuItems.forEach((elment) async {
      await controlDBController.fixCate(drinkDB);
    });

  }
}