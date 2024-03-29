import 'package:flutter/cupertino.dart';
import '../view/brand.dart';
import '../view/home.dart';
import '../view/myPage.dart';
import '../view/search.dart';
import '../view/unauth/brand.dart';

class RouterController {
  static const String home = '/';
  static const String brand = '/brand';
  static const String myPage = '/myPage';
  static const String starbucksPage = '/brand/starbucks';

  static final routes = <String, WidgetBuilder> {
    home: (BuildContext context) => const HomePage(),
    brand: (BuildContext context) => const UnAuthBrandPage(),
    myPage: (BuildContext context) => MyPage(),
  };
}