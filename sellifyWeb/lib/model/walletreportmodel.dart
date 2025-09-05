// To parse this JSON data, do
//
//     final walletreportModel = walletreportModelFromJson(jsonString);

import 'dart:convert';

WalletreportModel walletreportModelFromJson(String str) => WalletreportModel.fromJson(json.decode(str));

String walletreportModelToJson(WalletreportModel data) => json.encode(data.toJson());

class WalletreportModel {
  List<Walletitem>? walletitem;
  String? wallet;
  String? responseCode;
  String? result;
  String? responseMsg;

  WalletreportModel({
    this.walletitem,
    this.wallet,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory WalletreportModel.fromJson(Map<String, dynamic> json) => WalletreportModel(
    walletitem: json["Walletitem"] == null ? [] : List<Walletitem>.from(json["Walletitem"]!.map((x) => Walletitem.fromJson(x))),
    wallet: json["wallet"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "Walletitem": walletitem == null ? [] : List<dynamic>.from(walletitem!.map((x) => x.toJson())),
    "wallet": wallet,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Walletitem {
  String? message;
  String? status;
  String? amt;

  Walletitem({
    this.message,
    this.status,
    this.amt,
  });

  factory Walletitem.fromJson(Map<String, dynamic> json) => Walletitem(
    message: json["message"],
    status: json["status"],
    amt: json["amt"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "amt": amt,
  };
}
