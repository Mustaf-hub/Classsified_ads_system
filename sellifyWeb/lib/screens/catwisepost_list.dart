import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/addfav_controller.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/catwisepost_controller.dart';
import 'package:sellify/controller/filter_controller/filters_controller.dart';
import 'package:sellify/controller/filter_update.dart';
import 'package:sellify/controller/inboxcontroller.dart';
import 'package:sellify/controller/myfav_controller.dart';
import 'package:sellify/screens/catwisepost_screen.dart';
import 'package:sellify/screens/search_screen.dart';

import '../api_config/config.dart';
import '../api_config/store_data.dart';
import '../controller/carbrandlist_controller.dart';
import '../controller/homedata_controller.dart';
import '../controller/login_controller.dart';
import '../controller/postad/bikecvehiclecontoller.dart';
import '../controller/postview_controller.dart';
import '../helper/appbar_screen.dart';
import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';
import 'filterpost_screen.dart';
import 'loginscreen.dart';

class CatwisepostList extends StatefulWidget {
  final int catID;
  final int subcatId;
  const CatwisepostList({super.key, required this.catID, required this.subcatId});

  @override
  State<CatwisepostList> createState() => _CatwisepostListState();
}

class _CatwisepostListState extends State<CatwisepostList> {

  @override
  void initState() {
    // TODO: implement initState
      catwisePostCont.getCatwisePost(catId: widget.catID.toString(), subcatId: widget.subcatId.toString()).then((value) {
        setState(() {});
      },);

      if(kIsWeb){
        setState(() {
          if(selectFilter == 0 && budget.isEmpty){
            if(widget.subcatId == 8 || widget.subcatId == 27 || widget.subcatId == 49 || widget.subcatId == 50 || (widget.subcatId >= 54 &&  widget.subcatId <= 56)){
              getRange(sRange: 0, eRange: 10000, setState1: setState);
            } else if(widget.subcatId >= 46 && widget.subcatId <= 48){
              getRange(sRange: 0, eRange: 15000, setState1: setState);
            } else if(widget.subcatId == 28 || widget.subcatId == 31){
              getRange(sRange: 0, eRange: 50000, setState1: setState);
            } else if(widget.subcatId == 32){
              getRange(sRange: 0, eRange: 75000, setState1: setState);
            } else if(widget.subcatId == 40 || widget.subcatId == 51 || widget.subcatId == 30){
              getRange(sRange: 0, eRange: 100000, setState1: setState);
            } else if(widget.subcatId == 25 || widget.subcatId == 26){
              getRange(sRange: 0, eRange: 200000, setState1: setState);
            } else if(widget.subcatId == 2 || widget.subcatId == 4 || widget.subcatId == 53){
              getRange(sRange: 0, eRange: 500000, setState1: setState);
            } else if(widget.subcatId == 3 || widget.subcatId == 6 || widget.subcatId == 39 || widget.catID == 1){
              getRange(sRange: 0, eRange: 1000000, setState1: setState);
            } else if(widget.subcatId == 1 || widget.subcatId == 5){
              getRange(sRange: 0, eRange: 50000000, setState1: setState);
            } else {
              getRange(sRange: 0, eRange: 25000, setState1: setState);
            }
          }
        });
        setState(() {
          isNavigate = true;
        });
        widget.catID == 1 ?
        carbrandlistCont.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
          isNavigate = false;
          setState(() {});
        },)
        : widget.subcatId == 28 ? subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
          isNavigate = false;
          setState(() {});
        },)
        : (widget.catID == 5 || widget.subcatId == 39) ? bikeScoCvehicleCon.getvehicle(subcatId: widget.subcatId.toString()).then((value) {
          isNavigate = false;
          setState(() {});
        },)
        : subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
          isNavigate = false;
          setState(() {});
        },);
      }
    setState(() {
      if (widget.catID == 1) {
        subcatCont.categoryList().then((value) {
          setState(() {
            catTitle = subcatCont.categorylistData!.categorylist![0].title ?? "";
          });
        },);
      } else {
        subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
          for(int i = 0;i < subcatCont.subcategoryData!.subcategorylist!.length;i++){
            if(widget.subcatId.toString() == subcatCont.subcategoryData!.subcategorylist![i].id){
              setState(() {
                catTitle = subcatCont.subcategoryData!.subcategorylist![i].title ?? "";
              });
            }
          }
        },);
      }

      filterupdateCont.selectedFiltersList = [];
      filtersCont.filterUploded = false;
    });
    super.initState();
    if(filtersCont.filterUploded){
      getFilterData();
    }
  }

  bool isloadoing = false;

  bool isNavigate = false;
  late ColorNotifire notifier;

  CatwisePostController catwisePostCont = Get.find();
  AddfavController addfavCont = Get.find();
  MyfavController myfavCont = Get.find();
  InboxController inbox = Get.find();
  CarbrandlistController carbrandlistCont = Get.find();
  CategoryListController subcatCont = Get.find();
  FilterupdateController filterupdateCont = Get.put(FilterupdateController());
  BikescooterCvehicleContoller bikeScoCvehicleCon = Get.find();
  PostviewController postviewCont = Get.find();

  FiltersController filtersCont = Get.find();

  TextEditingController yearminText = TextEditingController();
  TextEditingController yearmaxText = TextEditingController();

  String catTitle = "";
  int? selectedBrand;

  List checkData = [];

  int selectedSort = 0;
  int selectFilter = 0;

  String brandId = "";
  String builtupArea = "";
  String sorting = "";
  String plotArea = "";
  String budget = "";
  String kmDriven = "";
  String kmStart = "";
  String kmEnd = "";
  String year = "";
  String mealIncluded = "";
  String meal = "";
  String mobilebrand = "";
  String budgetStart = "";
  String budgetEnd = "";
  String sort = "";
  String fuel = "";
  String selectedfuelData = "";
  String ownerLength = "";
  String selectedownerLength = "";
  String transmission = "";
  String transmissionData = "";
  String positionType = "";
  String positionTypeData = "";
  String salaryPeriod = "";
  String salaryPeriodData = "";
  String byType = "";

  String buildareaStart = "";
  String buildareaEnd = "";
  String propertyType = "";
  String bedroom = "";
  String bedroomData = "";
  String bathroom = "";
  String bathroomData = "";
  String furnishing = "";
  String furnishingData = "";
  String constStatus = "";
  String constStatusData = "";
  String bachelor = "";
  String propertyListedBy = "";
  String propertyListedByData = "";
  String plotAreaStart = "";
  String plotAreaEnd = "";

  List salaryPeriodList = [];
  List salaryPeriodListData = [];
  List positionList = [];
  List positionListData = [];
  List carBrand = [];
  List fuelData = [];
  List fuelDataList = [];
  List propertyListing = [];
  List propertyListingData = [];
  List ownerLengthData = [];
  List ownerLengthDataList = [];
  List propertyTypeList = [];
  List mobilebrandId = [];
  String selectBachelor = "";
  List commerBrand = [];

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: catTitle, fun: () {
                Get.back();
              },)) : AppBar(
            elevation: 0,
            backgroundColor: notifier.getWhiteblackColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  if(isNavigate) return;

                    setState(() {
                      isNavigate = true;
                    });
                  setState(() {
                    if(selectFilter == 0 && budget.isEmpty){
                    if(widget.subcatId == 8 || widget.subcatId == 27 || widget.subcatId == 49 || widget.subcatId == 50 || (widget.subcatId >= 54 &&  widget.subcatId <= 56)){
                      getRange(sRange: 0, eRange: 10000, setState1: setState);
                    } else if(widget.subcatId >= 46 && widget.subcatId <= 48){
                      getRange(sRange: 0, eRange: 15000, setState1: setState);
                    } else if(widget.subcatId == 28 || widget.subcatId == 31){
                      getRange(sRange: 0, eRange: 50000, setState1: setState);
                    } else if(widget.subcatId == 32){
                      getRange(sRange: 0, eRange: 75000, setState1: setState);
                    } else if(widget.subcatId == 40 || widget.subcatId == 51 || widget.subcatId == 30){
                      getRange(sRange: 0, eRange: 100000, setState1: setState);
                    } else if(widget.subcatId == 25 || widget.subcatId == 26){
                      getRange(sRange: 0, eRange: 200000, setState1: setState);
                    } else if(widget.subcatId == 2 || widget.subcatId == 4 || widget.subcatId == 53){
                      getRange(sRange: 0, eRange: 500000, setState1: setState);
                    } else if(widget.subcatId == 3 || widget.subcatId == 6 || widget.subcatId == 39 || widget.catID == 1){
                      getRange(sRange: 0, eRange: 1000000, setState1: setState);
                    } else if(widget.subcatId == 1 || widget.subcatId == 5){
                        getRange(sRange: 0, eRange: 50000000, setState1: setState);
                      } else {
                        getRange(sRange: 0, eRange: 25000, setState1: setState);
                      }
                     }
                  });

                  widget.catID == 1 ?
                  carbrandlistCont.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
                    Get.bottomSheet(
                        StatefulBuilder(builder: (context, setState) {
                          return BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                              child: filterBottom(setState, constraints));
                        },)
                    ).then((value) {
                      setState(() {
                        isNavigate = false;
                      });
                    },);
                  },)
                      : widget.subcatId == 28 ? subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
                    Get.bottomSheet(
                        StatefulBuilder(builder: (context, setState) {
                          return BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                              child: filterBottom(setState, constraints));
                        },)
                    ).then((value) {
                      setState(() {
                        isNavigate = false;
                      });
                    },);
                  },) :
                  (widget.catID == 5 || widget.subcatId == 39) ?
                  bikeScoCvehicleCon.getvehicle(subcatId: widget.subcatId.toString()).then((value) {
                    Get.bottomSheet(
                        StatefulBuilder(builder: (context, setState) {
                          return BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                              child: filterBottom(setState,constraints));
                        },)
                    ).then((value) {
                      setState(() {
                        isNavigate = false;
                      });
                    },);
                  },)
                      : subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
                    Get.bottomSheet(
                        StatefulBuilder(builder: (context, setState) {
                          return BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                              child: filterBottom(setState, constraints));
                        },)
                    ).then((value) {
                      setState(() {
                        isNavigate = false;
                      });
                    },);
                  },);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: notifier.getWhiteblackColor,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: Image.asset("assets/Filter.png", height: 16, color: notifier.iconColor,),
                ),
              )
            ],
            title: Text(catTitle, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
          ),
          body: GetBuilder<HomedataController>(
              builder: (homedataCont) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 750 < constraints.maxWidth ? 0 : 20, horizontal: 1550 < constraints.maxWidth ? 200 : 1050 < constraints.maxWidth ? 100 : 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    constraints.maxWidth < 850 ? const SizedBox() : Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: Get.height - 300,
                                        child: isNavigate ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              child: LoadingAnimationWidget.staggeredDotsWave(
                                                size: 30,
                                                color: PurpleColor,
                                              ),
                                            ),
                                          ],
                                        ) : filterBottom(setState, constraints),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 55,
                                                  child: TextField(
                                                    readOnly: true,
                                                    onTap: () {
                                                      Get.to(const SearchScreen(), transition: Transition.noTransition);
                                                    },
                                                    style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),
                                                    decoration: InputDecoration(
                                                        prefixIcon: Padding(
                                                          padding: const EdgeInsets.only(left: 8),
                                                          child: Image.asset("assets/searchIcon.png", scale: 2.8,),
                                                        ),
                                                        hintStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),
                                                        hintText: "Search ".tr,
                                                        filled: true,
                                                        fillColor: notifier.textfield,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(35),
                                                          borderSide: BorderSide(color: searchBorder),
                                                        ),
                                                        enabledBorder:  OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(35),
                                                          borderSide: BorderSide(color: notifier.borderColor, width: 2),
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              constraints.maxWidth < 850 ? InkWell(
                                                onTap: () {
                                                  if(isNavigate) return;

                                                  setState(() {
                                                    isNavigate = true;
                                                  });
                                                  setState(() {
                                                    if(selectFilter == 0 && budget.isEmpty){
                                                      if(widget.subcatId == 8 || widget.subcatId == 27 || widget.subcatId == 49 || widget.subcatId == 50 || (widget.subcatId >= 54 &&  widget.subcatId <= 56)){
                                                        getRange(sRange: 0, eRange: 10000, setState1: setState);
                                                      } else if(widget.subcatId >= 46 && widget.subcatId <= 48){
                                                        getRange(sRange: 0, eRange: 15000, setState1: setState);
                                                      } else if(widget.subcatId == 28 || widget.subcatId == 31){
                                                        getRange(sRange: 0, eRange: 50000, setState1: setState);
                                                      } else if(widget.subcatId == 32){
                                                        getRange(sRange: 0, eRange: 75000, setState1: setState);
                                                      } else if(widget.subcatId == 40 || widget.subcatId == 51 || widget.subcatId == 30){
                                                        getRange(sRange: 0, eRange: 100000, setState1: setState);
                                                      } else if(widget.subcatId == 25 || widget.subcatId == 26){
                                                        getRange(sRange: 0, eRange: 200000, setState1: setState);
                                                      } else if(widget.subcatId == 2 || widget.subcatId == 4 || widget.subcatId == 53){
                                                        getRange(sRange: 0, eRange: 500000, setState1: setState);
                                                      } else if(widget.subcatId == 3 || widget.subcatId == 6 || widget.subcatId == 39 || widget.catID == 1){
                                                        getRange(sRange: 0, eRange: 1000000, setState1: setState);
                                                      } else if(widget.subcatId == 1 || widget.subcatId == 5){
                                                        getRange(sRange: 0, eRange: 50000000, setState1: setState);
                                                      } else {
                                                        getRange(sRange: 0, eRange: 25000, setState1: setState);
                                                      }
                                                    }
                                                  });

                                                  widget.catID == 1 ?
                                                  carbrandlistCont.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
                                                    Get.bottomSheet(
                                                        StatefulBuilder(builder: (context, setState) {
                                                          return BackdropFilter(
                                                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                                              child: filterBottom(setState, constraints));
                                                        },)
                                                    ).then((value) {
                                                      setState(() {
                                                        isNavigate = false;
                                                      });
                                                    },);
                                                  },)
                                                      : widget.subcatId == 28 ? subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
                                                    Get.bottomSheet(
                                                        StatefulBuilder(builder: (context, setState) {
                                                          return BackdropFilter(
                                                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                                              child: filterBottom(setState, constraints));
                                                        },)
                                                    ).then((value) {
                                                      setState(() {
                                                        isNavigate = false;
                                                      });
                                                    },);
                                                  },) :
                                                  (widget.catID == 5 || widget.subcatId == 39) ?
                                                  bikeScoCvehicleCon.getvehicle(subcatId: widget.subcatId.toString()).then((value) {
                                                    Get.bottomSheet(
                                                        StatefulBuilder(builder: (context, setState) {
                                                          return BackdropFilter(
                                                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                                              child: filterBottom(setState, constraints));
                                                        },)
                                                    ).then((value) {
                                                      setState(() {
                                                        isNavigate = false;
                                                      });
                                                    },);
                                                  },)
                                                      : subcatCont.subcatType(subcatID: widget.subcatId.toString()).then((value) {
                                                    Get.bottomSheet(
                                                        StatefulBuilder(builder: (context, setState) {
                                                          return BackdropFilter(
                                                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                                              child: filterBottom(setState, constraints));
                                                        },)
                                                    ).then((value) {
                                                      setState(() {
                                                        isNavigate = false;
                                                      });
                                                    },);
                                                  },);
                                                },
                                                child: Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: notifier.borderColor, width: 2),
                                                      color: notifier.getWhiteblackColor,
                                                      shape: BoxShape.circle
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                                  child: Image.asset("assets/Filter.png", height: 16, color: notifier.iconColor,),
                                                ),
                                              ) : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          catwisePostCont.isloading ? ListView.separated(
                                            itemCount: 5,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: searchBorder),
                                                    color: notifier.getWhiteblackColor
                                                ),
                                                padding: const EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120, width: 100),
                                                    const SizedBox(width: 10,),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14),
                                                          const SizedBox(height: 10,),
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                                              const SizedBox(width: 10,),
                                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 70),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },)
                                              : (catwisePostCont.catwisepostData!.searchlist!.isNotEmpty) ? (
                                              filtersCont.filterUploded ? (
                                                  (filtersCont.filterData == null || filtersCont.filterData!.filter!.isEmpty || catwisePostCont.catwisepostData!.searchlist!.isEmpty) ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(height: 100,),
                                                      Center(
                                                          child: Image.asset("assets/emptyOrder.png", height: 200)),
                                                      const SizedBox(height: 100,),
                                                    ],
                                                  )
                                                      : ListView.builder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: filtersCont.filterData!.filter!.length,
                                                    itemBuilder: (context, index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(bottom: 14),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.to(FilterpostScreen(prodIndex: index), transition: Transition.noTransition);
                                                            postviewCont.getPostview(postId: filtersCont.filterData!.filter![index].postId ?? "");
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(12),
                                                                border: Border.all(color: notifier.borderColor),
                                                                color: notifier.getWhiteblackColor
                                                            ),
                                                            padding: const EdgeInsets.all(10),
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  child: SizedBox(
                                                                    height: 120,
                                                                    width: 100,
                                                                    child: FadeInImage.assetNetwork(
                                                                      fit: BoxFit.cover,
                                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                                        return Center(child: shimmer(baseColor: notifier.shimmerbase, context: context, width: 100, height: 120));
                                                                      },
                                                                      image: Config.imageUrl + filtersCont.filterData!.filter![index].postImage!,
                                                                      placeholder:  "assets/ezgif.com-crop.gif",
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 10,),
                                                                Flexible(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          filtersCont.filterData!.filter![index].isPaid == "0" ? const SizedBox() : Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.black.withOpacity(0.5),
                                                                                borderRadius: BorderRadius.circular(5)
                                                                            ),
                                                                            padding: const EdgeInsets.all(3),
                                                                            child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              if(getData.read("UserLogin") == null){
                                                                                Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                                                              } else {
                                                                                if(filtersCont.filterData!.filter![index].isFavourite == 0){
                                                                                  setState(() {
                                                                                    addfavCont.addFav(postId: filtersCont.filterData!.filter![index].postId!).then((value) {
                                                                                      getFilterData();
                                                                                    },);
                                                                                  });
                                                                                } else {
                                                                                  unFavBottomSheet(
                                                                                    context: context,
                                                                                    description: filtersCont.filterData!.filter![index].adDescription ?? "",
                                                                                    title: filtersCont.filterData!.filter![index].postTitle ?? "",
                                                                                    image: "${Config.imageUrl}${filtersCont.filterData!.filter![index].postImage}",
                                                                                    price: "$currency${addCommas(filtersCont.filterData!.filter![index].adPrice!)}",
                                                                                    removeFun: () {
                                                                                      setState(() {
                                                                                        addfavCont.addFav(postId: filtersCont.filterData!.filter![index].postId!).then((value) {
                                                                                          getFilterData();
                                                                                        },);
                                                                                      });
                                                                                      Get.back();
                                                                                    },
                                                                                  );
                                                                                }
                                                                              }
                                                                            },
                                                                            child: filtersCont.filterData!.filter![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                                                : Image.asset("assets/heart.png", height: 20, color: notifier.iconColor),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: filtersCont.filterData!.filter![index].isPaid == "0" ? 0 : 10,),
                                                                      Text(filtersCont.filterData!.filter![index].adPrice == "0" ? "$currency ${filtersCont.filterData!.filter![index].jobSalaryFrom} - ${filtersCont.filterData!.filter![index].jobSalaryTo} / ${filtersCont.filterData!.filter![index].jobSalaryPeriod}" : "$currency${addCommas(filtersCont.filterData!.filter![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: filtersCont.filterData!.filter![index].catId == "4" ? 16 : 18, fontFamily: FontFamily.gilroyBold),maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                      const SizedBox(height: 10,),
                                                                      Text("${filtersCont.filterData!.filter![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                      const SizedBox(height: 10,),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Row(
                                                                              children: [
                                                                                Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                                                                                Flexible(child: Text(getAddress(address: filtersCont.filterData!.filter![index].fullAddress!), style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 10,),
                                                                          Text("${filtersCont.filterData!.filter![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },)) : ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                scrollDirection: Axis.vertical,
                                                itemCount: catwisePostCont.catwisepostData!.searchlist!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 14),
                                                    child: InkWell(
                                                      onTap: () {
                                                        postviewCont.getPostview(postId: catwisePostCont.catwisepostData!.searchlist![index].postId ?? "");
                                                        Navigator.push(context, screenTransRight(routes: CatwisepostScreen(prodIndex: index), context: context));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            border: Border.all(color: notifier.borderColor),
                                                            color: notifier.getWhiteblackColor
                                                        ),
                                                        padding: const EdgeInsets.all(10),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: SizedBox(
                                                                height: 120,
                                                                width: 100,
                                                                child: FadeInImage.assetNetwork(
                                                                  fit: BoxFit.cover,
                                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                                    return Center(child: shimmer(baseColor: notifier.shimmerbase, context: context, width: 100, height: 120));
                                                                  },
                                                                  image: Config.imageUrl + catwisePostCont.catwisepostData!.searchlist![index].postImage!,
                                                                  placeholder:  "assets/ezgif.com-crop.gif",
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10,),
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      catwisePostCont.catwisepostData!.searchlist![index].isPaid == "0" ? const SizedBox() : Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.black.withOpacity(0.5),
                                                                            borderRadius: BorderRadius.circular(5)
                                                                        ),
                                                                        padding: const EdgeInsets.all(3),
                                                                        child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                                      ),
                                                                      GetBuilder<CatwisePostController>(
                                                                          builder: (catwisePostCont) {
                                                                            return InkWell(
                                                                              onTap: () {
                                                                                if(getData.read("UserLogin") == null){
                                                                                  Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                                                                } else {
                                                                                  if(catwisePostCont.catwisepostData!.searchlist![index].isFavourite == 0){
                                                                                    addfavCont.addFav(postId: catwisePostCont.catwisepostData!.searchlist![index].postId!).then((value) {
                                                                                      catwisePostCont.getCatwisePost(catId: catwisePostCont.catwisepostData!.searchlist![index].catId ?? "", subcatId: catwisePostCont.catwisepostData!.searchlist![index].subcatId ?? "");
                                                                                    },);
                                                                                  } else {
                                                                                    unFavBottomSheet(
                                                                                      context: context,
                                                                                      description: catwisePostCont.catwisepostData!.searchlist![index].adDescription ?? "",
                                                                                      title: catwisePostCont.catwisepostData!.searchlist![index].postTitle ?? "",
                                                                                      image: "${Config.imageUrl}${catwisePostCont.catwisepostData!.searchlist![index].postImage}",
                                                                                      price: "$currency${addCommas(catwisePostCont.catwisepostData!.searchlist![index].adPrice!)}",
                                                                                      removeFun: () {
                                                                                        setState(() {
                                                                                          addfavCont.addFav(postId: catwisePostCont.catwisepostData!.searchlist![index].postId!).then((value) {
                                                                                            catwisePostCont.getCatwisePost(catId: catwisePostCont.catwisepostData!.searchlist![index].catId ?? "", subcatId: catwisePostCont.catwisepostData!.searchlist![index].subcatId ?? "");
                                                                                          },);
                                                                                        });
                                                                                        Get.back();
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: catwisePostCont.catwisepostData!.searchlist![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                                                  : Image.asset("assets/heart.png", height: 20, color: notifier.iconColor),
                                                                            );
                                                                          }
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: catwisePostCont.catwisepostData!.searchlist![index].isPaid == "0" ? 0 : 10,),
                                                                  Text(catwisePostCont.catwisepostData!.searchlist![index].adPrice == "0" ? "$currency ${catwisePostCont.catwisepostData!.searchlist![index].jobSalaryFrom} - ${catwisePostCont.catwisepostData!.searchlist![index].jobSalaryTo} / ${catwisePostCont.catwisepostData!.searchlist![index].jobSalaryPeriod}" : "$currency${addCommas(catwisePostCont.catwisepostData!.searchlist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: catwisePostCont.catwisepostData!.searchlist![index].catId == "4" ? 16 : 18, fontFamily: FontFamily.gilroyBold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                  const SizedBox(height: 10,),
                                                                  Text("${catwisePostCont.catwisepostData!.searchlist![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                  const SizedBox(height: 10,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Row(
                                                                          children: [
                                                                            Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                                                                            Flexible(child: Text(" ${getAddress(address: catwisePostCont.catwisepostData!.searchlist![index].fullAddress!)}", style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 10,),
                                                                      Text("${catwisePostCont.catwisepostData!.searchlist![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },))
                                              : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 100,),
                                              Center(child: Image.asset("assets/emptyOrder.png", height: 200)),
                                              const SizedBox(height: 100,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: kIsWeb ? 10 : 0,),
                              kIsWeb ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                                child: footer(context),
                              ) : const SizedBox(),
                            ],
                          ),
                        )
                    );
                  }
                );
              }
          ),
        );
      }
    );
  }

  getFilterData(){
    if(widget.catID == 1){
      filtersCont.getCarFilter(fuel: selectedfuelData, ownerLength: selectedownerLength, transmission: transmissionData, budgetStart: budgetStart, budgetEnd: budgetEnd, sort: sort, brandId: brandId, yearEnd: yearminText.text, yearStart: yearmaxText.text, kmStart: kmStart, kmEnd: kmEnd).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else if(widget.catID == 2){
      filtersCont.getPropFilter(mealIncluded: meal, pgsubtype: propertyType, plotareaEnd: plotAreaEnd, plotareaStart: plotAreaStart, bachelor: bachelor, constStatus: constStatusData, propertyListedBy: propertyListedByData, furnishing: furnishingData, bedroom: bedroomData, bathroom: bathroomData, propertyType: propertyType, buildareaEnd: buildareaEnd, buildareaStart: buildareaStart, sort: sort, budgetStart: budgetStart, budgetEnd: budgetEnd, subcatId: widget.subcatId.toString()).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else if(widget.catID == 3){
      filtersCont.getmobileFilter(subcatId: widget.subcatId.toString(), sort: sort, budgetStart: budgetStart, budgetEnd: budgetEnd, brandId: brandId).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else if(widget.catID == 4){
      filtersCont.getjobFilter(subcatId: widget.subcatId.toString(), sort: sort, positionType: positionTypeData, salaryPeriod: salaryPeriodData).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else if(widget.catID == 5){
      filtersCont.getBikeFilter(sort: sort, budgetStart: budgetStart, budgetEnd: budgetEnd, brandId: brandId, subcatId: widget.subcatId.toString(), yearEnd: yearminText.text, yearStart: yearminText.text, kmStart: kmStart, kmEnd: kmEnd).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else if(widget.catID == 7){
      filtersCont.getCommerfilter(sort: sort, budgetStart: budgetStart, budgetEnd: budgetEnd, brandId: brandId, subcatId: widget.subcatId.toString(), yearEnd: yearminText.text, yearStart: yearminText.text, kmStart: kmStart, kmEnd: kmEnd).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else if(widget.catID == 12) {
      filtersCont.getserviceFilter(sort: sort, byType: byType, subcatId: widget.subcatId.toString()).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    } else {
      filtersCont.getCommonfilter(sort: sort, budgetEnd: budgetEnd, budgetStart: budgetStart, subcatId: widget.subcatId.toString(), catId: widget.catID).then((value) {
        setState(() {
          filtersCont.filterUploded = true;
        });
      },);
    }
  }

  Widget filterBottom(var setState, constraints){
    return GetBuilder<InboxController>(
        builder: (inbox) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  bottomNavigationBar: Container(
                    color: notifier.getBgColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                                    elevation: const WidgetStatePropertyAll(0),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(side: BorderSide(color: PurpleColor), borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      filterupdateCont.selectedFiltersList = [];
                                      checkData = [];
                                      fuelData = [];
                                      fuelDataList = [];
                                      ownerLengthData = [];
                                      filterupdateCont.selected = "";
                                      filterupdateCont.range = "";
                                      propertyTypeList = [];
                                      mobilebrandId = [];
                                      brandId = "";
                                      builtupArea = "";
                                      sorting = "";
                                      plotArea = "";
                                      budget = "";
                                      kmDriven = "";
                                      kmStart = "";
                                      kmEnd = "";
                                      year = "";
                                      mealIncluded = "";
                                      mobilebrand = "";
                                      budgetStart = "";
                                      budgetEnd = "";
                                      sort = "";
                                      fuel = "";
                                      selectedfuelData = "";
                                      ownerLength = "";
                                      selectedownerLength = "";
                                      transmission = "";
                                      transmissionData = "";
                                      positionType = "";
                                      positionTypeData = "";
                                      salaryPeriod = "";
                                      salaryPeriodData = "";
                                      byType = "";
                                      buildareaStart = "";
                                      buildareaEnd = "";
                                      propertyType = "";
                                      bedroom = "";
                                      bedroomData = "";
                                      bathroom = "";
                                      bathroomData = "";
                                      furnishing = "";
                                      furnishingData = "";
                                      constStatus = "";
                                      constStatusData = "";
                                      bachelor = "";
                                      propertyListedBy = "";
                                      propertyListedByData = "";
                                      plotAreaStart = "";
                                      plotAreaEnd = "";
                                      propertyTypeList = [];
                                      mobilebrandId = [];
                                      selectBachelor = "";
                                      commerBrand = [];
                                      carBrand = [];
                                      salaryPeriodList = [];
                                      salaryPeriodListData = [];
                                      positionList = [];
                                      positionListData = [];
                                      ownerLengthData = [];
                                      ownerLengthDataList = [];
                                    });
                                  },
                                  child: Text("Clear all".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w600, color: notifier.getTextColor, fontSize: 16),)),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(PurpleColor),
                                    elevation: const WidgetStatePropertyAll(0),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(side: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (constraints.maxWidth < 850 || !kIsWeb) {
                                      Get.back();
                                    }
                                    getFilterData();
                                  },
                                  child: Text("Apply".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontWeight: FontWeight.w600, color: WhiteColor, fontSize: 16),)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.only(top: kIsWeb ? 0 : 100),
                    child: Container(
                      decoration: BoxDecoration(
                          color: notifier.getBgColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)
                          )
                      ),
                      height: Get.height - 150,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5,),
                            kIsWeb ? const SizedBox() : Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: lightGreyColor
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12, left: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Filter & Sort".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 22, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),),
                                            SingleChildScrollView(
                                              child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return LayoutBuilder(
                                                          builder: (context, constraints) {
                                                            return BackdropFilter(
                                                              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 600 : 1150 < constraints.maxWidth ? 400 : 750 < constraints.maxWidth ? 150 : 20),
                                                                child: Dialog(
                                                                  backgroundColor: notifier.getBgColor,
                                                                  insetPadding: const EdgeInsets.all(10),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Image.asset("assets/alert.png", height: 100,),
                                                                        Text("Are you sure to get back!".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 18, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                                                        const SizedBox(height: 10,),
                                                                        Text("Your selected filters will be removed!".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                                                        const SizedBox(height: 20,),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                height: 40,
                                                                                child: ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                                                                                      elevation: const WidgetStatePropertyAll(0),
                                                                                      shape: WidgetStatePropertyAll(
                                                                                        RoundedRectangleBorder(side: BorderSide(color: PurpleColor), borderRadius: BorderRadius.circular(12)),
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Text("Back".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w600, color: notifier.getTextColor, fontSize: 16),)),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 10,),
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                height: 40,
                                                                                child: ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                      backgroundColor: WidgetStatePropertyAll(PurpleColor),
                                                                                      elevation: const WidgetStatePropertyAll(0),
                                                                                      shape: WidgetStatePropertyAll(
                                                                                        RoundedRectangleBorder(side: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(12)),
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        filterupdateCont.selectedFiltersList = [];
                                                                                        checkData = [];
                                                                                        fuelData = [];
                                                                                        fuelDataList = [];
                                                                                        ownerLengthData = [];
                                                                                        filterupdateCont.selected = "";
                                                                                        filterupdateCont.range = "";
                                                                                        propertyTypeList = [];
                                                                                        mobilebrandId = [];
                                                                                        brandId = "";
                                                                                        builtupArea = "";
                                                                                        sorting = "";
                                                                                        plotArea = "";
                                                                                        budget = "";
                                                                                        kmDriven = "";
                                                                                        kmStart = "";
                                                                                        kmEnd = "";
                                                                                        year = "";
                                                                                        mealIncluded = "";
                                                                                        mobilebrand = "";
                                                                                        budgetStart = "";
                                                                                        budgetEnd = "";
                                                                                        sort = "";
                                                                                        fuel = "";
                                                                                        selectedfuelData = "";
                                                                                        ownerLength = "";
                                                                                        selectedownerLength = "";
                                                                                        transmission = "";
                                                                                        transmissionData = "";
                                                                                        positionType = "";
                                                                                        positionTypeData = "";
                                                                                        salaryPeriod = "";
                                                                                        salaryPeriodData = "";
                                                                                        byType = "";
                                                                                        buildareaStart = "";
                                                                                        buildareaEnd = "";
                                                                                        propertyType = "";
                                                                                        bedroom = "";
                                                                                        bedroomData = "";
                                                                                        bathroom = "";
                                                                                        bathroomData = "";
                                                                                        furnishing = "";
                                                                                        furnishingData = "";
                                                                                        constStatus = "";
                                                                                        constStatusData = "";
                                                                                        bachelor = "";
                                                                                        propertyListedBy = "";
                                                                                        propertyListedByData = "";
                                                                                        plotAreaStart = "";
                                                                                        plotAreaEnd = "";
                                                                                        propertyTypeList = [];
                                                                                        mobilebrandId = [];
                                                                                        selectBachelor = "";
                                                                                        commerBrand = [];
                                                                                        positionListData = [];
                                                                                        positionList = [];
                                                                                        carBrand = [];
                                                                                        salaryPeriodList = [];
                                                                                        salaryPeriodListData = [];
                                                                                        ownerLengthData = [];
                                                                                        ownerLengthDataList = [];
                                                                                      });
                                                                                      Get.back();
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Text("Continue".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontWeight: FontWeight.w600, color: WhiteColor, fontSize: 16),)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        );
                                                      },);
                                                  },
                                                  child: Image.network("https://img.icons8.com/?size=100&id=95771&format=png&color=000000", height: 24, color: notifier.iconColor,)),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        filterupdateCont.selectedFiltersList.isEmpty ? const SizedBox() : Text("Selected Filters".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),),
                                        const SizedBox(height: 10,),
                                        filterupdateCont.selectedFiltersList.isEmpty ? const SizedBox() : Wrap(
                                            // runSpacing: 5,
                                            alignment: WrapAlignment.start,
                                            clipBehavior: Clip.none,
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            runAlignment: WrapAlignment.start,
                                            children: [
                                              for (int i = 0; i < filterupdateCont.selectedFiltersList.length; i++)
                                                Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Chip(
                                                    padding: EdgeInsets.zero,
                                                    label: Text("${filterupdateCont.selectedFiltersList[i]}", style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyBold, color: WhiteColor,),),
                                                    deleteIcon: Image.asset("assets/times.png", color: notifier.borderColor, height: 16,),
                                                    backgroundColor: Colors.deepPurpleAccent.shade200,
                                                    onDeleted:() {
                                                      setState(() {

                                                        if (widget.catID == 1) {
                                                          for (int c = 0; c < carbrandlistCont.carbrandData!.carbrandlist!.length; c++) {
                                                            if(carbrandlistCont.carbrandData!.carbrandlist![c].title == filterupdateCont.selectedFiltersList[i]){
                                                              carBrand.remove(carbrandlistCont.carbrandData!.carbrandlist![c].id!);
                                                              brandId = carBrand.join(",");
                                                            }
                                                          }
                                                        } else if (widget.catID == 5) {
                                                          for (int b = 0; b < bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length; b++) {
                                                            if(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![b].title == filterupdateCont.selectedFiltersList[i]){
                                                              checkData.remove(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![b].id!);
                                                              brandId = checkData.join(",");
                                                            }
                                                          }
                                                        } else if(widget.catID == 7){
                                                          for (int b = 0; b < bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length; b++) {
                                                            if(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![b].title == filterupdateCont.selectedFiltersList[i]){
                                                              checkData.remove(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![b].id!);
                                                              brandId = checkData.join(",");
                                                            }
                                                          }
                                                        } else if(widget.catID == 2 || widget.catID == 3 || widget.catID == 27 || widget.catID == 28 || widget.subcatId == 40 || (58 <= widget.subcatId && widget.subcatId < 65)){
                                                          for(int c = 0; c < subcatCont.subcatTypeData!.subtypelist!.length; c++){
                                                            if(subcatCont.subcatTypeData!.subtypelist![c].title == filterupdateCont.selectedFiltersList[i]){
                                                              if(widget.catID == 2){
                                                                propertyTypeList.remove(subcatCont.subcatTypeData!.subtypelist![c].id);
                                                                propertyType = propertyTypeList.join(",");
                                                              } else if (widget.catID == 3) {
                                                                mobilebrandId.remove(subcatCont.subcatTypeData!.subtypelist![c].id);
                                                                brandId = mobilebrandId.join(",");
                                                              } else {
                                                                commerBrand.remove(subcatCont.subcatTypeData!.subtypelist![c].id);
                                                                brandId = commerBrand.join(",");
                                                              }
                                                            }
                                                          }
                                                        }

                                                        if(bathroom == filterupdateCont.selectedFiltersList[i]){
                                                          bathroom = "";
                                                          bathroomData = "";
                                                        }
                                                        if(bedroom == filterupdateCont.selectedFiltersList[i]){
                                                          bedroom = "";
                                                          bedroomData = "";
                                                        }
                                                        if(furnishing == filterupdateCont.selectedFiltersList[i]){
                                                          furnishing = "";
                                                          furnishingData = "";
                                                        }
                                                        if(constStatus == filterupdateCont.selectedFiltersList[i]){
                                                          constStatus = "";
                                                          constStatusData = "";
                                                        }
                                                        if(filterupdateCont.selected == filterupdateCont.selectedFiltersList[i]){
                                                          filterupdateCont.selected = "";
                                                        }
                                                        if(kmDriven == filterupdateCont.selectedFiltersList[i]){
                                                          kmDriven = "";
                                                          kmStart = "";
                                                          kmEnd = "";
                                                          getRange(sRange: 0, eRange: 200000, setState1: setState);
                                                        }
                                                        if(builtupArea == filterupdateCont.selectedFiltersList[i]){
                                                          builtupArea = "";
                                                          buildareaStart = "";
                                                          buildareaEnd = "";
                                                          getRange(sRange: 0, eRange: 10000, setState1: setState);
                                                        }
                                                        if(fuelData.contains(filterupdateCont.selectedFiltersList[i])){

                                                          if(checkData.contains(filterupdateCont.selectedFiltersList[i])){
                                                            fuelData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            fuelDataList.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            checkData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            fuel = checkData.join(",");
                                                            selectedfuelData = fuelDataList.join(",");
                                                          } else {
                                                            fuelData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            fuelDataList.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            fuel = fuelData.join(",");
                                                            selectedfuelData = fuelDataList.join(",");
                                                          }

                                                        }
                                                        if(ownerLengthData.contains(filterupdateCont.selectedFiltersList[i])){

                                                          if(checkData.contains(filterupdateCont.selectedFiltersList[i])){
                                                            ownerLengthData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            ownerLengthDataList.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            checkData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            ownerLength = checkData.join(",");
                                                            selectedownerLength = ownerLengthDataList.join(",");
                                                          } else {
                                                            ownerLengthData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            ownerLengthDataList.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            ownerLength = ownerLengthData.join(",");
                                                            selectedownerLength = ownerLengthDataList.join(",");
                                                          }

                                                        }

                                                        if(positionList.contains(filterupdateCont.selectedFiltersList[i])){

                                                          if(checkData.contains(filterupdateCont.selectedFiltersList[i])){
                                                            positionList.remove(filterupdateCont.selectedFiltersList[i]);
                                                            positionListData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            checkData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            positionType = checkData.join(",");
                                                            positionTypeData = positionListData.join(",");
                                                          } else {
                                                            positionList.remove(filterupdateCont.selectedFiltersList[i]);
                                                            positionListData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            positionType = positionList.join(",");
                                                            positionTypeData = positionListData.join(",");
                                                          }

                                                        }

                                                        if(salaryPeriodList.contains(filterupdateCont.selectedFiltersList[i])){

                                                          if(checkData.contains(filterupdateCont.selectedFiltersList[i])){
                                                            salaryPeriodList.remove(filterupdateCont.selectedFiltersList[i]);
                                                            salaryPeriodListData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            checkData.remove(filterupdateCont.selectedFiltersList[i]);

                                                            salaryPeriod = checkData.join(",");
                                                            salaryPeriodData = salaryPeriodListData.join(",");
                                                          } else {
                                                            salaryPeriodList.remove(filterupdateCont.selectedFiltersList[i]);
                                                            salaryPeriodListData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            salaryPeriod = checkData.join(",");
                                                            salaryPeriodData = salaryPeriodListData.join(",");
                                                          }

                                                        }

                                                        if(transmission == filterupdateCont.selectedFiltersList[i]){
                                                          transmission = "";
                                                          transmissionData = "";
                                                        }


                                                        if(byType == filterupdateCont.selectedFiltersList[i]){
                                                          byType = "";
                                                        }

                                                        if(selectBachelor == filterupdateCont.selectedFiltersList[i]){
                                                          bachelor = "";
                                                          selectBachelor = "";
                                                        }

                                                        if(propertyListing.contains(filterupdateCont.selectedFiltersList[i])){

                                                          if(checkData.contains(filterupdateCont.selectedFiltersList[i])){
                                                            propertyListing.remove(filterupdateCont.selectedFiltersList[i]);
                                                            checkData.remove(filterupdateCont.selectedFiltersList[i]);
                                                            propertyListingData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            propertyListedBy = checkData.join(",");
                                                            propertyListedByData = propertyListingData.join(",");
                                                          } else {
                                                            propertyListing.remove(filterupdateCont.selectedFiltersList[i]);
                                                            propertyListingData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                            propertyListedBy = propertyListing.join(",");
                                                            propertyListedByData = propertyListingData.join(",");
                                                          }

                                                        }
                                                        if(year == filterupdateCont.selectedFiltersList[i]){
                                                          yearminText.text = "";
                                                          yearmaxText.text = "";
                                                          year = "";
                                                        }
                                                        if(sorting == filterupdateCont.selectedFiltersList[i]){
                                                          sort = "";
                                                          sorting = "";
                                                        }

                                                        if(plotArea == filterupdateCont.selectedFiltersList[i]){
                                                          plotArea = "";
                                                          plotAreaStart = "";
                                                          plotAreaEnd = "";
                                                          getRange(sRange: 0, eRange: 5000, setState1: setState);
                                                        }

                                                        if(mealIncluded == filterupdateCont.selectedFiltersList[i]){
                                                          meal = "";
                                                          mealIncluded = "";
                                                        }

                                                        if(budget == filterupdateCont.selectedFiltersList[i]){
                                                          budget = "";
                                                          budgetStart = "";
                                                          budgetEnd = "";
                                                          if(budget.isEmpty){
                                                            if(widget.subcatId == 8 || widget.subcatId == 27 || widget.subcatId == 49 || widget.subcatId == 50 || (widget.subcatId >= 54 &&  widget.subcatId <= 56)){
                                                              getRange(sRange: 0, eRange: 10000, setState1: setState);
                                                            } else if(widget.subcatId >= 46 && widget.subcatId <= 48){
                                                              getRange(sRange: 0, eRange: 15000, setState1: setState);
                                                            } else if(widget.subcatId == 28 || widget.subcatId == 31){
                                                              getRange(sRange: 0, eRange: 50000, setState1: setState);
                                                            } else if(widget.subcatId == 32){
                                                              getRange(sRange: 0, eRange: 75000, setState1: setState);
                                                            } else if(widget.subcatId == 40 || widget.subcatId == 51 || widget.subcatId == 30){
                                                              getRange(sRange: 0, eRange: 100000, setState1: setState);
                                                            } else if(widget.subcatId == 25 || widget.subcatId == 26){
                                                              getRange(sRange: 0, eRange: 200000, setState1: setState);
                                                            } else if(widget.subcatId == 2 || widget.subcatId == 4 || widget.subcatId == 53){
                                                              getRange(sRange: 0, eRange: 500000, setState1: setState);
                                                            } else if(widget.subcatId == 3 || widget.subcatId == 6 || widget.subcatId == 39 || widget.catID == 1){
                                                              getRange(sRange: 0, eRange: 1000000, setState1: setState);
                                                            } else if(widget.subcatId == 1 || widget.subcatId == 5){
                                                              getRange(sRange: 0, eRange: 50000000, setState1: setState);
                                                            } else {
                                                              getRange(sRange: 0, eRange: 25000, setState1: setState);
                                                            }
                                                          }
                                                        }

                                                        filterupdateCont.selectedFiltersList.remove(filterupdateCont.selectedFiltersList[i]);
                                                        filterupdateCont.selectedFiltersListData.remove(filterupdateCont.selectedFiltersListData[i]);
                                                      });
                                                    },
                                                  ),
                                                ),
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  widget.catID == 1 ? carFilter(setState)
                                      : widget.catID == 2 ? propertyFilter(setState)
                                      : widget.catID == 3 ? mobileFilter(setState)
                                      : widget.catID == 4 ? jobFilter(setState)
                                      : widget.catID == 5 ? bikeFilter(setState)
                                      : widget.catID == 7 ? commercialFilter(setState)
                                      : commonFilter(setState),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  Widget carFilter(var setState1){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: inbox.carFilterList.length,
            itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState1(() {
                  selectFilter = index;
                  checkData = [];
                  filterupdateCont.selected = "";
                  filterupdateCont.range = "";

                  if(selectFilter == 0 && brandId.isNotEmpty){
                    carBrand = brandId.split(",");
                  } else if(selectFilter == 1 && budget.isNotEmpty){
                    getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                    filterupdateCont.range = budget;
                  } else if(selectFilter == 1){
                    setState1(() {
                      getRange(sRange: 0, eRange: 1000000, setState1: setState1);
                    });
                  } else if(selectFilter == 2 && year.isNotEmpty){
                    filterupdateCont.selected = year;
                  } else if(selectFilter == 3 && ownerLength.isNotEmpty){
                    checkData = ownerLength.split(",");
                    ownerLengthData = ownerLength.split(",");
                  } else if(selectFilter == 4 && kmDriven.isNotEmpty){
                    getRange(sRange: double.parse(kmStart), eRange: double.parse(kmEnd), setState1: setState1);
                    filterupdateCont.range = kmDriven;
                  } else if(selectFilter == 4){
                    getRange(sRange: 0, eRange: 200000, setState1: setState1);
                  } else if(selectFilter == 5 && fuel.isNotEmpty){
                    fuelData = fuel.split(",");
                    checkData = fuel.split(",");
                  } else if(selectFilter == 6 && transmission.isNotEmpty){
                    filterupdateCont.selected = transmission;
                  } else if(selectFilter == 7 && sorting.isNotEmpty){
                    filterupdateCont.selected = sorting;
                  }

                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                  border: Border(bottom: BorderSide(
                    color: GreyColor,
                  )),
                ),
                  child: Text("${inbox.carFilterList[index]}".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
            );
            },),
        ),
        const SizedBox(width: 10,),
        Expanded(
          flex: 2,
          child: selectFilter == 0 ? GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 90,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5
            ),
            shrinkWrap: true,
            itemCount: carbrandlistCont.carbrandData!.carbrandlist!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState1(() {
                    if(carBrand.contains(carbrandlistCont.carbrandData!.carbrandlist![index].id!)){
                      carBrand.remove(carbrandlistCont.carbrandData!.carbrandlist![index].id!);
                      brandId = carBrand.join(",");
                    } else {
                      carBrand.add(carbrandlistCont.carbrandData!.carbrandlist![index].id!);
                      brandId = carBrand.join(",");
                    }
                    filterupdateCont.updateCheckbox(checkData: carbrandlistCont.carbrandData!.carbrandlist![index].title ?? "", filterData: checkData);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: filterupdateCont.selectedFiltersList.contains(carbrandlistCont.carbrandData!.carbrandlist![index].title) ? Colors.deepPurpleAccent.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInImage.assetNetwork(
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return shimmer(baseColor: notifier.shimmerbase2, height: 50, width: 50, context: context);
                        },
                        image: Config.imageUrl + carbrandlistCont.carbrandData!.carbrandlist![index].img!,
                        placeholder:  "assets/ezgif.com-crop.gif",
                      ),
                      const SizedBox(height: 5,),
                      Text(carbrandlistCont.carbrandData!.carbrandlist![index].title ?? "",
                        style: TextStyle(color: filterupdateCont.selectedFiltersList.contains(carbrandlistCont.carbrandData!.carbrandlist![index].title) ? PurpleColor : notifier.getTextColor,
                            fontFamily: FontFamily.gilroyBold, fontSize: 14),maxLines: 1,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              );
            },)
              : selectFilter == 1 ? sliderSelect(note: "Budget".tr, type: "", minValue: 0, maxValue: 1000000, currentValue: const RangeValues(0, 1000000),
            setState1: setState1,
            getDataIn: (value) {
              setState1(() {
                budgetStart = value.toString().split("-").first;
                budgetEnd = value.toString().split("-").last;
                budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
              });
            },)
              : selectFilter == 2 ? selectYear(note: "Year".tr, setState1: setState1, getDataIn: (value) {
            setState1(() {
              year = "${"Year".tr}: $yearMin - $yearNow";
            });
          })
              : selectFilter == 3 ? checkBoxSelect(dataList: inbox.ownersType, setState1: setState1, selctedListData: ownerLengthDataList, transData: inbox.ownersTypeData, getDataIn: (value) {
                 setState1(() {
                   ownerLength = value.toString().split("-").first;
                   selectedownerLength = value.toString().split("-").last;
                   ownerLengthData = ownerLength.split(",");
                   ownerLengthDataList = selectedownerLength.split(",");
                 });
              },)
              : selectFilter == 4 ? sliderSelect(setState1: setState1, type: "km", note: "KM Driven".tr, minValue: 0, maxValue: 200000, currentValue: const RangeValues(0, 200000), getDataIn: (value) {
            setState1(() {
              kmStart = value.toString().split("-").first;
              kmEnd = value.toString().split("-").last;
              kmDriven = "${"KM Driven".tr}: $kmStart - $kmEnd";
            });
          })
              : selectFilter == 5 ? checkBoxSelect(dataList: inbox.fuel, setState1: setState1, transData: inbox.fuelData, selctedListData: fuelDataList, getDataIn: (value) {
               setState1(() {
                 fuel = value.toString().split("-").first;
                 selectedfuelData = value.toString().split("-").last;
                 fuelData = fuel.split(",");
                 fuelDataList = selectedfuelData.split(",");
               });
              })
              : selectFilter == 6 ? optionSelect(dataList: inbox.transmissionData, selected: "", optionsList: inbox.transmission, setState1: setState1, getDataIn: (value) {
            setState1(() {
              transmission = value.toString().split("-").first;
              transmissionData = value.toString().split("-").last;
            });
          }, )
              : selectFilter == 7 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
            setState1(() {
              sort = value.toString().split("-").first;
              sorting = value.toString().split("-").last;
            });
          })
              : const SizedBox(),
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

  Widget propertyFilter(var setState1){
    return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<InboxController>(
                  builder: (inbox) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.subcatId == 1 ? inbox.saleHouseFilterList.length : widget.subcatId ==2 ? inbox.rentHouseFilterList.length : widget.subcatId == 3 ? inbox.plotFilterList.length : widget.subcatId == 4 ? inbox.rentOfficeFilterList.length : widget.subcatId == 5 ? inbox.saleOfficeFilterList.length : inbox.rentPgFilterList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState1(() {
                              selectFilter = index;
                              checkData = [];
                              filterupdateCont.selected = "";
                              filterupdateCont.range = "";
                              propertyType = "";
                              if (widget.subcatId <= 2) {
                                if(selectFilter == 0 && budget.isNotEmpty) {
                                  filterupdateCont.range = budget;
                                  getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                                } else if(selectFilter == 0){
                                  getRange(sRange: 0, eRange: widget.subcatId == 1 ? 50000000 : 500000, setState1: setState1);
                                } else if(selectFilter == 1 && propertyType.isNotEmpty) {
                                  propertyTypeList = propertyType.split(",");
                                } else if(selectFilter == 2 && bedroom.isNotEmpty) {
                                  filterupdateCont.selected = bedroom;
                                } else if(selectFilter == 3 && bathroom.isNotEmpty) {
                                  filterupdateCont.selected = bathroom;
                                } else if(selectFilter == 4 && furnishing.isNotEmpty) {
                                  filterupdateCont.selected = furnishing;
                                } else if(selectFilter == 5 && widget.subcatId == 1 && constStatus.isNotEmpty) {
                                  filterupdateCont.selected = constStatus;
                                } else if(selectFilter == 5 && widget.subcatId == 2 && propertyListedBy.isNotEmpty) {
                                  checkData = propertyListedBy.split(",");
                                  propertyListing = propertyListedBy.split(",");
                                } else if(selectFilter == 6 && widget.subcatId == 1 && propertyListedBy.isNotEmpty) {
                                  checkData = propertyListedBy.split(",");
                                  propertyListing = propertyListedBy.split(",");
                                } else if(selectFilter == 6 && widget.subcatId == 2 && builtupArea.isNotEmpty) {
                                  filterupdateCont.range = builtupArea;
                                  getRange(sRange: double.parse(buildareaEnd), eRange: double.parse(buildareaEnd), setState1: setState1);
                                } else if(selectFilter == 7 && widget.subcatId == 1 && builtupArea.isNotEmpty){
                                  filterupdateCont.range = builtupArea;
                                  getRange(sRange: double.parse(buildareaStart), eRange: double.parse(buildareaEnd), setState1: setState1);
                                } else if((selectFilter == 7 && widget.subcatId == 1) || (selectFilter == 6 && widget.subcatId == 2)){
                                  getRange(sRange: 0, eRange: 10000, setState1: setState1);
                                } else if(selectFilter == 7 && widget.subcatId == 2 && bachelor.isNotEmpty){
                                  filterupdateCont.selected = bachelor;
                                } else if(selectFilter == 8 &&  sorting.isNotEmpty) {
                                  filterupdateCont.selected =  sorting;
                                }

                              } else if(widget.subcatId == 3){
                                if(selectFilter == 0 && budget.isNotEmpty) {
                                  filterupdateCont.range = budget;
                                  getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                                } else if(selectFilter == 0){
                                  getRange(sRange: 0, eRange: 1000000, setState1: setState1);
                                } else if(selectFilter == 1 && propertyType.isNotEmpty) {
                                  propertyTypeList = propertyType.split(",");
                                } else if(selectFilter == 2 && propertyListedBy.isNotEmpty) {
                                  checkData = propertyListedBy.split(",");
                                  propertyListing = propertyListedBy.split(",");
                                } else if(selectFilter == 3 && plotArea.isNotEmpty){
                                  filterupdateCont.range = plotArea;
                                  getRange(sRange: double.parse(plotAreaStart), eRange: double.parse(plotAreaEnd), setState1: setState1);
                                } else if(selectFilter == 3){
                                  getRange(sRange: 0, eRange: 5000, setState1: setState1);
                                } else if(selectFilter == 4 && sorting.isNotEmpty) {
                                  filterupdateCont.selected = sorting;
                                }
                              } else if(widget.subcatId <= 5){
                                if(selectFilter == 0 && budget.isNotEmpty) {
                                  filterupdateCont.range = budget;
                                  getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                                } else if(selectFilter == 0){
                                  getRange(sRange: 0, eRange: widget.subcatId == 4 ? 500000 : 50000000, setState1: setState1);
                                } else if(selectFilter == 1 && furnishing.isNotEmpty) {
                                  filterupdateCont.selected = furnishing;
                                } else if(selectFilter == 2 && propertyListedBy.isNotEmpty) {
                                  checkData = propertyListedBy.split(",");
                                  propertyListing = propertyListedBy.split(",");
                                } else if(selectFilter == 3 && builtupArea.isNotEmpty){
                                  filterupdateCont.range = builtupArea;
                                  getRange(sRange: double.parse(buildareaStart), eRange: double.parse(buildareaEnd), setState1: setState1);
                                } else if(selectFilter == 3){
                                  getRange(sRange: 0, eRange: 10000, setState1: setState1);
                                } else if(selectFilter == 4 && widget.subcatId == 4 && sort.isNotEmpty) {
                                  filterupdateCont.selected = sort;
                                } else if(selectFilter == 4 && widget.subcatId == 5 && sort.isNotEmpty) {
                                  filterupdateCont.selected = constStatus;
                                } else if(selectFilter == 5 && widget.subcatId == 5 &&  sorting.isNotEmpty) {
                                  filterupdateCont.selected =  sorting;
                                }
                              } else {
                                if(selectFilter == 0 && budget.isNotEmpty){
                                  filterupdateCont.range = budget;
                                  getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                                } else if(selectFilter == 0){
                                  getRange(sRange: 0, eRange: 100000, setState1: setState1);
                                } else if(selectFilter == 1 && propertyType.isNotEmpty) {
                                  propertyTypeList = propertyType.split(",");
                                } else if(selectFilter == 2 && furnishing.isNotEmpty) {
                                  filterupdateCont.selected = furnishing;
                                } else if(selectFilter == 3 && mealIncluded.isNotEmpty) {
                                  filterupdateCont.selected = mealIncluded;
                                } else if(selectFilter == 4 && propertyListedBy.isNotEmpty){
                                  checkData = propertyListedBy.split(",");
                                  propertyListing = propertyListedBy.split(",");
                                } else if(selectFilter == 5 && sorting.isNotEmpty) {
                                  filterupdateCont.selected = sorting;
                                }
                              }
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                                border: Border(bottom: BorderSide(
                                  color: GreyColor,
                                )),
                              ),
                              child: Text("${widget.subcatId == 1 ? inbox.saleHouseFilterList[index] : widget.subcatId == 2 ? inbox.rentHouseFilterList[index] : widget.subcatId == 3 ? inbox.plotFilterList[index] : widget.subcatId == 4 ? inbox.rentOfficeFilterList[index] : widget.subcatId == 5 ? inbox.saleOfficeFilterList[index] : inbox.rentPgFilterList[index]}".tr,
                                style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
                        );
                      },),
                  );
                }
              ),
              const SizedBox(width: 10,),
              catPropertyFilter(setState1),
              const SizedBox(width: 10,),
            ],
          );
        }
    );
  }

  Widget catPropertyFilter(var setState1) {
    return widget.subcatId <= 2 ? Expanded(
      flex: 2,
      child: selectFilter == 0 ? sliderSelect(note: "Budget".tr, minValue: 0,  type: "", maxValue: widget.subcatId == 1 ? 50000000 : 500000, currentValue: RangeValues(0, widget.subcatId == 1 ? 50000000 : 500000),
        setState1: setState1,
        getDataIn: (value) {
          setState1(() {
            budgetStart = value.toString().split("-").first;
            budgetEnd = value.toString().split("-").last;
            budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
          });
        },)
          : selectFilter == 1 ? proType(setState1: setState1)
          : selectFilter == 2 ? optionSelect(dataList: inbox.bedroomsData, selected: bedroom, optionsList: inbox.bedrooms, setState1: setState1, getDataIn: (value) {
        setState1(() {
          bedroom = value.toString().split("-").first;
          bedroomData = value.toString().split("-").last;
        });
      })
          : selectFilter == 3 ? optionSelect(dataList: inbox.bathroomsData, optionsList: inbox.bathrooms, setState1: setState1, selected: bathroom,getDataIn: (value) {
        bathroom = value.toString().split("-").first;
        bathroomData = value.toString().split("-").last;
      })
          : selectFilter == 4 ? (optionSelect(dataList: inbox.furnitureData, selected: "", optionsList: inbox.furniture, setState1: setState1, getDataIn: (value) {
        setState1(() {
          furnishing = value.toString().split("-").first;
          furnishingData = value.toString().split("-").last;
        });
      }))
          : selectFilter == 5 ? (widget.subcatId == 1 ? optionSelect(dataList: inbox.constStatusData, selected: constStatus, optionsList: inbox.constStatus, setState1: setState1, getDataIn: (value) {
        setState1(() {
          constStatus = value.toString().split("-").first;
          constStatusData = value.toString().split("-").last;
        });
      }) : checkBoxSelect(dataList: inbox.listedBy, setState1: setState1, selctedListData: propertyListingData, transData: inbox.listedByData, getDataIn: (value) {
        setState1(() {
          propertyListedBy = value.toString().split("-").first;
          propertyListedByData = value.toString().split("-").last;
          propertyListing = propertyListedBy.split(",");
          propertyListingData = propertyListedByData.split(",");
        });
      }))
          : selectFilter == 6 ? (widget.subcatId == 2 ? sliderSelect(note: "Super Built-up area sqft".tr, type: "sqft", minValue: 0, maxValue: 10000, currentValue: const RangeValues(0, 10000), setState1: setState1,
        getDataIn: (value) {
          setState1(() {
            buildareaStart = value.toString().split("-").first;
            buildareaEnd = value.toString().split("-").last;
            builtupArea = "${"Super Built-up area sqft".tr}: $buildareaStart - $buildareaEnd";
          });
        },) : checkBoxSelect(dataList: inbox.listedBy, setState1: setState1, selctedListData: propertyListingData, transData: inbox.listedByData, getDataIn: (value) {
        setState1(() {
          propertyListedBy = value.toString().split("-").first;
          propertyListedByData = value.toString().split("-").last;
          propertyListing = propertyListedBy.split(",");
          propertyListingData = propertyListedByData.split(",");
        });
      }))
          : selectFilter == 7 ? (widget.subcatId == 1 ? sliderSelect(note: "Super Built-up area sqft".tr, type: "sqft", minValue: 0, maxValue: 10000, currentValue: const RangeValues(0, 10000), setState1: setState1,
        getDataIn: (value) {
          setState1(() {
            buildareaStart = value.toString().split("-").first;
            buildareaEnd = value.toString().split("-").last;
            builtupArea = "${"Super Built-up area sqft".tr}: $buildareaStart - $buildareaEnd";
          });
        },)
          : optionSelect(dataList: inbox.bechlorsFilterList, selected: "", optionsList: inbox.bechlorsFilterList, setState1: setState1, getDataIn: (value) {
        setState1(() {
          selectBachelor = value;
          bachelor = selectBachelor == "Bachelors allowed".tr ? "Yes" : "No";
        });
      }))
          : selectFilter == 8 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
        setState1(() {
          sort = value.toString().split("-").first;
          sorting = value.toString().split("-").last;
        });
      })
          : const SizedBox(),
    ) : widget.subcatId == 3 ? Expanded(
      flex: 2,
      child: selectFilter == 0 ? sliderSelect(note: "Budget".tr, minValue: 0, type: "", maxValue: 1000000, currentValue: const RangeValues(0, 50000000),
        setState1: setState1,
        getDataIn: (value) {
          setState1(() {
            budgetStart = value.toString().split("-").first;
            budgetEnd = value.toString().split("-").last;
            budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
          });
        },)
          : selectFilter == 1 ? proType(setState1: setState1)
          : selectFilter == 2 ? checkBoxSelect(dataList: inbox.listedBy, setState1: setState1, selctedListData: propertyListingData, transData: inbox.listedByData, getDataIn: (value) {
        setState1(() {
          propertyListedBy = value.toString().split("-").first;
          propertyListedByData = value.toString().split("-").last;
          propertyListing = propertyListedBy.split(",");
          propertyListingData = propertyListedByData.split(",");
        });
      })
          : selectFilter == 3 ? sliderSelect(note: "Plot Area".tr, minValue: 0, type: "area", maxValue: 5000, currentValue: const RangeValues(0, 5000), setState1: setState1, getDataIn: (value) {
        setState1(() {
          plotAreaStart = value.toString().split("-").first;
          plotAreaEnd = value.toString().split("-").last;
          plotArea = "${"Plot Area".tr}: $plotAreaStart - $plotAreaEnd";
        });
      },)
          : selectFilter == 4 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
        setState1(() {
          sort = value.toString().split("-").first;
          sorting = value.toString().split("-").last;
        });
      })
          : const SizedBox(),
    ) : widget.subcatId <= 5 ? Expanded(
      flex: 2,
      child: selectFilter == 0 ? sliderSelect(note: "Budget".tr, minValue: 0, type: "", maxValue: widget.subcatId == 4 ? 500000 : 50000000, currentValue: const RangeValues(0, 50000000),
        setState1: setState1,
        getDataIn: (value) {
          setState1(() {
            budgetStart = value.toString().split("-").first;
            budgetEnd = value.toString().split("-").last;
            budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
          });
        },)
          : selectFilter == 1 ? optionSelect(dataList: inbox.furnitureData, selected: "", optionsList: inbox.furniture, setState1: setState1, getDataIn: (value) {
        setState1(() {
          furnishing = value.toString().split("-").first;
          furnishingData = value.toString().split("-").last;
        });
      })
          : selectFilter == 2 ? checkBoxSelect(dataList: inbox.listedBy, setState1: setState1, selctedListData: propertyListingData, transData: inbox.listedByData, getDataIn: (value) {
        setState1(() {
          propertyListedBy = value.toString().split("-").first;
          propertyListedByData = value.toString().split("-").last;
          propertyListing = propertyListedBy.split(",");
          propertyListingData = propertyListedByData.split(",");
        });
      })
          : selectFilter == 3 ? sliderSelect(note: "Super Built-up area sqft".tr, type: "sqft", minValue: 0, maxValue: 10000, currentValue: const RangeValues(0, 10000), setState1: setState1, getDataIn: (value) {
        setState1(() {
          buildareaStart = value.toString().split("-").first;
          buildareaEnd = value.toString().split("-").last;
          builtupArea = "${"Super Built-up area sqft".tr}: $plotAreaStart - $plotAreaEnd";
        });
      },)
          : selectFilter == 4 ? (widget.subcatId == 5 ? optionSelect(dataList: inbox.constStatusData, selected: "", optionsList: inbox.constStatus, setState1: setState1, getDataIn: (value) {
        setState1(() {
          constStatus = value.toString().split("-").first;
          constStatusData = value.toString().split("-").last;
        });
      }) : getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
        setState1(() {
          sort = value.toString().split("-").first;
          sorting = value.toString().split("-").last;
        });
      }))
          : selectFilter == 5 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
        setState1(() {
          sort = value.toString().split("-").first;
          sorting = value.toString().split("-").last;
        });
      })
          : const SizedBox(),
    ) : Expanded(
      flex: 2,
      child: selectFilter == 0 ? sliderSelect(note: "Budget".tr, type: "", minValue: 0, maxValue: 1000000, currentValue: const RangeValues(0, 1000000),
        setState1: setState1,
        getDataIn: (value) {
          setState1(() {
            budgetStart = value.toString().split("-").first;
            budgetEnd = value.toString().split("-").last;
            budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
          });
        },)
          : selectFilter == 1 ? proType(setState1: setState1)
          : selectFilter == 2 ? optionSelect(dataList: inbox.furnitureData, selected: "", optionsList: inbox.furniture, setState1: setState1, getDataIn: (value) {
        setState1(() {
          furnishing = value.toString().split("-").first;
          furnishingData = value.toString().split("-").last;
        });
      })
          : selectFilter == 3 ? optionSelect(dataList: inbox.meal, selected: "", optionsList: inbox.meal, setState1: setState1, getDataIn: (value) {
        setState1(() {
          mealIncluded = value;
          if(mealIncluded == "Meals included".tr) {
            meal = "yes";
          } else {
            meal = "no";
          }
        });
      })
          : selectFilter == 4 ? checkBoxSelect(dataList: inbox.listedBy, setState1: setState1, selctedListData: propertyListingData, transData: inbox.listedByData, getDataIn: (value) {
        setState1(() {
          propertyListedBy = value.toString().split("-").first;
          propertyListedByData = value.toString().split("-").last;
          propertyListing = propertyListedBy.split(",");
          propertyListingData = propertyListedByData.split(",");
        });
      })
          : selectFilter == 5 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
        setState1(() {
          sort = value.toString().split("-").first;
          sorting = value.toString().split("-").last;
        });
      })
          : const SizedBox(),
    );
  }

  Widget proType({var setState1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
        const SizedBox(height: 10,),
        StatefulBuilder(
            builder: (context, setState) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: subcatCont.subcatTypeData!.subtypelist!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      setState1(() {
                        if(propertyTypeList.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                          propertyTypeList.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                          propertyType = propertyTypeList.join(",");
                        } else {
                          propertyTypeList.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                          propertyType = propertyTypeList.join(",");
                        }
                        filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: checkData);
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          activeColor: PurpleColor,
                          side: BorderSide(color: notifier.iconColor),
                          value: filterupdateCont.selectedFiltersList.contains(subcatCont.subcatTypeData!.subtypelist![index].title!),
                          onChanged: (value) {
                            setState1(() {
                              if(propertyTypeList.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                                propertyTypeList.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                propertyType = propertyTypeList.join(",");
                              } else {
                                propertyTypeList.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                propertyType = propertyTypeList.join(",");
                              }
                              filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: checkData);
                            });
                          },),
                        Flexible(
                          child: Text(subcatCont.subcatTypeData!.subtypelist![index].title!,
                            style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  );
                },);
            }
        )
      ],
    );
  }

  Widget mobileFilter(var setState1) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.subcatId == 7 ? inbox.mobileFilterList.length : widget.subcatId == 8 ? inbox.accesFilterList.length : inbox.tabletFilterList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState1(() {
                    selectFilter = index;
                    filterupdateCont.range = "";

                    if(widget.subcatId == 7 || widget.subcatId == 8){
                      if(selectFilter == 0 && budget.isNotEmpty){
                        filterupdateCont.range = budget;
                        getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                      } else if(selectFilter == 0){
                        getRange(sRange: 0, eRange: widget.subcatId == 8 ? 10000 : 25000, setState1: setState1);
                      } else if(selectFilter == 1 && brandId.isNotEmpty){
                        mobilebrandId = brandId.split(",");
                      } else if(selectFilter == 2 && sorting.isNotEmpty){
                        filterupdateCont.selected = sorting;
                      }
                    } else {
                      if(selectFilter == 0 && brandId.isNotEmpty){
                        mobilebrandId = brandId.split(",");
                      } else if(selectFilter == 1 && budget.isNotEmpty){
                        filterupdateCont.range = budget;
                      } else if(selectFilter == 1){
                        getRange(sRange: 0, eRange: 25000, setState1: setState1);
                      } else if(selectFilter == 2 && sorting.isNotEmpty){
                        filterupdateCont.selected = sorting;
                      }
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                      border: Border(bottom: BorderSide(
                        color: GreyColor,
                      )),
                    ),
                    child: Text("${widget.subcatId == 7 ? inbox.mobileFilterList[index] : widget.subcatId == 8 ? inbox.accesFilterList[index] : inbox.tabletFilterList[index]}".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
              );
            },),
        ),
        const SizedBox(width: 10,),
        Expanded(
          flex: 2,
          child: widget.subcatId == 9 ? (
          selectFilter == 0 ? mobileBrand(setState1: setState1,)
          : selectFilter == 1 ? sliderSelect(note: "Budget".tr, minValue: 0, type: "", maxValue: 25000, currentValue: const RangeValues(0, 25000), setState1: setState1, getDataIn: (value) {
            setState1(() {
              budgetStart = value.toString().split("-").first;
              budgetEnd = value.toString().split("-").last;
              budget = "${"Budget".tr}:  $budgetStart - $budgetEnd";
            });
          },)
              : getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
            setState1(() {
              sort = value.toString().split("-").first;
              sorting = value.toString().split("-").last;
            });
          })
          )
              : (selectFilter == 0 ? sliderSelect(note: "Budget".tr, type: "", minValue: 0, maxValue: widget.subcatId == 8 ? 10000 : 25000, currentValue: RangeValues(0, widget.subcatId == 8 ? 10000 : 25000), setState1: setState1, getDataIn: (value) {
               setState1(() {
                 budgetStart = value.toString().split("-").first;
                 budgetEnd = value.toString().split("-").last;
                 budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
               });
          },)
              : selectFilter == 1 ? mobileBrand(setState1: setState1)
              : selectFilter == 2 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
            setState1(() {
              sort = value.toString().split("-").first;
              sorting = value.toString().split("-").last;
            });
          })
              : const SizedBox()),
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

  Widget mobileBrand({var setState1}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
        const SizedBox(height: 10,),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: subcatCont.subcatTypeData!.subtypelist!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                setState1(() {
                  if(mobilebrandId.contains(subcatCont.subcatTypeData!.subtypelist![index].id)){
                    mobilebrandId.remove(subcatCont.subcatTypeData!.subtypelist![index].id);
                    brandId = mobilebrandId.join(",");
                  } else {
                    mobilebrandId.add(subcatCont.subcatTypeData!.subtypelist![index].id);
                    brandId = mobilebrandId.join(",");
                  }
                  filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: checkData,);
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    activeColor: PurpleColor,
                    side: BorderSide(color: notifier.iconColor),
                    value: filterupdateCont.selectedFiltersList.contains(subcatCont.subcatTypeData!.subtypelist![index].title!),
                    onChanged: (value) {
                      setState1(() {
                        if(mobilebrandId.contains(subcatCont.subcatTypeData!.subtypelist![index].id)){
                          mobilebrandId.remove(subcatCont.subcatTypeData!.subtypelist![index].id);
                          brandId = mobilebrandId.join(",");
                        } else {
                          mobilebrandId.add(subcatCont.subcatTypeData!.subtypelist![index].id);
                          brandId = mobilebrandId.join(",");
                        }
                        filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: checkData);
                      });
                    },),
                  Flexible(
                    child: Text(subcatCont.subcatTypeData!.subtypelist![index].title!,
                      style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            );
          },)
      ],
    );
  }

  Widget jobFilter(var setState1) {
    return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: inbox.jobFilterList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState1(() {
                          selectFilter = index;
                          checkData = [];
                          filterupdateCont.selected = "";

                          if(selectFilter == 0 && positionType.isNotEmpty){
                            checkData = positionType.split(",");
                            positionList = positionType.split(",");
                          } else if(selectFilter == 1 && salaryPeriod.isNotEmpty){
                            checkData = salaryPeriod.split(",");
                            salaryPeriodList = salaryPeriod.split(",");
                          } else if(selectFilter == 2 && sort.isNotEmpty) {
                            filterupdateCont.selected = sort;
                          }
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                            border: Border(bottom: BorderSide(
                              color: GreyColor,
                            )),
                          ),
                          child: Text("${inbox.jobFilterList[index]}".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
                    );
                  },),
              ),
              const SizedBox(width: 10,),
              Expanded(
                flex: 2,
                child: selectFilter == 0 ? checkBoxSelect(dataList: inbox.positionType, setState1: setState1, selctedListData: positionListData, transData: inbox.positionTypeData, getDataIn: (value) {
                  setState1((){
                    positionType = value.toString().split("-").first;
                    positionTypeData = value.toString().split("-").last;
                    positionList = positionType.split(",");
                    positionListData = positionTypeData.split(",");
                  });
                })
                    : selectFilter == 1 ? checkBoxSelect(dataList: inbox.salaryPeriod, setState1: setState1, selctedListData: salaryPeriodListData, transData: inbox.salaryPeriodData, getDataIn: (value) {
                  setState1((){
                    salaryPeriod = value.toString().split("-").first;
                    salaryPeriodData = value.toString().split("-").last;
                    salaryPeriodList = salaryPeriod.split(",");
                    salaryPeriodListData = salaryPeriodData.split(",");
                  });
                })
                    : selectFilter == 2 ? getSorting(selcted: "", optionsList: inbox.jobSort, setState1: setState1, getDataIn: (value) {
                  setState1(() {
                    sort = value.toString().split("-").first;
                    sorting = value.toString().split("-").last;
                  });
                })
                    : const SizedBox()),
              const SizedBox(width: 10,),
            ],
          );
        }
    );
  }
  
  Widget bikeFilter(var setState1) {
    return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.subcatId == 28 ? inbox.bicycleFilterList.length : widget.subcatId == 27 ? inbox.commonFilterList.length :inbox.bikeFilterList.length,
                  itemBuilder: (context, index) {
                    return (widget.subcatId == 28 && index == 2 && index == 3) ? const SizedBox() : InkWell(
                      onTap: () {
                        setState1(() {
                          selectFilter = index;
                          checkData = [];
                          filterupdateCont.selected = "";
                          filterupdateCont.range = "";
                          if(widget.subcatId <= 26 || widget.subcatId == 28){
                            if(selectFilter == 0 && budget.isNotEmpty){
                              filterupdateCont.range = budget;
                                getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                            } else if(selectFilter == 0){
                              getRange(sRange: 0, eRange: widget.subcatId == 27 ? 10000 : 50000, setState1: setState1);
                            } else if(selectFilter == 1 && brandId.isNotEmpty){
                              checkData = brandId.split(",");
                            } else if(selectFilter == 2 && kmDriven.isNotEmpty){
                              filterupdateCont.range = kmDriven;
                            } else if(selectFilter == 2){
                              getRange(sRange: 0, eRange: 200000, setState1: setState1);
                            } else if(selectFilter == 3 && year.isNotEmpty){
                              filterupdateCont.selected = year;
                            } else {
                              filterupdateCont.selected = sort;
                            }
                          } else {
                            if(selectFilter == 0 && budget.isNotEmpty){
                              filterupdateCont.range = budget;
                              getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                            } else if(selectFilter == 0){
                              getRange(sRange: 0, eRange: 10000, setState1: setState1);
                            } else {
                              filterupdateCont.selected = sort;
                            }
                          }
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                            border: Border(bottom: BorderSide(
                              color: GreyColor,
                            )),
                          ),
                          child: Text("${widget.subcatId == 28 ? inbox.bicycleFilterList[index] : widget.subcatId == 27 ? inbox.commonFilterList[index] : inbox.bikeFilterList[index]}".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
                    );
                  },),
              ),
              const SizedBox(width: 10,),
              Expanded(
                  flex: 2,
                  child: (widget.subcatId == 27 || widget.subcatId == 28)
                      ? (
                      selectFilter == 0 ? sliderSelect(note: "Budget".tr, type: "", setState1: setState1, minValue: 0, maxValue: widget.subcatId == 28 ? 50000 : 10000, currentValue: RangeValues(0, widget.subcatId == 28 ? 50000 : 10000), getDataIn: (value) {
                        setState1(() {
                          budgetStart = value.toString().split("-").first;
                          budgetEnd = value.toString().split("-").last;
                          budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
                        });
                      },)
                      : selectFilter == 1 ? (widget.subcatId == 28 ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
                          const SizedBox(height: 10,),
                          StatefulBuilder(
                              builder: (context, setState) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: subcatCont.subcatTypeData!.subtypelist!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: (){
                                        setState1(() {
                                          if(checkData.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                                            checkData.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                          } else {
                                            checkData.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                          }
                                          filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title ?? "", filterData: checkData).then((value) {
                                            brandId = value;
                                          },);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            activeColor: PurpleColor,
                                            value: filterupdateCont.selectedFiltersList.contains(subcatCont.subcatTypeData!.subtypelist![index].title!),
                                            onChanged: (value) {
                                              setState1(() {
                                                if(checkData.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                                                  checkData.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                                } else {
                                                  checkData.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                                }
                                                filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title ?? "", filterData: checkData).then((value) {
                                                  brandId = value;
                                                },);
                                              });
                                            },),
                                          Flexible(
                                            child: Text(subcatCont.subcatTypeData!.subtypelist![index].title!,
                                              style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },);
                              }
                          )
                        ],
                      ) : optionSelect(dataList: inbox.bysort, selected: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                        setState1(() {
                          sort = value;
                        });
                      }))
                      : selectFilter == 2 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                        setState1(() {
                          sort = value.toString().split("-").first;
                          sorting = value.toString().split("-").last;
                        });
                      })
                      : const SizedBox())
                      : (selectFilter == 1 ? GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      mainAxisExtent: 100,
                    ),
                    shrinkWrap: true,
                    itemCount: bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState1(() {
                            if(checkData.contains(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].id!)){
                              checkData.remove(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].id!);
                            } else {
                              checkData.add(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].id!);
                            }
                            filterupdateCont.updateCheckbox(checkData: bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].title ?? "", filterData: checkData).then((value) {
                              brandId = value;
                            },);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: filterupdateCont.selectedFiltersList.contains(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].title) ? Colors.deepPurpleAccent.withOpacity(0.1) : Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FadeInImage.assetNetwork(
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return shimmer(baseColor: notifier.shimmerbase2, height: 50, width: 50, context: context);
                                },
                                image: Config.imageUrl + bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].img!,
                                placeholder:  "assets/ezgif.com-crop.gif",
                              ),
                              const SizedBox(height: 5,),
                              Text(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].title ?? "",
                                style: TextStyle(color: filterupdateCont.selectedFiltersList.contains(bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].title) ? PurpleColor : notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 14),maxLines: 2,textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      );
                    },)
                      : selectFilter == 0 ? sliderSelect(setState1: setState1, note: "Budget".tr, type: "", minValue: 0, maxValue: 200000, currentValue: const RangeValues(0, 200000), getDataIn: (value) {
                       setState1(() {
                         budgetStart = value.toString().split("-").first;
                         budgetEnd = value.toString().split("-").last;
                         budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
                       });
                  },)
                      : selectFilter == 2 ? sliderSelect(setState1: setState1, type: "km", note: "KM Driven".tr, minValue: 0, maxValue: 200000, currentValue: const RangeValues(0, 200000), getDataIn: (value) {
                    setState1(() {
                      kmStart = value.toString().split("-").first;
                      kmEnd = value.toString().split("-").last;
                      kmDriven = "${"KM Driven".tr}: $kmStart - $kmEnd";
                    });
                  })
                      : selectFilter == 3 ? selectYear(note: "Year".tr, setState1: setState1, getDataIn: (value) {
                    setState1(() {
                      year = "${"Year".tr}: $yearMin - $yearNow";
                    });
                  })
                      : selectFilter == 4 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                    setState1(() {
                      sort = value.toString().split("-").first;
                      sorting = value.toString().split("-").last;
                    });
                  })
                      : const SizedBox()),),
              const SizedBox(width: 10,),
            ],
          );
        }
    );
  }

  Widget commercialFilter(var setState1) {
    return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.subcatId == 40 ? inbox.tabletFilterList.length : inbox.commerFilterList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState1(() {
                          selectFilter = index;

                          checkData = [];
                          commerBrand = [];
                          filterupdateCont.selected = "";
                          filterupdateCont.range = "";
                          if(widget.subcatId == 39){
                            if(selectFilter == 0 && budget.isNotEmpty){
                              filterupdateCont.range = budget;
                              getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                            } else if(selectFilter == 0){
                              getRange(sRange: 0, eRange: 1000000, setState1: setState1);
                            } else if(selectFilter == 1 && year.isNotEmpty){
                              filterupdateCont.selected = year;
                            } else if(selectFilter == 2 && kmDriven.isNotEmpty){
                              filterupdateCont.range = kmDriven;
                            } else if(selectFilter == 2){
                              getRange(sRange: 0, eRange: 200000, setState1: setState1);
                            } else if(selectFilter == 3 && sort.isNotEmpty){
                              filterupdateCont.selected = sort;
                            }
                          } else {
                            if(selectFilter == 0 && brandId.isNotEmpty){
                              commerBrand = brandId.split(",");
                            } else if(selectFilter == 1 && budget.isNotEmpty){
                              filterupdateCont.range = budget;
                              getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                            } else if(selectFilter == 1){
                              getRange(sRange: 0, eRange: 100000, setState1: setState1);
                            } else if(selectFilter == 3 && sort.isNotEmpty){
                              filterupdateCont.selected = sort;
                            }
                          }
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                            border: Border(bottom: BorderSide(
                              color: GreyColor,
                            )),
                          ),
                          child: Text("${widget.subcatId == 40 ? inbox.tabletFilterList[index] : inbox.commerFilterList[index]}".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
                    );
                  },),
              ),
              const SizedBox(width: 10,),
              Expanded(
                  flex: 2,
                   child: widget.subcatId == 40 ? (
                       selectFilter == 0 ? Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
                           const SizedBox(height: 10,),
                           StatefulBuilder(
                               builder: (context, setState) {
                                 return ListView.builder(
                                   scrollDirection: Axis.vertical,
                                   shrinkWrap: true,
                                   itemCount: subcatCont.subcatTypeData!.subtypelist!.length,
                                   itemBuilder: (context, index) {
                                     return InkWell(
                                       onTap: (){
                                         setState1(() {
                                           if(commerBrand.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                                             commerBrand.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                           } else {
                                             commerBrand.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                           }
                                           filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: commerBrand).then((value) {
                                             brandId = value;
                                           },);
                                         });
                                       },
                                       child: Row(
                                         children: [
                                           Checkbox(
                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                             activeColor: PurpleColor,
                                             side: BorderSide(color: notifier.iconColor),
                                             value: filterupdateCont.selectedFiltersList.contains(subcatCont.subcatTypeData!.subtypelist![index].title!),
                                             onChanged: (value) {
                                               setState1(() {
                                                 filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: []);
                                               });
                                             },),
                                           Flexible(
                                             child: Text(subcatCont.subcatTypeData!.subtypelist![index].title!,
                                               style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),
                                               maxLines: 1,
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                           )
                                         ],
                                       ),
                                     );
                                   },);
                               }
                           )
                         ],
                       )
                       : selectFilter == 1 ? sliderSelect(note: "Budget".tr, type: "", minValue: 0, maxValue: 100000, currentValue: const RangeValues(0, 1000000), getDataIn: (value) {
                         setState1(() {
                           budgetStart = value.toString().split("-").first;
                           budgetEnd = value.toString().split("-").last;
                           budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
                         });
                       },)
                       : selectFilter == 2 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                         setState1(() {
                           sort = value.toString().split("-").first;
                           sorting = value.toString().split("-").last;
                         });
                       })
                       : const SizedBox())
                      : (selectFilter == 0 ? sliderSelect(note: "Budget".tr, type: "", setState1: setState1, minValue: 0, maxValue: 1000000, currentValue: const RangeValues(0, 1000000), getDataIn: (value) {
                     setState1(() {
                       budgetStart = value.toString().split("-").first;
                       budgetEnd = value.toString().split("-").last;
                       budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
                     });
                   },)
                      : selectFilter == 1 ? selectYear(note: "Year".tr, setState1: setState1, getDataIn: (value) {
                     setState1(() {
                       year = "${"Year".tr}: $yearMin - $yearNow";
                     });
                   })
                      : selectFilter == 2 ? sliderSelect(setState1: setState1, type: "km", note: "KM Driven".tr, minValue: 0, maxValue: 200000, currentValue: const RangeValues(0, 200000), getDataIn: (value) {
                     setState1(() {
                       kmStart = value.toString().split("-").first;
                       kmEnd = value.toString().split("-").last;
                       kmDriven = "${"KM Driven".tr}: $kmStart - $kmEnd";
                     });
                   })
                      : selectFilter == 3 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                     setState1(() {
                       sort = value.toString().split("-").first;
                       sorting = value.toString().split("-").last;
                     });
                   })
                      : const SizedBox())),
              const SizedBox(width: 10,),
            ],
          );
        }
    );
  }

  Widget commonFilter(var setState1) {
    return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: 65 <= widget.subcatId ? Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                 color:notifier.getWhiteblackColor,
                 border: Border(bottom: BorderSide(
                 color: GreyColor,
                 )),
                 ),
                 child: Text("Change Sort".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),))
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 58 <= widget.subcatId ? inbox.serviceFilterList.length : inbox.commonFilterList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState1(() {
                          selectFilter = index;
                          checkData = [];
                          filterupdateCont.range = "";
                          filterupdateCont.selected = "";
                          if(58 <= widget.subcatId){
                            if (selectFilter == 0 && byType.isNotEmpty) {
                              checkData = byType.split(",");
                            } else {
                              filterupdateCont.selected = sorting;
                            }
                          } else {
                              if (selectFilter == 0 && budget.isNotEmpty) {
                                filterupdateCont.range = budget;
                                getRange(sRange: double.parse(budgetStart), eRange: double.parse(budgetEnd), setState1: setState1);
                              } else if(selectFilter == 0){
                                getRange(sRange: 0, eRange: widget.subcatId == 53 ? 500000 : (widget.subcatId == 30 || widget.subcatId == 51) ? 100000 : widget.subcatId == 32 ? 75000 : widget.subcatId == 31 ? 50000 : (widget.subcatId >= 46 && widget.subcatId <= 48) ? 15000 : (widget.subcatId == 50 || widget.subcatId == 49 || (widget.subcatId >= 54 &&  widget.subcatId <= 56)) ? 10000 : 25000, setState1: setState1);
                              } else {
                                filterupdateCont.selected = sorting;
                              }
                            }
                          });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectFilter == index ? (notifier.isDark ? Colors.grey : notifier.getWhiteblackColor) : notifier.isDark ? notifier.getWhiteblackColor : searchBorder,
                            border: Border(bottom: BorderSide(
                              color: GreyColor,
                            )),
                          ),
                          child: Text("${58 <= widget.subcatId ? inbox.serviceFilterList[index] :  inbox.commonFilterList[index]}".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700),)),
                    );
                  },),
              ),
              const SizedBox(width: 10,),
              Expanded(
                  flex: 2,
                  child: 65 <= widget.subcatId ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                    setState1(() {
                      sort = value.toString().split("-").first;
                      sorting = value.toString().split("-").last;
                    });
                  })
                      : 58 <= widget.subcatId  ?
                       (selectFilter == 0 ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
                      const SizedBox(height: 10,),
                      StatefulBuilder(
                          builder: (context, setState) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: subcatCont.subcatTypeData!.subtypelist!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    setState1(() {
                                      if(checkData.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                                        checkData.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                      } else {
                                        checkData.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                      }
                                      filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: checkData).then((value) {
                                        byType = value;
                                      },);
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        activeColor: PurpleColor,
                                        side: BorderSide(color: notifier.iconColor),
                                        value: filterupdateCont.selectedFiltersList.contains(subcatCont.subcatTypeData!.subtypelist![index].title!),
                                        onChanged: (value) {
                                          setState1(() {
                                            if(checkData.contains(subcatCont.subcatTypeData!.subtypelist![index].id!)){
                                              checkData.remove(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                            } else {
                                              checkData.add(subcatCont.subcatTypeData!.subtypelist![index].id!);
                                            }
                                            filterupdateCont.updateCheckbox(checkData: subcatCont.subcatTypeData!.subtypelist![index].title!, filterData: checkData).then((value) {
                                              byType = value;
                                            },);
                                          });
                                        },),
                                      Flexible(
                                        child: Text(subcatCont.subcatTypeData!.subtypelist![index].title!,
                                          style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },);
                          }
                      )
                    ],
                  )
                       : getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                         setState1(() {
                           sort = value.toString().split("-").first;
                           sorting = value.toString().split("-").last;
                         });
                       }))
                      : (selectFilter == 0 ? sliderSelect(note: "Budget".tr, type: "", setState1: setState1, minValue: 0, maxValue: widget.subcatId == 53 ? 500000 : (widget.subcatId == 30 || widget.subcatId == 51) ? 100000 : widget.subcatId == 32 ? 75000 : widget.subcatId == 31 ? 50000 : (widget.subcatId >= 46 && widget.subcatId <= 48) ? 15000 : (widget.subcatId == 50 || widget.subcatId == 49 || (widget.subcatId >= 54 &&  widget.subcatId <= 56)) ? 10000 : 25000, currentValue: const RangeValues(0, 25000), getDataIn: (value) {
                    setState1(() {
                      budgetStart = value.toString().split("-").first;
                      budgetEnd = value.toString().split("-").last;
                      budget = "${"Budget".tr}: $budgetStart - $budgetEnd";
                    });
                  },)
                      : selectFilter == 1 ? getSorting(selcted: "", optionsList: inbox.bysort, setState1: setState1, getDataIn: (value) {
                    setState1(() {
                      sort = value.toString().split("-").first;
                      sorting = value.toString().split("-").last;
                    });
                  })
                      : const SizedBox())),
              const SizedBox(width: 10,),
            ],
          );
        }
    );
  }

  var yearNow = DateTime.now().year;
  var yearMin = 2004;

  Widget selectYear({required String note, setState1, required void Function(dynamic)? getDataIn}){
    return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose a range below".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
              const SizedBox(height: 10,),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: yearminText,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) {
                          setState1((){

                            yearMin = int.parse(yearminText.text);
                            if(yearMin >= DateTime.now().year){
                              yearMin = DateTime.now().year-1;
                              yearminText.text = yearMin.toString();
                            }
                            filterupdateCont.updateSelection(optionsList: "$note: $yearMin - $yearNow").then((value) {
                              getDataIn!("$yearNow-$yearMin");
                            },);
                          });
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          counterText: "",
                          filled: true,
                          fillColor: notifier.textfield,
                          hintText: "${yearNow-20}",
                          hintStyle: TextStyle(color: lightGreyColor,fontFamily: FontFamily.gilroyMedium,fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: PurpleColor),
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text("To".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        controller: yearmaxText,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) {
                          setState1((){

                            yearNow = int.parse(yearmaxText.text);
                            if(yearNow > DateTime.now().year){
                              yearNow = DateTime.now().year;
                              yearmaxText.text = yearNow.toString();
                            }
                            filterupdateCont.updateSelection(optionsList: "$note: $yearMin - $yearNow").then((value) {
                              getDataIn!("$yearNow-$yearMin");
                            },);
                          });
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          counterText: "",
                          fillColor: notifier.textfield,
                          hintText: "$yearNow",
                          hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                          helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: PurpleColor),
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  double rangeStart = 0;
  double rangeEnd = 0;

  void getRange({required double sRange, required double eRange, var setState1}) {
    setState1((){
        rangeStart = sRange;
        rangeEnd = eRange;
    });
  }
  Widget sliderSelect({var setState1, required String type, required double minValue, required double maxValue, required RangeValues currentValue, var note, required void Function(dynamic)? getDataIn}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose a range below".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor),),
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${type == "km" ? "KM" : type == "sqft" ? "SqFt" : type == "area" ? "Area" : currency} ${rangeStart.toString().split(".").first}", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor),),
            Text("${type == "km" ? "KM" : type == "sqft" ? "SqFt" : type == "area" ? "Area" : currency} ${rangeEnd.toString().split(".").first}+", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor),),
          ],
        ),
        RangeSlider(
          values: RangeValues(rangeStart, rangeEnd),
          max: maxValue,
          min: minValue,
          divisions: 50,
          activeColor: Colors.deepPurpleAccent.shade200,
          inactiveColor: notifier.borderColor,
          onChanged: (RangeValues values) {
            setState(() {
              rangeStart = values.start;
              rangeEnd = values.end;
              filterupdateCont.updateSlider(sliderData: "$note: ${rangeStart.toString().split(".").first} - ${rangeEnd.toString().split(".").first}",).then((value) {
                getDataIn!("${rangeStart.toString().split(".").first}-${rangeEnd.toString().split(".").first}");
              },);
            });
          },
        ),
      ],
    );
  }

  String decodeData = "";
  Widget checkBoxSelect({required List selctedListData, required List transData, required List<dynamic> dataList, setState1, required void Function(dynamic)? getDataIn}) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
         const SizedBox(height: 10,),
         StatefulBuilder(
           builder: (context, setState) {
             return ListView.builder(
               scrollDirection: Axis.vertical,
               shrinkWrap: true,
               itemCount: dataList.length,
               itemBuilder: (context, index) {
                 return InkWell(
                   onTap: () {
                     setState1(() {
                       if(checkData.contains(dataList[index])){
                         checkData.remove(dataList[index]);
                         selctedListData.remove(transData[index]);
                         decodeData = selctedListData.join(",");
                       } else {
                         checkData.add(dataList[index]);
                         selctedListData.add(transData[index]);
                         decodeData = selctedListData.join(",");
                       }
                       filterupdateCont.updateCheckbox(selectedData: transData[index], checkData: dataList[index], filterData: checkData).then((value) {
                         getDataIn!("$value-$decodeData");
                       },);
                     });
                   },
                   child: Row(
                     children: [
                       Checkbox(
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                         activeColor: PurpleColor,
                         side: BorderSide(color: notifier.iconColor),
                         value: filterupdateCont.selectedFiltersList.contains(dataList[index]),
                         onChanged: (value) {

                           setState1(() {
                             if(checkData.contains(dataList[index])){
                               checkData.remove(dataList[index]);
                               selctedListData.remove(transData[index]);
                               decodeData = selctedListData.join(",");
                             } else {
                               checkData.add(dataList[index]);
                               selctedListData.add(transData[index]);
                               decodeData = selctedListData.join(",");
                             }
                             filterupdateCont.updateCheckbox(selectedData: transData[index], checkData: dataList[index], filterData: checkData).then((value) {
                               getDataIn!("$value-$decodeData");
                             },);
                           });

                         },),
                       Text("${dataList[index]}".tr, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                     ],
                   ),
                 );
               },);
           }
         )
       ],
     );

  }

  Widget getSorting({required List optionsList, setState1, required String selcted, required void Function(dynamic)? getDataIn}) {
    return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
              const SizedBox(height: 10,),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: optionsList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10,);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState1((){
                        filterupdateCont.updateSelection(optionsList: optionsList[index]).then((value) {
                          getDataIn!("${index+1}-$value");
                        },);
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: filterupdateCont.selectedFiltersList.contains(optionsList[index]) ? PurpleColor : lightGreyColor,
                          ),
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Text("${optionsList[index]}".tr, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                    ),
                  );
                },)
            ],
          );
        }
    );
  }

  Widget optionSelect({required List dataList, required List optionsList, setState1, required void Function(dynamic)? getDataIn, required String selected}) {
    return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose from below options".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),),
              const SizedBox(height: 10,),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: optionsList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10,);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState1((){
                        filterupdateCont.updateSelection(optionsList: optionsList[index]).then((value) {
                          getDataIn!("$value-${dataList[index]}");
                        },);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: filterupdateCont.selectedFiltersList.contains(optionsList[index]) ? PurpleColor : lightGreyColor,
                        ),
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: Text("${optionsList[index]}".tr, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                    ),
                  );
                },)
            ],
          );
        }
    );
  }
}
