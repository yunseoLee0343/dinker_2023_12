import 'dart:developer';

import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:dinker_2023_12/controller/firestore.dart';
import 'package:dinker_2023_12/view/brand.dart';
import 'package:dinker_2023_12/view/favorite.dart';
import 'package:dinker_2023_12/view/login.dart';
import 'package:dinker_2023_12/view/myPage.dart';
import 'package:dinker_2023_12/view/search.dart';
import 'package:dinker_2023_12/view/starbucks.dart';
import 'package:dinker_2023_12/view/unauth/brand.dart';
import 'package:dinker_2023_12/view/unauth/starbucks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'controller/connectDB.dart';
import 'firebase_options.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var connectDBController = ConnectDBController();
  await connectDBController.deleteDB("/data/user/0/com.example.dinker_2023_12/databases/drink.db");
  await connectDBController.deleteDB("/data/user/0/com.example.dinker_2023_12/databases/session.db");
  await connectDBController.connectSqflite();
  print('--Dinker db path is ${ConnectDBController.drinkDB.path}\n');
  print("initialCreate executed");

  var firestoreController = FireStoreController();
  await firestoreController.createFireStore();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var firebaseController = FirebaseController();
    String? uid = firebaseController.getUserId();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/brand': (context) => uid != "Cannot find current user" ? BrandPage() : const UnAuthBrandPage(),
        '/brand/starbucks': (context) => uid != "Cannot find current user" ? StarbucksPage() : UnAuthStarbucksPage(),
        '/favorite': (context) => FavoritePage(),
        '/login': (context) => LoginPage(),
      }
    );
  }
}