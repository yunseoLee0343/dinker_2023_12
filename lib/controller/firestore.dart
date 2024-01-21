import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/fireModel.dart';
import 'firebase.dart';

class FireStoreController {
  final db = FirebaseFirestore.instance;
  final FirebaseController _firebaseController = FirebaseController();

  Future<void> createFireStore() async {
    final favMenus = <String, String> {
      "menuName": "sample",
    };
    final favBrands = <String, String> {
      "brandName": "sample",
    };

    db
        .collection("user")
        .doc(_firebaseController.getUserId())
        .collection("favMenus")
        .doc("sample")
        .set(favMenus)
        .onError((e, _) => print("Error writing document: $e"));

    db
        .collection("user")
        .doc(_firebaseController.getUserId())
        .collection("favBrands")
        .doc("sample")
        .set(favBrands)
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<void> addFav(String collectionName, String name, Map<String, String> favItem) async {
    db
        .collection("user")
        .doc(_firebaseController.getUserId())
        .collection(collectionName)
        .doc(name)
        .set(favItem).then(
            (doc) => log("Document added"),
            onError: (e) => log("Error writing document: $e"),
        );
  }

  Future<void> removeFav(String collectionName, String name) async {
    db
        .collection("user")
        .doc(_firebaseController.getUserId())
        .collection(collectionName)
        .doc(name)
        .delete().then(
          (doc) => log("Document deleted"),
          onError: (e) => log("Error updating document $e"),
    );
  }

  Future<List<String>> getFav(String collectionName, String userId) async {
    List<String> menuNames = [];

    await db.collection("user").doc(userId).collection(collectionName).get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var map = docSnapshot.data();
          map.forEach((k, v) => menuNames.add(v));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return menuNames;
  }

  Future<bool> checkAlreadyExist(String collectionName, String name) async {
    String? userId = _firebaseController.getUserId();

    if(userId == "Cannot find current user") {
      return false;
    }

    List<String> favItems = await getFav(collectionName, userId);
    if(favItems.isEmpty) {
      return false;
    }

    bool result = false;

    for (String s in favItems!) {
      if (s == name) return true;
    }
    return result;
  }
}