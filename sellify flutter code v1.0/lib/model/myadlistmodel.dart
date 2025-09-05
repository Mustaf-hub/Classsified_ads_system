// To parse this JSON data, do
//
//     final myadlistModel = myadlistModelFromJson(jsonString);

import 'dart:convert';

MyadlistModel myadlistModelFromJson(String str) => MyadlistModel.fromJson(json.decode(str));

String myadlistModelToJson(MyadlistModel data) => json.encode(data.toJson());

class MyadlistModel {
  List<MyadList>? myadList;
  String? currency;
  String? responseCode;
  String? result;
  String? responseMsg;

  MyadlistModel({
    this.myadList,
    this.currency,
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory MyadlistModel.fromJson(Map<String, dynamic> json) => MyadlistModel(
    myadList: json["MyadList"] == null ? [] : List<MyadList>.from(json["MyadList"]!.map((x) => MyadList.fromJson(x))),
    currency: json["currency"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "MyadList": myadList == null ? [] : List<dynamic>.from(myadList!.map((x) => x.toJson())),
    "currency": currency,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class MyadList {
  String? postId;
  String? catId;
  String? subcatId;
  String? postImage;
  List<String>? postAllImage;
  String? postTitle;
  DateTime? postDate;
  DateTime? postExpireDate;
  int? daysRemaining;
  int? totalDay;
  String? transmission;
  String? adPrice;
  String? jobSalaryFrom;
  String? jobSalaryTo;
  dynamic jobSalaryPeriod;
  dynamic jobPositionType;
  String? fullAddress;
  String? lats;
  String? longs;
  String? adDescription;
  String? brandId;
  String? variantId;
  String? variantTypeId;
  String? postYear;
  String? fuel;
  String? kmDriven;
  String? noOwner;
  String? propertyType;
  dynamic propertyBedroom;
  dynamic propertyBathroom;
  dynamic propertyFurnishing;
  dynamic propertyConstructionStatus;
  dynamic propertyListedBy;
  String? propertySuperbuildarea;
  String? propertyCarpetarea;
  String? propertyMaintainceMonthly;
  String? propertyTotalFloor;
  String? propertyFloorNo;
  dynamic propertyCarParking;
  dynamic propertyFacing;
  dynamic projectName;
  String? propertyBachloar;
  dynamic propertyLandType;
  String? plotArea;
  String? plotLength;
  String? plotBreadth;
  String? pgSubtype;
  String? pgMealsInclude;
  String? mobileBrand;
  String? accessoriesType;
  String? tabletType;
  String? motocycleBrandId;
  String? motorcycleModelId;
  String? scooterBrandId;
  String? scooterModelId;
  String? bicyclesBrandId;
  String? commercialBrandId;
  String? commercialModelId;
  String? sparepartTypeId;
  String? serviceTypeId;
  String? isApprove;
  String? isSold;
  String? isFeatureAd;
  String? postType;
  dynamic soldType;
  String? isPaid;
  String? isExpire;
  int? totalFavourite;
  int? totalViews;

  MyadList({
    this.postId,
    this.catId,
    this.subcatId,
    this.postImage,
    this.postAllImage,
    this.postTitle,
    this.postDate,
    this.postExpireDate,
    this.daysRemaining,
    this.totalDay,
    this.transmission,
    this.adPrice,
    this.jobSalaryFrom,
    this.jobSalaryTo,
    this.jobSalaryPeriod,
    this.jobPositionType,
    this.fullAddress,
    this.lats,
    this.longs,
    this.adDescription,
    this.brandId,
    this.variantId,
    this.variantTypeId,
    this.postYear,
    this.fuel,
    this.kmDriven,
    this.noOwner,
    this.propertyType,
    this.propertyBedroom,
    this.propertyBathroom,
    this.propertyFurnishing,
    this.propertyConstructionStatus,
    this.propertyListedBy,
    this.propertySuperbuildarea,
    this.propertyCarpetarea,
    this.propertyMaintainceMonthly,
    this.propertyTotalFloor,
    this.propertyFloorNo,
    this.propertyCarParking,
    this.propertyFacing,
    this.projectName,
    this.propertyBachloar,
    this.propertyLandType,
    this.plotArea,
    this.plotLength,
    this.plotBreadth,
    this.pgSubtype,
    this.pgMealsInclude,
    this.mobileBrand,
    this.accessoriesType,
    this.tabletType,
    this.motocycleBrandId,
    this.motorcycleModelId,
    this.scooterBrandId,
    this.scooterModelId,
    this.bicyclesBrandId,
    this.commercialBrandId,
    this.commercialModelId,
    this.sparepartTypeId,
    this.serviceTypeId,
    this.isApprove,
    this.isSold,
    this.isFeatureAd,
    this.postType,
    this.soldType,
    this.isPaid,
    this.isExpire,
    this.totalFavourite,
    this.totalViews,
  });

  factory MyadList.fromJson(Map<String, dynamic> json) => MyadList(
    postId: json["post_id"],
    catId: json["cat_id"],
    subcatId: json["subcat_id"],
    postImage: json["post_image"],
    postAllImage: json["post_all_image"] == null ? [] : List<String>.from(json["post_all_image"]!.map((x) => x)),
    postTitle: json["post_title"],
    postDate: json["post_date"] == null ? null : DateTime.parse(json["post_date"]),
    postExpireDate: json["post_expire_date"] == null ? null : DateTime.parse(json["post_expire_date"]),
    daysRemaining: json["days_remaining"],
    totalDay: json["total_day"],
    transmission: json["transmission"],
    adPrice: json["ad_price"],
    jobSalaryFrom: json["job_salary_from"],
    jobSalaryTo: json["job_salary_to"],
    jobSalaryPeriod: json["job_salary_period"],
    jobPositionType: json["job_position_type"],
    fullAddress: json["full_address"],
    lats: json["lats"],
    longs: json["longs"],
    adDescription: json["ad_description"],
    brandId: json["brand_id"],
    variantId: json["variant_id"],
    variantTypeId: json["variant_type_id"],
    postYear: json["post_year"],
    fuel: json["fuel"],
    kmDriven: json["km_driven"],
    noOwner: json["no_owner"],
    propertyType: json["property_type"],
    propertyBedroom: json["property_bedroom"],
    propertyBathroom: json["property_bathroom"],
    propertyFurnishing: json["property_furnishing"],
    propertyConstructionStatus: json["property_construction_status"],
    propertyListedBy: json["property_listed_by"],
    propertySuperbuildarea: json["property_superbuildarea"],
    propertyCarpetarea: json["property_carpetarea"],
    propertyMaintainceMonthly: json["property_maintaince_monthly"],
    propertyTotalFloor: json["property_total_floor"],
    propertyFloorNo: json["property_floor_no"],
    propertyCarParking: json["property_car_parking"],
    propertyFacing: json["property_facing"],
    projectName: json["project_name"],
    propertyBachloar: json["property_bachloar"],
    propertyLandType: json["property_land_type"],
    plotArea: json["plot_area"],
    plotLength: json["plot_length"],
    plotBreadth: json["plot_breadth"],
    pgSubtype: json["pg_subtype"],
    pgMealsInclude: json["pg_meals_include"],
    mobileBrand: json["mobile_brand"],
    accessoriesType: json["accessories_type"],
    tabletType: json["tablet_type"],
    motocycleBrandId: json["motocycle_brand_id"],
    motorcycleModelId: json["motorcycle_model_id"],
    scooterBrandId: json["scooter_brand_id"],
    scooterModelId: json["scooter_model_id"],
    bicyclesBrandId: json["bicycles_brand_id"],
    commercialBrandId: json["commercial_brand_id"],
    commercialModelId: json["commercial_model_id"],
    sparepartTypeId: json["sparepart_type_id"],
    serviceTypeId: json["service_type_id"],
    isApprove: json["is_approve"],
    isSold: json["is_sold"],
    isFeatureAd: json["is_feature_ad"],
    postType: json["post_type"],
    soldType: json["sold_type"],
    isPaid: json["is_paid"],
    isExpire: json["is_expire"],
    totalFavourite: json["total_favourite"],
    totalViews: json["total_views"],
  );

  Map<String, dynamic> toJson() => {
    "post_id": postId,
    "cat_id": catId,
    "subcat_id": subcatId,
    "post_image": postImage,
    "post_all_image": postAllImage == null ? [] : List<dynamic>.from(postAllImage!.map((x) => x)),
    "post_title": postTitle,
    "post_date": postDate?.toIso8601String(),
    "post_expire_date": postExpireDate?.toIso8601String(),
    "days_remaining": daysRemaining,
    "total_day": totalDay,
    "transmission": transmission,
    "ad_price": adPrice,
    "job_salary_from": jobSalaryFrom,
    "job_salary_to": jobSalaryTo,
    "job_salary_period": jobSalaryPeriod,
    "job_position_type": jobPositionType,
    "full_address": fullAddress,
    "lats": lats,
    "longs": longs,
    "ad_description": adDescription,
    "brand_id": brandId,
    "variant_id": variantId,
    "variant_type_id": variantTypeId,
    "post_year": postYear,
    "fuel": fuel,
    "km_driven": kmDriven,
    "no_owner": noOwner,
    "property_type": propertyType,
    "property_bedroom": propertyBedroom,
    "property_bathroom": propertyBathroom,
    "property_furnishing": propertyFurnishing,
    "property_construction_status": propertyConstructionStatus,
    "property_listed_by": propertyListedBy,
    "property_superbuildarea": propertySuperbuildarea,
    "property_carpetarea": propertyCarpetarea,
    "property_maintaince_monthly": propertyMaintainceMonthly,
    "property_total_floor": propertyTotalFloor,
    "property_floor_no": propertyFloorNo,
    "property_car_parking": propertyCarParking,
    "property_facing": propertyFacing,
    "project_name": projectName,
    "property_bachloar": propertyBachloar,
    "property_land_type": propertyLandType,
    "plot_area": plotArea,
    "plot_length": plotLength,
    "plot_breadth": plotBreadth,
    "pg_subtype": pgSubtype,
    "pg_meals_include": pgMealsInclude,
    "mobile_brand": mobileBrand,
    "accessories_type": accessoriesType,
    "tablet_type": tabletType,
    "motocycle_brand_id": motocycleBrandId,
    "motorcycle_model_id": motorcycleModelId,
    "scooter_brand_id": scooterBrandId,
    "scooter_model_id": scooterModelId,
    "bicycles_brand_id": bicyclesBrandId,
    "commercial_brand_id": commercialBrandId,
    "commercial_model_id": commercialModelId,
    "sparepart_type_id": sparepartTypeId,
    "service_type_id": serviceTypeId,
    "is_approve": isApprove,
    "is_sold": isSold,
    "is_feature_ad": isFeatureAd,
    "post_type": postType,
    "sold_type": soldType,
    "is_paid": isPaid,
    "is_expire": isExpire,
    "total_favourite": totalFavourite,
    "total_views": totalViews,
  };
}
