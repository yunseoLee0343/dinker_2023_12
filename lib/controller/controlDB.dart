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
            ' MenuItems(brandName,ifNew,name,content,imgPath)'
            ' VALUES(${m.brandName}, ${m.ifNew}, ${m.name}, ${m.content}, ${m.imgPath})'
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
  bool getUserIfSub2(Database sessionDB, int uid) {
    bool result = getUserIfSub(sessionDB, uid) as bool;
    return result;
  }

  Future<void> updateIfSub(Database sessionDB, String uid, String query) async {
    await sessionDB.rawQuery("UPDATE Users SET ifSubStarbucks=$query WHERE id=$uid");
  }

  Future<List<Map<String, Object?>>> getIfNew(Database drinkDB) async {
    var result = await drinkDB.rawQuery(
      "SELECT name FROM MenuItems WHERE ifNew='true'"
    );
    return result;
  }
  displayNew(Database drinkDB) async {
    List<Map<String,dynamic>> result = await getIfNew(drinkDB);

  }

  findMenuPathByName(String name) async {

  }
}

