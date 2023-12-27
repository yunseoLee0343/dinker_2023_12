import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  FirebaseAuth auth = FirebaseAuth.instance;

  String? getUserId() {
    String? uid = auth.currentUser?.uid;
    if(uid==null) return "Cannot find current user";
    return uid;
  }
}