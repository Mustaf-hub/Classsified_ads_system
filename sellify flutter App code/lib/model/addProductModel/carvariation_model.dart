// To parse this JSON data, do
//
//     final carvariationModel = carvariationModelFromJson(jsonString);

import 'dart:convert';

CarvariationModel carvariationModelFromJson(String str) => CarvariationModel.fromJson(json.decode(str));

String carvariationModelToJson(CarvariationModel data) => json.encode(data.toJson());

class CarvariationModel {
  List<Carvariationlist>? carvariationlist;
  String? responseCode;
  String? result;
  String? responseMsg;

  CarvariationModel({
    this.carvariationlist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory CarvariationModel.fromJson(Map<String, dynamic> json) => CarvariationModel(
    carvariationlist: json["carvariationlist"] == null ? [] : List<Carvariationlist>.from(json["carvariationlist"]!.map((x) => Carvariationlist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "carvariationlist": carvariationlist == null ? [] : List<dynamic>.from(carvariationlist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Carvariationlist {
  String? id;
  String? brandId;
  String? title;
  int? variationTypeCount;

  Carvariationlist({
    this.id,
    this.brandId,
    this.title,
    this.variationTypeCount,
  });

  factory Carvariationlist.fromJson(Map<String, dynamic> json) => Carvariationlist(
    id: json["id"],
    brandId: json["brand_id"],
    title: json["title"],
    variationTypeCount: json["variation_type_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "title": title,
    "variation_type_count": variationTypeCount,
  };
}
