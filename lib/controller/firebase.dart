import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Platform  Firebase App Id
//android   1:822144194459:android:115829d23fdd1b8c08333e
//ios       1:822144194459:ios:bf76bdebd6db445508333e

  String? getUserId() {
    String? uid = auth.currentUser?.uid;
    if(uid==null) return "Cannot find current user";
    return uid;
  }
}