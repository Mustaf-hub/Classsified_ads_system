import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/utils/colors.dart';

import '../utils/dark_lightMode.dart';

class OnBoardingscreen extends StatefulWidget {
  const OnBoardingscreen({super.key});

  @override
  State<OnBoardingscreen> createState() => _OnBoardingscreenState();
}

class _OnBoardingscreenState extends State<OnBoardingscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageController = PageController(initialPage: currentPage);
  }

  late ColorNotifire notifier;

  List onboardTitle = [
    "Discover Local Treasures!",
    "List your items in seconds!",
    "Your safety, our priority!"
  ];

  List onboardsubTitle = [
    "Introduce users to the convenience of discovering items for sale, services.",
    "Showcase the ease and speed of listing items for sale emphasize intuitive features.",
    "Highlight app features like verified profiles, secure payment options, and robust reporting."
  ];

  int currentPage = 0;

  List backLottie = [
    "assets/lotti1.json",
    "assets/lotti2.json",
    "assets/lotti3.json"
  ];


  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: PurpleColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: PageView.builder(
                    itemCount: backLottie.length,
                    controller: pageController,
                    onPageChanged: (value) {
                      _handlingOnPageChanged(page: value);
                    },
                    itemBuilder: (context, index) {
                      return Center(child: Lottie.asset(backLottie[index]));
                    },),
                ),
              ),
              Container(
                height: 350,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: notifier.getWhiteblackColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35)
                    ),
                ),
                padding: EdgeInsets.symmetric(horizontal: currentPage == 2 ? 30 : 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    onboarding(),
                    Spacer(),
                    currentPage == 2 ? (750 < constraints.maxWidth ? Row(
                      children: [
                        Spacer(),
                        Expanded(flex: 1200 > constraints.maxWidth ? 2 : 1, child: mainButton(context: context,txt1: "Get Started", containcolor: PurpleColor, onPressed1: () => Get.offAll(Loginscreen()),)),
                        Spacer(),
                      ],
                    ) : SizedBox(
                        width: double.infinity,
                        child: mainButton(context: context,txt1: "Get Started", containcolor: PurpleColor, onPressed1: () => Get.offAll(Loginscreen()),)
                    )) : _buildPageIndicator(),
                    Spacer(),
                    currentPage == 2 ? SizedBox() : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState((){
                                pageController.animateToPage(2,
                                    duration: const Duration(microseconds: 300),
                                    curve: Curves.easeIn);
                              });
                            },
                            child: Text("Skip", style: TextStyle(fontSize: 14, color: GreyColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700),)),
                        GestureDetector(
                          onTap: () {
                            setState((){
                              pageController.nextPage(duration: const Duration(microseconds: 300),
                                  curve: Curves.easeIn);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PurpleColor
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/arrow-right.png", height: 25, color: WhiteColor,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    currentPage == 2 ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GreyColor, fontFamily: FontFamily.gilroyMedium),),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.signupScreen);
                            },
                            child: Text("Register", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PurpleColor, fontFamily: FontFamily.gilroyMedium),))
                      ],
                    ) : SizedBox(),
                    Spacer(),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget onboarding(){
   return StatefulBuilder(
     builder: (context, setState) {
       return Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(onboardTitle[currentPage],
               style: TextStyle(fontSize: 28, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),
               textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
           SizedBox(height: 20,),
           Text(onboardsubTitle[currentPage],
             style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 15),textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
         ],
       );
     }
   );
  }
  _handlingOnPageChanged({required int page}) {
    setState(() {
      currentPage = page;
    });
  }
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < onboardTitle.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != onboardTitle.length - 1) {
        row.children.add(
          const SizedBox(
            width: 10,
          ),
        );
      }
    }
    return row;
  }
  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == currentPage ? 27 : 9,
      height: index == currentPage ? 8 : 8,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          color: index == currentPage ? PurpleColor : lightGreyColor),
    );
  }
}
