import 'package:json_annotation/json_annotation.dart';
part 'originMenu.g.dart';

@JsonSerializable()
class OriginMenu {
  String? cate_CD;
  String? del_YN;
  String? reg_USER;
  String? reg_DT;
  String? mod_USER;
  String? mod_DT;
  String? content;
  String? cate_TYPE;
  int? pro_SEQ;
  String? view_YN;
  String? info_TABLE;
  String? file_TABLE;
  String? cate_TABLE;
  String? card_TABLE;
  int? msr_SEQ;
  String? web_IMAGE_WEBVIEW;
  String? web_IMAGE_TABVIEW;
  String? web_IMAGE_MOBVIEW;
  String? product_ENGNM;
  String? product_CD;
  String? product_NM;
  String? file_NAME;
  String? file_PATH;
  String? cate_NAME;
  String? recommend;
  String? kcal;
  String? fat;
  String? nut_TABLE;
  String? new_SDATE;
  String? new_EDATE;
  String? sell_CAT;
  String? gift_VALUE;
  String? hot_YN;
  String? price;
  String? sold_OUT;
  String? front_VIEW_YN;
  String? view_SDATE;
  String? view_EDATE;
  String? note_TYPE;
  String? youtube_CODE;
  String? newicon;
  String? recomm;
  String? file_MASTER;
  String? thumbnail;
  String? img_ORDER;
  String? standard;
  String? unit;
  String? sat_FAT;
  String? trans_FAT;
  String? cholesterol;
  String? sugars;
  String? chabo;
  String? protein;
  String? sodium;
  String? caffeine;
  String? allergy;
  String? kcal_L;
  String? fat_L;
  String? sat_FAT_L;
  String? trans_FAT_L;
  String? cholesterol_L;
  String? sugars_L;
  String? chabo_L;
  String? protein_L;
  String? sodium_L;
  String? caffeine_L;
  String? msr_SEQ2;
  String? web_NEW;
  String? app_IMAGE;
  String? web_CARD_BIRTH;
  String? card_YEAR;
  String? card_MONTH;
  String? egift_CARD_YN;
  String? pair_TABLE;
  String? sub_VIEW;
  String? f_CATE_CD;
  String? pcate_CD;
  String? all_CATE_CD;
  String? img_UPLOAD_PATH;
  String? premier;
  String? search_DATE_TYPE;
  String? search_START_DATE;
  String? search_END_DATE;
  String? search_1_CATE;
  String? search_2_CATE;
  String? search_3_CATE;
  String? search_SALE_TYPE;
  String? search_VIEW_YN;
  String? search_KEY;
  String? search_VALUE;
  String? theme_SEARCH;
  int? page_INDEX;
  int? page_UNIT;
  int? page_SIZE;
  int? first_INDEX;
  int? last_INDEX;
  int? record_COUNT_PER_PAGE;
  int? total_CNT;
  int? rnum;

  //flutter pub run build_runner build

  OriginMenu(
      {this.cate_CD,
        this.del_YN,
        this.reg_USER,
        this.reg_DT,
        this.mod_USER,
        this.mod_DT,
        this.content,
        this.cate_TYPE,
        this.pro_SEQ,
        this.view_YN,
        this.info_TABLE,
        this.file_TABLE,
        this.cate_TABLE,
        this.card_TABLE,
        this.msr_SEQ,
        this.web_IMAGE_WEBVIEW,
        this.web_IMAGE_TABVIEW,
        this.web_IMAGE_MOBVIEW,
        this.product_ENGNM,
        this.product_CD,
        this.product_NM,
        this.file_NAME,
        this.file_PATH,
        this.cate_NAME,
        this.recommend,
        this.kcal,
        this.fat,
        this.nut_TABLE,
        this.new_SDATE,
        this.new_EDATE,
        this.sell_CAT,
        this.gift_VALUE,
        this.hot_YN,
        this.price,
        this.sold_OUT,
        this.front_VIEW_YN,
        this.view_SDATE,
        this.view_EDATE,
        this.note_TYPE,
        this.youtube_CODE,
        this.newicon,
        this.recomm,
        this.file_MASTER,
        this.thumbnail,
        this.img_ORDER,
        this.standard,
        this.unit,
        this.sat_FAT,
        this.trans_FAT,
        this.cholesterol,
        this.sugars,
        this.chabo,
        this.protein,
        this.sodium,
        this.caffeine,
        this.allergy,
        this.kcal_L,
        this.fat_L,
        this.sat_FAT_L,
        this.trans_FAT_L,
        this.cholesterol_L,
        this.sugars_L,
        this.chabo_L,
        this.protein_L,
        this.sodium_L,
        this.caffeine_L,
        this.msr_SEQ2,
        this.web_NEW,
        this.app_IMAGE,
        this.web_CARD_BIRTH,
        this.card_YEAR,
        this.card_MONTH,
        this.egift_CARD_YN,
        this.pair_TABLE,
        this.sub_VIEW,
        this.f_CATE_CD,
        this.pcate_CD,
        this.all_CATE_CD,
        this.img_UPLOAD_PATH,
        this.premier,
        this.search_DATE_TYPE,
        this.search_START_DATE,
        this.search_END_DATE,
        this.search_1_CATE,
        this.search_2_CATE,
        this.search_3_CATE,
        this.search_SALE_TYPE,
        this.search_VIEW_YN,
        this.search_KEY,
        this.search_VALUE,
        this.theme_SEARCH,
        this.page_INDEX,
        this.page_UNIT,
        this.page_SIZE,
        this.first_INDEX,
        this.last_INDEX,
        this.record_COUNT_PER_PAGE,
        this.total_CNT,
        this.rnum}
      );

  factory OriginMenu.fromJson(Map<String, dynamic> json) => _$OriginMenuFromJson(json);
  Map<String, dynamic> toJson() => _$OriginMenuToJson(this);
}