class MenuItem {
  String brandName="";
  bool ifNew=false;
  String name="";
  String content="";
  String imgPath="";
  String cate="";
  int kcal=0;
  double sat_fat=0;
  double protein=0;
  double sodium=0;
  double caffeine=0;
  double sugars=0;

  /*
  MenuItem({
    required this.brandName,
    required this.ifNew,
    required this.name,
    required this.content,
    required this.imgPath,
    required this.cate,
    required this.kcal,
    required this.sat_fat,
    required this.protein,
    required this.sodium,
    required this.caffeine,
    required this.sugars,
  });

  factory MenuItem.fromJson(Map<String, dynamic> parsedJson){
    return MenuItem(
      brandName: parsedJson['brandName'],
      ifNew : parsedJson['ifNew']=="true" ? true : false,
      name: parsedJson['name'],
      content: parsedJson['content'],
      imgPath: parsedJson['imgPath'],
      cate: parsedJson['name'],
      kcal: int.parse(parsedJson['kcal']),
      sat_fat: double.parse(parsedJson['sat_fat']),
      protein: double.parse(parsedJson['protein']),
      sodium: double.parse(parsedJson['sodium']),
      caffeine: double.parse(parsedJson['caffeine']),
      sugars: double.parse(parsedJson['sugars']),
    );
  }
   */
}
