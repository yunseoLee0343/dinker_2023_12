import 'dart:developer';

import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/controlDB.dart';
import 'package:dinker_2023_12/view/shared/menuItem.dart';
import 'package:dinker_2023_12/view/shared/upperBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Search extends SearchDelegate {
  final ControlDBController _controlDBController = ControlDBController();
  final ConnectDBController _connectDBController = ConnectDBController();

  List<String> selectedMenus=[];

  Future<List<String>> getItems() async {
    List<String> items = await _controlDBController.getAllMenus(_connectDBController.getDrinkDB());
    return items;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () { query=""; }
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context); }
        //close(context, null);
      );
  }

  String selectedResult="";
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  List<String> recentList = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList=[];
    List<String> allList=[];
    Database drinkDB = _connectDBController.getDrinkDB();

    return FutureBuilder(
        future: getItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            allList = snapshot.data;

            query.isEmpty ? suggestionList = recentList : suggestionList.addAll(
                allList.where((element) => element.contains(query),));

            return ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: TextButton(
                    child: Text(suggestionList[index],
                      style: TextStyle(color: Colors.black),),
                    onPressed: () async {
                      var data = await _controlDBController.getMenuByName(suggestionList[index], drinkDB);
                      if(data != null) {
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MenuItemPage(menuItem: data)),);
                        });
                      }
                    },
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        }
        );
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);

    log("???????");
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const NonSearchedPage()
      ),
    );
  }
}

class NonSearchedPage extends StatelessWidget {
  const NonSearchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueGrey,
            title: const Text("Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
            actions: [UpperBar()],
          )
      ),
      body: Column(
        children: [
          Container(
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
                  width: 250,
                  child: TextButton(
                    child: const Text("검색어를 입력해주세요", style: TextStyle(color: Colors.grey, fontSize: 15,),),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: Search());
                      //Navigator.of(context).pop();
                    },
                  ),
                ),
                Spacer(),
                Icon(Icons.filter_list),
              ],
            ),
          ),

          const SizedBox(height: 300),
          const Icon(Icons.question_mark, size: 50, color: Colors.blueGrey,),
          const SizedBox(height: 50),
          const Text("검색결과가 존재하지 않습니다.\n\n 검색어를 다시 입력해주세요.\n 이벤트는 검색되지 않습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}