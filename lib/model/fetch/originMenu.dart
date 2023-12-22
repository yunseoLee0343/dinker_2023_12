import 'package:json_annotation/json_annotation.dart';
part 'originMenu.g.dart';

@JsonSerializable()
class OriginMenu {
  String? cateCD;
  String? delYN;
  String? regUSER;
  String? regDT;
  String? modUSER;
  String? modDT;
  String? content;
  String? cateTYPE;
  int? proSEQ;
  String? viewYN;
  String? infoTABLE;
  String? fileTABLE;
  String? cateTABLE;
  String? cardTABLE;
  int? msrSEQ;
  String? webIMAGEWEBVIEW;
  String? webIMAGETABVIEW;
  String? webIMAGEMOBVIEW;
  String? productENGNM;
  String? productCD;
  String? productNM;
  String? fileNAME;
  String? filePATH;
  String? cateNAME;
  String? recommend;
  String? kcal;
  String? fat;
  String? nutTABLE;
  String? newSDATE;
  String? newEDATE;
  String? sellCAT;
  String? giftVALUE;
  String? hotYN;
  String? price;
  String? soldOUT;
  String? frontVIEWYN;
  String? viewSDATE;
  String? viewEDATE;
  String? noteTYPE;
  String? youtubeCODE;
  String? newicon;
  String? recomm;
  String? fileMASTER;
  String? thumbnail;
  String? imgORDER;
  String? standard;
  String? unit;
  String? satFAT;
  String? transFAT;
  String? cholesterol;
  String? sugars;
  String? chabo;
  String? protein;
  String? sodium;
  String? caffeine;
  String? allergy;
  String? kcalL;
  String? fatL;
  String? satFATL;
  String? transFATL;
  String? cholesterolL;
  String? sugarsL;
  String? chaboL;
  String? proteinL;
  String? sodiumL;
  String? caffeineL;
  String? msrSEQ2;
  String? webNEW;
  String? appIMAGE;
  String? webCARDBIRTH;
  String? cardYEAR;
  String? cardMONTH;
  String? egiftCARDYN;
  String? pairTABLE;
  String? subVIEW;
  String? fCATECD;
  String? pcateCD;
  String? allCATECD;
  String? imgUPLOADPATH;
  String? premier;
  String? searchDATETYPE;
  String? searchSTARTDATE;
  String? searchENDDATE;
  String? search1CATE;
  String? search2CATE;
  String? search3CATE;
  String? searchSALETYPE;
  String? searchVIEWYN;
  String? searchKEY;
  String? searchVALUE;
  String? themeSEARCH;
  int? pageINDEX;
  int? pageUNIT;
  int? pageSIZE;
  int? firstINDEX;
  int? lastINDEX;
  int? recordCOUNTPERPAGE;
  int? totalCNT;
  int? rnum;
  //flutter pub run build_runner build

  OriginMenu(
      {this.cateCD,
        this.delYN,
        this.regUSER,
        this.regDT,
        this.modUSER,
        this.modDT,
        this.content,
        this.cateTYPE,
        this.proSEQ,
        this.viewYN,
        this.infoTABLE,
        this.fileTABLE,
        this.cateTABLE,
        this.cardTABLE,
        this.msrSEQ,
        this.webIMAGEWEBVIEW,
        this.webIMAGETABVIEW,
        this.webIMAGEMOBVIEW,
        this.productENGNM,
        this.productCD,
        this.productNM,
        this.fileNAME,
        this.filePATH,
        this.cateNAME,
        this.recommend,
        this.kcal,
        this.fat,
        this.nutTABLE,
        this.newSDATE,
        this.newEDATE,
        this.sellCAT,
        this.giftVALUE,
        this.hotYN,
        this.price,
        this.soldOUT,
        this.frontVIEWYN,
        this.viewSDATE,
        this.viewEDATE,
        this.noteTYPE,
        this.youtubeCODE,
        this.newicon,
        this.recomm,
        this.fileMASTER,
        this.thumbnail,
        this.imgORDER,
        this.standard,
        this.unit,
        this.satFAT,
        this.transFAT,
        this.cholesterol,
        this.sugars,
        this.chabo,
        this.protein,
        this.sodium,
        this.caffeine,
        this.allergy,
        this.kcalL,
        this.fatL,
        this.satFATL,
        this.transFATL,
        this.cholesterolL,
        this.sugarsL,
        this.chaboL,
        this.proteinL,
        this.sodiumL,
        this.caffeineL,
        this.msrSEQ2,
        this.webNEW,
        this.appIMAGE,
        this.webCARDBIRTH,
        this.cardYEAR,
        this.cardMONTH,
        this.egiftCARDYN,
        this.pairTABLE,
        this.subVIEW,
        this.fCATECD,
        this.pcateCD,
        this.allCATECD,
        this.imgUPLOADPATH,
        this.premier,
        this.searchDATETYPE,
        this.searchSTARTDATE,
        this.searchENDDATE,
        this.search1CATE,
        this.search2CATE,
        this.search3CATE,
        this.searchSALETYPE,
        this.searchVIEWYN,
        this.searchKEY,
        this.searchVALUE,
        this.themeSEARCH,
        this.pageINDEX,
        this.pageUNIT,
        this.pageSIZE,
        this.firstINDEX,
        this.lastINDEX,
        this.recordCOUNTPERPAGE,
        this.totalCNT,
        this.rnum}
      );

  factory OriginMenu.fromJson(Map<String, dynamic> json) => _$OriginMenuFromJson(json);
  Map<String, dynamic> toJson() => _$OriginMenuToJson(this);
}