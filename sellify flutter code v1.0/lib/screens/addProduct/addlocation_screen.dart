import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

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

    print("POSTING TYPE > $subcatID");
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
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getBgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Confirm your location".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () {
          postadController.address = location;
          propertiesCont.address = location;
          Get.toNamed(Routes.reviewyourdetail, arguments: {
            "subcatId" : subcatID,
            "price" : price,
            "address" : location,
            "adIndex" : adindex,
            "postingType" : postingType,
          });
        },),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.chooseLocation, arguments: {
                  "route" : Routes.addlocationScreen,
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
                        Text(location, style: TextStyle(color: GreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16), overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12,)
                ],
              ),
            ),
            Divider(color: lightGreyColor,),
          ],
        ),
      ),
    );
  }
}
