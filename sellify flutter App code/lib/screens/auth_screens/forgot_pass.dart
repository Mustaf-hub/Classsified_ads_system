import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/msg_otp_controller.dart';
import 'package:sellify/controller/signup_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/colors.dart';

import '../../utils/dark_lightMode.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController mobile = TextEditingController();

  SignupController signupController = Get.put(SignupController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());

  String countryCode = "";

  bool isGetNavigate = false;
  @override
  Widget build(BuildContext context) {
      notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: 750 < constraints.maxWidth ? Row(
                children: [
                  Spacer(),
                  Expanded(
                    flex: 1200 > constraints.maxWidth ? 2 : 1,
                      child: mobileAuth()),
                  Spacer(),
                ],
              ) : mobileAuth(),
            ),
          );
        }
      ),
    );
  }

  Widget mobileAuth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appbar(),
        SizedBox(height: 30,),
        Center(child: Text("Forgot Password", style: TextStyle(fontSize: 24,
            color: notifier.getTextColor,
            fontFamily: FontFamily.gilroyMedium,
            fontWeight: FontWeight.w700,
            letterSpacing: 1),)),
        SizedBox(height: 10,),
        Center(
          child: Text("Enter your Email address which we use to send the OTP",
            style: TextStyle(fontSize: 16,
                color: GreyColor,
                fontFamily: FontFamily.gilroyMedium,
                letterSpacing: 1,
                height: 1.5), textAlign: TextAlign.center,),
        ),
        SizedBox(height: 40),
        Text("Mobile", style: TextStyle(fontFamily: FontFamily.gilroyMedium,
            color: GreyColor,
            fontSize: 16,
            fontWeight: FontWeight.w600),),
        SizedBox(height: 10),
        IntlPhoneField(
          style: TextStyle(fontSize: 16,
              fontFamily: FontFamily.gilroyMedium,
              color: notifier.getTextColor,
              fontWeight: FontWeight.w600),
          controller: mobile,
          onChanged: (value) {
            setState(() {
              countryCode = value.countryCode;
            });
          },
          initialCountryCode: "IN",
          disableLengthCheck: true,
          showCountryFlag: false,
          showDropdownIcon: false,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          dropdownIcon: Icon(
            Icons.arrow_drop_down,
            color: lightGreyColor,
          ),
          dropdownTextStyle: TextStyle(fontSize: 14,
              fontFamily: FontFamily.gilroyMedium,
              color: GreyColor,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifier.textfield,
            hintText: "Enter  your Mobile Number",
            hintStyle: TextStyle(color: lightGreyColor,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: PurpleColor),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
          ),
        ),
        SizedBox(height: 40),
        mainButton(txt1: "Continue".tr,
          context: context,
          containcolor: PurpleColor,
          loading: isGetNavigate,
          onPressed1: () {
            isGetNavigate = true;
            if (mobile.text.isNotEmpty) {
              msgOtpController.smstype().then((msgType) {
                print("MOBILE  NUMBEr ${mobile.text}");
                signupController.checkMobileNumber(
                    mobilenumber: mobile.text, countrycode: countryCode).then((
                    value) {
                  if (value["Result"] == "false") {
                    if (msgType["otp_auth"] == "No") {
                      isGetNavigate = true;
                      setState(() {});
                      Get.toNamed(Routes.resetPassword);
                    } else {
                      if (msgType["SMS_TYPE"] == "Msg91") {
                        isGetNavigate = true;
                        setState(() {});
                        msgOtpController
                            .sendOtp(mobile: countryCode + mobile.text)
                            .then((value) {
                          if (value["Result"] == "true") {
                            Get.toNamed(Routes.otpScreen, arguments: {
                              "number": mobile.text,
                              "cuntryCode": countryCode,
                              "route": "forgotPassword",
                              "otpCode": value["otp"].toString(),
                            });
                          } else {
                            isGetNavigate = false;
                            setState(() {});
                            showToastMessage(
                                'Invalid Mobile Number'.tr);
                          }
                        });
                      } else if (msgType["SMS_TYPE"] == "Twilio") {
                        isGetNavigate = true;
                        setState(() {});
                        msgOtpController
                            .twilloOtp(mobile: countryCode + mobile.text)
                            .then((value) {
                          if (value["Result"] == "true") {
                            Get.toNamed(Routes.otpScreen, arguments: {
                              "number": mobile.text,
                              "cuntryCode": countryCode,
                              "route": "forgotPassword",
                              "otpCode": value["otp"].toString(),
                            });
                          } else {
                            isGetNavigate = false;
                            setState(() {});
                            showToastMessage('Invalid Mobile Number'.tr);
                          }
                        });
                      }
                    }
                  } else {
                    showToastMessage('Invalid Mobile Number'.tr);
                  }
                },);
              },);
            } else {
              showToastMessage(
                  "Enter  you're mobile number which we use to send the OTP"
                      .tr);
            }
          },),
      ],
    );
  }
  Widget appbar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: GestureDetector(
        onTap: () {
            Get.toNamed(Routes.loginScreen);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notifier.isDark ? notifier.getWhiteblackColor : backGrey,
            shape: BoxShape.circle,
          ),
          child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
        ),
      ),
    );
  }
}
