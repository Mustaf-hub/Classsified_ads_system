// To parse this JSON data, do
//
//     final listpackageModel = listpackageModelFromJson(jsonString);

import 'dart:convert';

ListpackageModel listpackageModelFromJson(String str) => ListpackageModel.fromJson(json.decode(str));

String listpackageModelToJson(ListpackageModel data) => json.encode(data.toJson());

class ListpackageModel {
  List<PackageDatum>? packageData;
  String? responseCode;
  String? result;
  String? responseMsg;

  ListpackageModel({
    this.packageData,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory ListpackageModel.fromJson(Map<String, dynamic> json) => ListpackageModel(
    packageData: json["PackageData"] == null ? [] : List<PackageDatum>.from(json["PackageData"]!.map((x) => PackageDatum.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "PackageData": packageData == null ? [] : List<dynamic>.from(packageData!.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class PackageDatum {
  String? id;
  String? title;
  String? days;
  String? price;
  String? status;
  String? postType;

  PackageDatum({
    this.id,
    this.title,
    this.days,
    this.price,
    this.status,
    this.postType,
  });

  factory PackageDatum.fromJson(Map<String, dynamic> json) => PackageDatum(
    id: json["id"],
    title: json["title"],
    days: json["days"],
    price: json["price"],
    status: json["status"],
    postType: json["post_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "days": days,
    "price": price,
    "status": status,
    "post_type": postType,
  };
}
