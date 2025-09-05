import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/carbrandlist_controller.dart';
import 'package:sellify/controller/carvariation_controller.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/repub_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/myads_view.dart';
import 'package:sellify/screens/payment_gateway/card_formater.dart';
import 'package:sellify/screens/payment_gateway/payment_card.dart';
import 'package:sellify/screens/payment_gateway/razorpay_screen.dart';
import 'package:sellify/screens/payment_gateway/webview_screen.dart';
import 'package:sellify/screens/successful_screen.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/listpackage_controller.dart';
import '../controller/login_controller.dart';
import '../controller/makefeature_controller.dart';
import '../controller/marksold_controller.dart';
import '../controller/paymentgaeway_cont.dart';
import '../controller/paystackcontroller.dart';
import '../controller/walletreport_controller.dart';
import '../helper/appbar_screen.dart';
import '../helper/web_payment_controller.dart';
import 'StripeWeb.dart';

class MyadsScreen extends StatefulWidget {
  const MyadsScreen({super.key});

  @override
  State<MyadsScreen> createState() => _MyadsScreenState();
}

class _MyadsScreenState extends State<MyadsScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    razorpayScreen.initiateRazorpay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);
  }
  late ColorNotifire notifier;

  MyadlistController myadlistCont = Get.find();
  CarbrandlistController carbrandlistCon = Get.find();
  CarvariationController carvariationCont = Get.find();
  CategoryListController subcategoryCont = Get.find();
  MarkSoldController markSoldCont = Get.find();

  List mark = [
    "Sold InSide",
    "Sold OutSide"
  ];

  int selectedMark = 0;

  bool isMakeFeature = false;

  var numberController = TextEditingController();

  PaystackController paystackCont = Get.find();
  PaymentgaewayController paymentgaewayCont = Get.find();
  WalletreportController walletreportCont = Get.find();
  ListpackageController listpackageCont = Get.find();
  RepubController repubCont = Get.find();
  MakeFeatureController makeFeatureCont = Get.find();
  WebPaymentController webPaymentCont = Get.find();

  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;

  final _paymentCard = PaymentCardCreated();
  final _card = PaymentCardCreated();

  int selectedPackage = 0;
  int selectedindex = 0;
  String selectedPayment = "";

  int selectedPost = 0;

  String mainAmount = "";
  bool walletCheck = false;
  double walletAmt = 0;
  double tempWallet = 0;
  double walletMain = 0;
  double tempAmount = 0;
  double amount = 0;
  String? payerID;
  String? accessToken;
  final notificationId = UniqueKey().hashCode;
  RazorpayScreen razorpayScreen = RazorpayScreen();

  List favAdd = [];

  Future popup(){
    return showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(color: PurpleColor,),
      );
    },
    );
  }



  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: "My Ads".tr, fun: () {
                Get.back();
              },)) : AppBar(
            elevation: 0,
            backgroundColor: notifier.getWhiteblackColor,
            automaticallyImplyLeading: false,
            title: Text("My Ads".tr, style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: notifier.iconColor,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: CustomBehavior(),
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 2),
                          () {
                            myadlistCont.myadlist().then((value) {
                              setState(() {});
                            },);
                      },
                    );
                  },
                  child: GetBuilder<MyadlistController>(
                    builder: (myadlistCont) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 750 < constraints.maxWidth ? 0 : 20),
                              child: SafeArea(
                                  child: myadlistCont.isloading ? SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                                      child: ListView.separated(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: 5,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: notifier.borderColor),
                                                color: notifier.getWhiteblackColor
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120, width: 100),
                                                    const SizedBox(width: 10,),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14),
                                                          const SizedBox(height: 10,),
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                                              const SizedBox(width: 10,),
                                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 70),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(color: circleGrey,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 20, width: 20),
                                                          const SizedBox(width: 5,),
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 20, width: 60),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      color: notifier.borderColor,
                                                      width: 1,
                                                      height: 20,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 20, width: 20),
                                                          const SizedBox(width: 5,),
                                                          shimmer(context: context, baseColor: notifier.shimmerbase2, height: 20, width: 60),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(color: circleGrey,),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                    child: shimmer(context: context, baseColor: notifier.shimmerbase2, height: 40, width: 100)),
                                              ],
                                            ),
                                          );
                                        },),
                                    ),
                                  )
                                      : myadlistCont.myadlistData == null ? Center(
                                          child: Image.asset("assets/emptyOrder.png", height: 200))
                                      : myadlistCont.myadlistData!.myadList!.isEmpty ? Center(
                                          child: Image.asset("assets/emptyOrder.png", height: 200))
                                      : SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: myadlistCont.myadlistData!.myadList!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 14),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(const MyadsView(), arguments: {
                                                  "productindex" : index,
                                                }, transition: Transition.noTransition);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: notifier.borderColor),
                                                    color: notifier.getWhiteblackColor
                                                ),
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: SizedBox(
                                                            height: 120,
                                                            width: 100,
                                                            child: FadeInImage.assetNetwork(
                                                              fit: BoxFit.cover,
                                                              imageErrorBuilder: (context, error, stackTrace) {
                                                                return shimmer(baseColor: notifier.shimmerbase2, height: 120, context: context);
                                                              },
                                                              image: Config.imageUrl + myadlistCont.myadlistData!.myadList![index].postImage!,
                                                              placeholder:  "assets/ezgif.com-crop.gif",
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              myadlistCont.myadlistData!.myadList![index].isPaid == "0" ? const SizedBox() : Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.black.withOpacity(0.5),
                                                                    borderRadius: BorderRadius.circular(5)
                                                                ),
                                                                padding: const EdgeInsets.all(3),
                                                                child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                              ),
                                                              SizedBox(height: myadlistCont.myadlistData!.myadList![index].isPaid == "0" ? 0 : 10,),
                                                              Text("${myadlistCont.myadlistData!.myadList![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 18, fontFamily: FontFamily.gilroyBold),),
                                                              const SizedBox(height: 10,),
                                                              Text("${myadlistCont.myadlistData!.myadList![index].adDescription}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),
                                                              overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                              const SizedBox(height: 10,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Image.asset("assets/location-pin.png", height: 18, color: notifier.iconColor),
                                                                  Flexible(child: Text(getAddress(address: myadlistCont.myadlistData!.myadList![index].fullAddress!), style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Row(
                                                                children: [
                                                                  Image.asset("assets/postingdate.png", height: 18, color: notifier.iconColor),
                                                                  Text(" ${"From".tr}: ${formatDate(myadlistCont.myadlistData!.myadList![index].postDate.toString().split(" ").first)}  ${"To".tr}: ${formatDate(myadlistCont.myadlistData!.myadList![index].postExpireDate.toString().split(" ").first)}", style: TextStyle(color: notifier.getTextColor, fontSize: 12, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(color: circleGrey,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image.asset("assets/visible.png", height: 20, color: notifier.iconColor,),
                                                              const SizedBox(width: 5,),
                                                              Text("${myadlistCont.myadlistData!.myadList![index].totalViews} ${"Views".tr}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          color: circleGrey,
                                                          width: 2,
                                                          height: 20,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image.asset("assets/heartdark.png", height: 20, color: notifier.iconColor,),
                                                              const SizedBox(width: 5,),
                                                              Text("${myadlistCont.myadlistData!.myadList![index].totalFavourite} ${"Favourite".tr}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(color: circleGrey,),
                                                    (myadlistCont.myadlistData!.myadList![index].isFeatureAd == "0" || myadlistCont.myadlistData!.myadList![index].daysRemaining == 0) ? const SizedBox() : Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      alignment: Alignment.centerLeft,
                                                      decoration: BoxDecoration(
                                                        color: notifier.isDark ? notifier.getBgColor : circleBG,
                                                        border: Border(left: BorderSide(color: myadlistCont.myadlistData!.myadList![index].isApprove == "0" ? Colors.orange : PurpleColor, width: 2))
                                                      ),
                                                      child: myadlistCont.myadlistData!.myadList![index].isApprove == "0" ? Text(" Your Ad is Under Review".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontWeight: FontWeight.w600, color: notifier.getTextColor, fontSize: 16),) : RichText(
                                                        overflow: TextOverflow.ellipsis,
                                                          text: TextSpan(
                                                        text: "  ${"Featured Ad for".tr} ${myadlistCont.myadlistData!.myadList![index].totalDay} ${"days".tr}. ",
                                                        style: TextStyle(fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor, fontSize: 14),
                                                        children: [
                                                          TextSpan(
                                                            text: "${myadlistCont.myadlistData!.myadList![index].daysRemaining} ${"days remaining".tr}",
                                                            style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14),
                                                          )
                                                        ]
                                                      )),
                                                    ),
                                                    SizedBox(height: (myadlistCont.myadlistData!.myadList![index].isFeatureAd == "0" || myadlistCont.myadlistData!.myadList![index].daysRemaining == 0) ? 0 : 5,),
                                                    GetBuilder<MyadlistController>(
                                                      builder: (myadlistCont) {
                                                        return myadlistCont.myadlistData!.myadList![index].isApprove == "0" ? const SizedBox() : (myadlistCont.myadlistData!.myadList![index].isExpire == "1" && myadlistCont.myadlistData!.myadList![index].isSold == "1") ? const SizedBox() : (myadlistCont.myadlistData!.myadList![index].isExpire == "0" && myadlistCont.myadlistData!.myadList![index].isSold == "1") ? Align(alignment: Alignment.centerRight,child: Text("Already soldout.".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontWeight: FontWeight.w600, color: notifier.getTextColor, fontSize: 16),))
                                                            : Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            myadlistCont.myadlistData!.myadList![index].isFeatureAd == "0" ? Container(
                                                              height: 40,
                                                              alignment: Alignment.centerRight,
                                                              child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      elevation: const WidgetStatePropertyAll(0),
                                                                      alignment: Alignment.center,
                                                                      padding: const WidgetStatePropertyAll(
                                                                          EdgeInsets.symmetric(vertical: 8, horizontal: 14)
                                                                      ),
                                                                      shape: WidgetStatePropertyAll(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: const WidgetStatePropertyAll(Colors.green)
                                                                  ),
                                                                  onPressed: () {
                                                                    selectedPost = index;
                                                                    setState(() {});
                                                                    listpackageCont.listofPackage(packageType: "Feature").then((value) {
                                                                       paymentgaewayCont.getPaymentgateway().then((value) {
                                                                          setState((){
                                                                            mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                            selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                          });
                                                                       },);
                                                                    },);

                                                                    showModalBottomSheet(
                                                                      backgroundColor: Colors.transparent,
                                                                      context: context,
                                                                      builder: (context) {
                                                                      return LayoutBuilder(
                                                                        builder: (context, constraints) {
                                                                          return StatefulBuilder(
                                                                            builder: (context, setState) {
                                                                              return Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
                                                                                child: GetBuilder<ListpackageController>(
                                                                                    builder: (listpackageCont) {
                                                                                      return Container(
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                                                                          color: notifier.getBgColor,
                                                                                        ),
                                                                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            const SizedBox(height: 10,),
                                                                                            Center(
                                                                                              child: Container(
                                                                                                width: 40,
                                                                                                height: 8,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                                    color: lightGreyColor
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(height: 20,),
                                                                                            Text("Featured Ad".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 18,fontFamily: FontFamily.gilroyBold,),),
                                                                                            const SizedBox(height: 10,),
                                                                                            listpackageCont.isLoading ? ListView.separated(
                                                                                              separatorBuilder: (context, index) {
                                                                                                return const SizedBox(height: 10,);
                                                                                              },
                                                                                              itemCount: 2,
                                                                                              shrinkWrap: true,
                                                                                              itemBuilder: (context, index) {
                                                                                                return shimmer(baseColor: notifier.shimmerbase2, context: context, height: 50);
                                                                                              },) : ListView.separated(
                                                                                              shrinkWrap: true,
                                                                                              scrollDirection: Axis.vertical,
                                                                                              itemCount: listpackageCont.listpackageData!.packageData!.length,
                                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                                              separatorBuilder: (context, index) {
                                                                                                return const SizedBox(height: 10,);
                                                                                              },
                                                                                              itemBuilder: (context, index) {
                                                                                                return InkWell(
                                                                                                  onTap: () {
                                                                                                    setState((){
                                                                                                      selectedPackage = index;
                                                                                                      paymentgaewayCont.getPaymentgateway().then((value) {
                                                                                                        setState((){
                                                                                                          mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                                                          selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                                                        });
                                                                                                        walletreportCont.getWalletReport().then((value) {
                                                                                                          setState(() {
                                                                                                            tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                            walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                            amount = double.parse(mainAmount);
                                                                                                            walletCheck = false;
                                                                                                          });
                                                                                                        },);
                                                                                                      },);
                                                                                                    });
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                        color: notifier.getWhiteblackColor,
                                                                                                        borderRadius: BorderRadius.circular(14),
                                                                                                        border: Border.all(width: 1, color: selectedPackage == index ? PurpleColor : notifier.borderColor)
                                                                                                    ),
                                                                                                    padding: const EdgeInsets.all(10),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              width: 20,
                                                                                                              child: Radio(
                                                                                                                value: selectedPackage,
                                                                                                                fillColor: WidgetStatePropertyAll(notifier.iconColor),
                                                                                                                groupValue: index,
                                                                                                                onChanged: (value) {
                                                                                                                  setState(() {
                                                                                                                    selectedPackage = index;
                                                                                                                    paymentgaewayCont.getPaymentgateway().then((value) {
                                                                                                                      setState((){
                                                                                                                        mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                                                                        selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                                                                      });
                                                                                                                      walletreportCont.getWalletReport().then((value) {
                                                                                                                        setState(() {
                                                                                                                          tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                                          walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                                          amount = double.parse(mainAmount);
                                                                                                                          walletCheck = false;
                                                                                                                        });
                                                                                                                      },);
                                                                                                                    },);
                                                                                                                  });
                                                                                                                },),
                                                                                                            ),
                                                                                                            const SizedBox(width: 10,),
                                                                                                            Text("${listpackageCont.listpackageData!.packageData![index].title}",
                                                                                                              style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: notifier.getTextColor,),
                                                                                                              maxLines: 2,
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Text("\$ ${listpackageCont.listpackageData!.packageData![index].price}",
                                                                                                          style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16, fontWeight: FontWeight.w700, color: notifier.getTextColor,),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },),
                                                                                            const SizedBox(height: 10,),
                                                                                            mainButton(
                                                                                              context: context,
                                                                                              loading: listpackageCont.isLoading,
                                                                                              txt1: "Pay $currency${listpackageCont.listpackageData == null ? "" : listpackageCont.listpackageData!.packageData![selectedPackage].price}",
                                                                                              containcolor: PurpleColor,
                                                                                              onPressed1: () {
                                                                                                selectedindex = 0;
                                                                                                isMakeFeature = true;
                                                                                                setState((){});
                                                                                                mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                                                selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                                                walletreportCont.getWalletReport().then((value) {
                                                                                                  setState(() {
                                                                                                    tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                    walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                    amount = double.parse(mainAmount);
                                                                                                    walletCheck = false;
                                                                                                  });
                                                                                                  showModalBottomSheet(
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    shape: const RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                                                                                    context: context,
                                                                                                    builder: (context) {
                                                                                                      return bottomsheet(isFeature: isMakeFeature);
                                                                                                    },);
                                                                                                },);
                                                                                              },),
                                                                                            const SizedBox(height: 20,),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                ),
                                                                              );
                                                                            }
                                                                          );
                                                                        }
                                                                      );
                                                                    },);
                                                                  }, child: Text("Sell faster now", style: TextStyle(color: WhiteColor, fontFamily: FontFamily.gilroyRegular, fontWeight: ui.FontWeight.w700, letterSpacing: 1, fontSize: 14),)),
                                                            ) : const SizedBox(),
                                                            const SizedBox(width: 10,),
                                                            Container(
                                                              height: 40,
                                                              alignment: Alignment.centerRight,
                                                              child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      elevation: const WidgetStatePropertyAll(0),
                                                                      alignment: Alignment.center,
                                                                      padding: const WidgetStatePropertyAll(
                                                                          EdgeInsets.symmetric(vertical: 8, horizontal: 14)
                                                                      ),
                                                                      shape: WidgetStatePropertyAll(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: WidgetStatePropertyAll(PurpleColor)
                                                                  ),
                                                                  onPressed: () {
                                                                    selectedPost = index;
                                                                    setState(() {});
                                                                    if(myadlistCont.myadlistData!.myadList![index].isExpire == "0" && myadlistCont.myadlistData!.myadList![index].isSold == "0"){
                                                                      Get.bottomSheet(
                                                                        elevation: 0,
                                                                        backgroundColor: Colors.transparent,
                                                                        LayoutBuilder(
                                                                          builder: (context, constraints) {
                                                                            return StatefulBuilder(
                                                                                builder: (context, setState) {
                                                                                  return BackdropFilter(
                                                                                    filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
                                                                                      child: Container(
                                                                                        height: 320,
                                                                                        decoration: BoxDecoration(
                                                                                            color: notifier.getWhiteblackColor,
                                                                                            borderRadius: const BorderRadius.only(
                                                                                                topLeft: Radius.circular(12),
                                                                                                topRight: Radius.circular(12)
                                                                                            )
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 5),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Center(
                                                                                                child: Container(
                                                                                                  width: 40,
                                                                                                  height: 5,
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                                    color: lightGreyColor,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              const SizedBox(height: 20),
                                                                                              Text("Are you Sure!".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 26, color: notifier.getTextColor,),),
                                                                                              Text("Will you want to mark the post as a sold?".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: notifier.getTextColor,),),
                                                                                              const SizedBox(height: 20,),
                                                                                              for(int i = 0; i < mark.length; i++)
                                                                                                Column(
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(right: 30, left: 30),
                                                                                                      child: InkWell(
                                                                                                        onTap: () {
                                                                                                          setState((){
                                                                                                            selectedMark = i;
                                                                                                          });
                                                                                                        },
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                          children: [
                                                                                                            Text(mark[i], style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: notifier.getTextColor,),),
                                                                                                            Radio(
                                                                                                              value: i,
                                                                                                              activeColor: PurpleColor,
                                                                                                              groupValue: selectedMark,
                                                                                                              onChanged: (value) {
                                                                                                                setState(() {
                                                                                                                  selectedMark = value!;
                                                                                                                });
                                                                                                              },
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(height: i == 1 ? 0 : 5),
                                                                                                    i == 1 ? const SizedBox() : Divider(color: lightGreyColor,),
                                                                                                  ],
                                                                                                ),
                                                                                              const SizedBox(height: 20,),
                                                                                              const Spacer(),
                                                                                              Container(
                                                                                                color: notifier.getWhiteblackColor,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: SizedBox(
                                                                                                          height: 40,
                                                                                                          child: ElevatedButton(
                                                                                                              style: ButtonStyle(
                                                                                                                backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                                                                                                                elevation: const WidgetStatePropertyAll(0),
                                                                                                                shape: WidgetStatePropertyAll(
                                                                                                                  RoundedRectangleBorder(side: BorderSide(color: PurpleColor), borderRadius: BorderRadius.circular(12)),
                                                                                                                ),
                                                                                                              ),
                                                                                                              onPressed: () {
                                                                                                                Get.back();
                                                                                                              },
                                                                                                              child: Text("Cancel".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w600, color: notifier.getTextColor, fontSize: 16),)),
                                                                                                        ),
                                                                                                      ),
                                                                                                      const SizedBox(width: 10,),
                                                                                                      Expanded(
                                                                                                        child: SizedBox(
                                                                                                          height: 40,
                                                                                                          child: ElevatedButton(
                                                                                                              style: ButtonStyle(
                                                                                                                backgroundColor: WidgetStatePropertyAll(PurpleColor),
                                                                                                                elevation: const WidgetStatePropertyAll(0),
                                                                                                                shape: WidgetStatePropertyAll(
                                                                                                                  RoundedRectangleBorder(side: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(12)),
                                                                                                                ),
                                                                                                              ),
                                                                                                              onPressed: () {
                                                                                                                markSoldCont.getMarskSold(postId: myadlistCont.myadlistData!.myadList![index].postId!, soldType: selectedMark == 0 ? "inside" : "outside").then((value) {
                                                                                                                  myadlistCont.myadlist();
                                                                                                                  Get.back();
                                                                                                                },);
                                                                                                              },
                                                                                                              child: Text("Mark as Sold".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontWeight: FontWeight.w600, color: WhiteColor, fontSize: 16),)),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                            );
                                                                          }
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      listpackageCont.listofPackage(packageType: "POST").then((value) {
                                                                        paymentgaewayCont.getPaymentgateway().then((value) {
                                                                          setState((){
                                                                            mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                            selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                          });
                                                                          walletreportCont.getWalletReport().then((value) {
                                                                            setState(() {
                                                                              tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                              walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                              amount = double.parse(mainAmount);
                                                                              walletCheck = false;
                                                                            });
                                                                          },);
                                                                        },);
                                                                        },);
                                                                      showModalBottomSheet(
                                                                        backgroundColor: Colors.transparent,
                                                                        shape: const RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                                                        context: context, builder: (context) {
                                                                        return LayoutBuilder(
                                                                            builder: (context, constraints) {
                                                                              return GetBuilder<ListpackageController>(
                                                                                builder: (listpackageCont) {
                                                                                  return StatefulBuilder(
                                                                                      builder: (context, setState) {
                                                                                        return Padding(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              color: notifier.getWhiteblackColor,
                                                                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  const SizedBox(height: 10,),
                                                                                                  Center(
                                                                                                    child: Container(
                                                                                                      width: 40,
                                                                                                      height: 8,
                                                                                                      decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(6),
                                                                                                          color: lightGreyColor
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  const SizedBox(height: 20,),
                                                                                                  Text("Republish Ad".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 18,fontFamily: FontFamily.gilroyBold,),),
                                                                                                  const SizedBox(height: 10,),
                                                                                                  listpackageCont.isLoading ? ListView.separated(
                                                                                                    shrinkWrap: true,
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    itemCount: 2,
                                                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                                                    separatorBuilder: (context, index) {
                                                                                                      return const SizedBox(height: 10,);
                                                                                                    },
                                                                                                    itemBuilder: (context, index) {
                                                                                                      return shimmer(context: context, baseColor: notifier.shimmerbase2, height: 40,);
                                                                                                  },) : ListView.separated(
                                                                                                    shrinkWrap: true,
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    itemCount: listpackageCont.listpackageData!.packageData!.length,
                                                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                                                    separatorBuilder: (context, index) {
                                                                                                      return const SizedBox(height: 10,);
                                                                                                    },
                                                                                                    itemBuilder: (context, index) {
                                                                                                      return InkWell(
                                                                                                        onTap: () {
                                                                                                          setState((){
                                                                                                            selectedPackage = index;
                                                                                                            paymentgaewayCont.getPaymentgateway().then((value) {
                                                                                                              setState((){
                                                                                                                mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                                                                selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                                                              });
                                                                                                              walletreportCont.getWalletReport().then((value) {
                                                                                                                setState(() {
                                                                                                                  tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                                  walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                                  amount = double.parse(mainAmount);
                                                                                                                  walletCheck = false;
                                                                                                                });
                                                                                                              },);
                                                                                                            },);
                                                                                                          });
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          decoration: BoxDecoration(
                                                                                                              color: notifier.getWhiteblackColor,
                                                                                                              borderRadius: BorderRadius.circular(14),
                                                                                                              border: Border.all(width: 1, color: selectedPackage == index ? PurpleColor : notifier.borderColor)
                                                                                                          ),
                                                                                                          padding: const EdgeInsets.all(10),
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                children: [
                                                                                                                  SizedBox(
                                                                                                                    width: 20,
                                                                                                                    child: Radio(
                                                                                                                      value: selectedPackage,
                                                                                                                      fillColor: WidgetStatePropertyAll(notifier.iconColor),
                                                                                                                      groupValue: index,
                                                                                                                      onChanged: (value) {
                                                                                                                        setState(() {
                                                                                                                          selectedPackage = index;
                                                                                                                          paymentgaewayCont.getPaymentgateway().then((value) {
                                                                                                                            setState((){
                                                                                                                              mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                                                                              selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                                                                            });
                                                                                                                            walletreportCont.getWalletReport().then((value) {
                                                                                                                              setState(() {
                                                                                                                                tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                                                walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                                                amount = double.parse(mainAmount);
                                                                                                                                walletCheck = false;
                                                                                                                              });
                                                                                                                            },);
                                                                                                                          },);
                                                                                                                        });
                                                                                                                      },),
                                                                                                                  ),
                                                                                                                  const SizedBox(width: 10,),
                                                                                                                  Text("${listpackageCont.listpackageData!.packageData![index].title}",
                                                                                                                    style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: notifier.getTextColor,),
                                                                                                                    maxLines: 2,
                                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                              Text("\$ ${listpackageCont.listpackageData!.packageData![index].price}",
                                                                                                                style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16, fontWeight: FontWeight.w700, color: notifier.getTextColor,),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    },),
                                                                                                  const SizedBox(height: 10,),
                                                                                                  mainButton(
                                                                                                    context: context,
                                                                                                    loading: listpackageCont.isLoading,
                                                                                                    txt1: "Pay \$${listpackageCont.listpackageData!.packageData![selectedPackage].price}",
                                                                                                    containcolor: PurpleColor,
                                                                                                    onPressed1: () {
                                                                                                      selectedindex = 0;
                                                                                                      setState((){
                                                                                                        mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                                                                                        selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                                                                                        isMakeFeature = false;
                                                                                                      });
                                                                                                      walletreportCont.getWalletReport().then((value) {
                                                                                                        setState(() {
                                                                                                          tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                          walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                                                                                          amount = double.parse(mainAmount);
                                                                                                          walletCheck = false;
                                                                                                        });
                                                                                                      },);
                                                                                                      showModalBottomSheet(
                                                                                                        backgroundColor: Colors.transparent,
                                                                                                        shape: const RoundedRectangleBorder(
                                                                                                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                                                                                        context: context,
                                                                                                        builder: (context) {
                                                                                                          return bottomsheet(isFeature: false);
                                                                                                        },);
                                                                                                    },),
                                                                                                  const SizedBox(height: 20,),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                  );
                                                                                }
                                                                              );
                                                                            }
                                                                        );
                                                                      },);
                                                                    }
                                                                  },
                                                                  child: Text((myadlistCont.myadlistData!.myadList![index].isExpire == "0" && myadlistCont.myadlistData!.myadList![index].isSold == "0") ? "Mark as Sold".tr : "Republish Ad".tr, style: TextStyle(color: WhiteColor, fontFamily: FontFamily.gilroyRegular, fontWeight: ui.FontWeight.w700, letterSpacing: 1, fontSize: 14),)),
                                                            ),
                                                          ],
                                                        );
                                                    },)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },),
                                    ),
                                  )
                              ),
                            ),
                            const SizedBox(height: kIsWeb ? 10 : 0,),
                            kIsWeb ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                              child: footer(context),
                            ) : const SizedBox(),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }

  Widget bottomsheet({bool? isFeature}){
    return StatefulBuilder(
        builder: (context, setState) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: notifier.getBgColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10,),
                        Center(
                          child: Container(
                            width: 40,
                            height: 8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: lightGreyColor
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        walletAmt == 0 ? const SizedBox() : Row(
                          children: [
                            Image.asset("assets/account_icons/empty-wallet.png", height: 40, color: PurpleColor,),
                            const SizedBox(width: 10,),
                            Text("${"My Wallet".tr} ($currency$tempWallet)"
                              , style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),),
                            const Spacer(),
                            Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: walletCheck,
                                activeTrackColor: PurpleColor,
                                offLabelColor: GreyColor,
                                onChanged: (value) async{

                                  setState((){

                                    walletCheck =! walletCheck;

                                    if(walletCheck){
                                      if(walletAmt <= double.parse(mainAmount)){
                                        walletMain = walletAmt;
                                        mainAmount = (amount - walletAmt).toString();
                                        tempWallet = 0;
                                      } else {
                                        walletMain = amount;
                                        tempWallet = walletAmt - amount;
                                        mainAmount = "0";
                                      }
                                    } else {
                                      tempWallet = walletAmt;
                                      mainAmount = amount.toString();
                                      walletMain = 0;
                                    }
                                  });
                                },),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: paymentgaewayCont.gatewayData!.paymentdata!.length,
                            itemBuilder: (context, index) {
                              return (kIsWeb && (paymentgaewayCont.gatewayData!.paymentdata![index].title! == "2checkout" || paymentgaewayCont.gatewayData!.paymentdata![index].title! == "MercadoPago")) ? const SizedBox() : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {

                                      if(walletCheck && mainAmount == "0"){
                                        walletCheck = false;
                                        tempWallet = walletAmt;
                                        mainAmount = amount.toString();
                                      } else {

                                        selectedindex = index;
                                        selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![index].title!;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: notifier.getWhiteblackColor,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(width: 1, color: selectedindex == index ? PurpleColor : notifier.borderColor)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FadeInImage.assetNetwork(
                                              height: 70,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Center(child: Image.asset("assets/emty.gif", fit: BoxFit.cover,height: 70,),);
                                              },
                                              image: Config.imageUrl + paymentgaewayCont.gatewayData!.paymentdata![index].img!,
                                              placeholder:  "assets/ezgif.com-crop.gif",
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(paymentgaewayCont.gatewayData!.paymentdata![index].title!, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),),
                                          ],
                                        ),
                                        Radio(
                                          fillColor: WidgetStatePropertyAll(notifier.iconColor),
                                          value: selectedindex,
                                          groupValue: index,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![index].title!;
                                              selectedindex = index;
                                            });
                                          },)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: mainButton(
                            context: context,
                            txt1: "Continue".tr,
                            containcolor: PurpleColor,
                            onPressed1: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              
                              prefs.setString("statuspayment", paymentgaewayCont.gatewayData!.paymentdata![selectedindex].status ?? "");
                              prefs.setString("paymentfor", "myAds");
                              prefs.setBool("isFeature", isFeature!);

                              if (kIsWeb && !walletCheck && double.parse(mainAmount) != 0) {
                                isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: "", walletAmt: walletMain.toString())
                                    : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: "");
                              }
                              if(walletCheck && double.parse(mainAmount) == 0) {

                                popup();
                                isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                    : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);

                              } else {
                                if(selectedPayment == "Razorpay"){
                                  Get.back();
                                  razorpayScreen.getcheckout(
                                    amount: mainAmount,
                                    contact: getData.read("UserLogin")["mobile"],
                                    description: "",
                                    email: getData.read("UserLogin")["email"],
                                    key: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!,
                                    name: getData.read("UserLogin")["name"],
                                  );
                                }
                                else if(selectedPayment == "Paypal") {
                                  List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!.split(",");
                                  prefs.setString("clientId", keyList[0]);
                                  prefs.setString("secretId", keyList[1]);
                                  if (kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/paypal/index.php", paymentGateway: selectedPayment);
                                    Get.to(const SuccessfulScreen(), transition: Transition.noTransition);
                                  } else {
                                    paypalPayment(mainAmount, keyList[0], keyList[1], isFeature);
                                  }
                                }
                                else if(selectedPayment == "Stripe") {
                                  List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!.split(",");
                                  Get.back();
                                  prefs.setString("secretKey", keyList[1]);
                                  if(kIsWeb){
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/stripe/index.php", paymentGateway: selectedPayment);
                                    Get.to(const SuccessfulScreen(), transition: Transition.noTransition);
                                  } else {
                                    stripePayment(isFeature);
                                  }

                                }
                                else if(selectedPayment == "PayStack") {
                                  List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!.split(",");
                                  prefs.setString("secretKey", keyList[1]);
                                  if(kIsWeb){
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/paystack/index.php");
                                  } else {
                                    paystackCont.getPaystack(amount: mainAmount)
                                        .then((value) {
                                      Get.to(() =>
                                          PaymentWebVIew(
                                            initialUrl: value["data"]["authorization_url"],
                                            navigationDelegate: (
                                                NavigationRequest request) async {
                                              final uri = Uri.parse(
                                                  request.url);
                                              var status = uri
                                                  .queryParameters["status"];

                                              if (uri
                                                  .queryParameters["status"] ==
                                                  null) {
                                                accessToken = uri
                                                    .queryParametersAll["trxref"]
                                                    .toString();
                                              } else {
                                                if (status == "success") {
                                                  payerID = uri
                                                      .queryParametersAll["trxref"]
                                                      .toString();
                                                  Get.back(result: payerID);
                                                } else {
                                                  Get.back();
                                                  showToastMessage("${uri
                                                      .queryParameters["status"]}");
                                                }
                                              }

                                              return NavigationDecision
                                                  .navigate;
                                            },), transition: Transition.noTransition)!.then((otid) {
                                        Get.back();

                                        if (otid != null) {
                                          showToastMessage(
                                              "Payment done Successfully".tr);
                                          popup();
                                          isFeature ? makeFeatureCont
                                              .getMakeFeature(
                                              postId: myadlistCont.myadlistData!
                                                  .myadList![selectedPost]
                                                  .postId.toString(),
                                              transactionId: otid,
                                              pMethodId: paymentgaewayCont
                                                  .gatewayData!
                                                  .paymentdata![selectedindex]
                                                  .id.toString(),
                                              wallAmt: walletMain.toString(),
                                              packageId: listpackageCont
                                                  .listpackageData!
                                                  .packageData![selectedPackage]
                                                  .id.toString(),
                                              mainAmt: mainAmount,
                                              paymentMethod: selectedPayment,
                                              walletAmt: walletMain.toString())
                                              : repubCont.getRepublish(
                                              postId: myadlistCont.myadlistData!
                                                  .myadList![selectedPost]
                                                  .postId.toString(),
                                              transId: otid,
                                              pMethod: paymentgaewayCont
                                                  .gatewayData!
                                                  .paymentdata![selectedindex]
                                                  .id.toString(),
                                              package: listpackageCont
                                                  .listpackageData!
                                                  .packageData![selectedPackage]
                                                  .id.toString(),
                                              isPaid: "1",
                                              mainAmt: mainAmount,
                                              paymentMethod: selectedPayment,
                                              walletAmt: walletMain.toString());
                                        }
                                      });
                                    },);
                                  }
                                }
                                else if(selectedPayment == "FlutterWave") {
                                  kIsWeb ? webPaymentCont.getPaymentUrl(
                                      body: {
                                        "email": getData.read("UserLogin")["email"],
                                        "amount": mainAmount
                                      }, url: "https://sellify.cscodetech.com/w_payment/flutterwave/index.php") : Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}flutterwave/index.php?amt=$mainAmount&email=${getData.read("UserLogin")["email"]}",
                                    navigationDelegate: (NavigationRequest request) async {
                                      final uri = Uri.parse(request.url);
                                      if (uri.queryParameters["status"] == null) {
                                        accessToken = uri.queryParameters["token"];
                                      } else {
                                        if (uri.queryParameters["status"] == "successful") {
                                          payerID = uri.queryParameters["transaction_id"];
                                          Get.back(result: payerID);
                                        } else {
                                          Get.back();
                                          showToastMessage("${uri.queryParameters["status"]}");
                                        }
                                      }
                                      return NavigationDecision.navigate;
                                    },))!.then((otid) {
                                    Get.back();

                                    if (otid != null) {
                                      showToastMessage("Payment done Successfully".tr);
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: otid, pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: otid, pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString());
                                    }
                                  });
                                }
                                else if(selectedPayment == "Paytm") {
                                  if(kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "uid": getData.read("UserLogin")["id"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/paytm/index.php");
                                  } else {
                                    Get.to(() =>
                                        PaymentWebVIew(
                                          initialUrl: "${Config
                                              .paymentBaseUrl}paytm/index.php?amt=$mainAmount&uid=${getData
                                              .read("UserLogin")["id"]}",
                                          navigationDelegate: (
                                              NavigationRequest request) async {
                                            final uri = Uri.parse(request.url);

                                            if (uri.queryParameters["status"] ==
                                                null) {
                                              accessToken =
                                              uri.queryParameters["token"];
                                            } else {
                                              if (uri
                                                  .queryParameters["status"] ==
                                                  "successful") {
                                                payerID = uri
                                                    .queryParameters["transaction_id"];
                                                Get.back(result: payerID);
                                              } else {
                                                Get.back();
                                                popup();
                                                showToastMessage("${uri
                                                    .queryParameters["status"]}");
                                              }
                                            }
                                            return NavigationDecision.navigate;
                                          },))!.then((otid) {
                                      Get.back();

                                      if (otid != null) {
                                        showToastMessage(
                                            "Payment done Successfully".tr);
                                        popup();
                                        isFeature ? makeFeatureCont
                                            .getMakeFeature(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transactionId: otid,
                                            pMethodId: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            wallAmt: walletMain.toString(),
                                            packageId: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString())
                                            : repubCont.getRepublish(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transId: otid,
                                            pMethod: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            package: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            isPaid: "1",
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString());
                                      }
                                    });
                                  }
                                }
                                else if(selectedPayment == "SenangPay") {
                                  if(kIsWeb){
                                    webPaymentCont.getPaymentUrl(
                                     body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount,
                                      "name": getData.read("UserLogin")["name"],
                                      "phone": getData.read("UserLogin")["mobile"],
                                      "detail": "Wallet TopUp"
                                    }, url: "${Config.paymentBaseUrl}w_payment/senangpay/index.php", paymentGateway: selectedPayment);
                                    Get.to(const SuccessfulScreen(), transition: Transition.noTransition);
                                  } else {
                                    Get.to(() =>
                                        PaymentWebVIew(
                                          initialUrl: "${Config
                                              .paymentBaseUrl}result.php?detail=Movers&amount=$mainAmount&order_id=$notificationId&name=${getData
                                              .read(
                                              "UserLogin")["name"]}&email=${getData
                                              .read(
                                              "UserLogin")["email"]}&phone=${getData
                                              .read("UserLogin")["ccode"] +
                                              getData.read(
                                                  "UserLogin")["mobile"]}",
                                          navigationDelegate: (
                                              NavigationRequest request) async {
                                            final uri = Uri.parse(request.url);
                                            if (uri.queryParameters["msg"] ==
                                                null) {
                                              accessToken =
                                              uri.queryParameters["token"];
                                            } else {
                                              if (uri.queryParameters["msg"] ==
                                                  "Payment_was_successful") {
                                                payerID = uri
                                                    .queryParameters["transaction_id"]!;
                                                Get.back(result: uri
                                                    .queryParameters["transaction_id"]);
                                              } else {
                                                Get.back();
                                                showToastMessage("${uri
                                                    .queryParameters["msg"]}");
                                              }
                                            }
                                            return NavigationDecision.navigate;
                                          },))!.then((otid) {
                                      Get.back();

                                      if (otid != null) {
                                        showToastMessage(
                                            "Payment done Successfully".tr);
                                        popup();
                                        isFeature ? makeFeatureCont
                                            .getMakeFeature(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transactionId: otid,
                                            pMethodId: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            wallAmt: walletMain.toString(),
                                            packageId: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString())
                                            : repubCont.getRepublish(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transId: otid,
                                            pMethod: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            package: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            isPaid: "1",
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString());
                                      }
                                    });
                                  }
                                }
                                else if(selectedPayment == "MercadoPago") {
                                  Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}merpago/index.php?amt=$mainAmount",
                                    navigationDelegate: (NavigationRequest request) async {
                                      final uri = Uri.parse(request.url);

                                      if (uri.queryParameters["merchant_account_id"] != null) {
                                        payerID = uri.queryParameters["transaction_id"]!;
                                        Get.back();
                                      } else {
                                        Get.back();
                                        showToastMessage("${uri.queryParameters["status"]}");
                                      }

                                      return NavigationDecision.navigate;

                                    },))!.then((otid) {
                                    Get.back();

                                    if (otid != null) {
                                      showToastMessage("Payment done Successfully".tr);
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: otid, pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: otid, pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString());
                                    }
                                  });
                                }
                                else if(selectedPayment == "Payfast"){
                                  if(kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount,
                                      "name": getData.read("UserLogin")["name"]
                                    }, url: "${Config.paymentBaseUrl}w_payment/payfast/index.php", paymentGateway: selectedPayment);
                                    Get.to(const SuccessfulScreen(), transition: Transition.noTransition);
                                  } else {
                                    Get.to(() =>
                                        PaymentWebVIew(
                                          initialUrl: "${Config
                                              .paymentBaseUrl}Payfast/index.php?amt=$mainAmount",
                                          navigationDelegate: (
                                              NavigationRequest request) async {
                                            final uri = Uri.parse(request.url);

                                            if (uri.queryParameters["status"] ==
                                                null) {
                                              accessToken = uri
                                                  .queryParameters["Transaction_id"];
                                            } else {
                                              if (uri
                                                  .queryParameters["status"] ==
                                                  "success") {
                                                payerID = uri
                                                    .queryParameters["payment_id"]!;
                                                Get.back(result: uri
                                                    .queryParameters["payment_id"]);
                                              } else {
                                                Get.back();
                                                showToastMessage("${uri
                                                    .queryParameters["ResponseMsg"]}");
                                              }
                                            }

                                            return NavigationDecision.navigate;
                                          },))!.then((otid) {
                                      Get.back();

                                      if (otid != null) {
                                        showToastMessage(
                                            "Payment done Successfully".tr);
                                        popup();
                                        isFeature ? makeFeatureCont
                                            .getMakeFeature(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transactionId: otid,
                                            pMethodId: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            wallAmt: walletMain.toString(),
                                            packageId: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString())
                                            : repubCont.getRepublish(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transId: otid,
                                            pMethod: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            package: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            isPaid: "1",
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString());
                                      }
                                    });
                                  }
                                }
                                else if(selectedPayment == "Midtrans") {
                                  if(kIsWeb){
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount,
                                      "name": getData.read("UserLogin")["name"],
                                      "phone": getData.read("UserLogin")["mobile"]
                                    }, url: "${Config.paymentBaseUrl}w_payment/midtrans/index.php");
                                  } else {
                                    Get.to(() =>
                                        PaymentWebVIew(
                                          initialUrl: "${Config
                                              .paymentBaseUrl}Midtrans/index.php?name=test&email=${getData
                                              .read(
                                              "UserLogin")["email"]}&phone=${getData
                                              .read("UserLogin")["ccode"] +
                                              getData.read(
                                                  "UserLogin")["mobile"]}&amt=$mainAmount",
                                          navigationDelegate: (
                                              NavigationRequest request) async {
                                            final uri = Uri.parse(request.url);
                                            if (uri
                                                .queryParameters["transaction_status"] ==
                                                null) {
                                              accessToken =
                                              uri.queryParameters["order_id"];
                                            } else {
                                              if (uri
                                                  .queryParameters["transaction_status"] ==
                                                  "capture") {
                                                payerID = uri
                                                    .queryParameters["order_id"]!;
                                                Get.back(result: payerID);
                                              } else {
                                                Get.back();
                                                showToastMessage("${uri
                                                    .queryParameters["ResponseMsg"]}");
                                              }
                                            }

                                            return NavigationDecision.navigate;
                                          },))!.then((otid) {
                                      Get.back();

                                      if (otid != null) {
                                        showToastMessage(
                                            "Payment done Successfully".tr);
                                        popup();
                                        isFeature ? makeFeatureCont
                                            .getMakeFeature(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transactionId: otid,
                                            pMethodId: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            wallAmt: walletMain.toString(),
                                            packageId: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString())
                                            : repubCont.getRepublish(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transId: otid,
                                            pMethod: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            package: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            isPaid: "1",
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString());
                                      }
                                    });
                                  }
                                }
                                else if(selectedPayment == "2checkout"){
                                  Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}2checkout/index.php?amt=$mainAmount",
                                    navigationDelegate: (NavigationRequest request) async {
                                      final uri = Uri.parse(request.url);

                                      if (uri.queryParameters["status"] == null) {
                                        accessToken = uri.queryParameters["merchant_account_id"];
                                      } else {
                                        if (uri.queryParameters["status"] == "successful") {
                                          payerID = uri.queryParameters["merchant_account_id"]!;
                                          Get.back(result: payerID);
                                        } else {
                                          Get.back();
                                          showToastMessage("${uri.queryParameters["status"]}");
                                        }
                                      }

                                      return NavigationDecision.navigate;
                                    },))!.then((otid) {
                                    Get.back();

                                    if (otid != null) {
                                      showToastMessage("Payment done Successfully".tr);
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: otid, pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: otid, pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString());
                                    }
                                  });
                                }
                                else if(selectedPayment == "Khalti Payment"){
                                  if(kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/khalti/index.php", paymentGateway: selectedPayment);
                                    Get.to(const SuccessfulScreen(), transition: Transition.noTransition);
                                  } else {
                                    Get.to(() =>
                                        PaymentWebVIew(
                                          initialUrl: "${Config
                                              .paymentBaseUrl}Khalti/index.php?amt=$mainAmount",
                                          navigationDelegate: (
                                              NavigationRequest request) async {
                                            final uri = Uri.parse(request.url);

                                            if (uri.queryParameters["status"] ==
                                                null) {
                                              accessToken = uri
                                                  .queryParameters["merchant_account_id"];
                                            } else {
                                              if (uri
                                                  .queryParameters["status"] ==
                                                  "Completed") {
                                                payerID = uri
                                                    .queryParameters["transaction_id"]!;
                                                Get.back(result: payerID);
                                              } else {
                                                Get.back();
                                                showToastMessage("${uri
                                                    .queryParameters["status"]}");
                                              }
                                            }
                                            return NavigationDecision.navigate;
                                          },))!.then((otid) {
                                      Get.back();

                                      if (otid != null) {
                                        showToastMessage(
                                            "Payment done Successfully".tr);
                                        popup();
                                        isFeature ? makeFeatureCont
                                            .getMakeFeature(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transactionId: otid,
                                            pMethodId: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            wallAmt: walletMain.toString(),
                                            packageId: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString())
                                            : repubCont.getRepublish(
                                            postId: myadlistCont.myadlistData!
                                                .myadList![selectedPost].postId
                                                .toString(),
                                            transId: otid,
                                            pMethod: paymentgaewayCont
                                                .gatewayData!
                                                .paymentdata![selectedindex].id
                                                .toString(),
                                            package: listpackageCont
                                                .listpackageData!
                                                .packageData![selectedPackage]
                                                .id.toString(),
                                            isPaid: "1",
                                            mainAmt: mainAmount,
                                            paymentMethod: selectedPayment,
                                            walletAmt: walletMain.toString());
                                      }
                                    });
                                  }
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        }
    );
  }

  stripePayment(bool isFeature) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: notifier.getBgColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notifier.getWhiteblackColor,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Ink(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10,),
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: lightGreyColor
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text("Add Your payment information".tr,
                                          style: TextStyle(
                                              color: notifier.getTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 0.5)),
                                      const SizedBox(height: 10),
                                      Form(
                                        key: _formKey,
                                        autovalidateMode: _autoValidateMode,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(19),
                                                CardNumberInputFormatter()
                                              ],
                                              controller: numberController,
                                              onSaved: (String? value) {
                                                _paymentCard.number =
                                                    CardUtils.getCleanedNumber(value!);

                                                CardTypee cardType =
                                                CardUtils.getCardTypeFrmNumber(
                                                    _paymentCard.number.toString());
                                                setState(() {
                                                  _card.name = cardType.toString();
                                                  _paymentCard.type = cardType;
                                                });
                                              },
                                              onChanged: (val) {
                                                CardTypee cardType =
                                                CardUtils.getCardTypeFrmNumber(val);
                                                setState(() {
                                                  _card.name = cardType.toString();
                                                  _paymentCard.type = cardType;
                                                });
                                              },
                                              validator: CardUtils.validateCardNum,
                                              decoration: InputDecoration(
                                                prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 6,
                                                    ),
                                                    child: CardUtils.getCardIcon(
                                                      _paymentCard.type,
                                                    ),
                                                  ),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: PurpleColor,
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: PurpleColor,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: PurpleColor,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: PurpleColor,
                                                  ),
                                                ),
                                                hintText:
                                                "What number is written on card?".tr,
                                                hintStyle: const TextStyle(color: Colors.grey),
                                                labelStyle: const TextStyle(color: Colors.grey),
                                                labelText: "Number".tr,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Flexible(
                                                  flex: 4,
                                                  child: TextFormField(
                                                    style: const TextStyle(color: Colors.grey),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(4),
                                                    ],
                                                    decoration: InputDecoration(
                                                        prefixIcon: SizedBox(
                                                          height: 10,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 14),
                                                            child: Image.asset(
                                                              'assets/card_cvv.png',
                                                              width: 6,
                                                              color: PurpleColor,
                                                            ),
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: PurpleColor,
                                                          ),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: PurpleColor,
                                                          ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: PurpleColor,
                                                          ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: PurpleColor)),
                                                        hintText:
                                                        "Number behind the card".tr,
                                                        hintStyle:
                                                        const TextStyle(color: Colors.grey),
                                                        labelStyle:
                                                        const TextStyle(color: Colors.grey),
                                                        labelText: 'CVV'),
                                                    validator: CardUtils.validateCVV,
                                                    keyboardType: TextInputType.number,
                                                    onSaved: (value) {
                                                      _paymentCard.cvv = int.parse(value!);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: Get.width * 0.03),
                                                Flexible(
                                                  flex: 4,
                                                  child: TextFormField(
                                                    style: const TextStyle(color: Colors.black),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(4),
                                                      CardMonthInputFormatter()
                                                    ],
                                                    decoration: InputDecoration(
                                                      prefixIcon: SizedBox(
                                                        height: 10,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                          child: Image.asset(
                                                            'assets/calender.png',
                                                            width: 10,
                                                            color: PurpleColor,
                                                          ),
                                                        ),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: PurpleColor,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: PurpleColor,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: PurpleColor,
                                                        ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: PurpleColor,
                                                        ),
                                                      ),
                                                      hintText: 'MM/YY',
                                                      hintStyle:
                                                      const TextStyle(color: Colors.black),
                                                      labelStyle:
                                                      const TextStyle(color: Colors.grey),
                                                      labelText: "Expiry Date".tr,
                                                    ),
                                                    validator: CardUtils.validateDate,
                                                    keyboardType: TextInputType.number,
                                                    onSaved: (value) {
                                                      List<int> expiryDate =
                                                      CardUtils.getExpiryDate(value!);
                                                      _paymentCard.month = expiryDate[0];
                                                      _paymentCard.year = expiryDate[1];
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            mainButton(
                                              context: context,
                                              txt1: "${"Pay".tr} $currency$mainAmount",
                                              containcolor: PurpleColor,
                                              onPressed1: () {
                                                _validateInputs(isFeature);
                                              },),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        );
      },
    );
  }

  void _validateInputs(bool? isFeature) {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      showToastMessage("Please fix the errors in red before submitting.".tr);
    } else {
      var username = getData.read("UserLogin")["name"] ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = mainAmount.toString();
      form.save();

      Get.to(() => StripePaymentWeb(url: 'stripe/index.php?name=${_paymentCard.name}&email=${_paymentCard.email}&cardno=${_paymentCard.number}&cvc=${_paymentCard.cvv}&amt=${_paymentCard.amount}&mm=${_paymentCard.month}&yyyy=${_paymentCard.year}'), transition: Transition.noTransition)!.then((otid) {
        Get.back();
        
        if (otid != null) {
          showToastMessage("Payment done Successfully".tr);
          popup();
          isFeature! ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: otid, pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
              : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: otid, pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString());
        }
      });

      showToastMessage("Payment card is valid".tr);
    }
  }

  paypalPayment(
      String amt,
      String key,
      String secretKey,
      bool isFeature
      ) {
    Get.back();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UsePaypal(
            sandboxMode: true,
            clientId: key,
            secretKey: secretKey,
            returnURL:
            "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-35S7886705514393E",
            cancelURL: "${Config.paymentBaseUrl}restate/paypal/cancle.php",
            transactions: [
              {
                "amount": {
                  "total": amt,
                  "currency": "USD",
                  "details": {
                    "subtotal": amt,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": amt,
                      "currency": "USD"
                    }
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) {
              showToastMessage("Payment done Successfully".tr);
              popup();
              isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: params["paymentId"].toString(), pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                  : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: params["paymentId"].toString(), pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString());
            },
            onError: (error) {
              showToastMessage(error.toString());
            },
            onCancel: (params) {
              showToastMessage(params.toString());
            },
          );
        },
      ),
    );
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    popup();
    isMakeFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: response.paymentId.toString(), pMethodId: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
        : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: response.paymentId.toString(), pMethod: paymentgaewayCont.gatewayData!.paymentdata![selectedindex].id.toString(), package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString());
  }
  void handlePaymentError(PaymentFailureResponse response) {
    showToastMessage(response.message);
  }
  void handleExternalWallet(ExternalWalletResponse response) {}

}
