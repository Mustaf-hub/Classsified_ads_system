import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/msg_otp_controller.dart';
import 'package:sellify/controller/signup_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:sellify/utils/mq.dart';

import '../../api_config/config.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  String code = "";
  String phoneNumber = Get.arguments["number"];

  String countryCode = Get.arguments["cuntryCode"];

  String rout = Get.arguments["route"];

  String otpCode = Get.arguments["otpCode"].toString();

  late ColorNotifire notifire;

  bool clearText = false;

  TextEditingController pinPutController = TextEditingController();

  SignupController signupController = Get.put(SignupController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());

  bool isGetnavigate = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              appbar(),
              SizedBox(height: 30,),
              Center(child: Text("Enter OTP", style: TextStyle(fontSize: 24, color: notifire.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,letterSpacing: 1),)),
              SizedBox(height: 10,),
              Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "We have just sent 6 digit code \nvia your ",
                      style: TextStyle(fontSize: 16, color: GreyColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 1, height: 1.5),
                    children: [
                      TextSpan(
                        text: "$countryCode $phoneNumber",
                        style: TextStyle(fontSize: 16, color: notifire.getTextColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 1),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Pinput(
                  length: 6,
                  keyboardType: TextInputType.number,
                  obscureText: false,

                  defaultPinTheme: PinTheme(
                    width: width/5,
                    height: 55,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: notifire.getTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: notifire.borderColor, width: 2),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  controller: pinPutController,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  onCompleted: (pin) => print(pin),
                  onChanged: (value) {
                    code = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your otp'.tr;
                    }
                    return null;
                  }),
              SizedBox(height: 40),
              mainButton(txt1: "Continue".tr, context: context, loading: isGetnavigate, containcolor: PurpleColor, onPressed1: () {
                if(otpCode == code){
                  if (rout == "signupScreen") {
                    initPlatformState();
                    isGetnavigate = true;
                    setState(() {});
                    signupController.userRegister(context).then((value) {
                      if(value["Result"] == "true"){
                         Get.offAndToNamed(Routes.chooseLocation, arguments: {
                           "route" : Routes.signupScreen,
                         })!.then((value) {
                           isGetnavigate = false;
                           setState(() {});
                         },);
                      } else {
                        isGetnavigate = false;
                        setState(() {});
                      }
                    },);
                  } else if(rout == "forgotPassword"){
                    isGetnavigate = true;
                    setState(() {});
                    Get.toNamed(Routes.resetPassword, arguments: {
                      "mobile" : phoneNumber,
                      "ccode" : countryCode,
                    })!.then((value) {
                      isGetnavigate = false;
                      setState(() {});
                    },);
                  }
                } else {
                  showToastMessage("Please enter your valid OTP".tr);
                }
              },),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive code? ",style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 18),),
                  InkWell(
                      onTap: () {
                        clearText = true;
                        msgOtpController.smstype().then((value) {
                          if(value["SMS_TYPE"] == "Msg91"){
                            msgOtpController.sendOtp(mobile: countryCode + phoneNumber).then((value) {
                              setState(() {
                                otpCode = value["otp"].toString();
                              });
                            },);
                          } else if(value["SMS_TYPE"] == "Twilio") {
                            msgOtpController.twilloOtp(mobile: countryCode + phoneNumber).then((value) {
                              setState(() {
                                otpCode = value["otp"].toString();
                              });
                            },);
                          }
                        });
                      },
                      child: Text("Resend Code",style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: PurpleColor, fontWeight: FontWeight.w700, fontSize: 18),)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(Config.onesignalKey);
    OneSignal.Notifications.requestPermission(true).then((value) {
      print("Signal value:- $value");
    },);
  }

  Future dialogBox(){
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          backgroundColor: WhiteColor,
          elevation: 0,
          child: Container(
            height: 440,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 10),
                SvgPicture.asset("assets/success.svg",height: 150,),
                Spacer(),
                Text("You have logged in successfully", style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 24, color: BlackColor),textAlign: TextAlign.center,),
                Spacer(),
                Text("Your account is ready to use. You will be redirected to the Home page..", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: GreyColor),textAlign: TextAlign.center,),
                Spacer(flex: 2,),
                mainButton(containcolor: PurpleColor, context: context, txt1: "Continue".tr, onPressed1: () {

                  Get.toNamed(Routes.bottomBarScreen);
                },),
              ],
            ),
          ),
        );
      },);
  }
  Widget appbar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: GestureDetector(
        onTap: () {
          setState(() {
            Get.back();
          });
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notifire.isDark ? notifier.getWhiteblackColor : backGrey,
            shape: BoxShape.circle,
          ),
          child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
        ),
      ),
    );
  }
}
