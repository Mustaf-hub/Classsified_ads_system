import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/screens/home_screen.dart';

import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';
import 'bottombar_screen.dart';

class Featureadded extends StatelessWidget {
  Featureadded({super.key});

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
            Text("Your Ad has been successfully Featured.".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
            SizedBox(
              height: 10,
            ),
            Text("Your ad is live now with features. ready to attract buyers and sell faster!".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
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
