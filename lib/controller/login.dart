import 'dart:developer';

import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/controlDB.dart';
import 'package:dinker_2023_12/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/user.dart' as myuser;
import '../view/login.dart';

class LoginController {
  FirebaseAuth auth = FirebaseAuth.instance;
  ControlDBController _controlDBController = ControlDBController();

  void signIn(BuildContext context, String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password,
      );

      if(context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  void signUp(BuildContext context, String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      if(context.mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage())
        );
        var user = myuser.MyUser(
            id: auth.currentUser!.uid,
            email: email,
            password: password,
            ifLogin: true,
            ifSubStarbucks: false);
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  void signOut() {
    ConnectDBController _connectDBController = ConnectDBController();
    if(auth.currentUser!=null) {
      auth.signOut();
    }
  }

}