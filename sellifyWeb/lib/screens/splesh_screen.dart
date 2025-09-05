
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/home_screen.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/screens/onboardingscreen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/routes_helper.dart';
import '../utils/dark_lightMode.dart';

var androidinId = "";
var iosinId = "";

var androidBannerid = "";
var iosBannerid = "";

var androidNativeid = "";
var iosNativeid = "";

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
        kIsWeb ? (getData.read("UserLogin") == null ? Get.offAll(const Chooselocation(), arguments: {
          "route" : Routes.loginScreen,
        }) : getNavigateBottom())
          : prefs.getBool('Firstuser') != true
        ? Navigator.push(context, screenTransRight(routes: const OnBoardingscreen(), context: context))
         : prefs.getBool('Remember') != true
           ? Navigator.push(context, screenTransRight(routes: const Loginscreen(), context: context))
           : getNavigateBottom();
      },
    );
  }



  getNavigateBottom() async {
    homedataCont.gethomedata();
    categoryListCont.categoryList();

    smsTypeCont.smstype().then((value) {
        if (smsTypeCont.smstypeData != null) {
          setState(() {
            androidinId = smsTypeCont.smstypeData!.inId.toString();
            iosinId = smsTypeCont.smstypeData!.iosInId.toString();
            androidBannerid = smsTypeCont.smstypeData!.bannerId.toString();
            iosBannerid = smsTypeCont.smstypeData!.iosBannerId.toString();
            androidNativeid = smsTypeCont.smstypeData!.nativeAd.toString();
            iosNativeid = smsTypeCont.smstypeData!.iosNativeAd.toString();
          });
          Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen());
        }
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
                const SizedBox(width: 10,),
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


  if (kIsWeb == false && Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int androidVersion = androidInfo.version.sdkInt;
    save("androidversion", androidVersion);
  }
}



 Future requestStoragePermission() async {

   if (Platform.isAndroid) {
     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
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