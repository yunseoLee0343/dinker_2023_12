import 'package:cloud_firestore/cloud_firestore.dart';

class FireModel {
  String userId="";
  List favList=[];

  static FireModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data();
    String userId = data['userId'] ?? ""; // Replace 'userId' with the actual field name in your Firestore document
    List<String> favList = List<String>.from(data['favList'] ?? []); // Replace 'favList' with the actual field name

    FireModel fireModel = FireModel();
    fireModel.userId = userId;
    fireModel.favList = favList;

    return fireModel;
  }
}