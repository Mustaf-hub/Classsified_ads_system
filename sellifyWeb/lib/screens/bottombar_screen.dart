import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/myfav_controller.dart';
import 'package:sellify/controller/pagelist_controller.dart';
import 'package:sellify/firebase/chat_list.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/language/translatelang.dart';
import 'package:sellify/screens/account_screen.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/favourite_screen.dart';
import 'package:sellify/screens/home_screen.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:sellify/utils/mq.dart';

import '../api_config/store_data.dart';
import '../controller/msg_otp_controller.dart';
import '../utils/admob.dart';

class BottombarScreen extends StatefulWidget {
  const BottombarScreen({super.key});

  @override
  State<BottombarScreen> createState() => _BottombarScreenState();
}

class _BottombarScreenState extends State<BottombarScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabCont = TabController(length: 4, vsync: this);
    if(!kIsWeb){
      createInterstitialAd();
    }

  }

  List<Widget> bottomScreem = [
    const HomePage(),
    const ChatListScreen(),
    const FavouriteScreen(),
    const AccountScreen(),
  ];
  late TabController tabCont;

  int currentIndex = 0;

  MyadlistController myadlistCont = Get.find();
  MyfavController myfavController = Get.find();
  PageListController pageListCont  = Get.find();
  MsgOtpController smsTypeCont = Get.find();

  late ColorNotifire notifier;

  List bottombarImage = [
    "assets/home.png",
    "assets/chat.png",
    "assets/heart.png",
    "assets/user.png",
  ];

  List bottomTitle = [
    "Home".tr,
    "Chats".tr,
    "Favourite".tr,
    "Account".tr,
  ];

  BannerAd? bannerAd;

  DateTime? lastBackPressed;
  Future popScopeBack(context) async{
    DateTime now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      showToastMessage("Press back again to exit");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        return await popScopeBack(context);
      },
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body:  bottomScreem[currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: notifier.getWhiteblackColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {

                            setState(() {
                              currentIndex = 0;
                            });
                        },

                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutExpo,
                          height: currentIndex != 0 ? 60 : 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentIndex != 0 ? Colors.transparent : PurpleColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.only(left: currentIndex == 0 ? height / 40 : rtl ? 0 : 10, right: currentIndex == 0 ? height / 40 : rtl ? 10 : 0),
                          child: Row(
                            children: [
                              Image.asset("assets/home.png", color: currentIndex == 0 ? WhiteColor : notifier.getTextColor, height: height / 30,),
                              const SizedBox(width: 8,),
                              currentIndex != 0 ? const SizedBox() : Text("Home".tr, style: TextStyle(color: currentIndex == 0 ? WhiteColor : notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 14), overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if(getData.read("UserLogin") == null){
                            Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                          } else {
                            setState(() {
                              currentIndex = 1;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutExpo,
                          height: currentIndex != 1 ? 60 : 50,
                          decoration: BoxDecoration(
                            color: currentIndex != 1 ? Colors.transparent : PurpleColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: currentIndex == 1 ? height / 35 : 0,),
                          child: Row(
                            children: [
                              Image.asset("assets/chat.png", color: currentIndex == 1 ? WhiteColor : notifier.getTextColor,height: height / 30,),
                              const SizedBox(width: 8,),
                              currentIndex != 1 ? const SizedBox() : Text("Chats".tr, style: TextStyle(color: currentIndex == 1 ? WhiteColor : notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 14),),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          if(getData.read("UserLogin") == null){
                            Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                          } else {
                          setState(() {
                            myfavController.getMyFav();
                            currentIndex = 2;
                          });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutExpo,
                          height: currentIndex != 2 ? 60 : 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentIndex != 2 ? Colors.transparent : PurpleColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: currentIndex == 2 ? height / 40 : 0,),
                          child: Row(
                            children: [
                              Image.asset("assets/heart.png", color: currentIndex == 2 ? WhiteColor : notifier.getTextColor, height: height / 30,),
                              const SizedBox(width: 8,),
                              currentIndex != 2 ? const SizedBox() : Text("Favourite".tr, style: TextStyle(color: currentIndex == 2 ? WhiteColor : notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 14),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if(getData.read("UserLogin") == null){
                            Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                          } else {
                            setState(() {
                              pageListCont.getPageList();
                                currentIndex = 3;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutExpo,
                          height: currentIndex != 3 ? 60 : 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentIndex != 3 ? Colors.transparent : PurpleColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: currentIndex == 3 ? height / 40 : 0, ),
                          child: Row(
                            children: [
                              Image.asset("assets/user.png", color: currentIndex == 3 ? WhiteColor : notifier.getTextColor, height: height / 30,),
                              const SizedBox(width: 8,),
                              currentIndex != 3 ? const SizedBox() : Text("Account".tr, style: TextStyle(color: currentIndex == 3 ? WhiteColor : notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 14),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: rtl ? 0 : 10, left: rtl ? 10 : 0),
                child: InkWell(
                  onTap: (smsTypeCont.smstypeData != null && smsTypeCont.smstypeData!.admobEnabled == "Yes") ?  () {
                    currentIndex = 0;
                    setState(() {});
                    showInterstitialAd();

                    // interstitialAda().show();

                  } :  () {
                    currentIndex = 0;
                    setState(() {});
                    if(getData.read("UserLogin") == null){
                      Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                    } else {
                      Get.to(const AddproductScreen(), transition: Transition.noTransition);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: PurpleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("assets/addIcon.png", color: WhiteColor, height: 20,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
