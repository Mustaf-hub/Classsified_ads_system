// To parse this JSON data, do
//
//     final bikescootercvehicleModel = bikescootercvehicleModelFromJson(jsonString);

import 'dart:convert';

BikescootercvehicleModel bikescootercvehicleModelFromJson(String str) => BikescootercvehicleModel.fromJson(json.decode(str));

String bikescootercvehicleModelToJson(BikescootercvehicleModel data) => json.encode(data.toJson());

class BikescootercvehicleModel {
  List<Bikescooterbrandlist>? bikescooterbrandlist;
  String? responseCode;
  String? result;
  String? responseMsg;

  BikescootercvehicleModel({
    this.bikescooterbrandlist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory BikescootercvehicleModel.fromJson(Map<String, dynamic> json) => BikescootercvehicleModel(
    bikescooterbrandlist: json["bikescooterbrandlist"] == null ? [] : List<Bikescooterbrandlist>.from(json["bikescooterbrandlist"]!.map((x) => Bikescooterbrandlist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "bikescooterbrandlist": bikescooterbrandlist == null ? [] : List<dynamic>.from(bikescooterbrandlist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Bikescooterbrandlist {
  String? id;
  String? title;
  String? img;
  int? modelCount;

  Bikescooterbrandlist({
    this.id,
    this.title,
    this.img,
    this.modelCount,
  });

  factory Bikescooterbrandlist.fromJson(Map<String, dynamic> json) => Bikescooterbrandlist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
    modelCount: json["model_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
    "model_count": modelCount,
  };
}
