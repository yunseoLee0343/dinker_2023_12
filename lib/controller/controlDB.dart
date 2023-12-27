import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../model/menuItem.dart';
import '../model/user.dart';

class ControlDBController {
  Future<void> insertBrand(Database drinkDB, String value) async {
    await drinkDB.rawInsert(
        'INSERT INTO Brands(brandName) VALUES($value)'
    );
  }

  Future<void> insertMenuItem(Database drinkDB, MenuItem m) async {
    await drinkDB.rawInsert(
        'INSERT INTO'
            ' MenuItems(brandName,ifNew,name,content,imgPath,cate)'
            ' VALUES(${m.brandName}, ${m.ifNew}, ${m.name}, ${m.content}, ${m.imgPath}, ${m.cate})'
    );
    await drinkDB.rawInsert(
        'INSERT INTO'
            ' MenuItems(kcal,sat_fat,protein,sodium,caffeine,sugars)'
            ' VALUES(${m.kcal}, ${m.sat_fat}, ${m.protein}, ${m.sodium}, ${m.caffeine}, ${m.sugars})'
    );
  }

  Future<void> insertUser(Database sessionDB, User u) async {
    await sessionDB.rawInsert(
        'INSERT INTO'
            ' Users(email,password,ifLogin,ifSubStarbucks)'
            ' VALUES(${u.email}, ${u.password}, ${u.ifLogin}, ${u.ifSubStarbucks}'
    );
  }

  Future<bool> getUserIfSub(Database sessionDB, String uid) async {
    var result = await sessionDB.rawQuery(
        'SELECT ifSubStarbucks FROM Users WHERE id=$uid'
    );
    return result[0] as bool;
  }
  bool getUserIfSub2(Database sessionDB, String uid) {
    bool result = getUserIfSub(sessionDB, uid) as bool;
    return result;
  }

  Future<void> updateIfSub(Database sessionDB, String uid, String query) async {
    await sessionDB.rawQuery("UPDATE Users SET ifSubStarbucks=$query WHERE id=$uid");
  }

  Future<void> fixCate(Database drinkDB) async {
    var result = await drinkDB.rawQuery('SELECT cate FROM MenuItems');
    result.forEach((element) async {
      var cateName = element['cate'];
      if(cateName=="라떼") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="도피오") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="에스프레소 마키아또") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="아메리카노") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="마키아또") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="카푸치노") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="모카") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="리스트레또 비안코") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="에스프레소" WHERE cate=$cateName'); }
      else if(cateName=="블렌디드 커피") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate=$cateName'); }
      else if(cateName=="블렌디드 주스") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate=$cateName'); }
      else if(cateName=="블렌디드 후르츠") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="블렌디드" WHERE cate=$cateName'); }
      else if(cateName=="아이스 티") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="티(타바나)" WHERE cate=$cateName'); }
      else if(cateName=="티 라떼") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="티(타바나)" WHERE cate=$cateName'); }
      else if(cateName=="브루드 티") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="티(타바나)" WHERE cate=$cateName'); }
      else if(cateName=="초콜릿") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="기타" WHERE cate=$cateName'); }
      else if(cateName=="올가니카") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="스타벅스 주스(병음료)" WHERE cate=$cateName'); }
      else if(cateName=="과일 과채") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="스타벅스 주스(병음료)" WHERE cate=$cateName'); }
      else if(cateName=="요거트") { await drinkDB.rawQuery('UPDATE MenuItems SET cate="스타벅스 주스(병음료)" WHERE cate=$cateName'); }
    });
  }

  Future<List> getAllMenus(Database drinkDB) async {
    List result=[];
    var data = await drinkDB.rawQuery('SELECT name FROM MenuItems');
    data.forEach((element) => result.add(element['name']));
    return result;
  }

}

