import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/fireModel.dart';
import 'firebase.dart';

class FireStoreController {
  final db = FirebaseFirestore.instance;
  final FirebaseController _firebaseController = FirebaseController();

  Future<void> createFireStore() async {
    var query = {"userId": "0", "name":"sample"};
    await db.collection('favItems').add(query);
  }

  Future<void> addFav(String name) async {
    var docRef = db.collection('favItems').doc();
    var query = {"userId":_firebaseController.getUserId(), "name":name};
    await docRef.set(query).then(
        (value) => log("Fav added successfully!"),
        onError: (e) => log("Error fav adding: $e"));
  }

  Future<List<FireModel>> getAllFav() async {
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance.collection("favItems");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference.get();
    List<FireModel> models = [];
    for (var doc in querySnapshot.docs) {
      FireModel fireModel = FireModel.fromQuerySnapshot(doc);
      models.add(fireModel);
    }
    return models;
  }

  Future<List> getFav(String userId) async {
    List<FireModel> models = await getAllFav();
    List result=[];
    models.forEach((element) {
      if(element.userId==userId) result.add(element.favList);
    });
    return result;
  }
}