import 'package:get/get.dart';


class InboxController extends GetxController implements GetxService {
  
    List carFilterList = [
      "By Brand / Model".tr,
      "By Budget".tr,
      "By Year".tr,
      "By No. of Owners".tr,
      "By KM Driven".tr,
      "By Fuel".tr,
      "By Transmission".tr,
      "Change Sort".tr
    ];

    List rentHouseFilterList = [
      "By Budget".tr,
      "By Property Type".tr,
      "By Bedrooms".tr,
      "By Bathrooms".tr,
      "By Furnishing".tr,
      "By Listed By".tr,
      "By Super Builtup Area".tr,
      "By Bachelors Allowed".tr,
      "Change Sort".tr
    ];

    List saleHouseFilterList = [
      "By Budget".tr,
      "By Property Type".tr,
      "By Bedrooms".tr,
      "By Bathrooms".tr,
      "By Furnishing".tr,
      "By Construction Status".tr,
      "By Listed By".tr,
      "By Super Builtup Area".tr,
      "Change Sort".tr
    ];

    List plotFilterList = [
      "By Budget".tr,
      "By Type".tr,
      "By Listed By".tr,
      "By Plot Area".tr,
      "Change Sort".tr
    ];

    List saleOfficeFilterList = [
      "By Budget".tr,
      "By Furnishing".tr,
      "By Listed By".tr,
      "By Super Builtup Area".tr,
      "By Construction Status".tr,
      "Change Sort".tr
    ];

    List rentOfficeFilterList = [
      "By Budget".tr,
      "By Furnishing".tr,
      "By Listed By".tr,
      "By Super Builtup Area".tr,
      "Change Sort".tr
    ];

    List rentPgFilterList = [
      "By Budget".tr,
      "By sub type".tr,
      "By Furnishing".tr,
      "By Meals Included".tr,
      "By Listed By".tr,
      "Change Sort".tr
    ];

    List mobileFilterList = [
      "By Budget".tr,
      "By Brand".tr,
      "Change Sort".tr
    ];

    List accesFilterList = [
      "By Budget".tr,
      "By Device Type".tr,
      "Change Sort".tr
    ];

    List tabletFilterList = [
      "By Type".tr,
      "By Budget".tr,
      "Change Sort".tr
    ];

    List jobFilterList = [
      "By Position Type".tr,
      "By Salary Period".tr,
      "Change Sort".tr
    ];

    List bikeFilterList = [
      "By Budget".tr,
      "By Brand / Model".tr,
      "By KM Driven".tr,
      "By Year".tr,
      "Change Sort".tr
    ];

    List bechlorsFilterList = [
      "Bechelors allowed".tr,
      "Bachelors not allowed".tr
    ];

    List commonFilterList = [
      "By Budget".tr,
      "Change Sort".tr
    ];

    List serviceFilterList = [
      "By Type".tr,
      "Change Sort".tr
    ];

    List bicycleFilterList = [
      "By Budget".tr,
      "By Brand".tr,
      "Change Sort".tr
    ];

    List commerFilterList = [
      "By Budget".tr,
      "By Year".tr,
      "By KM Driven".tr,
      "Change Sort".tr
    ];

    List fuelType = [
      "Petrol".tr,
      "Diesel".tr,
      "LPG".tr,
      "CNG & Hybrids".tr,
      "Electric".tr
    ];

    List owners = [
      "1st".tr,
      "2nd".tr,
      "3rd".tr,
      "4th".tr,
      "4+".tr
    ];

    List ownersData = [
      "1st",
      "2nd",
      "3rd",
      "4th",
      "4+"
    ];

    List ownersType = [
      "First".tr,
      "Second".tr,
      "Third".tr,
      "Fourth".tr,
      "More than Four".tr
    ];

    List ownersTypeData = [
      "First",
      "Second",
      "Third",
      "Fourth",
      "More than Four"
    ];

    List fuel = [
      "Petrol".tr,
      "Diesel".tr,
      "LPG".tr,
      "CNG & Hybrid".tr,
      "Electric".tr
    ];

    List fuelData = [
      "Petrol",
      "Diesel",
      "LPG",
      "CNG & Hybrid",
      "Electric"
    ];

    List transmission = [
      "Automatic".tr,
      "Manual".tr
    ];

    List transmissionData = [
      "Automatic",
      "Manual"
    ];

    List bysort = [
      "Date Published".tr,
      "Price: Low to High".tr,
      "Price: High to Low".tr,
      "Distance".tr
    ];

    List jobSort = [
      "Date Published".tr,
      "Relevence".tr,
      "Distance".tr
    ];

    List furniture = [
      "Furnished".tr,
      "Unfurnished".tr,
      "Semi Furnished".tr
    ];

    List furnitureData = [
      "Furnished",
      "Unfurnished",
      "Semi Furnished"
    ];

    List meal = [
      "Meals included".tr,
      "Meals not included".tr,
    ];

    List bathrooms = [
      "1+ bathroom".tr,
      "2+ bathrooms".tr,
      "3+ bathrooms".tr,
      "4+ bathrooms".tr,
    ];

    List bathroomsData = [
      "1+ bathroom",
      "2+ bathrooms",
      "3+ bathrooms",
      "4+ bathrooms",
    ];

    List bedrooms = [
      "1+ bedroom".tr,
      "2+ bedrooms".tr,
      "3+ bedrooms".tr,
      "4+ bedrooms".tr,
    ];
    List bedroomsData = [
      "1+ bedroom",
      "2+ bedrooms",
      "3+ bedrooms",
      "4+ bedrooms",
    ];

    List listedBy = [
      "Owner".tr,
      "Dealer".tr,
      "Builder".tr
    ];
    List listedByData = [
      "Owner",
      "Dealer",
      "Builder"
    ];

    List constStatus = [
      "Under Construction".tr,
      "Ready to Move".tr,
      "New Launch".tr
    ];

    List constStatusData = [
      "Under Construction",
      "Ready to Move",
      "New Launch"
    ];

    List positionType = [
      "Full time".tr,
      "Part time".tr,
      "Contract".tr,
      "Temporary".tr
    ];

    List positionTypeData = [
      "Full time",
      "Part time",
      "Contract",
      "Temporary"
    ];

   List salaryPeriod = [
      "Hourly".tr,
      "Weekly".tr,
      "Monthly".tr,
      "Yearly".tr
    ];

   List salaryPeriodData = [
      "Hourly",
      "Weekly",
      "Monthly",
      "Yearly"
    ];

  getUpdate(){
    update();
  }

}