import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/controller/paystackcontroller.dart';
import 'package:sellify/controller/topupwallet_controller.dart';
import 'package:sellify/controller/walletreport_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/StripeWeb.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/screens/payment_gateway/card_formater.dart';
import 'package:sellify/screens/payment_gateway/payment_card.dart';
import 'package:sellify/screens/payment_gateway/paypal/flutter_paypal.dart';
import 'package:sellify/screens/payment_gateway/razorpay_screen.dart';
import 'package:sellify/screens/payment_gateway/webview_screen.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api_config/config.dart';
import '../api_config/store_data.dart';
import '../controller/paymentgaeway_cont.dart';
import '../utils/dark_lightMode.dart';

class Walletscreen extends StatefulWidget {
  const Walletscreen({super.key});

  @override
  State<Walletscreen> createState() => _WalletscreenState();
}

class _WalletscreenState extends State<Walletscreen> {

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

  WalletreportController walletreportCont = Get.find();
  PaymentgaewayController paymentgaewayCont = Get.find();
  TopupWalletController topupWalletCont = Get.find();
  PaystackController paystackCont = Get.find();

  TextEditingController amount = TextEditingController();
  String selectedPayment = "";
  String? accessToken;
  int selectedIndex = 0;
  RazorpayScreen razorpayScreen = RazorpayScreen();

  final notificationId = UniqueKey().hashCode;

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: GetBuilder<WalletreportController>(
          builder: (walletreportCont) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      SvgPicture.asset("assets/account_icons/walletbg.svg", fit: BoxFit.fill,height: 400,),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(const BottombarScreen());
                              },
                              icon: Image.asset(
                                "assets/arrowLeftIcon.png",
                                color: WhiteColor,
                              ),
                            ),
                            SizedBox(height: 30,),
                            Text("Current balance".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: WhiteColor, fontSize: 16),textAlign: TextAlign.start,),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(walletreportCont.walletData ==null ? "" : "$currency${walletreportCont.walletData!.wallet}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: WhiteColor, fontSize: 50),textAlign: TextAlign.start,),
                                InkWell(
                                  onTap: () {
                                    paymentgaewayCont.getPaymentgateway().then((value) {
                                      Get.bottomSheet(
                                        paymentBottom(),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))),
                                      );
                                    },);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: WhiteColor),
                                      color: Colors.white.withOpacity(0.06)
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                                    child: Text("${"Add Wallet".tr} +", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: WhiteColor, fontSize: 18),textAlign: TextAlign.start,)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22, top: 230, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: notifier.getWhiteblackColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("All Transactions".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor, fontSize: 18),textAlign: TextAlign.start,),
                        SizedBox(height: 20,),
                        walletreportCont.isloading ?
                            Center(child: CircularProgressIndicator())
                            : walletreportCont.walletData == null ? Column(
                               children: [
                                 Center(child: Image.asset("assets/account_icons/emptywallet.png", height: 200,)),
                                 Text("No Transactions Found".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 22),textAlign: TextAlign.start,),
                               ],
                             )
                            : walletreportCont.walletData!.walletitem!.isNotEmpty ? Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: walletreportCont.walletData!.walletitem!.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 5,);
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: notifier.isDark ? notifier.getBgColor : circleBG,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: notifier.borderColor),
                                    ),
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset(walletreportCont.walletData!.walletitem![index].status == "Credit" ? "assets/account_icons/greenwallet.png" : "assets/account_icons/redwallet.png", height: 45,),
                                              SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(walletreportCont.walletData!.walletitem![index].message ?? "", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16), overflow: TextOverflow.ellipsis, ),
                                                  Text(walletreportCont.walletData!.walletitem![index].status ?? "", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 14)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("$currency${walletreportCont.walletData!.walletitem![index].amt}+" ?? "", style: TextStyle(fontFamily: FontFamily.gilroyBold, color: walletreportCont.walletData!.walletitem![index].status == "Debit" ? redColor : greenColor, fontSize: 16)),
                                      ],
                                    ),
                                  );
                              },),
                            )
                            : Column(
                              children: [
                                Center(child: Image.asset("assets/account_icons/emptywallet.png", height: 200,)),
                                Text("No Transactions Found".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 22),textAlign: TextAlign.start,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  String payerID = "";

  Widget paymentBottom(){
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(18), topLeft: Radius.circular(18)),
            color: notifier.getBgColor,
          ),
          padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
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
              SizedBox(height: 10,),
              textFeild(textController: amount, context: context, textInputType: TextInputType.number, hinttext: "Enter Amount".tr),
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: paymentgaewayCont.gatewayData!.paymentdata!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![index].title!;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: notifier.getWhiteblackColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(width: 1, color: selectedIndex == index ? PurpleColor : notifier.borderColor)
                          ),
                          padding: EdgeInsets.all(10),
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
                                  SizedBox(width: 10,),
                                  Text(paymentgaewayCont.gatewayData!.paymentdata![index].title!, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),),
                                ],
                              ),
                              Radio(
                                activeColor: PurpleColor,
                                fillColor: WidgetStatePropertyAll(notifier.iconColor),
                                value: selectedIndex,
                                groupValue: index,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![index].title!;
                                    selectedIndex = index;
                                  });
                                },)
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
              ),
              mainButton(containcolor: PurpleColor, context: context, txt1: "Continue".tr, onPressed1: () {
                if(amount.text.isNotEmpty){
                  if(selectedPayment == "Razorpay"){
                    Get.back();
                    razorpayScreen.getcheckout(
                      amount: amount.text,
                      contact: getData.read("UserLogin")["mobile"],
                      description: "",
                      email: getData.read("UserLogin")["email"],
                      key: paymentgaewayCont.gatewayData!.paymentdata![selectedIndex].attributes!,
                      name: getData.read("UserLogin")["name"],
                    );
                  }
                  else if(selectedPayment == "Paypal"){
                    List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedIndex].attributes!.split(",");
                    print(keyList.toString());
                    paypalPayment(amount.text, keyList[0], keyList[1]);
                  }
                  else if(selectedPayment == "Stripe"){
                    Get.back();
                    stripePayment();
                  }
                  else if(selectedPayment == "PayStack") {

                    paystackCont.getPaystack(amount: amount.text).then((value) {
                      Get.to(() => PaymentWebVIew(
                        initialUrl: value["data"]["authorization_url"],
                        navigationDelegate: (NavigationRequest request) async {
                          final uri = Uri.parse(request.url);
                          print("PAYSTACK RESPONSE ${uri.queryParametersAll}");
                          print("PAYSTACK URL  ${uri.queryParameters["status"]}");
                          var status = uri.queryParameters["status"];

                          if (uri.queryParameters["status"] == null) {
                            accessToken = uri.queryParametersAll["trxref"].toString();
                          } else {
                            if (status == "success") {
                              payerID = uri.queryParametersAll["trxref"].toString();
                              topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                                if (value["Result"] == "true") {
                                  walletreportCont.getWalletReport().then((value) {
                                    Get.to(const Walletscreen());
                                  },);
                                } else {
                                  Get.back();
                                  showToastMessage("Something went wrong!");
                                }
                              },);
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
                        }
                      });
                    },);

                  }
                  else if(selectedPayment == "FlutterWave") {
                    print("${Config.paymentBaseUrl}flutterwave/index.php?amt=$amount&email=${getData.read("UserLogin")["email"]}");
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}flutterwave/index.php?amt=${amount.text}&email=${getData.read("UserLogin")["email"]}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);
                        if (uri.queryParameters["status"] == null) {
                          accessToken = uri.queryParameters["token"];
                        } else {
                          if (uri.queryParameters["status"] == "successful") {
                            payerID = uri.queryParameters["transaction_id"]!;
                            topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                              if (value["Result"] == "true") {
                                walletreportCont.getWalletReport().then((value) {
                                  Get.to(const Walletscreen());
                                },);
                              } else {
                                Get.back();
                                showToastMessage("Something went wrong!");
                              }
                            },);
                          } else {
                            Get.back();
                            showToastMessage("${uri.queryParameters["status"]}");
                          }
                        }
                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      Get.back();
                      
                      
                     showToastMessage("Payment done Successfully".tr);
                    
                    });
                  }
                  else if(selectedPayment == "Paytm") {
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}paytm/index.php?amt=${amount.text}&uid=${getData.read("UserLogin")["id"]}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);

                        if (uri.queryParameters["status"] == null) {
                          accessToken = uri.queryParameters["token"];
                        } else {
                          if (uri.queryParameters["status"] == "successful") {
                            payerID = uri.queryParameters["transaction_id"]!;
                            topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                              if (value["Result"] == "true") {
                                walletreportCont.getWalletReport().then((value) {
                                  Get.to(const Walletscreen());
                                },);
                              } else {
                                Get.back();
                                showToastMessage("Something went wrong!");
                              }
                            },);
                            Get.back(result: payerID);
                          } else {
                            Get.back();
                            showToastMessage("${uri.queryParameters["status"]}");
                          }
                        }
                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      Get.back();
                      
                      
                      showToastMessage("Payment done Successfully".tr);
                    
                    });
                  }
                  else if(selectedPayment == "SenangPay") {
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}result.php?detail=Movers&amount=${amount.text}&order_id=$notificationId&name=${getData.read("UserLogin")["name"]}&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);

                        print("MSG > > ${uri.queryParameters}");
                        if (uri.queryParameters["msg"] == null) {
                          accessToken = uri.queryParameters["token"];
                        } else {
                          if (uri.queryParameters["msg"] == "Payment_was_successful") {
                            payerID = uri.queryParameters["transaction_id"]!;
                            Get.back(result: uri.queryParameters["transaction_id"]);
                          } else {
                            Get.back();
                            showToastMessage("${uri.queryParameters["msg"]}");
                          }
                        }
                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      Get.back();
                      
                      if(otid != null){
                        topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                          if (value["Result"] == "true") {
                            walletreportCont.getWalletReport().then((value) {
                              Get.to(const Walletscreen());
                            },);
                          } else {
                            Get.back();
                            showToastMessage("Something went wrong!".tr);
                          }
                        },);
                        showToastMessage("Payment done Successfully".tr);
                      }

                    });
                  }
                  else if(selectedPayment == "MercadoPago") {
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}merpago/index.php?amt=${amount.text}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);
                        print("URI MSG > ${uri.queryParameters}");

                        if (uri.queryParameters["merchant_account_id"] != null) {
                          payerID = uri.queryParameters["transaction_id"]!;
                          Get.back();
                        } else {
                          Get.back();
                          showToastMessage("${uri.queryParameters["status"]}");
                        }

                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      
                      
                       showToastMessage("Payment done Successfully".tr);
                    
                    });
                  }
                  else if(selectedPayment == "Payfast"){
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}Payfast/index.php?amt=${amount.text}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);

                        print("PARAMETERS ${uri.queryParametersAll}");
                        if (uri.queryParameters["status"] == null) {
                          accessToken = uri.queryParameters["Transaction_id"];
                        } else {
                          if (uri.queryParameters["status"] == "success") {
                            payerID = uri.queryParameters["payment_id"]!;
                            Get.back(result: uri.queryParameters["payment_id"]);
                            print('payerID');
                          } else {
                            Get.back();
                            print("CHCECK");
                            showToastMessage("${uri.queryParameters["ResponseMsg"]}");
                          }
                        }

                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      
                      if(otid != null){
                        topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                          if (value["Result"] == "true") {
                            walletreportCont.getWalletReport().then((value) {
                              Get.to(const Walletscreen());
                            },);
                          } else {
                            Get.back();
                            showToastMessage("Something went wrong!");
                          }
                        },);
                        showToastMessage("Payment done Successfully".tr);
                      }
                    });
                  }
                  else if(selectedPayment == "Midtrans") {
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}Midtrans/index.php?name=test&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}&amt=${amount.text}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);

                        if (uri.queryParameters["transaction_status"] == null) {
                          accessToken = uri.queryParameters["order_id"];
                        } else {
                          if (uri.queryParameters["transaction_status"] == "capture") {
                            payerID = uri.queryParameters["order_id"]!;
                            Get.back(result: uri.queryParameters["order_id"]);
                            print('payerID');
                          } else {
                            Get.back();
                            showToastMessage("${uri.queryParameters["ResponseMsg"]}");
                          }
                        }

                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      
                      if(otid != null){
                        topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                          if (value["Result"] == "true") {
                            walletreportCont.getWalletReport().then((value) {
                              Get.to(const Walletscreen());
                            },);
                          } else {
                            Get.back();
                            showToastMessage("Something went wrong!");
                          }
                        },);
                        showToastMessage("Payment done Successfully".tr);
                      }
                    });
                  }
                  else if(selectedPayment == "2checkout"){
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}2checkout/index.php?amt=${amount.text}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);

                        if (uri.queryParameters["status"] == null) {
                          accessToken = uri.queryParameters["merchant_account_id"];
                        } else {
                          if (uri.queryParameters["status"] == "successful") {
                            payerID = uri.queryParameters["merchant_account_id"]!;
                            Get.back(result: payerID);
                            print('payerID');
                          } else {
                            Get.back();
                            showToastMessage("${uri.queryParameters["status"]}");
                          }
                        }

                        return NavigationDecision.navigate;
                      },))!.then((otid) {
                      

                      if(otid != null){
                        topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                          if (value["Result"] == "true") {
                            walletreportCont.getWalletReport().then((value) {
                              Get.to(const Walletscreen());
                            },);
                          } else {
                            Get.back();
                            showToastMessage("Something went wrong!");
                          }
                        },);
                        showToastMessage("Payment done Successfully".tr);
                      }
                    
                    });
                  }
                  else if(selectedPayment == "Khalti Payment"){
                    Get.to(() => PaymentWebVIew(
                      initialUrl: "${Config.paymentBaseUrl}Khalti/index.php?amt=${amount.text}",
                      navigationDelegate: (NavigationRequest request) async {
                        final uri = Uri.parse(request.url);

                        if (uri.queryParameters["status"] == null) {
                          accessToken = uri.queryParameters["merchant_account_id"];
                        } else {
                          if (uri.queryParameters["status"] == "Completed") {
                            payerID = uri.queryParameters["transaction_id"]!;
                            Get.back(result: payerID);
                            print('payerID : $payerID');
                          } else {
                            Get.back();
                            showToastMessage("${uri.queryParameters["status"]}");
                          }
                        }

                        return NavigationDecision.navigate;
                      },))!.then((otid) {

                      

                      if(otid != null){
                        topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                          if (value["Result"] == "true") {
                            walletreportCont.getWalletReport().then((value) {
                              Get.to(const Walletscreen());
                            },);
                          } else {
                            Get.back();
                            showToastMessage("Something went wrong!");
                          }
                        },);
                        showToastMessage("Payment done Successfully".tr);
                      }
                    
                    });
                  }
                } else {
                  showToastMessage("Please enter amount first!".tr);
                }
              },),
            ],
          ),
        );
      }
    );
  }
  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;

  var numberController = TextEditingController();
  final _paymentCard = PaymentCardCreated();
  final _card = PaymentCardCreated();

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
      walletreportCont.getWalletReport().then((value) {
        Get.to(const Walletscreen());
      },);
    },);
  }
  void handlePaymentError(PaymentFailureResponse response) {}
  void handleExternalWallet(ExternalWalletResponse response) {}

  stripePayment() {
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
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Ink(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10,),
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
                              SizedBox(height: 20),
                              Text("Add Your payment information".tr,
                                  style: TextStyle(
                                      color: notifier.getTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.5)),
                              SizedBox(height: 10),
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
                                        hintStyle: TextStyle(color: Colors.grey),
                                        labelStyle: TextStyle(color: Colors.grey),
                                        labelText: "Number".tr,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: TextFormField(
                                            style: TextStyle(color: notifier.getTextColor),
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
                                                TextStyle(color: Colors.grey),
                                                labelStyle:
                                                TextStyle(color: Colors.grey),
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
                                            style: TextStyle(color: Colors.black),
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
                                              TextStyle(color: Colors.grey),
                                              labelStyle:
                                              TextStyle(color: Colors.grey),
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
                                    SizedBox(height: 20,),
                                    mainButton(
                                      context: context,
                                      txt1: "${"Pay".tr} ${currency}${amount.text}",
                                      containcolor: PurpleColor,
                                      onPressed1: () {
                                        _validateInputs();
                                      },),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void _validateInputs() {
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
      _paymentCard.amount = amount.text.toString();
      form.save();

      Get.to(() => StripePaymentWeb(
        url: 'stripe/index.php?name=${_paymentCard.name}&email=${_paymentCard.email}&cardno=${_paymentCard.number}&cvc=${_paymentCard.cvv}&amt=${_paymentCard.amount}&mm=${_paymentCard.month}&yyyy=${_paymentCard.year}',
        ))!.then((otid) {
        Get.back();
        
        if (otid != null) {
          showToastMessage("Payment done Successfully".tr);
          topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
            walletreportCont.getWalletReport().then((value) {
              Get.to(Walletscreen());
            },);
          },);

        }
      });

      showToastMessage("Payment card is valid".tr);
    }
  }

  paypalPayment(
      String amt,
      String key,
      String secretKey,
      ) {
    print("----------->>" + key.toString());
    print("----------->>" + secretKey.toString());
    Get.back();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UsePaypalScreen(
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

              topupWalletCont.getTopupWallet(amount: amount.text).then((value) {
                if (value["Result"] == "true") {
                  walletreportCont.getWalletReport().then((value) {
                    Get.to(const Walletscreen());
                  },);
                } else {
                  Get.back();
                  showToastMessage("Something went wrong!");
                }
              },);
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

}
