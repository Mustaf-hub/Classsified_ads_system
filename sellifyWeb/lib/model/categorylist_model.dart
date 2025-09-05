import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<Categorylist>? categorylist;
  String? responseCode;
  String? result;
  String? responseMsg;

  CategoryModel({
    this.categorylist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    categorylist: json["categorylist"] == null ? [] : List<Categorylist>.from(json["categorylist"]!.map((x) => Categorylist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "categorylist": categorylist == null ? [] : List<dynamic>.from(categorylist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Categorylist {
  String? id;
  String? title;
  String? img;
  String? totalFreePostAllow;
  int? subcatCount;
  int? isPaid;

  Categorylist({
    this.id,
    this.title,
    this.img,
    this.totalFreePostAllow,
    this.subcatCount,
    this.isPaid,
  });

  factory Categorylist.fromJson(Map<String, dynamic> json) => Categorylist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
    totalFreePostAllow: json["total_free_post_allow"],
    subcatCount: json["subcat_count"],
    isPaid: json["is_paid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
    "total_free_post_allow": totalFreePostAllow,
    "subcat_count": subcatCount,
    "is_paid": isPaid,
  };
}
