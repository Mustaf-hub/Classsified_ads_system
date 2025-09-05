import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/addProduct/reviewyourdetail.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../chooselocation.dart';

class AddlocationScreen extends StatefulWidget {
  const AddlocationScreen({super.key});

  @override
  State<AddlocationScreen> createState() => _AddlocationScreenState();
}

class _AddlocationScreenState extends State<AddlocationScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(postingType == "Edit"){

      route = Get.arguments["route"];
      if(route == Routes.chooseLocation){
        setState(() {
          location = getData.read("address");
        });
      } else {
        setState(() {
          adindex = Get.arguments["adIndex"];
          location = myadlistCont.myadlistData!.myadList![adindex].fullAddress!;
        });
      }
    } else {
      location = getData.read("address");
    }
  }
  String route = "";
  String location = "";
  late ColorNotifire notifier;

  String subcatID = Get.arguments["subcatId"];
  String price = Get.arguments["price"];
  String postingType = Get.arguments["postingType"];
  int adindex = 0;

  PostadController postadController = Get.find();
  PropertiesController propertiesCont = Get.find();
  MyadlistController myadlistCont = Get.find();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: notifier.getWhiteblackColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
              ),
            ),
            title: Text("Confirm your location".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
          ),
          bottomNavigationBar: kIsWeb ? const SizedBox() : Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
            child: mainButton(containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () {
              if (location.isNotEmpty) {
                postadController.address = location;
                propertiesCont.address = location;
                Get.to(const Reviewyourdetail(), transition: Transition.noTransition, arguments: {
                  "subcatId" : subcatID,
                  "price" : price,
                  "address" : location,
                  "adIndex" : adindex,
                  "postingType" : postingType,
                });
              } else {
                showToastMessage("Address is required!");
              }
            },),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(const Chooselocation(), transition: Transition.noTransition, arguments: {
                            "route" : "AddlocationScreen",
                            "subcatId" : subcatID,
                            "price" : price,
                            "adIndex" : adindex,
                            "postingType" : postingType,
                          })!.then((value) {
                            setState(() {
                              location = value["addresshome"];
                              subcatID = value["subcatId"];
                              price = value["price"];
                              postingType = value["postingType"];
                              adindex = value["adIndex"];
                              route = value["route"];
                            });
                            setState(() {});
                          },);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Location".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 18, fontFamily: FontFamily.gilroyMedium,),),
                                  Text(location.isEmpty ? "Your default location" : location, style: TextStyle(color: GreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16), overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 12,)
                          ],
                        ),
                      ),
                      Divider(color: lightGreyColor,),
                    ],
                  ),
                ),
                SizedBox(height: kIsWeb ? Get.height/3.5 : 0,),
                kIsWeb ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                  child: mainButton(containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () {
                    if (location.isNotEmpty) {
                      postadController.address = location;
                      propertiesCont.address = location;
                      Get.to(const Reviewyourdetail(), transition: Transition.noTransition, arguments: {
                        "subcatId" : subcatID,
                        "price" : price,
                        "address" : location,
                        "adIndex" : adindex,
                        "postingType" : postingType,
                      });
                    } else {
                      showToastMessage("Address is required!");
                    }
                  },),
                ) : const SizedBox(),
                kIsWeb ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                  child: footer(context),
                ) : const SizedBox(),
              ],
            ),
          ),
        );
      }
    );
  }
}
