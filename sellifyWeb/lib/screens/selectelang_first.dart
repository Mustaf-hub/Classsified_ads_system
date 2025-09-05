import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import 'chooselocation.dart';

class SelectelangFirst extends StatefulWidget {
  const SelectelangFirst({super.key});

  @override
  State<SelectelangFirst> createState() => _SelectelangFirstState();
}

class _SelectelangFirstState extends State<SelectelangFirst> {

  late ColorNotifire notifier;

  bool isDroped = false;

  List languages = [
    "English (UK)",
    "English",
    "Bahasa Indonesia",
    "Chineses",
    "Croatain",
    "Czech",
    "Danish",
    "Filipino",
    "Finland"
  ];
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDroped ? appBar() : const SizedBox(),
                  isDroped ? const SizedBox() : Center(child: Text("Select your Language", style: TextStyle(fontSize: 24, color: BlackColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,letterSpacing: 1),)),
                  SizedBox(height: isDroped ? 0 : 10,),
                  isDroped ? const SizedBox() : Center(
                    child: Text("Select the language which you like.",style: TextStyle(fontSize: 16, color: GreyColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 1, height: 1.5),textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: isDroped ? 0 : 30),
                  isDroped ? const SizedBox() : Text("Language", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),),
                  const SizedBox(height: 20,),
                  isDroped ? const SizedBox() : InkWell(
                    onTap: () {
                      setState(() {
                        isDroped = true;
                      });
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: textFieldInput,
                          borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang.isNotEmpty ? lang : "Select", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 18, color: lang.isNotEmpty ? notifier.getTextColor : lightGreyColor,),),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: lightGreyColor,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  isDroped ? langDropdown() : const SizedBox(),
                ],
              ),
              isDroped ? const SizedBox() : const Spacer(),
              isDroped ? const SizedBox() : mainButton(txt1: "Continue".tr, context: context, containcolor: PurpleColor, onPressed1: () => Get.to(const Chooselocation(), transition: Transition.noTransition,),),
            ],
          ),
        ),
      ),
    );
  }

  int? selectedLang;
  String lang = "";
  Widget langDropdown(){
    return ListView.builder(
      itemCount: languages.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedLang = index;
              lang = languages[index];
            });
            isDroped = false;
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: selectedLang == index ? PurpleColor : lightGreyColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: selectedLang == index ? PurpleColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: selectedLang == index ? Colors.transparent : lightGreyColor),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: SvgPicture.asset("assets/checkIcon.svg", height: 17,),
                  ),
                  const SizedBox(width: 10,),
                  Text(languages[index], style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 1,),)
                ],
              ),
            ),
          ),
        ),
      );
    },);
  }

  Widget appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: InkWell(
        onTap: () {
          setState(() {
            isDroped = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backGrey,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close_rounded, color: BlackColor,),
        ),
      ),
      title: Text("Select a Language", style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
      centerTitle: true,
    );
  }

}
