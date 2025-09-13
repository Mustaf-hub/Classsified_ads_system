// To parse this JSON data, do
//
//     final carbrandlistModel = carbrandlistModelFromJson(jsonString);

import 'dart:convert';

CarbrandlistModel carbrandlistModelFromJson(String str) => CarbrandlistModel.fromJson(json.decode(str));

String carbrandlistModelToJson(CarbrandlistModel data) => json.encode(data.toJson());

class CarbrandlistModel {
  List<Carbrandlist>? carbrandlist;
  String? responseCode;
  String? result;
  String? responseMsg;

  CarbrandlistModel({
    this.carbrandlist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory CarbrandlistModel.fromJson(Map<String, dynamic> json) => CarbrandlistModel(
    carbrandlist: json["carbrandlist"] == null ? [] : List<Carbrandlist>.from(json["carbrandlist"]!.map((x) => Carbrandlist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "carbrandlist": carbrandlist == null ? [] : List<dynamic>.from(carbrandlist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Carbrandlist {
  String? id;
  String? title;
  String? img;
  int? variationCount;

  Carbrandlist({
    this.id,
    this.title,
    this.img,
    this.variationCount,
  });

  factory Carbrandlist.fromJson(Map<String, dynamic> json) => Carbrandlist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
    variationCount: json["variation_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
    "variation_count": variationCount,
  };
}
