import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'brand.dart';
import 'shared/bottomBar.dart';
import 'shared/upperBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  List menuNames = ["아이스 토피넛 라떼", "아이스 핑크 캐모마일 릴렉서", "아이스 말차 크림 브륄레 라떼"];
  List eventNames = [0,1,2];
  List menuList = [
    Image.asset("home_menu0"),
    Image.asset("home_menu1"),
    Image.asset("home_menu2"),
  ];
  List eventList = [
    Image.asset("home_event0"),
    Image.asset("home_event1"),
    Image.asset("home_event2"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('asset/logo.png'),
        actions: const [ UpperBar(), ],
      ),
      body: Row(
        children: [
          const Text("이달의 신메뉴"),
          ImageSlider(imgList: menuList, imgNameList: menuNames),
          const Text("이달의 이벤트"),
          ImageSlider(imgList: eventList, imgNameList: eventNames),
          const BottomBar(),
        ]
      ),
    );
  }
}


class ImageSlider extends StatelessWidget {
  final List imgList;
  final List imgNameList;

  const ImageSlider({
    super.key,
    required this.imgList, required this.imgNameList
  });

  @override
  Widget build(BuildContext context) {
    int i=0;

    return CarouselSlider(
      options: CarouselOptions(autoPlay: false),
      items: imgList
        .map((item) => IconButton(
          icon: item,
          onPressed: () {
            MenuItemPage(menuItem: item);
          }
      )).toList(),
    );
  }
}