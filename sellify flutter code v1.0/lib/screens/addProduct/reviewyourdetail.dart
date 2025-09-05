import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/listpackage_controller.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/paymentgaeway_cont.dart';
import 'package:sellify/controller/postad/commonpost_controller.dart';
import 'package:sellify/controller/postad/postbike_controller.dart';
import 'package:sellify/controller/postad/postcvehicle_controller.dart';
import 'package:sellify/controller/postad/postmobile_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/controller/walletreport_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/StripeWeb.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/payment_gateway/card_formater.dart';
import 'package:sellify/screens/payment_gateway/payment_card.dart';
import 'package:sellify/screens/payment_gateway/razorpay_screen.dart';
import 'package:sellify/screens/payment_gateway/webview_screen.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/paystackcontroller.dart';

class Reviewyourdetail extends StatefulWidget {
  const Reviewyourdetail({super.key});

  @override
  State<Reviewyourdetail> createState() => _ReviewyourdetailState();
}

class _ReviewyourdetailState extends State<Reviewyourdetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if(postingType == "Edit"){
      adindex = Get.arguments["adIndex"];
      print("adindex ? > ?> ?> $subcatID");
      setState(() {
        recordId = myadlistCont.myadlistData!.myadList![adindex].postId!;
        updateCatId = myadlistCont.myadlistData!.myadList![adindex].catId!;
        print("CATID ? > ?> ?> $updateCatId");
        print("CATID ? > ?> ?> $updateCatId");
      });
    }

    setState(() {
      postadController.isloading = false;
      propertiesCont.isloading = false;
      postadController.isloading = false;
      commonPostCont.isLoading = false;
    });
    setState(() {
      addUserName.text = getData.read("UserLogin")["name"];
    });
    
    razorpayScreen.initiateRazorpay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);
  }

  String subcatID = Get.arguments["subcatId"];
  String price = Get.arguments["price"];
  String address = Get.arguments["address"];
  String postingType = Get.arguments["postingType"];
  int adindex = 0;
  String recordId = "";

  ListpackageController listpackageCont = Get.find();
  CategoryListController categoryListCont = Get.find();
  PostadController postadController = Get.find();
  PropertiesController propertiesCont = Get.find();
  PostmobileController postmobileCont = Get.find();
  PostbikeController postbikeCont = Get.find();
  PostcvehicleController postcvehicleCont = Get.find();
  CommonPostController commonPostCont = Get.find();
  MyadlistController myadlistCont = Get.find();
  PaystackController paystackCont = Get.find();

  RazorpayScreen razorpayScreen = RazorpayScreen();

  PaymentgaewayController paymentgaewayCont = Get.find();
  WalletreportController walletreportCont = Get.find();
  TextEditingController addUserName = TextEditingController();
  late ColorNotifire notifier;

  int selectedPackage = 0;
  int selectedindex = 0;
  String selectedPayment = "";

  String mainAmount = "";

  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  var _autoValidateMode = AutovalidateMode.disabled;

  final _paymentCard = PaymentCardCreated();
  final _card = PaymentCardCreated();

  bool walletCheck = false;
  double walletAmt = 0;
  double tempWallet = 0;
  double walletMain = 0;
  double tempAmount = 0;
  double amount = 0;

  String? payerID;
  String? accessToken;

  final notificationId = UniqueKey().hashCode;

  bool isNavigate = false;

  bool isGetHold = false;
  String updateCatId = "";
  adPost() {
    isGetHold = true;
    setState(() {});
    if(subcatID == "0"){
      if(postadController.isloading == false) {
        setState(() {
          postadController.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        print(">>>> >> >> >> >> >> >> >> >> >> >> >> >>");
        postadController.carpostAd(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "1"){
      if (propertiesCont.isloading == false) {
        setState(() {
          propertiesCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        propertiesCont.saleHome(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "2"){
      if (propertiesCont.isloading == false) {
        setState(() {
          propertiesCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        propertiesCont.rentHome(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "3"){
      if (propertiesCont.isloading == false) {
        setState(() {
          propertiesCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        propertiesCont.saleLandPlot(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "4"){
      if (propertiesCont.isloading == false) {
        setState(() {
          propertiesCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        propertiesCont.rentOffice(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "5"){
      if (propertiesCont.isloading == false) {
        setState(() {
          propertiesCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        propertiesCont.saleOffice(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "6"){
      if (propertiesCont.isloading == false) {
        setState(() {
          propertiesCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        propertiesCont.pgpost(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "7"){
      if(postmobileCont.isloading == false){
        setState(() {
          postmobileCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postmobileCont.postmobile(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "8"){
      if(postmobileCont.isloading == false){
        setState(() {
          postmobileCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postmobileCont.postAccessories(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "9"){
      if(postmobileCont.isloading == false){
        setState(() {
          postmobileCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postmobileCont.postTablet(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(24 >= int.parse(subcatID)){
      if(postadController.isloading == false){
        setState(() {
          postadController.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postadController.postJob(address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "25"){
      if(postbikeCont.isloading == false){
        setState(() {
          postbikeCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postbikeCont.postBike(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "26"){
      print("SUNCNNDFN ${postbikeCont.isloading}");
      if(postbikeCont.isloading == false){
        setState(() {
          postbikeCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postbikeCont.postScooter(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "28"){
      if(postbikeCont.isloading == false){
        setState(() {
          postbikeCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postbikeCont.postBicycle(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "39"){
      if(postcvehicleCont.isloading == false){
        setState(() {
          postcvehicleCont.isloading = true;
        });
        popup();
        postcvehicleCont.postcVehicle(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(subcatID == "40"){

      if(postcvehicleCont.isloading == false){
        setState(() {
          postcvehicleCont.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postcvehicleCont.postSparepart(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else if(58 <= int.parse(subcatID)){
      if(subcatID == "65" || subcatID == "66"){
        postadController.servicetypeId = "0";
      }
      if(postadController.isloading == false){
        print(">>>>>>>>>>>");
        setState(() {
          postadController.isloading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        postadController.postServices(adPrice: price, address: address, postType: postingType, recordId: recordId, updatecatId: updateCatId);
      }
    } else {
      print(">>>>>>>>>>>${commonPostCont.subcatId}");
      if(commonPostCont.isLoading == false) {
        print(">>>>>>>>>>>");
        setState(() {
          commonPostCont.isLoading = true;
        });
        popup().then((value) {
          isGetHold = false;
          setState(() {});
        },);
        commonPostCont.commonPost(adPrice: price, address: address, recordId: recordId, postType: postingType, updatecatId: updateCatId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getBgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Confirm your details".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(containcolor: PurpleColor, loading: isGetHold, context: context, txt1: "Post Now", onPressed1: () {
          print("<><> ID isPaid $isPaid");
          selectedindex = 0;

          setState(() {});
          if(postingType == "Edit") {
            print("><><><<><><><><>>>>>>>");
            isGetHold = true;
            setState(() {});
            adPost();
          }
          else if(isPaid == 1){
            if(isNavigate) return;
            setState(() {
              isNavigate = true;
            });

            listpackageCont.listofPackage().then((value) {
              setState(() {
                postadController.packageId = listpackageCont.listpackageData!.packageData![0].id!;
                propertiesCont.packageId = listpackageCont.listpackageData!.packageData![0].id!;
                postmobileCont.packageId = listpackageCont.listpackageData!.packageData![0].id!;
                postbikeCont.packageId = listpackageCont.listpackageData!.packageData![0].id!;
                commonPostCont.packageId = listpackageCont.listpackageData!.packageData![0].id!;
                postcvehicleCont.packageId = listpackageCont.listpackageData!.packageData![0].id!;
              });
              showModalBottomSheet(
                backgroundColor: notifier.getBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                context: context, builder: (context) {
                return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              SizedBox(height: 20,),
                              Text("Featured Ad".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 18,fontFamily: FontFamily.gilroyBold,),),
                              SizedBox(height: 10,),
                              listpackageCont.isLoading ? Center(child: CircularProgressIndicator(color: PurpleColor,)) : ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listpackageCont.listpackageData!.packageData!.length,
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 10,);
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState((){

                                        postadController.packageId = listpackageCont.listpackageData!.packageData![index].id!;
                                        propertiesCont.packageId = listpackageCont.listpackageData!.packageData![index].id!;
                                        postmobileCont.packageId = listpackageCont.listpackageData!.packageData![index].id!;
                                        postbikeCont.packageId = listpackageCont.listpackageData!.packageData![index].id!;
                                        commonPostCont.packageId = listpackageCont.listpackageData!.packageData![index].id!;
                                        postcvehicleCont.packageId = listpackageCont.listpackageData!.packageData![index].id!;

                                        print("> PACKAGE ID > ${postadController.packageId}");
                                        selectedPackage = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: notifier.getWhiteblackColor,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(width: 1, color: selectedPackage == index ? PurpleColor : notifier.borderColor)
                                      ),
                                      padding: EdgeInsets.all(10),
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
                                                  activeColor: PurpleColor,
                                                  groupValue: index,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedPackage = index;
                                                    });
                                                  },),
                                              ),
                                              SizedBox(width: 10,),
                                              Text("${listpackageCont.listpackageData!.packageData![index].title}",
                                                style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: notifier.getTextColor,),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text("\$ ${listpackageCont.listpackageData!.packageData![index].price}",
                                            style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, fontWeight: FontWeight.w700, color: notifier.getTextColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },),
                              SizedBox(height: 10,),
                              mainButton(
                                context: context,
                                loading: isGetHold,
                                txt1: "Pay \$${listpackageCont.listpackageData!.packageData![selectedPackage].price}",
                                containcolor: PurpleColor,
                                onPressed1: () {
                                  if(isNavigate) return;
                                  setState((){
                                    isNavigate = true;
                                    isGetHold = true;
                                  });
                                  selectedindex = 0;
                                  paymentgaewayCont.getPaymentgateway().then((value) {
                                    setState((){
                                      mainAmount = listpackageCont.listpackageData!.packageData![selectedPackage].price!;
                                      postadController.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![0].id!;
                                      propertiesCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![0].id!;
                                      postmobileCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![0].id!;
                                      postbikeCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![0].id!;
                                      commonPostCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![0].id!;
                                      postcvehicleCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![0].id!;
                                      selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![0].title!;
                                    walletreportCont.getWalletReport().then((value) {
                                      tempWallet = double.parse(walletreportCont.walletData!.wallet!);
                                      walletAmt = double.parse(walletreportCont.walletData!.wallet!);
                                      amount = double.parse(mainAmount);
                                      walletCheck = false;
                                      isGetHold = false;
                                    },);
                                    });
                                    listpackageCont.listpackageData!.packageData![selectedPackage].price! == "0" ? adPost() : showModalBottomSheet(
                                      backgroundColor: notifier.getBgColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                      context: context,
                                      builder: (context) {
                                        return bottomsheet();
                                      },).then((value) {
                                        setState(() {
                                          isNavigate = false;
                                        });
                                      },);
                                  },);
                                },),
                              SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      );
                    }
                );
              },);
              setState(() {
                isNavigate = false;
              });
            },);
          }
          else {
            setState(() {
              postadController.packageId = "0";
              propertiesCont.packageId = "0";
              postmobileCont.packageId = "0";
              postbikeCont.packageId = "0";
              commonPostCont.packageId = "0";
              postcvehicleCont.packageId = "0";
              postadController.pmethodId = "0";
              propertiesCont.pmethodId = "0";
              postmobileCont.pmethodId = "0";
              postbikeCont.pmethodId = "0";
              commonPostCont.pmethodId = "0";
              postcvehicleCont.pmethodId = "0";
              postadController.transactionId = "0";
              propertiesCont.transactionId = "0";
              postmobileCont.transactionId = "0";
              postbikeCont.transactionId = "0";
              commonPostCont.transactionId = "0";
              postcvehicleCont.transactionId = "0";
            });
            adPost();
          }
        },),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                   width: 70,
                   decoration: BoxDecoration(
                     color: PurpleColor,
                     shape: BoxShape.circle,
                   ),
                  alignment: Alignment.center,
                  child: Text(getData.read("UserLogin")["name"][0], style: TextStyle(fontSize: 20, color: notifier.getWhiteblackColor, fontFamily: FontFamily.gilroyBold),),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your name".tr, style: TextStyle(fontSize: 14, color: PurpleColor, fontFamily: FontFamily.gilroyMedium),),
                      SizedBox(
                        height: 30,
                          child: TextField(
                            readOnly: true,
                            controller: addUserName,
                            keyboardType: TextInputType.name,
                            style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: notifier.getTextColor, width: 1)
                              ),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: PurpleColor, width: 1)),
                              border: UnderlineInputBorder(borderSide: BorderSide(color: PurpleColor, width: 1)),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Text("Verified phone number".tr, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: PurpleColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(3),
                  child: SvgPicture.asset("assets/checkIcon.svg", height: 12,),
                ),
                SizedBox(width: 8,),
                Text("${getData.read("UserLogin")["ccode"]}${getData.read("UserLogin")["mobile"]}",
                  style: TextStyle(fontSize: 14, letterSpacing: 0.5, color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomsheet(){
    return GetBuilder<WalletreportController>(
      builder: (walletreportCont) {
      return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(height: 10,),
                    walletAmt == 0 ? SizedBox() : Row(
                      children: [
                        Image.asset("assets/account_icons/empty-wallet.png", height: 40, color: PurpleColor,),
                        SizedBox(width: 10,),
                        Text("${"My Wallet".tr} ($currency$tempWallet)"
                           , style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),),
                        Spacer(),
                        Transform.scale(
                          scale: 0.9,
                          child: CupertinoSwitch(
                            value: walletCheck,
                            activeColor: PurpleColor,
                            offLabelColor: GreyColor,
                            onChanged: (value) async{

                              setState((){

                                walletCheck =! walletCheck;

                                if(walletCheck){
                                  if(walletAmt <= double.parse(mainAmount)){
                                    walletMain = walletAmt;
                                    mainAmount = (amount - walletAmt).toString();
                                    tempWallet = 0;
                                    print("TEMP WALLET 1 $tempWallet - $mainAmount - $walletMain");
                                  } else {
                                    walletMain = amount;
                                    tempWallet = walletAmt - amount;
                                    mainAmount = "0";
                                    print("TEMP WALLET 2 $tempWallet - $mainAmount - $walletMain");
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

                                  if(walletCheck && mainAmount == "0"){
                                    walletCheck = false;
                                    tempWallet = walletAmt;
                                    mainAmount = amount.toString();
                                  } else {
                                    postadController.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![index].id!;
                                    propertiesCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![index].id!;
                                    postmobileCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![index].id!;
                                    postbikeCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![index].id!;
                                    commonPostCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![index].id!;
                                    postcvehicleCont.pmethodId = paymentgaewayCont.gatewayData!.paymentdata![index].id!;

                                    print("> PMETHOD ID > ${postadController.pmethodId}");
                                    selectedindex = index;
                                    selectedPayment = paymentgaewayCont.gatewayData!.paymentdata![index].title!;
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: notifier.getWhiteblackColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: selectedindex == index ? PurpleColor : backGrey)
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
                        onPressed1: () {
                          print("WALLET CHECK $walletCheck $mainAmount");
                          postadController.walletAmt = walletMain.toString();
                          propertiesCont.walletAmt = walletMain.toString();
                          postmobileCont.walletAmt = walletMain.toString();
                          postbikeCont.walletAmt = walletMain.toString();
                          commonPostCont.walletAmt = walletMain.toString();
                          postcvehicleCont.walletAmt = walletMain  .toString();
                          if(walletCheck && double.parse(mainAmount) == 0) {
                            setState(() {
                              postadController.pmethodId = "5";
                              propertiesCont.pmethodId = "5";
                              postmobileCont.pmethodId = "5";
                              postbikeCont.pmethodId = "5";
                              commonPostCont.pmethodId = "5";
                              postcvehicleCont.pmethodId = "5";
                              postadController.transactionId = "0";
                              propertiesCont.transactionId = "0";
                              postmobileCont.transactionId = "0";
                              postbikeCont.transactionId = "0";
                              commonPostCont.transactionId = "0";
                              postcvehicleCont.transactionId = "0";
                            });
                            print("Posted ???");
                            adPost();
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
                            else if(selectedPayment == "Paypal"){
                              List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!.split(",");
                              Get.back();
                              print(keyList.toString());
                              paypalPayment(mainAmount, keyList[0], keyList[1]);
                            }
                            else if(selectedPayment == "Stripe"){
                              Get.back();
                              stripePayment();
                            }
                            else if(selectedPayment == "PayStack") {
                              paystackCont.getPaystack(amount: mainAmount).then((value) {
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
                                    setState(() {
                                      postadController.transactionId = otid.toString();
                                      propertiesCont.transactionId = otid.toString();
                                      postmobileCont.transactionId = otid.toString();
                                      postbikeCont.transactionId = otid.toString();
                                      commonPostCont.transactionId = otid.toString();
                                      postcvehicleCont.transactionId = otid.toString();
                                    });
                                    print("><><><><> ??? ><><><><>${otid.toString()}");
                                    print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                    print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                    adPost();
                                  }
                                });
                              },);
                            }
                            else if(selectedPayment == "FlutterWave") {
                              print("${Config.paymentBaseUrl}flutterwave/index.php?amt=$mainAmount&email=${getData.read("UserLogin")["email"]}");
                              Get.to(() => PaymentWebVIew(
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
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "Paytm") {
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}paytm/index.php?amt=$mainAmount&uid=${getData.read("UserLogin")["id"]}",
                                navigationDelegate: (NavigationRequest request) async {
                                  final uri = Uri.parse(request.url);

                                  if (uri.queryParameters["status"] == null) {
                                    accessToken = uri.queryParameters["token"];
                                  } else {
                                    if (uri.queryParameters["status"] == "successful") {
                                      payerID = await uri.queryParameters["transaction_id"];
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
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "SenangPay") {
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}result.php?detail=Movers&amount=$mainAmount&order_id=$notificationId&name=${getData.read("UserLogin")["name"]}&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}",
                                navigationDelegate: (NavigationRequest request) async {

                                  final uri = Uri.parse(request.url);
                                  print("${Config.paymentBaseUrl}result.php?detail=Movers&amount=$mainAmount&order_id=$notificationId&name=${getData.read("UserLogin")["name"]}&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}");
                                  print("SENANG PAY ${uri.queryParameters}");
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
                                
                                if (otid != null) {
                                  showToastMessage("Payment done Successfully".tr);
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "MercadoPago") {
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}merpago/index.php?amt=$mainAmount",
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
                                Get.back();
                                
                                if (otid != null) {
                                  showToastMessage("Payment done Successfully".tr);
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "Payfast"){
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}Payfast/index.php?amt=$mainAmount",
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
                                      showToastMessage("${uri.queryParameters["ResponseMsg"]}");
                                    }
                                  }

                                  return NavigationDecision.navigate;
                                },))!.then((otid) {
                                Get.back();
                                
                                if (otid != null) {
                                  showToastMessage("Payment done Successfully".tr);
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "Midtrans") {
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}Midtrans/index.php?name=test&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}&amt=${mainAmount}",
                                navigationDelegate: (NavigationRequest request) async {
                                  final uri = Uri.parse(request.url);
                                  print("PAYING DETAILS ${uri.queryParameters}");
                                  if (uri.queryParameters["transaction_status"] == null) {
                                    accessToken = uri.queryParameters["order_id"];
                                  } else {
                                    if (uri.queryParameters["transaction_status"] == "capture") {
                                      payerID = uri.queryParameters["order_id"]!;
                                      Get.back(result: payerID);
                                      print('payerID');
                                    } else {
                                      Get.back();
                                      showToastMessage("${uri.queryParameters["ResponseMsg"]}");
                                    }
                                  }

                                  return NavigationDecision.navigate;
                                },))!.then((otid) {
                                Get.back();
                                
                                if (otid != null) {
                                  showToastMessage("Payment done Successfully".tr);
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "2checkout"){
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}2checkout/index.php?amt=${mainAmount}",
                                navigationDelegate: (NavigationRequest request) async {
                                  final uri = Uri.parse(request.url);

                                  print("@CHECKOUT ${uri.queryParameters}");
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
                                Get.back();
                                
                                if (otid != null) {
                                  showToastMessage("Payment done Successfully".tr);
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                            else if(selectedPayment == "Khalti Payment"){
                              Get.to(() => PaymentWebVIew(
                                initialUrl: "${Config.paymentBaseUrl}Khalti/index.php?amt=${mainAmount}",
                                navigationDelegate: (NavigationRequest request) async {
                                  final uri = Uri.parse(request.url);

                                  if (uri.queryParameters["status"] == null) {
                                    accessToken = uri.queryParameters["merchant_account_id"];
                                  } else {
                                    if (uri.queryParameters["status"] == "Completed") {
                                      payerID = uri.queryParameters["transaction_id"]!;
                                      Get.back(result: payerID);
                                      print('payerID');
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
                                  setState(() {
                                    postadController.transactionId = otid.toString();
                                    propertiesCont.transactionId = otid.toString();
                                    postmobileCont.transactionId = otid.toString();
                                    postbikeCont.transactionId = otid.toString();
                                    commonPostCont.transactionId = otid.toString();
                                    postcvehicleCont.transactionId = otid.toString();
                                  });
                                  print("><><><><> ??? ><><><><>${otid.toString()}");
                                  print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
                                  print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
                                  adPost();
                                }
                              });
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );
    },);
  }

  Future popup(){
    return showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context) {
      return Center(
        child: SizedBox(),
      );
    },
    );
  }

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
                                              TextStyle(color: Colors.black),
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
                                      txt1: "${"Pay".tr} ${currency}${mainAmount}",
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
      _paymentCard.amount = mainAmount.toString();
      form.save();

      Get.to(() => StripePaymentWeb(url: 'stripe/index.php?name=${_paymentCard.name}&email=${_paymentCard.email}&cardno=${_paymentCard.number}&cvc=${_paymentCard.cvv}&amt=${_paymentCard.amount}&mm=${_paymentCard.month}&yyyy=${_paymentCard.year}'))!.then((otid) {
        Get.back();
        
        if (otid != null) {
          showToastMessage("Payment done Successfully".tr);
          setState(() {
            postadController.transactionId = otid.toString();
            propertiesCont.transactionId = otid.toString();
            postmobileCont.transactionId = otid.toString();
            postbikeCont.transactionId = otid.toString();
            commonPostCont.transactionId = otid.toString();
            postcvehicleCont.transactionId = otid.toString();
          });
          print("><><><><> ??? ><><><><>${otid.toString()}");
          print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
          print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
          adPost();
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
              setState(() {
                postadController.transactionId = params["paymentId"].toString();
                propertiesCont.transactionId = params["paymentId"].toString();
                postmobileCont.transactionId = params["paymentId"].toString();
                postbikeCont.transactionId = params["paymentId"].toString();
                commonPostCont.transactionId = params["paymentId"].toString();
                postcvehicleCont.transactionId = params["paymentId"].toString();
              });
              print("><><><><> ??? ><><><><>${params["paymentId"].toString()}");
              print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
              print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
              adPost();
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
    setState(() {
      postadController.transactionId = response.paymentId.toString();
      propertiesCont.transactionId = response.paymentId.toString();
      postmobileCont.transactionId = response.paymentId.toString();
      postbikeCont.transactionId = response.paymentId.toString();
      commonPostCont.transactionId = response.paymentId.toString();
      postcvehicleCont.transactionId = response.paymentId.toString();
    });
    print("><><><><> ??? ><><><><>${response.paymentId.toString()}");
    print("><><><><> PAYMETHOD ID ><><><><>${postcvehicleCont.pmethodId}");
    print("><><><><> PACKAGE ID ><><><><>${postcvehicleCont.packageId}");
    Get.back();
    adPost();
  }
  void handlePaymentError(PaymentFailureResponse response) {}
  void handleExternalWallet(ExternalWalletResponse response) {}
}
