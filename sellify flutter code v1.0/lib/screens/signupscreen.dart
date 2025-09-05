import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/imageupload_controller.dart';
import 'package:sellify/controller/msg_otp_controller.dart';
import 'package:sellify/controller/signup_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:sellify/utils/mq.dart';

import '../api_config/config.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    msgOtpController.smstype();
    imageuploadCont.imageFile = null;
  }

  late ColorNotifire notifier;

  TextEditingController repassCont = TextEditingController();

  SignupController signupController = Get.put(SignupController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());
  ImageuploadController imageuploadCont = Get.put(ImageuploadController());

  bool isSignup = false;
  bool isRadioOn = false;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();


  bool isValidate = false;

  final _formKey = GlobalKey<FormState>();

  bool isGetNavigate = false;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: PurpleColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 50),
                child: Column(
                  children: [
                    Center(child: Text("Create account", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 24, color: WhiteColor, fontWeight: FontWeight.w700, letterSpacing: 1), textAlign: TextAlign.center,)),
                    SizedBox(height: 10,),
                    Center(child: Text("Your adventure begins here – create your account.", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: WhiteColor), textAlign: TextAlign.center, maxLines: 2,),),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20,),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: notifier.getBgColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                        ),
                        child: 750 < constraints.maxWidth ? Row(
                          children: [
                            Spacer(),
                            Expanded(
                              flex: 1200 > constraints.maxWidth ? 2  : 1,
                                child: enterDetail()
                            ),
                            Spacer(),
                          ],
                        )
                            : enterDetail(),
                      ),
                    ),
                    GetBuilder<ImageuploadController>(
                        builder: (imageuploadCont) {
                          return Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                  color: WhiteColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 3, color: WhiteColor),
                                  image: DecorationImage(fit: BoxFit.fitHeight, image: imageuploadCont.imageFile != null ? FileImage(imageuploadCont.imageFile!,scale: 1) : AssetImage("assets/sellifyLogo.png"), scale: 20)
                              ),
                            ),
                          );
                        }
                    ),
                    Positioned(
                      top: 60,
                      left: 70,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          imageuploadCont.openGallery(screenRoute: Routes.signupScreen);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: notifier.getWhiteblackColor, width: 3),
                            shape: BoxShape.circle,
                            color: PurpleColor,
                          ),
                          child: Image.asset("assets/addIcon.png", scale: 1, color: WhiteColor,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget enterDetail(){
    height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height / 20,),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                nameFeild(),
                SizedBox(height: height / 50,),
                Text("Mobile", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
                SizedBox(height: 8,),
                IntlPhoneField(
                  autofocus: false,
                  style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                  controller: signupController.mobile,
                  onChanged: (value) {
                    setState(() {
                      signupController.countryCode = value.countryCode;
                    });
                    print("SDSDSDSDSDSDSDSD ${loginController.countryCode}");
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please enter the mobile number!!";
                    }
                    return null;
                  },
                  initialCountryCode: "IN",
                  disableLengthCheck: false,
                  showCountryFlag: false,
                  showDropdownIcon: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  dropdownIcon: Icon(
                    Icons.arrow_drop_down,
                    color: lightGreyColor,
                  ),
                  dropdownTextStyle: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.isDark ? notifier.iconColor : GreyColor, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: notifier.isDark ? notifier.getWhiteblackColor : textFieldInput,
                    hintText: "Enter your Mobile number",
                    hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
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
                passField(),
              ],
            ),
          ),
          textFeild(textController: signupController.rcode, textInputType: TextInputType.name, context: context, hinttext: "Referral code (optional)",),
          SizedBox(height: height / 30,),
          mainButton(containcolor: PurpleColor, context: context, txt1: "Sign Up", loading: isGetNavigate, onPressed1: () {
      
              if (_formKey.currentState!.validate()) {
                signupController.checkMobileNumber(mobilenumber: signupController.mobile.text, countrycode: signupController.countryCode).then((value) {
                  if(value["Result"] == "true"){
                      if (signupController.passCont.text == signupController.repassCont.text) {
                        // if (_formKey.currentState?.validate() ?? false) {
                        // }
                        msgOtpController.smstype().then((msgtype) {

                          if (msgtype["otp_auth"] == "No") {
                            initPlatformState();
                            isGetNavigate = true;
                            setState(() {});
                            signupController.userRegister(context).then((value) {
                              if(value["Result"] == "true"){

                                initPlatformState();
                                Get.offAllNamed(Routes.chooseLocation, arguments: {
                                  "route" : Routes.signupScreen,
                                })!.then((value) {
                                  isGetNavigate = false;
                                  setState(() {});
                                },);
                              } else {
                                isGetNavigate = false;
                                setState(() {});
                                showToastMessage(value["ResponseMsg"]);
                              }
                            },);
                          } else {

                            if (msgtype["SMS_TYPE"] == "Msg91") {
                              isGetNavigate = true;
                              setState(() {});
                              msgOtpController.sendOtp(mobile: signupController.countryCode + signupController.mobile.text).then((value) {
                                if (value["Result"] == "true") {
                                  Get.toNamed(Routes.otpScreen, arguments: {
                                    "number": signupController.mobile.text,
                                    "cuntryCode": signupController.countryCode,
                                    "route": "signupScreen",
                                    "otpCode": value["otp"].toString(),
                                  });
                                } else {
                                  isGetNavigate = false;
                                  setState(() {});
                                  showToastMessage('Invalid Mobile Number'.tr);
                                }
                              });

                            } else if(msgtype["SMS_TYPE"] == "Twilio"){
                              isGetNavigate = true;
                              setState(() {});
                              msgOtpController.twilloOtp(mobile: signupController.countryCode + signupController.mobile.text).then((value) {
                                if (value["Result"] == "true") {
                                  Get.toNamed(Routes.otpScreen, arguments: {
                                    "number": signupController.mobile.text,
                                    "cuntryCode": signupController.countryCode,
                                    "route": "signupScreen",
                                    "otpCode": value["otp"]
                                  });

                                } else {
                                  isGetNavigate = false;
                                  setState(() {});
                                  showToastMessage('Invalid Mobile Number'.tr);
                                }
                              });
                            }

                          }
                        },);
                      } else {
                        showToastMessage("Please enter password correctly!!");
                      }
                  } else {
                    showToastMessage(value["ResponseMsg"]);
                  }
                             });
              } else {
                showToastMessage("Please fill the all field!!");
              }
          },),
          SizedBox(height: 10,),
          mainButton(context: context, txt1: "Continue with Guest", selected: true, containcolor: notifier.getWhiteblackColor, onPressed1: () {
            Get.offAllNamed(Routes.chooseLocation, arguments: {
              "route" : Routes.loginScreen,
            });
          },),
          SizedBox(height: isSignup ? 30 : height/20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ",style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 18),),
              GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.loginScreen);
                  },
                  child: Text("Login", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: PurpleColor, fontWeight: FontWeight.w700, fontSize: 18),)),
            ],
          ),
          SizedBox(height: 20),
        ],
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

  Widget nameFeild(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text("First Name", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        SizedBox(height: 8),
        textFeild (validMsg: "Please fill the name field.", textController: signupController.fnameCont, textInputType: TextInputType.name, context: context, hinttext: "Enter your First Name",),
        SizedBox(height: 8),
        Text("Email", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        SizedBox(height: 8),
        textFeild(validMsg: "Please fill the email field.", textController: signupController.email, textInputType: TextInputType.name, context: context, hinttext: "Enter your Email",),
      ],
    );
  }

  Widget passField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text("Password", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        SizedBox(height: 8),
        passTextFeild (validMsg: "Please fill the password field.", focusnode: focusNode, textInputType: TextInputType.visiblePassword, textController: signupController.passCont, context: context, hinttext: "Enter your password", suffixIcon: "assets/notVisible.png", suffix2: "assets/visible.png"),
        SizedBox(height: 8),
        Text("Confirm Password", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        SizedBox(height: 8),
        passTextFeild(validMsg: "Please fill the re-password field.",focusnode: focusNode2, textInputType: TextInputType.visiblePassword, textController: signupController.repassCont, context: context, hinttext: "Enter your password", suffixIcon: "assets/notVisible.png", suffix2: "assets/visible.png"),
        SizedBox(height: 8),
        Text("Refrence Code", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        SizedBox(height: 8),
      ],
    );
  }

  Widget signupwith(){
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 2,
              child: Divider(
                color: GreyColor,
                thickness: 1,
              ),
            ),
            SizedBox(width: 10,),
            Text("Or continue with", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontWeight: FontWeight.w600),),
            SizedBox(width: 10,),
            Expanded(
              flex: 2,
              child: Divider(
                color: GreyColor,
                thickness: 1,
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: isSignup ? 30 : height/20,),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                elevation: WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(side: BorderSide(color: BlackColor), borderRadius: BorderRadius.circular(26)),
                )
            ),
            onPressed: () {

            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/googleLogo.png", height: 25,),
                  SizedBox(width: 10,),
                  Text("Continue with Google", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700, color: BlackColor, fontSize: 18, letterSpacing: 0.5),),
                ],
              ),
            )),
        SizedBox(height: 20,),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                elevation: WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(side: BorderSide(color: BlackColor), borderRadius: BorderRadius.circular(26)),
                )
            ),
            onPressed: () {

            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/appleLogo.png", height: 25,),
                  SizedBox(width: 10,),
                  Text("Continue with Apple", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700, color: BlackColor, fontSize: 18, letterSpacing: 0.5),),
                ],
              ),
            )),
        SizedBox(height: height/15,),
      ],
    );
  }

  Widget appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: GestureDetector(
        onTap: () {
          setState(() {
            isSignup = false;
          });
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backGrey,
            shape: BoxShape.circle,
          ),
          child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
        ),
      ),
      title: Text("Sign Up", style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
      centerTitle: true,
    );
  }
}
