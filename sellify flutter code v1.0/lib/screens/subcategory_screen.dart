import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/postad/bikecvehiclecontoller.dart';
import 'package:sellify/controller/postad/postbike_controller.dart';
import 'package:sellify/controller/postad/commonpost_controller.dart';
import 'package:sellify/controller/postad/postcvehicle_controller.dart';
import 'package:sellify/controller/postad/postmobile_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/addProduct/adcommonpost.dart';
import 'package:sellify/screens/addProduct/addVehicle/addbikes.dart';
import 'package:sellify/screens/addProduct/addVehicle/addc_vehicle.dart';
import 'package:sellify/screens/addProduct/addjob_detail.dart';
import 'package:sellify/screens/addProduct/addmobiles.dart';
import 'package:sellify/screens/addProduct/addproperties.dart';
import 'package:sellify/screens/addProduct/addservices.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/catwisepost_controller.dart';
import '../helper/c_widget.dart';
import 'catwisepost_list.dart';

class SubcategoryScreen extends StatefulWidget {
  final String title;
  final String catId;
  final String route;
  const SubcategoryScreen({super.key, required this.title, required this.catId, required this.route});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {

  late ColorNotifire notifier;
  PostadController postadController = Get.find();
  PostmobileController postmobileCont = Get.find();
  PostbikeController postbikeCont = Get.find();
  CommonPostController commonPostCont = Get.find();
  PostcvehicleController postcvehicleCont = Get.find();
  CatwisePostController catwisePostCont = Get.find();


  CategoryListController subCategoryCont = Get.find();
  PropertiesController propertiesCont = Get.find();
  BikescooterCvehicleContoller bikeScoCvehicleCon = Get.find();

  bool isNavigate = false;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getWhiteblackColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor),
          ),
        ),
        title: Text(widget.title, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      body: GetBuilder<CategoryListController>(
          builder: (subCategoryCont) {
            return SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: subCategoryCont.subIsloading ? ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: 5,),
                        Divider(color: lightGreyColor,),
                        SizedBox(height: 5,),
                      ],
                    );
                  },
                  itemBuilder: (context, index) {
                    return shimmer(context: context, baseColor: notifier.isDark ? notifier.shimmerbase : notifier.shimmerbase2, height: 20,);
                  },)
                    : subCategoryCont.subcategoryData!.subcategorylist!.isEmpty ? Center(
                    child: Image.asset("assets/emptyOrder.png", height: 200)) : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: subCategoryCont.subcategoryData!.subcategorylist!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) {
                          return Divider(color: lightGreyColor, thickness: 1,height: 1,);
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {

                              if (widget.route == Routes.addproductScreen) {

                                if(int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) <= 6) {
                                  propertiesCont.catId = widget.catId;
                                  propertiesCont.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";
                                  setState(() {
                                    propertiesCont.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";
                                  });

                                  subCategoryCont.subcatType(subcatID: "${subCategoryCont.subcategoryData!.subcategorylist![index].id}").then((value) {
                                    Get.to(Addproperties(), arguments: {
                                      "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                      "postingType" : "newPost"
                                    });
                                      setState(() {
                                        isNavigate = false;
                                      });

                                  },);

                                } else if(int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) <= 9) {

                                  print(">>>>>>>>>>>>>>>> ID ${subCategoryCont.subcategoryData!.subcategorylist![index].id}");
                                  postmobileCont.catId = widget.catId;
                                  postmobileCont.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";
                                  subCategoryCont.subcatType(subcatID: "${subCategoryCont.subcategoryData!.subcategorylist![index].id}").then((value) {
                                    Get.to(Addmobiles(), arguments: {
                                      "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                      "postingType" : "newPost"
                                    })!.then((value) {
                                      setState(() {
                                        isNavigate = false;
                                      });
                                    },);
                                  },);

                                }
                                else if (int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) <= 24) {

                                  postadController.catId = widget.catId;
                                  postadController.subcatId = subCategoryCont.subcategoryData!.subcategorylist![index].id ?? "";
                                  Get.to(AddjobDetail(), arguments: {
                                    "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                    "postingType" : "newPost"
                                  })!.then((value) {
                                    setState(() {
                                      isNavigate = false;
                                    });
                                  },);

                                }
                                else if(int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) <= 26 || int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) == 28){

                                  postbikeCont.catId = widget.catId;
                                  postbikeCont.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";

                                  bikeScoCvehicleCon.getvehicle(subcatId: "${subCategoryCont.subcategoryData!.subcategorylist![index].id}").then((value) {
                                    Get.to(Addbikes(), arguments: {
                                      "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                      "postingType" : "newPost"
                                    })!.then((value) {
                                      setState(() {
                                        isNavigate = false;
                                      });
                                    },);
                                  },);

                                }
                                else if(int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) == 39 || int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) == 40){

                                  postcvehicleCont.catId = widget.catId;
                                  postcvehicleCont.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";
                                  bikeScoCvehicleCon.getvehicle(subcatId: "${subCategoryCont.subcategoryData!.subcategorylist![index].id}").then((value) {
                                    Get.to(AddcVehicle(), arguments: {
                                      "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                      "postingType" : "newPost"
                                    })!.then((value) {
                                      setState(() {
                                        isNavigate = false;
                                      });
                                    },);
                                  },);
                                }
                                else if(58 <= int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) && int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!) <= 66) {
                                  postadController.catId = widget.catId;
                                  postadController.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";
                                  subCategoryCont.subcatType(subcatID: "${subCategoryCont.subcategoryData!.subcategorylist![index].id}").then((value) {
                                    Get.to(Addservices(), arguments: {
                                      "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                      "postingType" : "newPost"
                                    })!.then((value) {
                                      setState(() {
                                        isNavigate = false;
                                      });
                                    },);
                                  },);
                                }
                                else {
                                  print(">>>>>>>>>>>>>>>> ID ${subCategoryCont.subcategoryData!.subcategorylist![index].id}");
                                  commonPostCont.catId = widget.catId;
                                  commonPostCont.subcatId = "${subCategoryCont.subcategoryData!.subcategorylist![index].id}";
                                  Get.to(Adcommonpost(), arguments: {
                                    "subcatId" : subCategoryCont.subcategoryData!.subcategorylist![index].id,
                                    "postingType" : "newPost"
                                  })!.then((value) {
                                    setState(() {
                                      isNavigate = false;
                                    });
                                  },);
                                }
                              } else {

                                  print("ISLOADING OR NOT  ${subCategoryCont.subcategoryData!.subcategorylist![index].id}");
                                    Get.to(CatwisepostList(subcatId: int.parse(subCategoryCont.subcategoryData!.subcategorylist![index].id!), catID: int.parse(widget.catId),));

                              }
                            },
                            child: Container(
                              height: 40,
                              color: notifier.getBgColor,
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Text("${subCategoryCont.subcategoryData!.subcategorylist![index].title}",
                                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16),),
                            ),
                          );
                        },),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

}
