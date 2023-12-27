import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/controlDB.dart';
import 'package:dinker_2023_12/view/shared/upperBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPage();
}
class _SearchPage extends State<SearchPage> {
  final ControlDBController _controlDBController = ControlDBController();
  final ConnectDBController _connectDBController = ConnectDBController();

  getItems() async {
    return _controlDBController.getAllMenus(_connectDBController.getDrinkDB());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('asset/logo.png'),
        actions: const [ UpperBar(), ],
        centerTitle: true,
        title: const Text('Search Bar'),
      ),
      body: ListView.builder(
        itemCount: getItems().length,
        itemBuilder: (context, index) => ListTile(
          title: Text(getItems()[index]),
        ),
      ),
    );
  }
}

class Search extends SearchDelegate {
  final ControlDBController _controlDBController = ControlDBController();
  final ConnectDBController _connectDBController = ConnectDBController();

  getItems() async {
    return _controlDBController.getAllMenus(_connectDBController.getDrinkDB());
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
    query.isEmpty
      ? suggestionList=recentList
      : suggestionList.addAll(getItems().where(
        (element) => element.contains(query),
     ));
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
        );
      }
    );
  }
}