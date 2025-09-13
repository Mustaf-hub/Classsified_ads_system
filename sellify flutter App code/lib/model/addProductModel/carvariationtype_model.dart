// To parse this JSON data, do
//
//     final carvariationTypeModel = carvariationTypeModelFromJson(jsonString);

import 'dart:convert';

CarvariationTypeModel carvariationTypeModelFromJson(String str) => CarvariationTypeModel.fromJson(json.decode(str));

String carvariationTypeModelToJson(CarvariationTypeModel data) => json.encode(data.toJson());

class CarvariationTypeModel {
  List<Carvariationtypelist>? carvariationtypelist;
  String? responseCode;
  String? result;
  String? responseMsg;

  CarvariationTypeModel({
    this.carvariationtypelist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory CarvariationTypeModel.fromJson(Map<String, dynamic> json) => CarvariationTypeModel(
    carvariationtypelist: json["carvariationtypelist"] == null ? [] : List<Carvariationtypelist>.from(json["carvariationtypelist"]!.map((x) => Carvariationtypelist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "carvariationtypelist": carvariationtypelist == null ? [] : List<dynamic>.from(carvariationtypelist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Carvariationtypelist {
  String? id;
  String? brandId;
  String? variationId;
  String? title;

  Carvariationtypelist({
    this.id,
    this.brandId,
    this.variationId,
    this.title,
  });

  factory Carvariationtypelist.fromJson(Map<String, dynamic> json) => Carvariationtypelist(
    id: json["id"],
    brandId: json["brand_id"],
    variationId: json["variation_id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "variation_id": variationId,
    "title": title,
  };
}
