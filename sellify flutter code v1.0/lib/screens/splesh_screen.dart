
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/controller/msg_otp_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/screens/home_screen.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/screens/onboardingscreen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/dark_lightMode.dart';

var android_in_id = "";
var ios_in_id = "";

var android_bannerid = "";
var ios_bannerid = "";

var android_nativeid = "";
var ios_nativeid = "";

class SpleshScreen extends StatefulWidget {
  const SpleshScreen({super.key});

  @override
  State<SpleshScreen> createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {

  ColorNotifire notifier = ColorNotifire();




  @override
  initState() {

    // TODO: implement initState
    super.initState();
    print("ASDADADA SDA ASD A  DFAS  A");
    getColor();
    loadScreen();
    androidVersion();
  }

  Future<void> getColor() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("isDark");
    if (previusstate == null) {
      notifier.setIsDark(false);
      setState(() {});
    } else {
      print("PREVIEW $previusstate");
      notifier.setIsDark(previusstate);
      setState(() {});
    }
  }

  CategoryListController categoryListCont = Get.find();
  HomedataController homedataCont = Get.find();
  MsgOtpController smsTypeCont = Get.find();

  loadScreen() async {
    final prefs = await SharedPreferences.getInstance();

    await Future.delayed(
      const Duration(
      seconds: 3,
    ), () {
        prefs.getBool('Firstuser') != true
        ? Navigator.push(context, ScreenTransRight(routes: OnBoardingscreen(), context: context))
         : prefs.getBool('Remember') != true
           ? Navigator.push(context, ScreenTransRight(routes: Loginscreen(), context: context))
           : getNavigateBottom();
      },
    );
  }



  getNavigateBottom(){
    homedataCont.gethomedata();
    categoryListCont.categoryList();

    smsTypeCont.smstype().then((value) {
        if (smsTypeCont.smstypeData != null) {
          setState(() {
            android_in_id = smsTypeCont.smstypeData!.inId.toString();
            ios_in_id = smsTypeCont.smstypeData!.iosInId.toString();
            android_bannerid = smsTypeCont.smstypeData!.bannerId.toString();
            ios_bannerid = smsTypeCont.smstypeData!.iosBannerId.toString();
            android_nativeid = smsTypeCont.smstypeData!.nativeAd.toString();
            ios_nativeid = smsTypeCont.smstypeData!.iosNativeAd.toString();
          });
        }
        Get.offAll(kIsWeb ? HomePage() : const BottombarScreen());
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/sellifyLogo.png", height: 50,),
                SizedBox(width: 10,),
                Text("Sellify", style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 30, color: BlackColor),),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

Future locationPermission() async {

   await Geolocator.checkPermission();
   await Geolocator.requestPermission();
}

Future<void> androidVersion() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (kIsWeb == false && Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(">>>>>>>>>>>>>>>>${androidInfo.version.sdkInt}");
    int androidVersion = androidInfo.version.sdkInt;
    save("androidversion", androidVersion);
  }
}



 Future requestStoragePermission() async {

   if (Platform.isAndroid) {
     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
     print(">>>>>>>>>>>>>>>>${androidInfo.version.sdkInt}");
     int androidVersion = androidInfo.version.sdkInt;
     if(androidVersion > 32){
       await Permission.photos.request();
     } else if(androidVersion <= 32){
       await Permission.storage.request();
     }
   } else if(Platform.isIOS) {
     await PhotoManager.requestPermissionExtend();
   }
}