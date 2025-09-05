import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/home_screen.dart';

import '../api_config/store_data.dart';
import '../controller/myadlist_controller.dart';
import '../controller/myfav_controller.dart';
import '../controller/pagelist_controller.dart';
import '../controller/postview_controller.dart';
import '../firebase/chat_list.dart';
import '../language/translatelang.dart';
import '../model/routes_helper.dart';
import '../screens/account_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/loginscreen.dart';
import '../screens/myads_screen.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';
import 'c_widget.dart';
import 'font_family.dart';


class CommonAppbar extends StatefulWidget {
  String? title;
  String? isFeatured;
  void Function()? fun;
  CommonAppbar({super.key, this.title, this.fun, this.isFeatured});

  @override
  State<CommonAppbar> createState() => _CommonAppbarState();
}

class _CommonAppbarState extends State<CommonAppbar> {

  PostviewController postviewCont = Get.find();
  MyadlistController myadlistCont = Get.find();
  PageListController pageListCont  = Get.find();
  MyfavController myfavController = Get.find();

  String selectedLang = "English (USA)";

  late ColorNotifire notifier;

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: notifier.getWhiteblackColor,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            constraints.maxWidth < 500 ? const SizedBox() : InkWell(
                              onTap: () {
                                Get.to(const HomePage(), transition: Transition.noTransition);
                              },
                              child: Row(
                                children: [
                                  Image.asset("assets/sellifyLogo.png", height: 35,),
                                  const SizedBox(width: 10,),
                                  Text("Sellify".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor, fontSize: 18),),
                                ],
                              ),
                            ),
                            SizedBox(width: constraints.maxWidth < 500 ? 0 : 10,),
                            InkWell(
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
                                child: Image.asset("assets/location.png", scale: 4, color: notifier.getTextColor,),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  Get.to(const Chooselocation(), arguments: {
                                    "route": Routes.homePage,
                                  }, transition: Transition.noTransition);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Location".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 14), overflow: TextOverflow.ellipsis,),
                                    const SizedBox(height: 5,),
                                    Text(getData.read("address") == null || getData.read("address") == "" ? "Your Default Location" : getData.read("address"), style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5), overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          constraints.maxWidth < 1050 ? PopupMenuButton(
                            tooltip: '',
                            padding: EdgeInsets.zero,
                            offset: Offset(rtl ? -70 : 60, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: notifier.getWhiteblackColor,
                            child: Image.asset("assets/3dots.png", height: 20,),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        appBarTabs(constraints: constraints, icon: "assets/account_icons/language-square.png", title: selectedLang, fun: () {
                                          Get.back();
                                          Get.to(const LanguageTrans(), transition: Transition.noTransition)!.then((value) {
                                            selectedLang = value["lang"];
                                            setState(() {});
                                          },);
                                        },),
                                        const SizedBox(
                                            height: 10),
                                        appBarTabs(constraints: constraints, icon: "assets/chat.png", title: "Chats".tr, fun: () {
                                          Get.back();
                                          if(getData.read("UserLogin") == null){
                                            Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                          } else {
                                            Get.to(const ChatListScreen(), transition: Transition.noTransition);
                                          }
                                        },),
                                        const SizedBox(
                                            height: 10),
                                        appBarTabs(constraints: constraints, icon: "assets/heart.png", title: "Favourite".tr, fun: () {
                                          Get.back();
                                          if(getData.read("UserLogin") == null){
                                            Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                          } else {
                                            myfavController.getMyFav();
                                            Get.to(const FavouriteScreen(), transition: Transition.noTransition);
                                          }
                                        },),
                                        const SizedBox(
                                            height: 10),
                                        appBarTabs(constraints: constraints, icon: "assets/user.png", title: getData.read("UserLogin") != null ? "Account".tr : "Login".tr, fun: () {
                                          Get.back();
                                          if(getData.read("UserLogin") == null){
                                            Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                          } else {
                                            pageListCont.getPageList();
                                            Get.to(const AccountScreen(), transition: Transition.noTransition);
                                          }
                                        },),
                                      ],
                                    )
                                )
                              ];
                            },
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: constraints.maxWidth / 80),
                              appBarTabs(constraints: constraints, icon: "assets/account_icons/language-square.png", title: selectedLang, fun: () {
                                Get.to(const LanguageTrans(), transition: Transition.noTransition)!.then((value) {
                                  selectedLang = value["lang"];
                                  setState(() {});
                                },);
                              },),
                              const SizedBox(width: 10,),
                              appBarTabs(constraints: constraints, icon: "assets/chat.png", title: "Chats".tr, fun: () {
                                Get.back();
                                if(getData.read("UserLogin") == null){
                                  Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                } else {
                                  Get.to(const ChatListScreen(), transition: Transition.noTransition);
                                }
                              },),
                              const SizedBox(width: 10,),
                              appBarTabs(constraints: constraints, icon: "assets/heart.png", title: "Favourite".tr, fun: () {
                                Get.back();
                                if(getData.read("UserLogin") == null){
                                  Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                } else {
                                  myfavController.getMyFav();
                                  Get.to(const FavouriteScreen(), transition: Transition.noTransition);
                                }
                              },),
                              const SizedBox(width: 10,),
                              appBarTabs(constraints: constraints, icon: "assets/user.png", title: getData.read("UserLogin") != null ? "Account".tr : "Login".tr, fun: () {
                                Get.back();
                                if(getData.read("UserLogin") == null){
                                  Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                } else {
                                  pageListCont.getPageList();
                                  Get.to(const AccountScreen(), transition: Transition.noTransition);
                                }
                              },),
                            ],
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.yellow),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                const SizedBox(width: 5,),
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
                                    child: Image.asset("assets/myads.png", height: 30, color: notifier.getTextColor,)),
                                const SizedBox(width: 8,),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                    backgroundColor: WidgetStatePropertyAll(PurpleColor),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)))
                                  ),
                                  onPressed: () {
                                    if(getData.read("UserLogin") == null){
                                      Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                    } else {
                                      Get.to(const AddproductScreen(), transition: Transition.noTransition);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: PurpleColor,
                                        borderRadius: BorderRadius.circular(22)
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Text("Post".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, color: WhiteColor, fontSize: 16),),
                                        const SizedBox(width: 5,),
                                        Image.asset("assets/addIcon.png", color: WhiteColor, height: 16,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: widget.title == null || widget.fun == null ? 0 : 10,),
                (widget.title == null || widget.fun == null) ? const SizedBox() : backAppbar(title: widget.title, fun: widget.fun, isFeatured: widget.isFeatured),
              ],
            ),
          );
        }
      ),
    );
  }
  Widget appBarTabs({void Function()? fun, required String icon, required String title, required constraints}) {
    return InkWell(
      onTap: fun,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: constraints.maxWidth < 1050 ? Colors.transparent : notifier.borderColor, width: 2),
        ),
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth < 1050 ? 0 : 10, vertical: 8),
        child: Row(
          children: [
            Image.asset(icon, color: notifier.getTextColor,height: 20,),
            const SizedBox(width: 5,),
            Text(title, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 14),),
          ],
        ),
      ),
    );
  }
}


