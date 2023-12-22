import 'dart:async';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ConnectDBController {
  late Database drinkDB;
  late Database sessionDB;

  Database getDrinkDB() {
    return drinkDB;
  }
  Database getSessionDB() {
    return sessionDB;
  }

  Future<void> connectSqflite() async {
    drinkDB = await openDatabase(
      join(await getDatabasesPath(), 'drink.db'),
    );
    sessionDB = await openDatabase(
      join(await getDatabasesPath(), 'session.db'),
    );
    await initialCreate(drinkDB, sessionDB);
  }

  Future<void> initialCreate(Database drinkDB, Database sessionDB) async {
    await drinkDB.execute(
        '''CREATE TABLE Brands (
      id INTEGER PRIMARY KEY,
      brandName TEXT NOT NULL
    '''
    );

    await drinkDB.execute(
        '''CREATE TABLE MenuItems (
    id INTEGER PRIMARY KEY,
    brandName TEXT NOT NULL,
    ifNew TEXT NOT NULL,
    name TEXT NOT NULL,
    content TEXT NOT NULL,
    category TEXT NOT NULL,
    imgPath TEXT NOT NULL,
    kcal INT NOT NULL,
    sat_fat INT NOT NULL,
    protein INT NOT NULL,
    sodium INT NOT NULL,
    caffeine INT NOT NULL,
    sugars INT NOT NULL'''
    );

    await sessionDB.execute(
        '''CREATE TABLE Users(
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    ifLogin TEXT,
    ifSubStarbucks TEXT
    '''
    );
  }
}