import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/menuItem.dart';
import '../view/brand.dart';
import '../view/shared/menuItem.dart';
import 'firebase.dart';

class FilterController {
  MenuItem fromJson(Map<String, dynamic> json) {
    MenuItem item = MenuItem();
    item.brandName = json['brandName'];
    item.ifNew = json['ifNew']=='true' ? true : false;
    item.name = json['name'];
    item.content = json['content'];
    item.imgPath = json['imgPath'];
    item.cate = json['cate'] ;
    item.kcal = json['kcal'];
    item.sat_fat = json['sat_fat'].toDouble();
    item.protein = json['protein'].toDouble();
    item.sodium = json['sodium'].toDouble();
    item.caffeine = json['caffeine'].toDouble();
    item.sugars = json['sugars'].toDouble();
    return item;
  }

  Future<MenuItem?> getMenuItemByName(Database drinkDB, String name) async {
    Map<String, dynamic> map = {};
    List? item = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE name='$name'");

    if (item.isNotEmpty) {
      item[0].forEach((key, value) => map[key] = value);

      return fromJson(map);
    } else {
      print('--FilterController: MenuItem is null');
      return null;
    }
  }

  Future<List<MenuItem>> getIfNew(Database drinkDB) async {
    List<MenuItem> result=[];
    List<Map<String, dynamic>> newMenus = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE ifNew='true'");

    for(int i=0; i<newMenus.length; i++) {
      //Map<String, dynamic> map = {};
      //newMenus[i].forEach((key, value) => map[key] = value);
      MenuItem? menuItem = fromJson(newMenus[i]);
      result.add(menuItem!);
    }
    return result;
  }
  //
  Future<List<MenuItem>> getAll(Database drinkDB) async {
    var menus = await drinkDB.rawQuery("SELECT * FROM MenuItems");
    List<MenuItem> result = [];

    for (int i = 0; i < menus.length; i++) {
      MenuItem? menuItem = fromJson(menus[i]);
      result.add(menuItem);
    }
    return result;
  }
  //

  Future<List<IconButton>> display(List<MenuItem> menuItems, BuildContext context) async {
    List<IconButton> menuIcons=[];
    menuItems.forEach((element) =>
        menuIcons.add(IconButton(
          icon: Image.asset('asset/starbucks_menu/${element.name.replaceAll(' ', '')}.jpg'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuItemPage(menuItem: element))),
        ))
    );
    return menuIcons;
  }

  Future<List<IconButton>> displayNew(Database drinkDB, BuildContext context) async {
    List<MenuItem> menus = await getIfNew(drinkDB);
    List<IconButton> icons = await display(menus, context);
    return icons;
  }

  Future<List<MenuItem>> getMenuByCate(Database drinkDB, String category) async {
    List<MenuItem> result=[];

    if(category == "전체") {
      var data = await getAll(drinkDB);
      return data;
    } else if(category == "신메뉴") {
      var data = await getIfNew(drinkDB);
      return data;
    }

    var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='$category'");
    data.forEach((element) => result.add(fromJson(element)));
    return result;
  }

}