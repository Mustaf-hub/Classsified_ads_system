// To parse this JSON data, do
//
//     final subcategoryModel = subcategoryModelFromJson(jsonString);

import 'dart:convert';

SubcategoryModel subcategoryModelFromJson(String str) => SubcategoryModel.fromJson(json.decode(str));

String subcategoryModelToJson(SubcategoryModel data) => json.encode(data.toJson());

class SubcategoryModel {
  List<Subcategorylist>? subcategorylist;
  String? responseCode;
  String? result;
  String? responseMsg;

  SubcategoryModel({
    this.subcategorylist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
    subcategorylist: json["subcategorylist"] == null ? [] : List<Subcategorylist>.from(json["subcategorylist"]!.map((x) => Subcategorylist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "subcategorylist": subcategorylist == null ? [] : List<dynamic>.from(subcategorylist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Subcategorylist {
  String? id;
  String? title;
  String? includedSubtype;
  String? includedSubtypeFormatIsPill;

  Subcategorylist({
    this.id,
    this.title,
    this.includedSubtype,
    this.includedSubtypeFormatIsPill,
  });

  factory Subcategorylist.fromJson(Map<String, dynamic> json) => Subcategorylist(
    id: json["id"],
    title: json["title"],
    includedSubtype: json["included_subtype"],
    includedSubtypeFormatIsPill: json["included_subtype_format_is_pill"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "included_subtype": includedSubtype,
    "included_subtype_format_is_pill": includedSubtypeFormatIsPill,
  };
}
