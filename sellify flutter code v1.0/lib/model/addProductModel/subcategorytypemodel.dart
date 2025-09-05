// To parse this JSON data, do
//
//     final subcatTypeModel = subcatTypeModelFromJson(jsonString);

import 'dart:convert';

SubcatTypeModel subcatTypeModelFromJson(String str) => SubcatTypeModel.fromJson(json.decode(str));

String subcatTypeModelToJson(SubcatTypeModel data) => json.encode(data.toJson());

class SubcatTypeModel {
  List<Subtypelist>? subtypelist;
  String? responseCode;
  String? result;
  String? responseMsg;

  SubcatTypeModel({
    this.subtypelist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory SubcatTypeModel.fromJson(Map<String, dynamic> json) => SubcatTypeModel(
    subtypelist: json["subtypelist"] == null ? [] : List<Subtypelist>.from(json["subtypelist"]!.map((x) => Subtypelist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "subtypelist": subtypelist == null ? [] : List<dynamic>.from(subtypelist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Subtypelist {
  String? id;
  String? subcatId;
  String? title;

  Subtypelist({
    this.id,
    this.subcatId,
    this.title,
  });

  factory Subtypelist.fromJson(Map<String, dynamic> json) => Subtypelist(
    id: json["id"],
    subcatId: json["subcat_id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subcat_id": subcatId,
    "title": title,
  };
}
