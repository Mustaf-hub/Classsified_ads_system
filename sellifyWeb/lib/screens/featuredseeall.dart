import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/addfav_controller.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/controller/myfav_controller.dart';
import 'package:sellify/controller/postview_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/featured_view.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../api_config/store_data.dart';
import '../controller/login_controller.dart';
import '../helper/appbar_screen.dart';
import 'loginscreen.dart';

class Featuredseeall extends StatefulWidget {
  const Featuredseeall({super.key});

  @override
  State<Featuredseeall> createState() => _FeaturedseeallState();
}

class _FeaturedseeallState extends State<Featuredseeall> {

  List favAdd = [];

  late ColorNotifire notifier;

  HomedataController homedataCont = Get.find();
  AddfavController addfavCont = Get.find();
  MyfavController myfavCont = Get.find();
  PostviewController postviewCont = Get.find();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: "Featured Ads".tr, fun: () {
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
                child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
              ),
            ),
            title: Text("Featured Ads".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
          ),
          body: ScrollConfiguration(
            behavior: CustomBehavior(),
            child: GetBuilder<HomedataController>(
              builder: (homedataCont) {
                return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: kIsWeb ? 5 : 0,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1150 < constraints.maxWidth ? 300 : 800 < constraints.maxWidth ? 150 : 20),
                            child: homedataCont.isloading ? SingleChildScrollView(
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: notifier.borderColor),
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
                                },),
                            )
                                : homedataCont.homedata!.featurelist!.isEmpty ? Center(
                                    child: Image.asset("assets/emptyOrder.png", height: 200,))
                                : SingleChildScrollView(
                                  child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: homedataCont.homedata!.featurelist!.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        postviewCont.getPostview(postId: homedataCont.homedata!.featurelist![index].postId ?? "");
                                           Navigator.push(context, screenTransDown(routes: FeaturedView(prodIndex: index), context: context));
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
                                                    return Center(child: shimmer(context: context, baseColor: notifier.shimmerbase, height: 120));
                                                  },
                                                  image: Config.imageUrl + homedataCont.homedata!.featurelist![index].postImage!,
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
                                                      homedataCont.homedata!.featurelist![index].isPaid == "0" ? const SizedBox() : Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.5),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        padding: const EdgeInsets.all(3),
                                                        child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                      ),
                                                      GetBuilder<HomedataController>(
                                                          builder: (homedataCont) {
                                                            return InkWell(
                                                              onTap: () {
                                                                if(getData.read("UserLogin") == null){
                                                                  Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                                                } else {
                                                                    if(homedataCont.homedata!.featurelist![index].isFavourite == 0){
                                                                    addfavCont.addFav(postId: homedataCont.homedata!.featurelist![index].postId!).then((value) {
                                                                      homedataCont.gethomedata();
                                                                    },);
                                                                  } else {
                                                                  unFavBottomSheet(
                                                                    context: context,
                                                                    description: homedataCont.homedata!.featurelist![index].adDescription ?? "",
                                                                    title: homedataCont.homedata!.featurelist![index].postTitle ?? "",
                                                                    image: "${Config.imageUrl}${homedataCont.homedata!.featurelist![index].postImage}",
                                                                    price: "$currency${addCommas(homedataCont.homedata!.featurelist![index].adPrice!)}",
                                                                    removeFun: () {
                                                                      setState(() {
                                                                        addfavCont.addFav(postId: homedataCont.homedata!.featurelist![index].postId!).then((value) {
                                                                          homedataCont.gethomedata();
                                                                        },);
                                                                      });
                                                                      Get.back();
                                                                    },
                                                                  );
                                                                }
                                                                }
                                                              },
                                                              child: homedataCont.homedata!.featurelist![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                                  : Image.asset("assets/heart.png", height: 20,),
                                                            );
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: homedataCont.homedata!.featurelist![index].isPaid == "0" ? 0 : 10,),
                                                  Text(homedataCont.homedata!.featurelist![index].catId == "4" ? "$currency ${homedataCont.homedata!.featurelist![index].jobSalaryFrom} - ${homedataCont.homedata!.featurelist![index].jobSalaryTo} / ${homedataCont.homedata!.featurelist![index].jobSalaryPeriod}" : "$currency${addCommas(homedataCont.homedata!.featurelist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: homedataCont.homedata!.featurelist![index].catId == "4" ? 16 : 18, fontFamily: FontFamily.gilroyBold),),
                                                  const SizedBox(height: 10,),
                                                  Text("${homedataCont.homedata!.featurelist![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700),),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                                                            Flexible(child: Text(getAddress(address: homedataCont.homedata!.featurelist![index].fullAddress!), style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Text("${homedataCont.homedata!.featurelist![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },),
                                ),
                          ),
                          const SizedBox(height: kIsWeb ? 10 : 0,),
                          kIsWeb ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
                            child: footer(context),
                          ) : const SizedBox(),
                        ],
                      ),
                    )
                );
              }
            ),
          ),
        );
      }
    );
  }
}
