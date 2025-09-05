import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sellify/controller/forgotpass_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/utils/colors.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {

  TextEditingController resetPassCont = TextEditingController();
  TextEditingController reResetPassCont = TextEditingController();

  ForgotpassController forgotpassController = Get.put(ForgotpassController());

  String mobile = Get.arguments["mobile"];
  String ccode = Get.arguments["ccode"];

  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();

  bool isGetnavigate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appbar(),
                const SizedBox(height: 30,),
                Center(child: Text("Create a\nNew Password", style: TextStyle(fontSize: 24, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,letterSpacing: 1),textAlign: TextAlign.center,)),
                const SizedBox(height: 10,),
                Center(
                  child: Text("Enter your new Password",style: TextStyle(fontSize: 16, color: GreyColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 1, height: 1.5),textAlign: TextAlign.center,),
                ),
                const SizedBox(height: 40),
                passField(),
                const SizedBox(height: 40),
                GetBuilder<ForgotpassController>(
                  builder: (forgotpassController) {
                    return mainButton(txt1: "Continue".tr, loading: isGetnavigate, context: context, containcolor: PurpleColor, onPressed1: () {
                      if (resetPassCont.text == reResetPassCont.text && reResetPassCont.text.isNotEmpty && reResetPassCont.text.isNotEmpty) {
                        isGetnavigate = true;
                        setState(() {});
                        forgotpassController.forgotPassword(mobile: mobile, ccode: ccode, password: resetPassCont.text).then((value) {
                          if(value["Result"] == "true") {
                            showToastMessage(value["ResponseMsg"]);
                            forgotpassController.isloading ? const CircularProgressIndicator() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Loginscreen(),));
                          } else {
                            isGetnavigate = false;
                            setState(() {});
                            forgotpassController.isloading ? const CircularProgressIndicator() : showToastMessage(value["ResponseMsg"]);
                          }
                        },);
                      } else {
                        showToastMessage("Please enter password correctly!!");
                      }
                      }
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget passField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text("Password", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        const SizedBox(height: 8),
        passTextFeild(focusnode: focusNode, textInputType: TextInputType.visiblePassword, textController: resetPassCont, context: context, hinttext: "Enter your password", suffixIcon: "assets/notVisible.png", suffix2: "assets/visible.png"),
        const SizedBox(height: 8),
        Text("Confirm Password", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16, fontWeight: FontWeight.w600),),
        const SizedBox(height: 8),
        passTextFeild(focusnode: focusNode2, textInputType: TextInputType.visiblePassword, textController: reResetPassCont, context: context, hinttext: "Enter your password", suffixIcon: "assets/notVisible.png", suffix2: "assets/visible.png"),
      ],
    );
  }

  Widget appbar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: InkWell(
        onTap: () {
          Get.offAll(const Loginscreen(), transition: Transition.noTransition);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
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
