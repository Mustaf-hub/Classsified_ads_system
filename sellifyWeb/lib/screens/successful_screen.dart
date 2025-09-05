import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/checkpayment_status.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/screens/walletscreen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/makefeature_controller.dart';
import '../controller/postad/commonpost_controller.dart';
import '../controller/postad/postbike_controller.dart';
import '../controller/postad/postcvehicle_controller.dart';
import '../controller/postad/postmobile_controller.dart';
import '../controller/postad/properties_cont.dart';
import '../controller/postad_controller.dart';
import '../controller/repub_controller.dart';
import '../controller/topupwallet_controller.dart';
import '../controller/walletreport_controller.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();

    if (kIsWeb) {
      getColor();
      readUrlParams();
    }
  }

  WalletreportController walletreportCont = Get.find();
  TopupWalletController topupWalletCont = Get.find();
  CheckpaymentStatus checkpaymentStatus = Get.find();
  PostadController postadController = Get.find();
  PropertiesController propertiesCont = Get.find();
  PostmobileController postmobileCont = Get.find();
  PostbikeController postbikeCont = Get.find();
  PostcvehicleController postcvehicleCont = Get.find();
  CommonPostController commonPostCont = Get.find();
  RepubController repubCont = Get.find();
  MakeFeatureController makeFeatureCont = Get.find();

  bool statusDone= false;
  String status = "";
  String? txRef;
  String? transactionId;
  String paymentMode = "";
  String? tokenId;
  String statusPayment = "";

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

  Future adPost(subcatID, transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(subcatID == "0") {
        postadController.carPostWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
    } else if(subcatID == "1"){
      if (propertiesCont.isloading == false) {
        propertiesCont.saleHomeWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "2"){
      if (propertiesCont.isloading == false) {
        propertiesCont.rentHomeWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "3"){
      if (propertiesCont.isloading == false) {
        propertiesCont.saleLandWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "4"){
      if (propertiesCont.isloading == false) {
        propertiesCont.rentOfficeWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "5"){
      if (propertiesCont.isloading == false) {
        propertiesCont.saleOfficeWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "6"){
      if (propertiesCont.isloading == false) {
        propertiesCont.pgpostWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    }
    else if(subcatID == "7"){
      if(postmobileCont.isloading == false){
        postmobileCont.postmobileWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "8"){
      if(postmobileCont.isloading == false){
        postmobileCont.postAccessoriesWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "9"){
      if(postmobileCont.isloading == false){
        postmobileCont.postTabletWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    }
    else if(24 >= int.parse(subcatID)){
      if(postadController.isloading == false){
        postadController.postjobWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    }
    else if(subcatID == "25"){
      if(postbikeCont.isloading == false){
        postbikeCont.postbikeWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "26"){
      if(postbikeCont.isloading == false){
        postbikeCont.postScooterWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "28"){
      if(postbikeCont.isloading == false){
        postbikeCont.postBicycleWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "39"){
      if(postcvehicleCont.isloading == false){
        postcvehicleCont.postcVehicleWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else if(subcatID == "40"){

      if(postcvehicleCont.isloading == false){
        postcvehicleCont.postSparepartWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    }
    else if(58 <= int.parse(subcatID)){
      if(subcatID == "65" || subcatID == "66"){
        postadController.servicetypeId = "0";
      }
      if(postadController.isloading == false){
        postadController.postservicesWeb(transId).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          setState(() {});
        },);
      }
    } else {
      if(commonPostCont.isLoading == false) {
        commonPostCont.commonpostWeb(transId).then((value) {
          setState(() {
            paymentFor = prefs.getString("paymentfor")!;
          });
        },);
      }
    }
  }

  Future readUrlParams() async {
    Map uri = Uri.base.queryParameters;


    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
        statusPayment = prefs.getString("statuspayment")!;


        paymentMode = uri["payment_mode"] ?? "";
        prefs.setString("paymentmode", paymentMode);

      if (paymentMode == "paypal") {
        tokenId = uri["token"];
        checkpaymentStatus.verifyPaypalPayment(tokenId!, statusPayment).then((value) {
          getVerfied(value);
        },);
      } else if(paymentMode == "stripe"){
        String sessionId = uri["session_id"];
        checkpaymentStatus.verifyStripePayment(sessionId).then((value) {
          getVerfied(value);
        },);
      } else if(paymentMode == "paystack") {
        tokenId = uri["reference"];
        checkpaymentStatus.verifyPaystackPayment(tokenId!).then((value) {
          getVerfied(value);
        },);
      } else if(paymentMode == "senangpay?") {
        status = uri["msg"];
        transactionId = uri["transaction_id"];
        paymentCheck(status: status).then((value) {
          statusDone = value;
          setState(() {});
        },).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          if(statusDone){
            if (paymentFor == "WalletTopUp") {
              topupWalletCont.getTopupWallet(amount: amountOfWallet).then((value) {
                if(value["Result"] == "true"){
                  walletreportCont.getWalletReport().then((value) {
                    Get.to(const Walletscreen(), transition: Transition.noTransition);
                  },);
                }
              },);
            } else if(paymentFor == "AdPost"){
              adPost(prefs.getString("subcatPost"), transactionId).then((value) {
                paymentFor = prefs.getString("paymentfor")!;
                setState(() {});
              },);
            } else if(paymentFor == "myAds"){
              isFeature = prefs.getBool("isFeature")!;
              setState(() {});
              isFeature ? makeFeatureCont.getMakeFeatureWeb(transactionId)
                  : repubCont.getRepubWeb(transactionId);
            }
          }
        },);

      } else if(paymentMode == "payfast"){
        status = uri["status"];
        transactionId = uri["tid"];
        paymentCheck(status: status).then((value) {
          statusDone = value;
          setState(() {});
        },).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          if(statusDone){
            if (paymentFor == "WalletTopUp") {
              topupWalletCont.getTopupWallet(amount: amountOfWallet).then((value) {
                if(value["Result"] == "true"){
                  walletreportCont.getWalletReport().then((value) {
                    Get.to(const Walletscreen(), transition: Transition.noTransition);
                  },);
                }
              },);
            } else if(paymentFor == "AdPost"){
              adPost(prefs.getString("subcatPost"), transactionId).then((value) {
                paymentFor = prefs.getString("paymentfor")!;
                setState(() {});
              },);
            } else if(paymentFor == "myAds"){
              isFeature = prefs.getBool("isFeature")!;
              setState(() {});
              isFeature ? makeFeatureCont.getMakeFeatureWeb(transactionId)
                  : repubCont.getRepubWeb(transactionId);
            }
          }
        },);
      } else if(paymentMode == "paytm"){
        status = uri["status"];
        transactionId = uri["txnId"];
        paymentCheck(status: status).then((value) {
          statusDone = value;
          setState(() {});
        },).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          if(statusDone){
            if (paymentFor == "WalletTopUp") {
              topupWalletCont.getTopupWallet(amount: amountOfWallet).then((value) {
                if(value["Result"] == "true"){
                  walletreportCont.getWalletReport().then((value) {
                    Get.to(const Walletscreen(), transition: Transition.noTransition);
                  },);
                }
              },);
            } else if(paymentFor == "AdPost"){
              adPost(prefs.getString("subcatPost"), transactionId).then((value) {
                paymentFor = prefs.getString("paymentfor")!;
                setState(() {});
              },);
            } else if(paymentFor == "myAds"){
              isFeature = prefs.getBool("isFeature")!;
              setState(() {});
              isFeature ? makeFeatureCont.getMakeFeatureWeb(transactionId)
                  : repubCont.getRepubWeb(transactionId);
            }
          }
        },);
      } else if(paymentMode == "midtrans") {
        status = uri["transaction_status"];
        transactionId = uri["order_id"];
        paymentCheck(status: status).then((value) {
          statusDone = value;
          setState(() {});
        },).then((value) {
          paymentFor = prefs.getString("paymentfor")!;
          if(statusDone){
            if (paymentFor == "WalletTopUp") {
              topupWalletCont.getTopupWallet(amount: amountOfWallet).then((value) {
                if(value["Result"] == "true"){
                  walletreportCont.getWalletReport().then((value) {
                    Get.to(const Walletscreen(), transition: Transition.noTransition);
                  },);
                }
              },);
            } else if(paymentFor == "AdPost"){
              adPost(prefs.getString("subcatPost"), transactionId).then((value) {
                paymentFor = prefs.getString("paymentfor")!;
                setState(() {});
              },);
            } else if(paymentFor == "myAds"){
              isFeature = prefs.getBool("isFeature")!;
              setState(() {});
              isFeature ? makeFeatureCont.getMakeFeatureWeb(transactionId)
                  : repubCont.getRepubWeb(transactionId);
            }
          }
        },);
      } else {
        paymentFor = prefs.getString("paymentfor")!;

        if (paymentFor == "myAdsRazorpay") {
          statusDone = true;
          status = "Complete";
        } else {
          status = uri["status"] ?? "";
          transactionId = uri["transaction_id"];
          txRef = uri["tx_ref"];
          if ((paymentMode.split("?").first).split("/").first == "khalti") {
            status = (paymentMode.split("?").last).split("=").last;
          }
          paymentCheck(status: status).then((value) {
            statusDone = value;
            setState(() {});
          },).then((value) {
            if(statusDone){
              if (paymentFor == "WalletTopUp") {
                topupWalletCont.getTopupWallet(amount: amountOfWallet).then((value) {
                  if(value["Result"] == "true"){
                    walletreportCont.getWalletReport().then((value) {
                      Get.to(const Walletscreen(), transition: Transition.noTransition);
                    },);
                  }
                },);
              } else if(paymentFor == "AdPost"){
                adPost(prefs.getString("subcatPost"), transactionId).then((value) {
                  paymentFor = prefs.getString("paymentfor")!;
                  setState(() {});
                },);
              } else if(paymentFor == "myAds"){
                isFeature = prefs.getBool("isFeature")!;
                setState(() {});
                isFeature ? makeFeatureCont.getMakeFeatureWeb(transactionId)
                    : repubCont.getRepubWeb(transactionId);
              }
            }
          },);
        }
      }

      amountOfWallet = prefs.getString("amountOfWallet")!;
      currency = prefs.getString("currency");
    });

  }

  Future<void> getVerfied(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = value["status"];
    transactionId = value['id'];
    paymentCheck(status: status).then((value) {
      statusDone = value;
      setState(() {});
    },).then((value) {
      paymentFor = prefs.getString("paymentfor")!;
      if(statusDone){
        if (paymentFor == "WalletTopUp") {
          topupWalletCont.getTopupWallet(amount: amountOfWallet).then((value) {
            if(value["Result"] == "true"){
              walletreportCont.getWalletReport().then((value) {
                Get.to(const Walletscreen(), transition: Transition.noTransition);
              },);
            }
          },);
        } else if(paymentFor == "AdPost"){
          adPost(prefs.getString("subcatPost"), transactionId).then((value) {
           paymentFor = prefs.getString("paymentfor")!;
           setState(() {});
          },);
        } else if(paymentFor == "myAds"){
          isFeature = prefs.getBool("isFeature")!;
          setState(() {});
          isFeature ? makeFeatureCont.getMakeFeatureWeb(transactionId)
              : repubCont.getRepubWeb(transactionId);
        }
      }
    },);
  }

  bool isFeature = false;
  String paymentFor = "";
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
            child: (status.isEmpty) ? waitforStatus() : paymentFor == "adposted" ? successful() : statusDone ? successfulPayment() : failedPayment(),
          );
        }
      ),
    );
  }

  Widget successful() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(child: Image.asset("assets/Success.png", height: 300,)),
        const SizedBox(height: 50,),
        Text("Your Post has been successfully posted.".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const SizedBox(
          height: 10,
        ),
        Text("Will be visible shortly. Get ready to connect with buyers and sell faster!".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const Spacer(),
        mainButton(containcolor: PurpleColor, txt1: "Home".tr, context: context, onPressed1: () async {
          Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen());
        },),
      ],
    );
  }

  Widget successfulPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(child: Image.asset("assets/Success.png", height: 300,)),
        const SizedBox(height: 50,),
        Text("Payment Successful!".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const SizedBox(
          height: 10,
        ),
        Text("Your transaction has been completed securely. Thank you for your payment.".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const Spacer(),
        mainButton(containcolor: PurpleColor, txt1: "Home".tr, context: context, onPressed1: () async {
          Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen());
        },),
      ],
    );
  }

  Widget waitforStatus(){
    return Column(
      children: [
        const Spacer(),
        Center(child: Image.asset("assets/waitingStatus.png", height: 300,)),
        const SizedBox(height: 50,),
        Text("Payment Under Processed".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const SizedBox(
          height: 10,
        ),
        Text("Wait, while we confirming the payment status.".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const Spacer(),
      ],
    );
  }
  Widget failedPayment(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(child: Image.asset("assets/paymentFailed.png", height: 300,)),
        const SizedBox(height: 50,),
        Text("Your payment has got failed.".tr, style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 26),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const SizedBox(
          height: 10,
        ),
        Text("Try again. if there is any other problem then contact us".tr, style: TextStyle(color: greyText, fontFamily: FontFamily.gilroyMedium, fontSize: 16),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
        const Spacer(),
        mainButton(containcolor: PurpleColor, txt1: "Home".tr, context: context, onPressed1: () async {
          Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen());
        },),
      ],
    );
  }
}
