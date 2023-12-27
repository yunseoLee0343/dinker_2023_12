import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinker_2023_12/controller/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


import '../model/menuItem.dart';
import '../view/brand.dart';
import 'firebase.dart';

class FilterController {
  MenuItem fromJson(Map<String, dynamic> json) {
    MenuItem item = MenuItem();
    item.brandName = json['brandName'];
    item.ifNew = json['ifNew'];
    item.name = json['name'];
    item.content = json['content'];
    item.imgPath = json['imgPath'];
    item.cate = json['cate'];
    item.kcal = json['kcal'];
    item.sat_fat = json['sat_fat'];
    item.protein = json['protein'];
    item.sodium = json['sodium'];
    item.caffeine = json['caffeine'];
    item.sugars = json['sugars'];
    return item;
  }

  Future<List> getIfNew(Database drinkDB) async {
    var newMenus = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE ifNew='true'");
    List menuItems=[];

    for(int i=0; i<newMenus.length; i++) {
      MenuItem menuItem = fromJson(newMenus[i]);
      menuItems.add(menuItem);
    }
    return menuItems;
  }
  //
  Future<List> getAll(Database drinkDB) async {
    var menus = await drinkDB.rawQuery("SELECT * FROM MenuItems");
    List result = [];

    for (int i = 0; i < menus.length; i++) {
      MenuItem menuItem = fromJson(menus[i]);
      result.add(menuItem);
    }
    return result;
  }
  //
  final FireStoreController _fireStoreController = FireStoreController();
  Future<List> getFavMenus(String userId) async {
    var favMenus = await _fireStoreController.getFav(userId);
    return favMenus;
  }

  Future<List> display(List menuItems, BuildContext context) async {
    List menuIcons=[];
    menuItems.forEach((element) =>
        menuIcons.add(IconButton(
          icon: Image.asset('../starbucks_menu/$element.jpg'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuItemPage(menuItem: element))),
        ))
    );
    return menuIcons;
  }

  Future<List> createFilteredView(int index, BuildContext context, Database drinkDB) async {
    List result=[];
    if(index==0) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='콜드브루'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==1) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='브루드 커피'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==2) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='에스프레소'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==3) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='프라푸치노'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==4) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='블렌디드'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==5) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='스타벅스 리프레셔'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==6) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='스타벅스 리프레셔'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==7) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='스타벅스 피지오'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==8) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='티(티바나)'");
      data.forEach((element) => result.add(fromJson(element)));
    } else if(index==9) {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='기타'");
      data.forEach((element) => result.add(fromJson(element)));
    } else {
      var data = await drinkDB.rawQuery("SELECT * FROM MenuItems WHERE cate='스타벅스 주스(병음료)'");
      data.forEach((element) => result.add(fromJson(element)));
    }
    return display(result,context);
  }
}