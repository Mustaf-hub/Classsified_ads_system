import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/accdelete_controller.dart';
import 'package:sellify/controller/pagelist_controller.dart';
import 'package:sellify/controller/refer_controller.dart';
import 'package:sellify/controller/walletreport_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/language/translatelang.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/screens/myads_screen.dart';
import 'package:sellify/screens/pagelistscreen.dart';
import 'package:sellify/screens/profilescreen.dart';
import 'package:sellify/screens/referscreen.dart';
import 'package:sellify/screens/walletscreen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/myadlist_controller.dart';
import '../helper/appbar_screen.dart';
import '../utils/mq.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLang = getData.read("language") ?? "English (USA)";
  }

  PageListController pageListCont = Get.find();
  ReferController referCont = Get.find();
  WalletreportController walletreportCont = Get.find();
  MyadlistController myadlistCont = Get.find();
  AccDeletController accDeletCont = Get.find();

  late ColorNotifire notifier;

  List pagelistImage = [
    "assets/account_icons/security-check.png",
    "assets/account_icons/file.png",
    "assets/account_icons/envelope.png",
    "assets/account_icons/help-circle.png",
  ];

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: kIsWeb ? notifier.getBgColor : PurpleColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: CustomBehavior(),
                child: GetBuilder<PageListController>(
                  builder: (pageListCont) {
                    return Column(
                      children: [
                        kIsWeb ? Container(height: 75, color: notifier.getBgColor, child: CommonAppbar(title: "",)) : const SizedBox(),
                        Expanded(
                          child: NestedScrollView(
                              headerSliverBuilder: (context, innerBoxIsScrolled) {
                                return [
                                  SliverAppBar(
                                    elevation: 0,
                                    expandedHeight: 70,
                                    floating: false,
                                    pinned: true,
                                    backgroundColor: PurpleColor,
                                    centerTitle: false,
                                    automaticallyImplyLeading: kIsWeb ? true : false,
                                    title: Text("My Account".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 24, color: WhiteColor, fontWeight: FontWeight.w700, letterSpacing: 1),),
                                  ),
                                ];
                          },
                              body: SingleChildScrollView(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      color: PurpleColor,
                                    ),
                                    Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 45),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: notifier.getBgColor,
                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                                                ),
                                                child: profileScreenWidgets(constraints),
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                      color: WhiteColor,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(width: 3, color: WhiteColor),
                                                      image: DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(Config.imageUrl + getData.read("UserLogin")["profile_pic"]), scale: 20)
                                                  ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        kIsWeb ? Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
                                          child: footer(context),
                                        ) : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    );
                  }
                ),
              );
            }
          ),
        );
      }
    );
  }

  String selectedLang = "English (USA)";
  Widget profileScreenWidgets(constraints){
    return SingleChildScrollView(
      child: Column(
       mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height / 30,),
          Text("${getData.read("UserLogin")["name"] ?? ""}", style: TextStyle(fontSize: 24, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),),
          Text("${getData.read("UserLogin")["email"] ?? ""}", style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),),
          SizedBox(height: height / 40,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Account Details".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),),
              const SizedBox(height: 20,),
              element(leading: "assets/account_icons/usercircle.png", subTitle: "Manage account details".tr, title: "Profile Information".tr, onPressed1: () {
                Get.to(const Profilescreen(), transition: Transition.noTransition)!.then((value) {
                  setState(() {});
                },);
              },),
              const SizedBox(height: 10,),
              element(leading: "assets/account_icons/empty-wallet.png", subTitle: "Check your wallet details".tr, title: "Wallet".tr, onPressed1: () {
                walletreportCont.getWalletReport().then((value) {
                  Get.to(const Walletscreen(), transition: Transition.noTransition);
                },);
              },),
              const SizedBox(height: 10,),
              element(leading: "assets/myads.png", subTitle: "See your ads.".tr, title: "My Ads".tr, onPressed1: () {
                  Get.to(const MyadsScreen(), transition: Transition.noTransition);
                myadlistCont.myadlist();
              },),
              const SizedBox(height: 10,),
              element(leading: "assets/account_icons/creditcard.png", subTitle: "Get refer your friends.".tr, title: "Refer & Earn".tr, onPressed1: () {
                Get.to(Referscreen(), transition: Transition.noTransition);
                  referCont.getReferData();
              },),
              const SizedBox(height: 20,),
              Text("Settings".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),),
              const SizedBox(height: 10,),
              element(leading: "assets/account_icons/language-square.png", subTitle: selectedLang, title: "Language".tr, onPressed1: () {
                Get.to(const LanguageTrans(), transition: Transition.noTransition)!.then((value) {
                    selectedLang = value["lang"];
                    setState(() {});
                },);
              },),
              const SizedBox(height: 10,),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: notifier.getWhiteblackColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: notifier.borderColor),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: notifier.isDark ? notifier.getBgColor : circleBG,
                            border: Border.all(color: notifier.borderColor),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset("assets/account_icons/contrastlight.png", height: 20, color: notifier.iconColor,),
                        ),
                        const SizedBox(width: 10),
                        Text("Dark Mode".tr, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),),
                      ],
                    ),
                    Transform.scale(
                      scale: 0.9,
                      child: CupertinoSwitch(
                          value: notifier.getIsDark,
                          activeTrackColor: PurpleColor,
                          offLabelColor: GreyColor,
                          onChanged: (value) async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            setState(() {
                              notifier.isDark = value;
                              notifier.setIsDark(value);
                              prefs.setBool("isDark", value);
                              save("isDark", value);
                            });
                          },),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Text("Others".tr, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),),
              const SizedBox(height: 10,),
              pageListCont.isloading ? Center(child: CircularProgressIndicator(color: PurpleColor,))
                  : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: pageListCont.pagelistdata!.pagelist!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10,);
                },
                itemBuilder: (context, index) {
                  return element(leading: pagelistImage[index], subTitle: "", title: pageListCont.pagelistdata!.pagelist![index].title ?? "", onPressed1: () {
                    Get.to(Pagelistscreen(index: index), transition: Transition.noTransition);
                  },);
              },),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(PurpleColor),
                      elevation: const WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(side: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(26)),
                      ),
                    ),
                    onPressed: () async {
                      conformationBottom(
                        text: "Alert!".tr,
                        text2: "Are you sure to get logout of your account?".tr,
                        buttonText: "Log out".tr,
                        onPressed1: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          getupdateLang();
                          prefs.remove('Firstuser');
                          prefs.remove('Remember');
                          getData.remove("lat");
                          getData.remove("long");
                          getData.remove("address");
                          getData.remove("language");
                          getData.remove("lanValue");
                          getData.remove("lCode");
                          notifier.setIsDark(false);
                          prefs.setBool("isDark", false);
                          getData.remove("UserLogin");
                          Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                        },
                      );
                    },
                    child: Text("Log out".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w600, color: WhiteColor, fontSize: 18),)),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(PurpleColor),
                      elevation: const WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(side: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(26)),
                      ),
                    ),

                    onPressed: () async {
                      conformationBottom(
                        text2: "If you delete your account, all your data will be deleted!".tr,
                        text: "Are you sure?".tr,
                        buttonText: "Delete Account".tr,
                        onPressed1: () async {
                          accDeletCont.accdelete();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          getupdateLang();
                          prefs.remove('Firstuser');
                          prefs.remove('Remember');
                          getData.remove("UserLogin");
                          getData.remove("lat");
                          getData.remove("long");
                          getData.remove("address");
                          getData.remove("language");
                          getData.remove("lanValue");
                          getData.remove("lCode");
                          notifier.setIsDark(false);
                          prefs.setBool("isDark", false);
                        },
                      );

                    },
                    child: Text("Delete Account".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w600, color: WhiteColor, fontSize: 18),)),
              ),
              const SizedBox(height: kIsWeb ? 0 : 110,),
            ],
          ),
        ],
      ),
    );
  }

  Future conformationBottom({String? text, String? text2, String? buttonText, required void Function() onPressed1}){
    return Get.bottomSheet(
      backgroundColor: Colors.transparent,
      LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
            child: Container(
              decoration: BoxDecoration(
                color: notifier.getWhiteblackColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text!, style: TextStyle(fontSize: 24, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),textAlign: TextAlign.center,),
                    const SizedBox(height: 10,),
                    Text(text2!, style: TextStyle(fontSize: 18, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),textAlign: TextAlign.center,),
                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        Expanded(
                          child: mainButton(
                            selected: true,
                            containcolor: notifier.getWhiteblackColor,
                              context: context,
                              txt1: "Back".tr,
                              onPressed1: () {
                            Get.back();
                          },),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: mainButton(
                            containcolor: PurpleColor,
                            context: context,
                            txt1: buttonText!,
                            onPressed1: onPressed1),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  getupdateLang(){
    Get.updateLocale(const Locale('en', 'US'));
    Get.back(result: {
      "lang": "English (USA)"
    });
  }

  Widget element({String? title, String? leading, String? subTitle, void Function()? onPressed1}){
    return InkWell(
      onTap: onPressed1,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: notifier.getWhiteblackColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: notifier.borderColor),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: notifier.isDark ? notifier.getBgColor : circleBG,
                      border: Border.all(color: notifier.borderColor),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(leading!, height: 20, color: notifier.iconColor,),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title!, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),overflow: TextOverflow.ellipsis,),
                        SizedBox(height: subTitle!.isEmpty ? 0 : 6),
                        subTitle.isEmpty ? const SizedBox() : Text(subTitle, style: TextStyle(fontSize: 16, color: greyText, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right_rounded, color: GreyColor,)
          ],
        ),
      ),
    );
  }
}
