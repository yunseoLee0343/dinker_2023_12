import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../model/fetch/originMenu.dart';
import '../../model/menuItem.dart';

class FetchController {
  Future<OriginMenu> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final originMenu = OriginMenu.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))
      );
      return originMenu;
    } else {
      throw Exception('Failed to fetch menu');
    }
  }

  MenuItem convert(OriginMenu originMenu) {
    MenuItem menuItem = MenuItem();
    menuItem.brandName = 'starbucks';
    (originMenu.newicon=='Y') ? (menuItem.ifNew=true) : (menuItem.ifNew=false);
    menuItem.name = originMenu.productNM!;
    menuItem.content = originMenu.content!;
    menuItem.imgPath = '../../asset/starbucks_menu/${menuItem.name.replaceAll("\\s", "")}.jpg';
    menuItem.kcal = originMenu.kcal! as int;
    menuItem.sat_fat = originMenu.satFAT! as int;
    menuItem.protein = originMenu.protein! as int;
    menuItem.sodium = originMenu.sodium! as int;
    menuItem.caffeine = originMenu.caffeine! as int;
    menuItem.sugars = originMenu.sugars! as int;
    return menuItem;
  }
}
