import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/editprofilecontroller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/model/routes_helper.dart';

import '../api_config/store_data.dart';
import '../controller/imageupload_controller.dart';
import '../helper/appbar_screen.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = getData.read("UserLogin")["name"] ?? "";
    email.text = getData.read("UserLogin")["email"] ?? "";
    password.text = getData.read("UserLogin")["password"] ?? "";
    number.text = getData.read("UserLogin")["mobile"] ?? "";
    ccode = getData.read("UserLogin")["ccode"] ?? "";

    imageuploadCont.imageFile = null;
  }

  late ColorNotifire notifier;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();
  String ccode = "";

  FocusNode focusNode = FocusNode();

  ImageuploadController imageuploadCont = Get.put(ImageuploadController());

  ProfileEditController profileEditCont = Get.find();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: (() async => true),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                backgroundColor: notifier.getBgColor,
                bottomNavigationBar: kIsWeb ? const SizedBox() : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    color: notifier.getBgColor,
                    padding: const EdgeInsets.all(20),
                    child: mainButton(context: context, txt1: "Update Profile".tr, containcolor: PurpleColor, onPressed1: () {
                      profileEditCont.getEditprofile(userName: name.text, email: email.text, password: password.text).then((value) {
                        if(value["Result"] == "true"){
                          setState(() {
                            save("UserLogin", value["UserLogin"]);
                          });

                          Get.to(const Profilescreen(), transition: Transition.noTransition);
                        } else {
                          showToastMessage(value["ResponseMsg"]);
                        }
                      },);
                    },),
                  ),
                ),
                appBar: kIsWeb ? PreferredSize(
                    preferredSize: const Size.fromHeight(125),
                    child: CommonAppbar(title: "My Profile".tr, fun: () {
                      Get.back();
                    },)) : AppBar(
                  centerTitle: true,
                  backgroundColor: notifier.getWhiteblackColor,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: notifier.iconColor,
                    ),
                  ),
                  title: Text(
                    "My Profile".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Gilroy Medium',
                      color: notifier.getTextColor,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(color: PurpleColor, height: 200,),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 45),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: notifier.getBgColor,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 70,),
                                          textFeild (textController: name, textInputType: TextInputType.name, context: context, hinttext: "Enter your First Name",),
                                          const SizedBox(height: 10,),
                                          textFeild (textController: email, textInputType: TextInputType.name, context: context, hinttext: "Enter your First Name",),
                                          const SizedBox(height: 10,),
                                          passTextFeild(focusnode: focusNode, textInputType: TextInputType.visiblePassword, textController: password, context: context, hinttext: "Enter your password", suffixIcon: "assets/notVisible.png", suffix2: "assets/visible.png"),
                                          const SizedBox(height: 10,),
                                          TextField(
                                            style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                                            controller: number,
                                            readOnly: true,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: notifier.textfield,
                                              hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(16),
                                                borderSide: const BorderSide(color: Colors.transparent),
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
                                        ],
                                      ),
                                    ),
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
                                              image: DecorationImage(fit: BoxFit.fitHeight, image: imageuploadCont.imageFile != null ? FileImage(imageuploadCont.imageFile!) : getData.read("UserLogin")["profile_pic"] != null ? NetworkImage(Config.imageUrl + getData.read("UserLogin")["profile_pic"]) : const AssetImage("assets/sellifyLogo.png"), scale: 20)
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
                                      imageuploadCont.openGallery(screenRoute: Routes.accountScreen).then((value) {
                                        setState(() {});
                                      },);
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
                            kIsWeb ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 15),
                              child: Container(
                                color: notifier.getBgColor,
                                padding: const EdgeInsets.all(20),
                                child: mainButton(context: context, txt1: "Update Profile".tr, containcolor: PurpleColor, onPressed1: () {
                                  profileEditCont.getEditprofile(userName: name.text, email: email.text, password: password.text).then((value) {
                                    if(value["Result"] == "true"){
                                      setState(() {
                                        save("UserLogin", value["UserLogin"]);
                                      });
                                      Get.to(const Profilescreen());
                                    } else {
                                      showToastMessage(value["ResponseMsg"]);
                                    }
                                  },);
                                },),
                              ),
                            ) : const SizedBox(),
                            const SizedBox(height: kIsWeb ? 10 : 0,),
                            kIsWeb ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                              child: footer(context),
                            ) : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}
