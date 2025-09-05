import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/addfav_controller.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/controller/myfav_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/viewdata_screen.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../api_config/store_data.dart';
import '../controller/login_controller.dart';
import '../controller/postview_controller.dart';
import 'loginscreen.dart';

class CommonadsSeeall extends StatefulWidget {
  const CommonadsSeeall({super.key});

  @override
  State<CommonadsSeeall> createState() => _CommonadsSeeallState();
}

class _CommonadsSeeallState extends State<CommonadsSeeall> {

  List favAdd = [];

  late ColorNotifire notifier;

  HomedataController homedataCont = Get.find();
  AddfavController addfavCont = Get.find();
  MyfavController myfavCont = Get.find();
  PostviewController postviewCont = Get.find();

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
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Common Ads".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: StatefulBuilder(
          builder: (context, setState) {
            return GetBuilder<HomedataController>(
                builder: (homedataCont) {
                  return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: homedataCont.isloading ? SingleChildScrollView(
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => SizedBox(height: 14,),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: notifier.borderColor),
                                    color: notifier.getWhiteblackColor
                                ),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120, width: 100),
                                    SizedBox(width: 10,),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14),
                                          SizedBox(height: 10,),
                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                              SizedBox(width: 10,),
                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 70),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },),
                        )
                            : homedataCont.homedata!.adlist!.isEmpty ? Center(
                              child: Image.asset("assets/emptyOrder.png", height: 200))
                            : SingleChildScrollView(
                              child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: homedataCont.homedata!.adlist!.length,
                              itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: InkWell(
                                  onTap: () {
                                    print("VIRERere");
                                    postviewCont.getPostview(postId: homedataCont.homedata!.adlist![index].postId ?? "");
                                      Navigator.push(context, ScreenTransDown(routes: ViewdataScreen(prodIndex: index), context: context));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: notifier.borderColor),
                                        color: notifier.getWhiteblackColor
                                    ),
                                    padding: EdgeInsets.all(10),
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
                                                return shimmer(baseColor: notifier.shimmerbase2, height: 120, context: context);
                                              },
                                              image: Config.imageUrl + homedataCont.homedata!.adlist![index].postImage!,
                                              placeholder:  "assets/ezgif.com-crop.gif",
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  homedataCont.homedata!.adlist![index].isPaid == "0" ? SizedBox() : Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.5),
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    padding: EdgeInsets.all(3),
                                                    child: Text("Featured".tr.tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                  ),
                                                  GetBuilder<HomedataController>(
                                                      builder: (homedataCont) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            if(getData.read("UserLogin") == null){
                                                               Get.offAll(Loginscreen());
                                                            } else {
                                                              if(homedataCont.homedata!.adlist![index].isFavourite == 0){
                                                                addfavCont.addFav(postId: homedataCont.homedata!.adlist![index].postId!).then((value) {
                                                                  homedataCont.gethomedata();
                                                                },);
                                                              } else {
                                                                unFavBottomSheet(
                                                                  context: context,
                                                                  description: homedataCont.homedata!.adlist![index].adDescription ?? "",
                                                                  title: homedataCont.homedata!.adlist![index].postTitle ?? "",
                                                                  image: "${Config.imageUrl}${homedataCont.homedata!.adlist![index].postImage}",
                                                                  price: "$currency${addCommas(homedataCont.homedata!.adlist![index].adPrice!)}",
                                                                  removeFun: () {
                                                                    setState(() {
                                                                      addfavCont.addFav(postId: homedataCont.homedata!.adlist![index].postId!).then((value) {
                                                                        homedataCont.gethomedata();
                                                                      },);
                                                                    });
                                                                    Get.back();
                                                                  },
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: homedataCont.homedata!.adlist![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                              : Image.asset("assets/heart.png", height: 20,),
                                                        );
                                                      }
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: homedataCont.homedata!.adlist![index].isPaid == "0" ? 0 : 10,),
                                              Text(homedataCont.homedata!.adlist![index].adPrice == "0" ? "$currency ${homedataCont.homedata!.adlist![index].jobSalaryFrom} - ${homedataCont.homedata!.adlist![index].jobSalaryTo} / ${homedataCont.homedata!.adlist![index].jobSalaryPeriod}" : "$currency${addCommas(homedataCont.homedata!.adlist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: homedataCont.homedata!.adlist![index].adPrice == "0" ? 16 :18, fontFamily: FontFamily.gilroyBold),),
                                              SizedBox(height: 10,),
                                              Text("${homedataCont.homedata!.adlist![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700),),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                                                        Flexible(child: Text(" ${homedataCont.homedata!.adlist![index].fullAddress}", style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text("${homedataCont.homedata!.adlist![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                                                      },),
                            ),
                      )
                  );
                }
            );
          }
        ),
      ),
    );
  }
}
