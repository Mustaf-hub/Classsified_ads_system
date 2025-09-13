// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

VehicleModel vehicleModelFromJson(String str) => VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  List<Bikescootermodellist>? bikescootermodellist;
  String? responseCode;
  String? result;
  String? responseMsg;

  VehicleModel({
    this.bikescootermodellist,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    bikescootermodellist: json["bikescootermodellist"] == null ? [] : List<Bikescootermodellist>.from(json["bikescootermodellist"]!.map((x) => Bikescootermodellist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "bikescootermodellist": bikescootermodellist == null ? [] : List<dynamic>.from(bikescootermodellist!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Bikescootermodellist {
  String? id;
  String? brandId;
  String? title;

  Bikescootermodellist({
    this.id,
    this.brandId,
    this.title,
  });

  factory Bikescootermodellist.fromJson(Map<String, dynamic> json) => Bikescootermodellist(
    id: json["id"],
    brandId: json["brand_id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "title": title,
  };
}
