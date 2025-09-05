import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/controller/signup_controller.dart';
import 'package:sellify/helper/appbar_screen.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/auth_screens/forgot_pass.dart';
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/signupscreen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:sellify/utils/mq.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_config/config.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  late ColorNotifire notifier;

  LoginController loginController = Get.put(LoginController());
  SignupController signupController = Get.put(SignupController());

  String buttonText = "Continue with Mobile Number";
  bool isSignin = false;
  bool isRadioOn = false;
  FocusNode focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: kIsWeb ? notifier.getBgColor : PurpleColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Form(
             key: _formKey,
            child: kIsWeb ? Column(
              children: [
                kIsWeb ? SizedBox(height: 75, child: CommonAppbar()) : const SizedBox(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          color: PurpleColor,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100, bottom: 50),
                            child: Column(
                              children: [
                                Center(child: Text("Hi, Welcome Back! 🖐", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 24, color: WhiteColor, fontWeight: FontWeight.w700, letterSpacing: 1), textAlign: TextAlign.center,)),
                                const SizedBox(height: 10,),
                                Center(child: Text("Log in and explore endless possibilities!", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: WhiteColor), textAlign: TextAlign.center,)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 210),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 45),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20,),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: notifier.getBgColor,
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                                  ),
                                  child: 750 < constraints.maxWidth ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Expanded(
                                              flex: 1200 > constraints.maxWidth ? 2 : 1,
                                              child: loginWidgets()
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                                        child: footer(context),
                                      ),
                                      const SizedBox(height: 50,),
                                    ],
                                  ) : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        loginWidgets(),
                                        kIsWeb ? Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                                          child: footer(context),
                                        ) : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: WhiteColor,
                                        shape: BoxShape.circle
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: Image.asset("assets/sellifyLogo.png", height: 80,)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ) : Column(
              children: [
                kIsWeb ? SizedBox(
                  height: 75,
                    child: CommonAppbar()) : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 50),
                  child: Column(
                    children: [
                      Center(child: Text("Hi, Welcome Back! 🖐", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 24, color: WhiteColor, fontWeight: FontWeight.w700, letterSpacing: 1), textAlign: TextAlign.center,)),
                      const SizedBox(height: 10,),
                      Center(child: Text("Log in and explore endless possibilities!", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: WhiteColor), textAlign: TextAlign.center,)),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                             color: notifier.getBgColor,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                          ),
                          child: 750 < constraints.maxWidth ? Column(
                            children: [
                              Row(
                              children: [
                                const Spacer(),
                                Expanded(
                                  flex: 1200 > constraints.maxWidth ? 2 : 1,
                                    child: loginWidgets()
                                ),
                                const Spacer(),
                              ],
                              ),
                              const SizedBox(height: 50,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 300 : 1200 < constraints.maxWidth ? 100 : 20),
                                child: footer(context),
                              ),
                            ],
                          ) : SingleChildScrollView(
                            child: Column(
                              children: [
                                loginWidgets(),
                                kIsWeb ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 300 : 1200 < constraints.maxWidth ? 100 : 20),
                                  child: footer(context),
                                ) : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            decoration: BoxDecoration(
                                color: WhiteColor,
                                shape: BoxShape.circle
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Image.asset("assets/sellifyLogo.png", height: 80,)),
                      ),
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

  bool getVal = false;
  Widget loginWidgets(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height/20,),
        Text("Mobile", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        const SizedBox(height: 10,),
        IntlPhoneField(
          autofocus: true,
          style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
          controller: loginController.mobile,
          onChanged: (value) {
            loginController.countryCode = value.countryCode;
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
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
          ),
        ),
        SizedBox(height: isSignin ? 10 : 0,),
        isSignin ?
        Text("Password", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),) : const SizedBox(),
        SizedBox(height: isSignin ? 10 : 0,),
        isSignin ?
        passTextFeild(validMsg: "Please enter the password!!", focusnode: focusNode, textInputType: TextInputType.visiblePassword, textController: loginController.password, context: context, hinttext: "Enter your password", suffixIcon: "assets/notVisible.png", suffix2: "assets/visible.png") : const SizedBox(),
        SizedBox(height: isSignin ? 10 : 0,),
        isSignin ? Row(
          children: [
            Row(
              children: [
                Checkbox(
                  side: BorderSide(color: lightGreyColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  activeColor: PurpleColor,
                  value: isRadioOn,
                  onChanged: (value) async {
                    setState(() {
                      isRadioOn = value!;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    if (isRadioOn) {
                      await prefs.setBool('Remember', true);
                    } else {
                      await prefs.setBool('Remember', false);
                    }
                  },),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isRadioOn = !isRadioOn;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    if (isRadioOn) {
                      await prefs.setBool('Remember', true);
                    } else {
                      await prefs.setBool('Remember', false);
                    }
                  },
                    child: Text("Remember Me", style: TextStyle(color: GreyColor, fontFamily: FontFamily.gilroyRegular, fontSize: 16, letterSpacing: 1, fontWeight: FontWeight.w700)))
              ],
            ),
            const Spacer(),
            InkWell(
                onTap: () => Get.to(const ForgotPassword(), transition: Transition.noTransition),
                child: Text("Forgot Password", style: TextStyle(fontFamily: FontFamily.gilroyRegular, fontWeight: FontWeight.w700, fontSize: 16, color: redColor),))
          ],
        ) : const SizedBox(),
        const SizedBox(height: 30,),
        mainButton(containcolor: PurpleColor, context: context, loading: getVal, txt1: buttonText, onPressed1: () {

          if (_formKey.currentState!.validate()) {
            if (loginController.mobile.text.isNotEmpty) {
              getVal = true;
              setState(() {});
              signupController.checkMobileNumber(mobilenumber: loginController.mobile.text, countrycode: loginController.countryCode).then((value) {
                if (value != null) {
                  getVal = false;
                  if(value["Result"] == "false"){
                    if(isSignin == false){
                      setState(() {
                        isSignin = true;
                        buttonText = "Sign In";
                      });
                    } else {
                      getVal = true;
                      setState(() {});
                      loginController.getLoginData(context).then((value) {
                        if(value == "true"){
                          initPlatformState();
                          Get.offAll(const Chooselocation(), transition: Transition.noTransition, arguments: {
                            "route" : Routes.loginScreen,
                          });
                        } else {
                          getVal = false;
                          setState(() {});
                        }
                      },);
                    }
                  } else {
                    getVal = false;
                    setState(() {});
                    showToastMessage("Mobile number or Password is incorrect!!");
                  }
                } else {
                  getVal = false;
                  setState(() {});
                  showToastMessage("Something went wrong!");
                }
              },);
              getVal = false;
              setState(() {});
            } else {
              showToastMessage("Please enter the mobile number!!");
            }
          } else {
            showToastMessage("Please fill the all field!!");
          }
        },),
        const SizedBox(height: 10,),
        mainButton(context: context, txt1: "Continue with Guest", selected: true, containcolor: notifier.getWhiteblackColor, onPressed1: () {
          Get.offAllNamed(Routes.chooseLocation, arguments: {
            "route" : Routes.loginScreen,
          });
        },),
        SizedBox(height: isSignin ? 30 : 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? ",style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 18),),
            InkWell(
                onTap: () {
                  Get.to(const Signupscreen(), transition: Transition.noTransition);
                },
                child: Text("Sign Up",style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: PurpleColor, fontWeight: FontWeight.w700, fontSize: 18),)),
          ],
        ),
      ],
    );
  }
  Widget appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: InkWell(
        onTap: () {
          setState(() {
            isSignin = false;
            buttonText = "Continue with Mobile Number";
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backGrey,
            shape: BoxShape.circle,
          ),
          child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
        ),
      ),
      title: Text("Sign In", style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
      centerTitle: true,
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(Config.onesignalKey);
    OneSignal.Notifications.requestPermission(true).then((value) {
    },);
  }

}
