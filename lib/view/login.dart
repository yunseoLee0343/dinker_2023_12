import 'dart:developer';

import 'package:dinker_2023_12/controller/connectDB.dart';
import 'package:dinker_2023_12/controller/controlDB.dart';
import 'package:dinker_2023_12/controller/firebase.dart';
import 'package:dinker_2023_12/controller/login.dart';
import 'package:dinker_2023_12/view/home.dart';
import 'package:dinker_2023_12/view/shared/upperBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final LoginController _loginController = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ControlDBController _controlDBController = ControlDBController();
  final ConnectDBController _connectDBController = ConnectDBController();
  final FirebaseController _firebaseController = FirebaseController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 243, 243, 1),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueGrey,
              title: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
            )
        ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),

                ),
                validator: (value) {
                  bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value!);

                  if(value.isEmpty) {
                    return "Enter Email";
                  } else if(!emailValid) {
                    return "Enter Valid Email";
                  }
                },
              ),
              TextFormField(
                obscureText: passToggle,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                  )
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "비밀번호를 입력하세요.";
                  } else if(_passwordController.text.length < 6) {
                    return "비밀번호는 6자리 이상이어야 합니다.";
                  }
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                  label: const Text('로그인'),
                  icon: const Icon(Icons.login),
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage())
                      );
                    } on FirebaseAuthException catch (e) {
                      log(e.code);
                      if(e.code == 'invalid-credential') {
                        Future.delayed(Duration.zero, () => showDialog(
                            context: context, builder: (context) => const AlertDialog(
                              title: Text("! 로그인 실패"),
                              content: Text("이메일 주소와 비밀번호를 확인해주세요."),
                        )));
                      }
                    }

                    if(_formKey.currentState!.validate()) {
                      _emailController.clear();
                      _passwordController.clear();
                    }
                  }
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                  label: const Text('회원가입'),
                  icon: const Icon(Icons.add_circle_outline_outlined),
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      String id = _firebaseController.getUserId()!;
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      Future.delayed(Duration.zero, () {
                        var myUser = MyUser(id: id, email: email, password: password, ifLogin: false, ifSubStarbucks: false);

                        showDialog(
                            context: context, builder: (context) => const AlertDialog(
                              title: Text("회원가입 완료!!"),
                            ));
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        Future.delayed(Duration.zero, () => showDialog(
                            context: context, builder: (context) => const AlertDialog(
                              title: Text("! 회원가입 실패"),
                              content: Text("이미 등록된 이메일입니다."),
                        )));
                        log('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
              ),
            ],
          )
        )
      )
    );
  }
}