import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../model/fetch/originMenu.dart';
import '../../model/menuItem.dart';

class FetchController {
  Future<List<OriginMenu>?> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<OriginMenu> result=[];

      var decoded = utf8.decode(response.bodyBytes);
      var jsonDecoded = jsonDecode(decoded);
      var jsonList = jsonDecoded['list'];
      for(int i=0; i<jsonList.length; i++) {
        var originMenu = OriginMenu.fromJson(jsonList[i]);
        result.add(originMenu);
      }
      return result;

      /*
      var a = jsonDecoded['list'];
      print('length: ${a.length}');
      print(a['product_NM']);
      var originMenu = OriginMenu.fromJson(jsonDecoded);
      //print(originMenu.productNM);
      return originMenu;
       */
    } else {
      throw Exception('Failed to fetch menu');
    }
  }

  MenuItem convert(OriginMenu originMenu) {
    MenuItem menuItem = MenuItem();
    menuItem.brandName = 'starbucks';
    (originMenu.newicon=='Y') ? (menuItem.ifNew=true) : (menuItem.ifNew=false);
    menuItem.name = originMenu.product_NM!;
    menuItem.content = originMenu.content!.replaceAll('"', '');
    menuItem.cate = originMenu.cate_NAME!;
    menuItem.imgPath = 'asset/starbucks_menu/${menuItem.name.replaceAll(" ", "")}.jpg';

    menuItem.kcal = int.parse(originMenu.kcal!);
    var value = originMenu.sat_FAT!;
    if(value.substring(0,1)==".") { menuItem.sat_fat = 0; }
    else { menuItem.sat_fat = double.parse(value); }

    value = originMenu.protein!;
    if(value.substring(0,1)==".") { menuItem.protein = 0; }
    else { menuItem.protein = double.parse(value); }

    value = originMenu.sodium!;
    if(value.substring(0,1)==".") { menuItem.sodium = 0; }
    else { menuItem.sodium = double.parse(value); }

    value = originMenu.caffeine!;
    if(value.substring(0,1)==".") { menuItem.caffeine = 0; }
    else { menuItem.caffeine = double.parse(value); }

    value = originMenu.sugars!;
    if(value.substring(0,1)==".") { menuItem.sugars = 0; }
    else { menuItem.sugars = double.parse(value); }

    return menuItem;
  }
}
