import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/controlDB.dart';
import 'package:dinker_2023_12/controller/filter.dart';
import 'package:dinker_2023_12/view/search.dart';
import 'package:dinker_2023_12/view/shared/menuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/firebase.dart';
import '../controller/login.dart';
import '../model/menuItem.dart';
import 'brand.dart';
import 'login.dart';
import 'shared/bottomBar.dart';
import 'shared/upperBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FilterController _filterController = FilterController();
  ConnectDBController _connectDBController = ConnectDBController();

  List<String> brands = [
    "스타벅스",
    "빽다방",
    "공차",
  ];

  List<String> eventImgPaths = [
    "asset/home/event0.jpg",
    "asset/home/event1.jpg",
    "asset/home/event2.jpg",
    "asset/home/event3.jpg",
    "asset/home/event4.jpg",
    "asset/home/event5.jpg",
    "asset/home/event6.jpg",
    "asset/home/event7.jpg",
    "asset/home/event8.jpg",
    "asset/home/event9.jpg",
  ];
  List<String> eventUrls = [
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2375&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2388&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2386&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2364&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2382&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2381&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2380&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2253&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2182&menu_cd=",
    "https://www.starbucks.co.kr/whats_new/campaign_view.do?pro_seq=2087&menu_cd="
  ];

  List<String> selectedBrands = [];

  int newNotifyCount=0;

  @override
  initState() {
    super.initState();
  }

  final FirebaseController _firebaseController = FirebaseController();
  final LoginController _loginController = LoginController();

  showUpperTwoIcons() {
    String userId = _firebaseController.getUserId();
    bool ifLogin = (userId=="Cannot find current user") ? false : true;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          child: IconButton(
            icon: ifLogin
                ? const Icon(Icons.logout, size: 30, color: Colors.white)
                : const Icon(Icons.login, size: 30, color: Colors.white),
            onPressed: () =>
            ifLogin
                ? _loginController.signOut()
                : Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage())),
          ),
        ),
      ],
    );
  }

  showSearchBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 200,
            child: TextButton(
              child: const Text("검색어를 입력해주세요", style: TextStyle(color: Colors.grey, fontSize: 15,),),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: Search());
              },
            ),
          ),
          Spacer(),
          Icon(Icons.filter_list),
        ],
      ),
    );
  }

  getChips() {
    List<Widget> list=[];

    brands.forEach((e) {
      list.add(
        Row(
          children: [
            FilterChip(
                selected: count==0 ? true : selectedBrands.contains(e),
                label: Text(e, style: const TextStyle(fontSize: 13,),),
                onSelected: (selected) {
                  count++;

                  setState(() {
                    selected ? selectedBrands.add(e) : selectedBrands.remove(e);
                  });
                }),

            const SizedBox(width: 15),
            //const Spacer(),
          ],
        ),
      );
    });

    return list;
  }

  int count=0;
  showFilteredMenu() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      height: 1000,

      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(children: getChips()),
                        const SizedBox(height: 15),
                        FutureBuilder(
                          future: showSelectedBrandMenuView(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData) {
                              return snapshot.data;
                            } else {
                              return const Text("error");
                            }
                          }),
                        SizedBox(height: 10),
                        showSelectedBrandEventView(),
                    ],
                  ),
                ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 20, left: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('asset/logo.png', width: 130,),
                    showUpperTwoIcons(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "\t 카페 신메뉴 과몰입러를 위한 플랫폼",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              showSearchBar(),
              SizedBox(height: 20,),
              showFilteredMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> showSelectedBrandMenuView() async {
    List<IconButton> iconButtons = [];
    List<MenuItem> starbucksMenus = await _filterController.getIfNew(_connectDBController.getDrinkDB());

    log("showSelectedBrandMenu: count: $count");

    if(count==0) {
      selectedBrands.add("스타벅스");
      selectedBrands.add("빽다방");
      selectedBrands.add("공차");
    }
    if(selectedBrands.contains("스타벅스")) {
        starbucksMenus.forEach((element) {
          IconButton icon = IconButton(
            icon: Image.asset(element.imgPath),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => MenuItemPage(menuItem: element)),
              );
            },
          );

          iconButtons.add(icon);
        });
      }
      if(selectedBrands.contains("빽다방")) {}
      if(selectedBrands.contains("공차")) {}

      return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              //const Icon(Icons.local_drink_rounded, color: Colors.blueGrey,),
              const Text(
                "이달의 신메뉴",
                style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blueGrey,
                ),
              ),
        
              Container(
                width: 500,
                height: 300,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CarouselSlider(
                    items: iconButtons,
                    options: CarouselOptions(autoPlay: true),
                  ),
                ),
              ),
            ],
          ),
      );
    }

    Widget showSelectedBrandEventView() {
      List<IconButton> iconButtons = [];
      print("showSelectedBrandEvent: count: $count");

      if(count==0) {
        selectedBrands.add("스타벅스");
        selectedBrands.add("빽다방");
        selectedBrands.add("공차");
      }
      if(selectedBrands.contains("스타벅스")) {
        int i=0;
        eventUrls.forEach((e) {
          iconButtons.add(IconButton(
            icon: Image.asset(eventImgPaths[i]),
            onPressed: () => setState(() {
              launchUrl(Uri.parse(e));
            }),
          ));
          i++;
        });
      }

      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            //const Icon(Icons.local_drink_rounded, color: Colors.blueGrey,),
            const Text(
              "이달의 이벤트",
              style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blueGrey,
              ),
            ),

            Container(
              width: 500,
              height: 300,
              child: AspectRatio(
                aspectRatio: 1,
                child: CarouselSlider(
                  items: iconButtons,
                  options: CarouselOptions(autoPlay: true),
                ),
              ),
            ),
          ],
        ),
      );
    }
}