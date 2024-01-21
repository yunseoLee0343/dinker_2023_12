import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../model/menuItem.dart';
import '../model/user.dart';
import 'filter.dart';

class ControlDBController {
  Future<void> insertBrand(Database drinkDB, String value) async {
    await drinkDB.rawInsert(
        'INSERT INTO Brands(brandName) VALUES("$value")'
    );
  }

  Future<void> insertMenuItem(Database drinkDB, MenuItem m) async {
    await drinkDB.rawInsert(
        'INSERT INTO'
            ' MenuItems(brandName,ifNew,name,content,imgPath,cate,kcal,sat_fat,protein,sodium,caffeine,sugars)'
            ' VALUES("${m.brandName}", "${m.ifNew}", "${m.name}", "${m.content}", "${m.imgPath}", "${m.cate}", "${m.kcal}", "${m.sat_fat}", "${m.protein}", "${m.sodium}", "${m.caffeine}", "${m.sugars}")'
    );
  }

  Future<void> insertUser(Database sessionDB, MyUser u) async {
    await sessionDB.rawInsert(
        'INSERT INTO'
            ' Users(id,email,password,ifLogin,ifSubStarbucks)'
            ' VALUES("${u.id}", "${u.email}", "${u.password}", "${u.ifLogin.toString()}", "${u.ifSubStarbucks.toString()}")'
    );
    log("inserted user to sqflite");
  }

  Future<void> loginUser(Database sessionDB, String email) async {
    await sessionDB.rawQuery(
      'UPDATE Users '
          'SET ifLogin=true'
          ' WHERE email="$email"'
    );
    log("changed ifLogin to true");
  }

  Future<void> logoutUser(Database sessionDB, String email) async {
    await sessionDB.rawQuery(
        'UPDATE Users '
            'SET ifLogin=false '
            'WHERE email=$email'
    );
    log("changed ifLogin to false");
  }

  Future<bool> checkUserExist(Database sessionDB, String? uid) async {
    log("user's id: $uid");
    var result = await sessionDB.rawQuery("SELECT * FROM Users WHERE id='$uid'");
    return result.isEmpty ? false : true;
  }

  Future<void> printAllUsers(Database sessionDB) async {
    var result = await sessionDB.rawQuery("SELECT * FROM Users");
    print(result);
  }

  Future<bool> getUserIfSub(Database sessionDB, String? uid) async {
    var check = await checkUserExist(sessionDB, uid);
    log("checked if user exist: $check");

    var result = await sessionDB.rawQuery(
        'SELECT ifSubStarbucks FROM Users WHERE id="$uid"'
    );

    if(result.isEmpty) {
      log("ControlDBController-- result is empty!!");
      return false;
    } else {
      Map<String, Object?>? data = result[0];
      var value = data["ifSubStarbucks"]=='true' ? true : false;
      return value;
    }
  }

  Future<void> updateIfSub(Database sessionDB, String uid, String query) async {
    await sessionDB.rawQuery("UPDATE Users SET ifSubStarbucks='$query' WHERE id='$uid'");
    log("sqflite-- ifSubStarbucks updated to.. $query");
  }

  Future<void> fixCate(Database drinkDB) async {
    var result = await drinkDB.rawQuery('SELECT cate FROM MenuItems');
    result.forEach((element) async {
      var cateName = element['cate'];
      if(cateName=="라떼") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="도피오") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="에스프레소 마키아또") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="아메리카노") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="마키아또") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="카푸치노") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="모카") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="리스트레또 비안코") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate="$cateName"'); }
      else if(cateName=="블렌디드 크림") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate="$cateName"'); }
      else if(cateName=="블렌디드 커피") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate="$cateName"'); }
      else if(cateName=="블렌디드 주스") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate="$cateName"'); }
      else if(cateName=="블렌디드 후르츠") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate="$cateName"'); }
      else if(cateName=="아이스 티") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="티(타바나)" WHERE cate="$cateName"'); }
      else if(cateName=="티 라떼") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="티(타바나)" WHERE cate="$cateName"'); }
      else if(cateName=="브루드 티") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="티(타바나)" WHERE cate="$cateName"'); }
      else if(cateName=="초콜릿") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="기타" WHERE cate="$cateName"'); }
      else if(cateName=="올가니카") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="스타벅스 주스(병음료)" WHERE cate="$cateName"'); }
      else if(cateName=="과일 과채") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="스타벅스 주스(병음료)" WHERE cate="$cateName"'); }
      else if(cateName=="요거트") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="스타벅스 주스(병음료)" WHERE cate="$cateName"'); }
      else if(cateName=="2024 NEW Year") {
        log("New menu detected");
        await drinkDB.rawQuery('UPDATE MenuItems SET cate="신메뉴" WHERE cate="$cateName"');
      }
    });
  }

  Future<List<String>> getAllMenus(Database drinkDB) async {
    List<String> result=[];
    var data = await drinkDB.rawQuery('SELECT name FROM MenuItems');
    data.forEach((element) => result.add(element['name'].toString()));
    return result;
  }

  Future<void> getAllCates(Database drinkDB) async {
    List<String> result=[];
    var data = await drinkDB.rawQuery('SELECT cate FROM MenuItems');
    data.forEach((element) => result.add(element['cate'].toString()));
    //result.forEach((e) => log(e));
  }

  Future<MenuItem> getMenuByName(String name, Database drinkDB) async {
    FilterController _filterController = FilterController();
    var data = await drinkDB.rawQuery('SELECT * FROM MenuItems WHERE name="$name"');
    var item = _filterController.fromJson(data[0]);
    return item;
  }
}

