import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/commonpost_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class Adcommonpost extends StatefulWidget {
  const Adcommonpost({super.key});

  @override
  State<Adcommonpost> createState() => _AdcommonpostState();
}

class _AdcommonpostState extends State<Adcommonpost> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("SBCAT I D > $subcatID");
    setState(() {
      if(postingType == "Edit") {
        adindex = Get.arguments["adIndex"];
        commonPostCont.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle!;
        commonPostCont.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription!;
      } else {
        commonPostCont.adTitle.text = "";
        commonPostCont.description.text = "";
      }
    });
  }

  CommonPostController commonPostCont = Get.find();
  MyadlistController myadlistCont = Get.find();
  String subcatID = Get.arguments["subcatId"];
  String postingType = Get.arguments["postingType"];
  int adindex = 0;

  final _formKey = GlobalKey<FormState>();

  late ColorNotifire notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getWhiteblackColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Include some details".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(context: context, txt1: "Next".tr, containcolor: PurpleColor, onPressed1: () {
          if (_formKey.currentState!.validate()) {
            Get.toNamed(Routes.addImages, arguments: {
              "subcatId" : subcatID,
              "adIndex" : adindex,
              "postingType" : postingType,
            });
          }
        },),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: commonPostCont.adTitle,
                  maxLength: 70,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return '${"Please edit the field.".tr}\n${"atleast 10 characters are required.".tr}';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: notifier.textfield,
                    hintText: "Ad Title *".tr,
                    hintStyle: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                    helperText: "${"Mention the lwy features of your item".tr} (e.g. ${"brand".tr},\n${"model, age, type.".tr})",
                    helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
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
                SizedBox(height: 15,),
                TextFormField(
                  controller: commonPostCont.description,
                  maxLength: 2000,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return '${"Please edit the field.".tr}\n${"atleast 10 characters are required.".tr}';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: notifier.textfield,
                    hintText: "Describe what you are selling *".tr,
                    hintStyle: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                    helperText: "Include condition, features and reason for selling".tr,
                    helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
