import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/firebase/chat_screen.dart';
import 'package:sellify/helper/appbar_screen.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/CommonadsSeeall.dart';
import 'package:sellify/screens/categoryseeall_screen.dart';
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/featured_view.dart';
import 'package:sellify/screens/featuredseeall.dart';
import 'package:sellify/screens/myads_screen.dart';
import 'package:sellify/screens/search_screen.dart';
import 'package:sellify/screens/subcategory_screen.dart';
import 'package:sellify/screens/viewdata_screen.dart';
import 'package:sellify/utils/admob.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/addfav_controller.dart';
import '../controller/catwisepost_controller.dart';
import '../controller/msg_otp_controller.dart';
import '../controller/myadlist_controller.dart';
import '../controller/myfav_controller.dart';
import '../controller/pagelist_controller.dart';
import '../controller/postview_controller.dart';
import '../firebase/firebase_accesstoken.dart';
import '../language/translatelang.dart';
import 'catwisepost_list.dart';
import 'loginscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollCont = ScrollController();
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      Get.to(
          ChatScreen(
            adImage: "",
            mobile: remoteMessage.data["mobile_number"] ?? "",
            profilePic: remoteMessage.data["pro_pic"] ?? "",
            initialTab: 0,
            adPrice: "",
            title: "",
            resiverUserId: remoteMessage.data["id"] ?? "",
            resiverUsername: remoteMessage.data["name"] ?? "",
          ), transition: Transition.noTransition);
    });



    FirebaseAccesstoken accesstoken = FirebaseAccesstoken();
    accesstoken.getAccessToken();
    homedataCont.gethomedata();
    categoryListCont.categoryList();
    if(!kIsWeb){
      initialNaticeAd();
    }
  }

  late Timer timer;
  int scrollCount = 2;

  late ColorNotifire notifier;
  CategoryListController categoryListCont = Get.find();
  HomedataController homedataCont = Get.find();
  AddfavController addfavCont = Get.find();
  CatwisePostController catwisePostCont = Get.find();
  PostviewController postviewCont = Get.find();
  MyadlistController myadlistCont = Get.find();
  PageListController pageListCont  = Get.find();

  final GlobalKey<ScaffoldState> dKey = GlobalKey();

  NativeAd? nativeAd;
  bool isNativeLoaded = false;

  void initialNaticeAd() async {
    nativeAd = NativeAd(
        adUnitId: AdHelper.nativeAdunitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isNativeLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            setState(() {
              isNativeLoaded = false;
              nativeAd!.dispose();
            });
          },
        ),
        nativeTemplateStyle: NativeTemplateStyle(templateType: TemplateType.medium),
        request: request,
    );

    nativeAd!.load();
  }

  MsgOtpController smsTypeCont = Get.find();
  MyfavController myfavController = Get.find();


  bool isNavigate = false;
  bool isHover = false;
  bool isHover2 = false;

  int? hoveredIndex;
  int? featuredIndex;
  int? commonIndex;

  int move = 4;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: dKey,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: CommonAppbar())
              : AppBar(
                backgroundColor: notifier.getWhiteblackColor,
                elevation: 0,
                leading: Padding(
                  padding: EdgeInsets.only(left: rtl ? 0 : 10, right: rtl ? 10 : 0),
                  child: InkWell(
                    onTap: () {
                      Get.to(const Chooselocation(), arguments: {
                        "route": Routes.homePage,
                      }, transition: Transition.noTransition);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.yellow)
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset("assets/location.png", scale: 3.2, color: notifier.getTextColor,),
                ),
              ),
            ),
            centerTitle: false,
            title: InkWell(
              onTap: () {
                Get.to(const Chooselocation(), transition: Transition.noTransition, arguments: {
                  "route": Routes.homePage,
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Location".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 14),),
                  const SizedBox(height: 5,),
                  Text(getData.read("address"), style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5),),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  if(getData.read("UserLogin") == null){
                    Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                  } else {
                    myadlistCont.myadlist().then((value) {
                      Get.to(const MyadsScreen(), transition: Transition.noTransition);
                    },);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        const SizedBox(width: 5,),
                        Image.asset("assets/myads.png", height: 30, color: notifier.getTextColor,),
                        const SizedBox(width: 8,),
                        Image.asset("assets/sellifyLogo.png", height: 35,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: notifier.getBgColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: CustomBehavior(),
                child: RefreshIndicator(
                  color: PurpleColor,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        homedataCont.gethomedata();
                        categoryListCont.categoryList();
                      },
                    );
                  },
                  child: GetBuilder<HomedataController>(
                      builder: (homedataCont) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 300 : 1200 < constraints.maxWidth ? 100 : 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("The Sellify Magic! ".tr, style: TextStyle(fontFamily: FontFamily.gilroyRegular, fontSize: 22, color: notifier.getTextColor, fontWeight: FontWeight.w700, letterSpacing: 0.5),),
                                              Expanded(child: Divider(color: notifier.getTextColor,  thickness: 1.6,)),
                                              const Spacer(),
                                            ],
                                          ),
                                          Text("One Click, Endless Possibilities!".tr, style: TextStyle(fontFamily: FontFamily.gilroyRegular, fontSize: 22, color: notifier.getTextColor, fontWeight: FontWeight.w700, letterSpacing: 0.5), overflow: TextOverflow.ellipsis,),
                                          const SizedBox(height: 15,),
                                          SizedBox(
                                            height: 55,
                                            child: TextField(
                                              readOnly: true,
                                              onTap: () {
                                                Navigator.push(context, screenTransDown(routes: const SearchScreen(), context: context));
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
                                                    borderSide: BorderSide(color: notifier.isDark ? notifier.borderColor : searchBorder),
                                                  ),
                                                  enabledBorder:  OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(35),
                                                    borderSide: BorderSide(color: notifier.isDark ? notifier.borderColor : searchBorder, width: 2),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Browse Categories".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5),),
                                          InkWell(
                                            onTap: () {
                                              Get.to(const CategoryseeallScreen(), transition: Transition.noTransition);
                                            },
                                            child: Row(
                                              children: [
                                                Text("See all".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: PurpleColor, fontSize: 16),),
                                                Icon(Icons.arrow_forward_ios_rounded, color: PurpleColor, size: 14,)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      GetBuilder<CategoryListController>(
                                          builder: (categoryListCont) {
                                            return categoryListCont.isloading ? GridView.builder(
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 16,
                                                mainAxisSpacing: 16
                                              ),
                                              itemCount: 6,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return shimmer(context: context, baseColor: notifier.shimmerbase, height: 110, width: 110);
                                              },)
                                                : categoryListCont.categorylistData!.categorylist!.isEmpty ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/emptyOrder.png", height: 200),
                                                  ],
                                                )
                                                : SizedBox(
                                              child: GridView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 1200 < constraints.maxWidth ? 5 : 950 < constraints.maxWidth ? 4 : 3,
                                                    mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  mainAxisExtent: 1200 < constraints.maxWidth ? 200 : 950 < constraints.maxWidth ? 150 : 110
                                                ),
                                                itemCount: 1200 < constraints.maxWidth ? 10 : 950 < constraints.maxWidth ? 8 : 6,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if(isNavigate) return;
                                                      setState(() {
                                                        isNavigate = true;
                                                      });
                                                      if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                                          Navigator.push(context, screenTransRight(routes: CatwisepostList(subcatId: 0, catID: int.parse(categoryListCont.categorylistData!.categorylist![index].id!),),)).then((value) {
                                                            setState(() {
                                                              isNavigate = false;
                                                            });
                                                          },);
                                                        catwisePostCont.getCatwisePost(catId: categoryListCont.categorylistData!.categorylist![index].id ?? "", subcatId: "0").then((value) {
                                                        },);
                                                      } else {
                                                          Navigator.push(context, screenTransDown(routes: SubcategoryScreen(
                                                            route: Routes.homePage,
                                                            title: categoryListCont.categorylistData!.categorylist![index].title ?? "",
                                                            catId: categoryListCont.categorylistData!.categorylist![index].id.toString(),
                                                          ), context: context)).then((value) {
                                                            isNavigate = false;
                                                          },);
                                                        categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id.toString()).then((value) {
                                                        },);
                                                      }
                                                    },
                                                    child: MouseRegion(
                                                      onEnter: (_) => setState(() => hoveredIndex = index),
                                                      onExit: (_) => setState(() => hoveredIndex = null),
                                                      child: AnimatedContainer(
                                                        height: 110,
                                                        duration: const Duration(),
                                                        decoration: BoxDecoration(
                                                            color: notifier.getWhiteblackColor,
                                                            border: Border.all(color: hoveredIndex == index ? circleGrey : notifier.borderColor),
                                                            borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        padding: const EdgeInsets.all(5),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            FadeInImage.assetNetwork(
                                                              height: 1200 < constraints.maxWidth ? 100 : 950 < constraints.maxWidth ? 70 : 45,
                                                              fit: BoxFit.cover,
                                                              imageErrorBuilder: (context, error, stackTrace) {
                                                                return shimmer(baseColor: notifier.shimmerbase2, height: 1200 < constraints.maxWidth ? 100 : 950 < constraints.maxWidth ? 70 : 45, context: context);
                                                              },
                                                              image: "${Config.imageUrl}${categoryListCont.categorylistData!.categorylist![index].img ?? ""}",
                                                              placeholder:  "assets/ezgif.com-crop.gif",
                                                            ),
                                                            const SizedBox(height: 8,),
                                                            Text("${categoryListCont.categorylistData!.categorylist![index].title}",
                                                              style: TextStyle(fontSize: constraints.maxWidth < 950 ? 12 : constraints.maxWidth < 1200 ? 14 : 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),
                                                              textAlign: TextAlign.center,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },),
                                            );
                                          }
                                      ),
                                      const SizedBox(height: 15),
                                      smsTypeCont.smstypeData == null ? const SizedBox() : smsTypeCont.smstypeData!.admobEnabled == "No" ? const SizedBox() : isNativeLoaded ? SizedBox(height: 360, child: AdWidget(ad: nativeAd!)) : Center(child: CircularProgressIndicator(color: PurpleColor,)),
                                      SizedBox(height: smsTypeCont.smstypeData == null ? 0 : smsTypeCont.smstypeData!.admobEnabled == "No" ? 0 : 15),
                                      homedataCont.isloading ? GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 950 < constraints.maxWidth ? 4 : 650 < constraints.maxWidth ? 3 : 2,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            mainAxisExtent: 1200 < constraints.maxWidth ? 286 : 230
                                        ),
                                        shrinkWrap: true,
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: notifier.getWhiteblackColor,
                                                border: Border.all(color: notifier.borderColor,),
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120),
                                                    Positioned(
                                                      top: 5,
                                                        right: 5,
                                                        child: shimmer(context: context, baseColor: notifier.shimmerbase, height: 30, width: 30)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10,),
                                                shimmer(context: context, baseColor: notifier.shimmerbase2, height: 18),
                                                const Spacer(),
                                                shimmer(context: context, baseColor: notifier.shimmerbase2, height: 16),
                                                const Spacer(),
                                                shimmer(context: context, baseColor: notifier.shimmerbase2, height: 16),
                                              ],
                                            ),
                                          );
                                        },) : homedataCont.homedata == null ? const SizedBox() : homedataCont.homedata!.featurelist!.isEmpty ? const SizedBox() : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Featured Ads".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, fontWeight: FontWeight.w700),),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context, screenTransRight(routes: const Featuredseeall(), context: context));
                                                },
                                                child: Row(
                                                  children: [
                                                    Text("See all".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: PurpleColor, fontSize: 16),),
                                                    Icon(Icons.arrow_forward_ios_rounded, color: PurpleColor, size: 14,)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          GetBuilder<HomedataController>(
                                            builder: (homedataCont) {
                                              return homedataCont.isloading ? GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 950 < constraints.maxWidth ? 4 : 650 < constraints.maxWidth ? 3 : 2,
                                                    mainAxisSpacing: 12,
                                                    crossAxisSpacing: 12,
                                                    mainAxisExtent: 1200 < constraints.maxWidth ? 286 : 230
                                                ),
                                                shrinkWrap: true,
                                                itemCount: 6,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: notifier.getWhiteblackColor,
                                                        border: Border.all(color: notifier.borderColor,),
                                                        borderRadius: BorderRadius.circular(12)
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 18),
                                                        const Spacer(),
                                                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 16),
                                                        const Spacer(),
                                                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 16),
                                                      ],
                                                    ),
                                                  );
                                                },)
                                                  : homedataCont.homedata!.featurelist!.isEmpty ? SizedBox(
                                                height: 160,
                                                    child: Center(
                                                    child: Image.asset("assets/emptyOrder.png", height: 120, fit: BoxFit.cover,)),
                                                  )
                                                  : featuredList(context, constraints);
                                          },),
                                          const SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Common Ads".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, fontWeight: FontWeight.w700),),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context, screenTransRight(routes: const CommonadsSeeall(), context: context));
                                                },
                                                child: Row(
                                                  children: [
                                                    Text("See all".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: PurpleColor, fontSize: 16),),
                                                    Icon(Icons.arrow_forward_ios_rounded, color: PurpleColor, size: 14,),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          categoryListCont.isloading ? GridView.builder(
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 12,
                                                crossAxisSpacing: 12,
                                                mainAxisExtent: 230
                                            ),
                                            shrinkWrap: true,
                                            itemCount: 6,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: notifier.getWhiteblackColor,
                                                    border: Border.all(color: notifier.borderColor,),
                                                    borderRadius: BorderRadius.circular(12)
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 18),
                                                    const Spacer(),
                                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 16),
                                                    const Spacer(),
                                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 16),
                                                  ],
                                                ),
                                              );
                                            },)
                                              : homedataCont.homedata!.adlist!.isEmpty ? SizedBox(
                                            height: 180,
                                              child: Center(
                                                  child: Image.asset("assets/emptyOrder.png", height: 120)))
                                              : adsList(context, constraints),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      homedataCont.isloading ? const SizedBox() : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Offer & Discount".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5),),
                                          Row(
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: (isHover)
                                                          ? notifier.iconColor
                                                          : notifier.borderColor),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    scrollCont.animateTo(double.parse("${move}00"),
                                                        curve: const FlippedCurve(Easing.legacy),
                                                        duration: const Duration(seconds: 1));
                                                    setState(() {
                                                      move = move - 4;
                                                    });
                                                  },
                                                  onHover: (val) {
                                                    setState(() {
                                                      isHover = val;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(13),
                                                    child: Image.asset(
                                                      'assets/lefticon.png',
                                                      width: 15,
                                                      color: notifier.iconColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: (isHover2)
                                                          ? notifier.iconColor
                                                          : notifier.borderColor),
                                                ),
                                                child: InkWell(
                                                    onTap: () {
                                                      scrollCont.animateTo(double.parse("${move}00"),
                                                          curve: const FlippedCurve(Easing.legacy),
                                                          duration: const Duration(seconds: 1));
                                                      setState(() {
                                                        move = move + 4;
                                                      });
                                                    },
                                                    onHover: (val) {
                                                      setState(() {
                                                        isHover2 = val;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(13),
                                                      child: Image.asset(
                                                        'assets/arrowrighticon.png',
                                                        width: 15,
                                                        color: notifier.iconColor,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      homedataCont.isloading ? CarouselSlider.builder(
                                        itemCount: 3,
                                        itemBuilder:(context, index, realIndex) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                boxShadow: [BoxShadow(
                                                    color: notifier.getTextColor
                                                )]
                                            ),
                                            child: ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                child: shimmer(context: context, baseColor: notifier.shimmerbase2,),),
                                          );
                                        },
                                        options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            autoPlay: true,
                                            height: 250
                                        ),
                                      ) : homedataCont.homedata!.bannerlist!.isEmpty ? const SizedBox()
                                          : 950 < constraints.maxWidth ? SizedBox(
                                           height: 250,
                                            child: ListView.builder(
                                            itemCount: 2,
                                            controller: scrollCont,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                            return SizedBox(
                                              height: 250,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: homedataCont.homedata!.bannerlist!.length,
                                                itemBuilder:(context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: notifier.getTextColor
                                                          )],
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                          child: FadeInImage.assetNetwork(
                                                            fit: BoxFit.fitHeight,
                                                            imageErrorBuilder: (context, error, stackTrace) {
                                                              return shimmer(baseColor: notifier.shimmerbase2, height: 250, context: context);
                                                            },
                                                            image: Config.imageUrl + homedataCont.homedata!.bannerlist![index].img!,
                                                            placeholder:  "assets/ezgif.com-crop.gif",
                                                          )),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                           },),
                                          )
                                          : CarouselSlider.builder(
                                        itemCount: homedataCont.homedata!.bannerlist!.length,
                                          itemBuilder:(context, index, realIndex) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                  boxShadow: [BoxShadow(
                                                    color: notifier.getTextColor
                                                  )]
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    child: FadeInImage.assetNetwork(
                                                      fit: BoxFit.fitHeight,
                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                        return shimmer(baseColor: notifier.shimmerbase2, height: 250, context: context);
                                                      },
                                                      image: Config.imageUrl + homedataCont.homedata!.bannerlist![index].img!,
                                                      placeholder:  "assets/ezgif.com-crop.gif",
                                                    )),
                                              );
                                          },
                                          options: CarouselOptions(
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              height: 250
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: kIsWeb ? 10 : 0,),
                                kIsWeb ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
                                  child: footer(context),
                                ) : const SizedBox(),
                                const SizedBox(height: kIsWeb ? 0 : 80,),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }

  Widget featuredList(context, constraints){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 950 < constraints.maxWidth ? 4 : 650 < constraints.maxWidth ? 3 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 1200 < constraints.maxWidth ? 290 : 230
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homedataCont.homedata!.featurelist!.length,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => setState(() => featuredIndex = index),
          onExit: (_) => setState(() => featuredIndex = null),
          child: InkWell(
            onTap: () {
                Get.to(FeaturedView(prodIndex: index), transition: Transition.noTransition);
              postviewCont.getPostview(postId: homedataCont.homedata!.featurelist![index].postId ?? "").then((value) {
              },);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: notifier.getWhiteblackColor,
                  border: Border.all(
                    color: featuredIndex == index ? circleGrey : notifier.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage.assetNetwork(
                          height: 1200 < constraints.maxWidth ? 180 : 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return shimmer(baseColor: notifier.shimmerbase2, height: 1200 < constraints.maxWidth ? 180 : 120, context: context);
                          },
                          image: Config.imageUrl + homedataCont.homedata!.featurelist![index].postImage!,
                          placeholder:  "assets/ezgif.com-crop.gif",
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GetBuilder<HomedataController>(
                          builder: (homedataCont) {
                            return InkWell(
                              onTap: () {
                                if(getData.read("UserLogin") == null){
                                  Get.offAll(const Loginscreen());
                                } else {
                                  if(homedataCont.homedata!.featurelist![index].isFavourite == 0){
                                    addfavCont.addFav(postId: homedataCont.homedata!.featurelist![index].postId!);
                                  } else {
                                    unFavBottomSheet(
                                      context: context,
                                      description: homedataCont.homedata!.featurelist![index].adDescription ?? "",
                                      title: homedataCont.homedata!.featurelist![index].postTitle ?? "",
                                      image: "${Config.imageUrl}${homedataCont.homedata!.featurelist![index].postImage}",
                                      price: "$currency${addCommas(homedataCont.homedata!.featurelist![index].adPrice!)}",
                                      removeFun: () {
                                          addfavCont.addFav(postId: homedataCont.homedata!.featurelist![index].postId!);

                                        Get.back();
                                      },
                                    );
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle
                                ),
                                padding: const EdgeInsets.all(5),
                                child: homedataCont.homedata!.featurelist![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 18, color: Colors.red.shade300,)
                                    : Image.asset("assets/heart.png", height: 18, color: Colors.grey.shade600,),
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text(homedataCont.homedata!.featurelist![index].adPrice == "0" ? "$currency ${homedataCont.homedata!.featurelist![index].jobSalaryFrom} - ${homedataCont.homedata!.featurelist![index].jobSalaryTo} / ${homedataCont.homedata!.featurelist![index].jobSalaryPeriod}" : "$currency ${addCommas(homedataCont.homedata!.featurelist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: homedataCont.homedata!.featurelist![index].catId == "4" ? 14 : 18, fontFamily: FontFamily.gilroyBold),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  const SizedBox(height: 10,),
                  Text(homedataCont.homedata!.featurelist![index].postTitle!, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700, height: 1),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                      Flexible(child: Text(getAddress(address: homedataCont.homedata!.featurelist![index].fullAddress!), style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget adsList(context, constraints){
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 950 < constraints.maxWidth ? 4 : 650 < constraints.maxWidth ? 3 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 1200 < constraints.maxWidth ? 290 : 230
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: homedataCont.homedata!.adlist!.length,
        itemBuilder: (context, index) {
          return MouseRegion(
            onEnter: (_) => setState(() => commonIndex = index),
            onExit: (_) => setState(() => commonIndex = null),
            child: InkWell(
              onTap: () {
                Get.to(ViewdataScreen(prodIndex: index), transition: Transition.noTransition);
                postviewCont.getPostview(postId: homedataCont.homedata!.adlist![index].postId ?? "").then((value) {
                },);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notifier.getWhiteblackColor,
                  border: Border.all(
                    color: commonIndex == index ? circleGrey : notifier.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                         ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                            child: FadeInImage.assetNetwork(
                              height: 1200 < constraints.maxWidth ? 180 : 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return shimmer(baseColor: notifier.shimmerbase2, height: 1200 < constraints.maxWidth ? 180 : 120, context: context);
                              },
                              image: Config.imageUrl + homedataCont.homedata!.adlist![index].postImage!,
                              placeholder:  "assets/ezgif.com-crop.gif",
                            ),
                        ),
                        homedataCont.homedata!.adlist![index].isFeatureAd == "0" ? const SizedBox() : Positioned(
                          top: 5,
                          left: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5)
                            ),
                              padding: const EdgeInsets.all(3),
                              child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GetBuilder<HomedataController>(
                              builder: (homedataCont) {
                                return InkWell(
                                  onTap: () {
                                    if(getData.read("UserLogin") == null){
                                      Get.offAll(const Loginscreen());
                                    } else {
                                      if(homedataCont.homedata!.adlist![index].isFavourite == 0){
                                        addfavCont.addFav(postId: homedataCont.homedata!.adlist![index].postId!);
                                      } else {
                                        unFavBottomSheet(
                                          context: context,
                                          description: homedataCont.homedata!.adlist![index].adDescription ?? "",
                                          title: homedataCont.homedata!.adlist![index].postTitle ?? "",
                                          image: "${Config.imageUrl}${homedataCont.homedata!.adlist![index].postImage}",
                                          price: "${homedataCont.homedata!.currency}${homedataCont.homedata!.adlist![index].adPrice}",
                                          removeFun: () {
                                            addfavCont.addFav(postId: homedataCont.homedata!.adlist![index].postId!);
                                            Get.back();
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: homedataCont.homedata!.adlist![index].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 18, color: Colors.red.shade300,)
                                        : Image.asset("assets/heart.png", height: 18, color: Colors.grey.shade600,),
                                  ),
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(homedataCont.homedata!.adlist![index].adPrice == "0" ? "$currency ${homedataCont.homedata!.adlist![index].jobSalaryFrom} - ${homedataCont.homedata!.adlist![index].jobSalaryTo} / ${homedataCont.homedata!.adlist![index].jobSalaryPeriod}" : "$currency ${addCommas(homedataCont.homedata!.adlist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: homedataCont.homedata!.adlist![index].catId == "4" ? 14 : 18, fontFamily: FontFamily.gilroyBold),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    const SizedBox(height: 10,),
                    Text(homedataCont.homedata!.adlist![index].postTitle!, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700, height: 1),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                        Flexible(child: Text(getAddress(address: homedataCont.homedata!.adlist![index].fullAddress!), style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}

void listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    WebNotification? web = message.notification?.web;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && (web != null || android != null)) {
      flutterLocalNotificationPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
              presentBadge: true,
            ),
          ),
          payload: jsonEncode({
            "name": message.data["name"],
            "id": message.data["id"],
            "propic": message.data["propic"]
          }));
    }
  });
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin;

Future<void> initializeNotifications() async {
  flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIos =
  DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  final InitializationSettings initializationSettings =
  const InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIos);

  await flutterLocalNotificationPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
}
//
Future<void> onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  if(payload != null){
    Map data = jsonDecode(payload);
    Get.to(
        ChatScreen(
          initialTab: 0,
          mobile: data["mobile_number"],
          profilePic: data["pro_pic"],
          adImage: "",
          adPrice: "",
          title: "",
          resiverUserId: data["id"],
          resiverUsername: data["title"],
        ));
  }
}
//
Future<void> onDidReceiveNotificationResponse(NotificationResponse response) async {
  // Handle the notification response. You can access the payload via response.payload.
  String? payload = response.payload;
  if(payload != null){
    Map data = jsonDecode(payload);
    Get.to(
        ChatScreen(
          mobile: data["mobile_number"],
          profilePic: data["pro_pic"],
          initialTab: 0,
          adImage: "",
          adPrice: "",
          title: "",
          resiverUserId: data["id"],
          resiverUsername: data["title"],
        ));
  }
}

Future<void> loadFCM() async {

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

}