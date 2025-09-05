import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../api_config/store_data.dart';
import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../utils/dark_lightMode.dart';

bool rtl = false;
class LanguageTrans extends StatefulWidget {
  const LanguageTrans({super.key});

  @override
  State<LanguageTrans> createState() => _LanguageTransState();
}

class _LanguageTransState extends State<LanguageTrans> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedIndex = getData.read("lanValue") ?? 0;
    });
  }

  late ColorNotifire notifier;

  List langCount = [
    "assets/US.png",
    "assets/ES.png",
    "assets/AE.png",
    "assets/IN.png",
    "assets/IN.png",
    "assets/ZA.png",
    "assets/IN.png",
    "assets/ID.png",
  ];

  final List locale = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Español', 'locale': const Locale('es', 'ES')},
    {'name': 'عربى', 'locale': const Locale('ar', 'AE')},
    {'name': 'हिंदी', 'locale': const Locale('hi', 'IN')},
    {'name': 'ગુજરાતી', 'locale': const Locale('gj', 'GJ')},
    {'name': 'Afrikaans', 'locale': const Locale('af', 'AF')},
    {'name': 'বাংলা', 'locale': const Locale('bn', 'BN')},
    {'name': 'Indonesian', 'locale': const Locale('id', 'ID')},
  ];

  getupdateLang(Locale localeLang){
    Get.updateLocale(localeLang);
    Get.back(result: {"lang" : locale[selectedIndex]["name"]});
  }
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: (() async => true),
      child: Scaffold(
        backgroundColor: notifier.getBgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: notifier.getWhiteblackColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Get.back(
                    result: {
                     "lang" : locale[selectedIndex]["name"]
                });
              },
              child: Icon(
                Icons.arrow_back,
                color: notifier.getTextColor,
              ),
            ),
          ),
          title: Text("Choose Language".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
          centerTitle: true,
        ),
        body: ScrollConfiguration(
          behavior: CustomBehavior(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: langCount.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10,);
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      if(selectedIndex == 2){
                        rtl = true;
                      } else {
                        rtl = false;
                      }
                      print("RTL $rtl");
                      save("lanValue", selectedIndex);
                      save("language", locale[index]["name"]);
                      getupdateLang(locale[index]["locale"]);
                      save("lCode", locale[index]['locale'].toString());
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: notifier.borderColor),
                      color: notifier.getWhiteblackColor
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                         borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 40,
                            width: 60,
                            child: Image.asset(langCount[index], fit: BoxFit.cover,),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text(locale[index]["name"], style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
                        Spacer(),
                        Radio(
                          value: index,
                          fillColor: WidgetStatePropertyAll(notifier.iconColor),
                          groupValue: selectedIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedIndex = value!;
                              if(selectedIndex == 2){
                                rtl = true;
                              } else {
                                rtl = false;
                              }
                              print("RTL $rtl");
                              save("lanValue", selectedIndex);
                              getupdateLang(locale[index]["locale"]);
                              save("lCode", locale[index]['locale'].toString());
                            });
                        },)
                      ],
                    ),
                  ),
                );
            },),
          ),
        ),
      ),
    );
  }
}
