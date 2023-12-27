class User {
  int id=0;
  String email="";
  String password="";
  bool ifLogin=false;
  bool ifSubStarbucks=false;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.ifLogin,
    required this.ifSubStarbucks,
  });
}