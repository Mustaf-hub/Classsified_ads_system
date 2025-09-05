import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/profilewisepost_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/profilepost_view.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../api_config/config.dart';
import '../api_config/store_data.dart';
import '../controller/addfav_controller.dart';
import '../controller/login_controller.dart';
import '../controller/postview_controller.dart';
import '../firebase/chat_screen.dart';

class ProfilepostsScreen extends StatefulWidget {
  const ProfilepostsScreen({super.key});

  @override
  State<ProfilepostsScreen> createState() => _ProfilepostsScreenState();
}

class _ProfilepostsScreenState extends State<ProfilepostsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  late ColorNotifire notifier;

  ProfilewiseController profilewiseCont = Get.find();
  AddfavController addfavCont = Get.find();
  PostviewController postviewCont = Get.find();

  String location = "Mahim East, Mumbai";

  List favAdd= [];

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
                backgroundColor: PurpleColor,
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset("assets/arrowLeftIcon.png", height: 20, color: WhiteColor, scale: 3.5,)),
                title: Text("Profile".tr,style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 18, color: WhiteColor,),),
         ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 100,
                      color: PurpleColor,
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: notifier.getWhiteblackColor,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(fit: BoxFit.fitHeight, image: profilewiseCont.profilewiseData!.ownerDetails!.ownerImg != null ? NetworkImage(Config.imageUrl+ profilewiseCont.profilewiseData!.ownerDetails!.ownerImg!) : AssetImage("assets/userprofile.png",)),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          Text(profilewiseCont.profilewiseData!.ownerDetails!.ownerName ?? "", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
                          Spacer(flex: 10,),
                          InkWell(
                             onTap: () {
                               Navigator.push(context, ScreenTransDown(
                                   routes: ChatScreen(
                                     adImage: "",
                                       mobile: profilewiseCont.profilewiseData!.ownerDetails!.ownerMobile!,
                                       profilePic: profilewiseCont.profilewiseData!.ownerDetails!.ownerImg!,
                                       title: "",
                                       adPrice: "",
                                       initialTab: 0,
                                       resiverUserId: profilewiseCont.profilewiseData!.ownerDetails!.postOwnerId ?? "",
                                       resiverUsername: profilewiseCont.profilewiseData!.ownerDetails!.ownerName ?? ""),
                                   context: context));
                             },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: PurpleColor)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                              alignment: Alignment.center,
                              child: Text("Chat".tr, style: TextStyle(fontSize: 16, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: PurpleColor,)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Text("${profilewiseCont.profilewiseData!.searchlist!.length} ${"Ads available for you".tr}", style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),),
                      SizedBox(height: 10,),
                      profilewiseCont.isloading ?
                        ListView.separated(
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
                        },)
                          : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: profilewiseCont.profilewiseData!.searchlist!.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              onTap: () {
                                postviewCont.getPostview(postId: profilewiseCont.profilewiseData!.searchlist![index].postId ?? "").then((value) {
                                  Navigator.push(context, ScreenTransRight(routes: ProfilepostView(prodIndex: index), context: context));
                                },);
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
                                            return Center(child: shimmer(context: context, baseColor: notifier.shimmerbase, height: 120, width: 100),);
                                          },
                                          image: Config.imageUrl + profilewiseCont.profilewiseData!.searchlist![index].postImage!,
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
                                              profilewiseCont.profilewiseData!.searchlist![index].isPaid == "0" ? const SizedBox() : Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                padding: EdgeInsets.all(3),
                                                child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                              ),
                                              GetBuilder<ProfilewiseController>(
                                                builder: (profilewiseCont) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if(profilewiseCont.profilewiseData!.searchlist![index].isFavourite == 0){
                                                        addfavCont.addFav(postId: profilewiseCont.profilewiseData!.searchlist![index].postId!).then((value) {
                                                          profilewiseCont.getProfilewise(profileId: profilewiseCont.profilewiseData!.ownerDetails!.postOwnerId ?? "");
                                                        },);
                                                      } else {
                                                        unFavBottomSheet(
                                                          context: context,
                                                          description: profilewiseCont.profilewiseData!.searchlist![index].adDescription ?? "",
                                                          title: profilewiseCont.profilewiseData!.searchlist![index].postTitle ?? "",
                                                          image: "${Config.imageUrl}${profilewiseCont.profilewiseData!.searchlist![index].postImage}",
                                                          price: "$currency${addCommas(profilewiseCont.profilewiseData!.searchlist![index].adPrice!)}",
                                                          removeFun: () {
                                                            setState(() {
                                                              addfavCont.addFav(postId: profilewiseCont.profilewiseData!.searchlist![index].postId!).then((value) {
                                                                profilewiseCont.getProfilewise(profileId: profilewiseCont.profilewiseData!.ownerDetails!.postOwnerId ?? "");
                                                              },);
                                                            });
                                                            Get.back();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: profilewiseCont.profilewiseData!.searchlist![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                        : Image.asset("assets/heart.png", height: 20, color: notifier.iconColor,),
                                                  );
                                                }
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Text(profilewiseCont.profilewiseData!.searchlist![index].adPrice == "0" ? "$currency ${profilewiseCont.profilewiseData!.searchlist![index].jobSalaryFrom} - ${profilewiseCont.profilewiseData!.searchlist![index].jobSalaryTo} / ${profilewiseCont.profilewiseData!.searchlist![index].jobSalaryPeriod}" : "$currency${addCommas(profilewiseCont.profilewiseData!.searchlist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: profilewiseCont.profilewiseData!.searchlist![index].catId == "4" ? 16 : 18, fontFamily: FontFamily.gilroyBold), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                          SizedBox(height: 10,),
                                          Text(profilewiseCont.profilewiseData!.searchlist![index].postTitle ?? "", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child: Text(profilewiseCont.profilewiseData!.searchlist![index].fullAddress.toString().split(",").first, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                              Text(profilewiseCont.profilewiseData!.searchlist![index].postDate.toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                        },)
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
