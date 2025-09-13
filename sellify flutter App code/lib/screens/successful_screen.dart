import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/addfav_controller.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/utils/colors.dart';

import '../helper/c_widget.dart';
import '../utils/dark_lightMode.dart';
import 'home_screen.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({super.key});

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {

  late ColorNotifire notifier;

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(child: Image.asset("assets/Success.png", height: 300,)),
            SizedBox(height: 50,),
            Text("Your Post has been successfully posted.".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
            SizedBox(
              height: 10,
            ),
           Text("Will be visible shortly. Get ready to connect with buyers and sell faster!".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
           Spacer(),
            mainButton(containcolor: PurpleColor, txt1: "Home".tr, context: context, onPressed1: () async {
              Get.offAll(kIsWeb ? HomePage() : const BottombarScreen());
            },),
          ],
        ),
      ),
    );
  }
}
