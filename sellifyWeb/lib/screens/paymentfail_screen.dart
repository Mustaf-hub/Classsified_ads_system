import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import 'bottombar_screen.dart';
import 'home_screen.dart';

class PaymentfailScreen extends StatefulWidget {
  const PaymentfailScreen({super.key});

  @override
  State<PaymentfailScreen> createState() => _PaymentfailScreenState();
}

class _PaymentfailScreenState extends State<PaymentfailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(child: Image.asset("assets/paymentFailed.png", height: 300,)),
                  const SizedBox(height: 50,),
                  Text("Your payment got failed.".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Try again after few minutes. For enquiry regarding to payment send Email.".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
                  const Spacer(),
                  mainButton(containcolor: PurpleColor, txt1: "Home".tr, context: context, onPressed1: () async {
                    Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen());
                  },),
                ],
              ),
            );
          }
      ),
    );
  }
}
