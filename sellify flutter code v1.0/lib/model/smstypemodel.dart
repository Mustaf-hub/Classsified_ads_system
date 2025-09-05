// To parse this JSON data, do
//
//     final smstypeModel = smstypeModelFromJson(jsonString);

import 'dart:convert';

SmstypeModel smstypeModelFromJson(String str) => SmstypeModel.fromJson(json.decode(str));

String smstypeModelToJson(SmstypeModel data) => json.encode(data.toJson());

class SmstypeModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  String? smsType;
  String? admobEnabled;
  String? maintainanceEnabled;
  String? bannerId;
  String? inId;
  String? otpAuth;
  String? iosInId;
  String? iosBannerId;
  String? nativeAd;
  String? iosNativeAd;

  SmstypeModel({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.smsType,
    this.admobEnabled,
    this.maintainanceEnabled,
    this.bannerId,
    this.inId,
    this.otpAuth,
    this.iosInId,
    this.iosBannerId,
    this.nativeAd,
    this.iosNativeAd,
  });

  factory SmstypeModel.fromJson(Map<String, dynamic> json) => SmstypeModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    smsType: json["SMS_TYPE"],
    admobEnabled: json["Admob_Enabled"],
    maintainanceEnabled: json["maintainance_Enabled"],
    bannerId: json["banner_id"],
    inId: json["in_id"],
    otpAuth: json["otp_auth"],
    iosInId: json["ios_in_id"],
    iosBannerId: json["ios_banner_id"],
    nativeAd: json["native_ad"],
    iosNativeAd: json["ios_native_ad"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "SMS_TYPE": smsType,
    "Admob_Enabled": admobEnabled,
    "maintainance_Enabled": maintainanceEnabled,
    "banner_id": bannerId,
    "in_id": inId,
    "otp_auth": otpAuth,
    "ios_in_id": iosInId,
    "ios_banner_id": iosBannerId,
    "native_ad": nativeAd,
    "ios_native_ad": iosNativeAd,
  };
}
