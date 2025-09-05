import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/controller/refer_controller.dart';
import 'package:sellify/utils/mq.dart';
import 'package:share_plus/share_plus.dart';
import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';

class Referscreen extends StatelessWidget {

  Referscreen({super.key});

  late ColorNotifire notifier;
  TextEditingController couponCode = TextEditingController();

  ReferController referCont = Get.find();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: notifier.getWhiteblackColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: notifier.getTextColor,
          ),
        ),
        title: Text(
          "Refer & Earn".tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'Gilroy Medium',
            color: notifier.getTextColor,
          ),
        ),
      ),
      body: GetBuilder<ReferController>(
        builder: (referCont) {
      return referCont.isloading ? Center(child: CircularProgressIndicator(color: PurpleColor,)) : Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: notifier.getBgColor,
        ),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset("assets/gift.png",)),
                SizedBox(height: height/46,),
                Text("Share this code with your freinds and earn aamount.".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: height/30),textAlign: TextAlign.center,),
                SizedBox(
                  height: 10,
                ),
                Text("${"Earn".tr} $currency${referCont.signupCredit} ${"on each your invited freind's Signup.".tr}", style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: height/50),textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                Text("${"Share the referral link with your friends and earn".tr} $currency${referCont.referCredit}.", style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: height/50),textAlign: TextAlign.center,),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                  color: notifier.textfield,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: notifier.borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/gifticon.png", height: 30, color: notifier.iconColor,),
                      SizedBox(width: 15,),
                      Text(referCont.referCode, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 18),textAlign: TextAlign.center,),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 2,
                            height: 30,
                            color: notifier.borderColor,
                          ),
                          SizedBox(width: 20,),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                new ClipboardData(text: referCont.referCode),
                              );
                              showToastMessage("Copied".tr);
                            },
                              child: Text("Copy".tr, style: TextStyle(color: PurpleColor, fontFamily: FontFamily.gilroyMedium, fontSize: 18),textAlign: TextAlign.center,)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                mainButton(containcolor: PurpleColor, txt1: "Invite My Friends".tr, context: context, onPressed1: () async {
                  getPackage();
                  if(referCont.referCode.isNotEmpty) {
                     await Share.share(
                       "Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code ${referCont.referCode} & Enjoy your shopping !!!",
                       subject: "https://play.google.com/store/apps/details?id=$packageName",
                      );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Refer code is not valid",
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: BlackColor.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  }
                },),
              ],
            ),
        );
      },)
    );
  }
}
