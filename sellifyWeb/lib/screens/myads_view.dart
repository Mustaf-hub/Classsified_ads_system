import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:readmore/readmore.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/carbrandlist_controller.dart';
import 'package:sellify/controller/carvariation_controller.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/marksold_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/bikecvehiclecontoller.dart';
import 'package:sellify/controller/postad/commonpost_controller.dart';
import 'package:sellify/controller/postad/postbike_controller.dart';
import 'package:sellify/controller/postad/postcvehicle_controller.dart';
import 'package:sellify/controller/postad/postmobile_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/addProduct/adcommonpost.dart';
import 'package:sellify/screens/addProduct/addVehicle/addbikes.dart';
import 'package:sellify/screens/addProduct/addjob_detail.dart';
import 'package:sellify/screens/addProduct/addmobiles.dart';
import 'package:sellify/screens/addProduct/addservices.dart';
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/payment_gateway/card_formater.dart';
import 'package:sellify/screens/payment_gateway/payment_card.dart';
import 'package:sellify/screens/payment_gateway/razorpay_screen.dart';
import 'package:sellify/screens/payment_gateway/webview_screen.dart';
import 'package:sellify/screens/storypage.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:sellify/utils/mq.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/listpackage_controller.dart';
import '../controller/login_controller.dart';
import '../controller/makefeature_controller.dart';
import '../controller/paymentgaeway_cont.dart';
import '../controller/paystackcontroller.dart';
import '../controller/repub_controller.dart';
import '../controller/walletreport_controller.dart';
import '../helper/appbar_screen.dart';
import '../helper/web_payment_controller.dart';
import '../language/translatelang.dart';
import 'StripeWeb.dart';
import 'addProduct/addVehicle/addc_vehicle.dart';
import 'addProduct/addproperties.dart';

class MyadsView extends StatefulWidget {
  const MyadsView({super.key});

  @override
  State<MyadsView> createState() => _MyadsViewState();
}

class _MyadsViewState extends State<MyadsView> {
  List<String> locationPart = [];
  String area = "";
  String city = "";
  
  bool isMakeFeature = false;

  int prodIndex = Get.arguments["productindex"];
  MyadlistController myadlistCont = Get.find();
  CarbrandlistController carbrandlistCon = Get.find();
  CarvariationController carvariationCont = Get.find();
  CategoryListController subcategoryCont = Get.find();
  BikescooterCvehicleContoller bikescooterCvehicleCont = Get.find();
  PostadController postadController = Get.find();
  PostmobileController postmobileCont = Get.find();
  PostbikeController postbikeCont = Get.find();
  CommonPostController commonPostCont = Get.find();
  PostcvehicleController postcvehicleCont = Get.find();
  PropertiesController propertiesCont = Get.find();
  MarkSoldController markSoldCont = Get.find();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dayAgo();
    setState(() {
      postType = myadlistCont.myadlistData!.myadList![prodIndex].postType ?? "";
      subcatId = int.parse(myadlistCont.myadlistData!.myadList![prodIndex].subcatId!);
    });

    razorpayScreen.initiateRazorpay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);

    if(subcatId == 0) {
      carbrandlistCon.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
        for(int i = 0; i < carbrandlistCon.carbrandData!.carbrandlist!.length;i++){
          if(myadlistCont.myadlistData!.myadList![prodIndex].brandId == carbrandlistCon.carbrandData!.carbrandlist![i].id){
            setState(() {
              brandName = carbrandlistCon.carbrandData!.carbrandlist![i].title!;
            });
            carvariationCont.carvariation(brandId: carbrandlistCon.carbrandData!.carbrandlist![i].id).then((value) {
              for(int i = 0; i < carvariationCont.carvariationData!.carvariationlist!.length; i++){
                if(myadlistCont.myadlistData!.myadList![prodIndex].variantId == carvariationCont.carvariationData!.carvariationlist![i].id){
                  setState(() {
                    model = carvariationCont.carvariationData!.carvariationlist![i].title!;
                  });
                }
              }
            },);
          }
        }
      },);
    } else if(subcatId <= 9 || subcatId == 28 || subcatId == 40 || (58 <= subcatId && subcatId <= 64)){
      subcategoryCont.subcatType(subcatID: subcatId.toString()).then((value) {
        for(int i = 0; i < subcategoryCont.subcatTypeData!.subtypelist!.length;i++){
          if(myadlistCont.myadlistData!.myadList![prodIndex].mobileBrand == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].propertyType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
               myadlistCont.myadlistData!.myadList![prodIndex].bicyclesBrandId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
                myadlistCont.myadlistData!.myadList![prodIndex].serviceTypeId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].accessoriesType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].tabletType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].sparepartTypeId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].pgSubtype == subcategoryCont.subcatTypeData!.subtypelist![i].id){
            setState(() {
              brandName = subcategoryCont.subcatTypeData!.subtypelist![i].title!;
            });
          }
        }
      },);
    } else if((25 == subcatId || 26 == subcatId) || subcatId == 39){
      bikescooterCvehicleCont.getvehicle(subcatId: subcatId.toString()).then((value) {
        for(int i = 0; i < bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist!.length; i++){
          if (myadlistCont.myadlistData!.myadList![prodIndex].motocycleBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].scooterBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id ||
              myadlistCont.myadlistData!.myadList![prodIndex].commercialBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id) {
            setState(() {
              brandName = bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].title!;
            });
          }
          bikescooterCvehicleCont.getModel(brandId: bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id!).then((value) {
            for(int i = 0; i < bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist!.length; i++){
             if(myadlistCont.myadlistData!.myadList![prodIndex].motorcycleModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id ||
                 myadlistCont.myadlistData!.myadList![prodIndex].scooterModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id ||
                 myadlistCont.myadlistData!.myadList![prodIndex].commercialModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id){
               setState(() {
                 model = bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].title!;
               });
             }
           }
          },);
        }
      },);
    }

    lathome = double.parse(myadlistCont.myadlistData!.myadList![prodIndex].lats!);
    longhome = double.parse(myadlistCont.myadlistData!.myadList![prodIndex].longs!);
    _onAddMarkerButtonPressed(lathome, longhome);

    String partsOfArea = myadlistCont.myadlistData!.myadList![prodIndex].fullAddress!;

    List partArea = partsOfArea.split(", ");
    if(partArea[0] != "") {
      if(partArea[0] == partArea[1] && partArea.length > 3){
        area = partArea[0];
        city = partArea[2];
      } else if(partArea[0] == partArea[1]){
        area = partArea[0];
        city = partArea[1];
      } else {
        area = partArea[0];
        city = partArea[1];
      }
    } else {
      area = partArea[1];
      city = partArea[2];
    }

    for (int i = 0; i < myadlistCont.myadlistData!.myadList![prodIndex].postAllImage!.length; i++) {
      stories.add(myadlistCont.myadlistData!.myadList![prodIndex].postAllImage![i]);
    }

  }

  String postType = "";
  String catId = "0";

  var lathome;
  var longhome;

  List detailImage = [
    "assets/km.png",
    "assets/geartype.png",
    "assets/fueltype.png",
  ];

  List detail2 = [
    "",
    "Owner".tr,
    "Posting date".tr
  ];

  List detail = [
    "25,000 Km",
    "Manual",
    "Petrol"
  ];

  List detailImage2 = [
    "assets/location.png",
    "assets/owner.png",
    "assets/postingdate.png"
  ];

  List contactImage = [
    "assets/phone.png",
    "assets/message.png",
    "assets/map.png"
  ];

  List proDetailTitle = [
    "Brand",
    "Model",
    "Year",
    "Fuel Type"
  ];

  String adAddress = "";
  late GoogleMapController mapController1;
  Set<Marker> markers = {};
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  Future<void> _onAddMarkerButtonPressed(double? lat, long) async {
    final Uint8List markIcon = await getImages("assets/pinIcon.png", kIsWeb ? 20 : 80);
    markers.add(Marker(
      markerId: const MarkerId("1"),
      position: LatLng(double.parse(lat.toString()),double.parse(long.toString())),
      
      icon: BitmapDescriptor.fromBytes(markIcon),
    ));
    setState(() {

    });
  }

  final List<String> stories = [];

  String brandName = "";
  String model = "";

  int subcatId = 0;

  int daysAgo = 0;

  dayAgo(){
    setState(() {
      DateTime postDate = DateTime.parse("${myadlistCont.myadlistData!.myadList![prodIndex].postDate}");

      DateTime currentDate = DateTime.now();

      Duration difference = currentDate.difference(postDate);

      daysAgo = difference.inDays;
    });
  }

  List mark = [
    "Sold InSide",
    "Sold OutSide"
  ];

  PaystackController paystackCont = Get.find();
  PaymentgaewayController paymentgaewayCont = Get.find();
  WalletreportController walletreportCont = Get.find();
  ListpackageController listpackageCont = Get.find();
  RepubController repubCont = Get.find();
  MakeFeatureController makeFeatureCont = Get.find();
  WebPaymentController webPaymentCont = Get.find();

  var numberController = TextEditingController();

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

  int selectedMark = 0;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          bottomNavigationBar: 850 < constraints.maxWidth ? const SizedBox()
              : GetBuilder<MyadlistController>(
            builder: (myadlistCont) {
              return (myadlistCont.myadlistData!.myadList![prodIndex].isExpire == "1" && myadlistCont.myadlistData!.myadList![prodIndex].isSold == "1") ? const SizedBox() : bottomButtons();
            }
          ),
          body: ScrollConfiguration(
            behavior: CustomBehavior(),
            child: SafeArea(
              child: Column(
                children: [
                  kIsWeb ? SizedBox(height: 75, child: CommonAppbar())
                      : const SizedBox(),
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          kIsWeb ? SliverAppBar(
                            elevation: 0,
                            expandedHeight: 400,
                            floating: false,
                            pinned: true,
                            backgroundColor: notifier.getBgColor,
                            centerTitle: false,
                            automaticallyImplyLeading: false,
                            title: Padding(
                              padding: EdgeInsets.only(left: rtl ? 0 : 1600 < constraints.maxWidth ? 395 : 1200 < constraints.maxWidth ? 195 : 900 < constraints.maxWidth ? 45 : 0, right: rtl ? 1600 < constraints.maxWidth ? 400 : 1200 < constraints.maxWidth ? 200 : 900 < constraints.maxWidth ? 50 : 0 : 0),
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: notifier.getWhiteblackColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: notifier.borderColor),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/arrowLeftIcon.png", height: 20, color: notifier.iconColor,),
                                ),
                              ),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Storypage(stories: stories, title: myadlistCont.myadlistData!.myadList![prodIndex].postTitle ?? "", isFeatured: myadlistCont.myadlistData!.myadList![prodIndex].isFeatureAd ?? "",),
                            ),
                          )
                          : SliverAppBar(
                            elevation: 0,
                            expandedHeight: 400,
                            floating: false,
                            pinned: true,
                            backgroundColor: notifier.getBgColor,
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: notifier.getWhiteblackColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: notifier.borderColor),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/arrowLeftIcon.png", height: 20, color: notifier.iconColor,),
                                ),
                              ),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Storypage(stories: stories, title: myadlistCont.myadlistData!.myadList![prodIndex].postTitle ?? "", isFeatured: myadlistCont.myadlistData!.myadList![prodIndex].isFeatureAd ?? "",),
                            ),
                          )
                        ];
                      },
                      body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 1600 < constraints.maxWidth ? 395 : 1200 < constraints.maxWidth ? 195 : 900 < constraints.maxWidth ? 45 : 12),
                            child: constraints.maxWidth < 850 ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                viewData(),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  height: 180,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: GoogleMap(
                                      gestureRecognizers: {
                                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                                      },
                                      initialCameraPosition: CameraPosition(target: LatLng(lathome, longhome), zoom: 13),
                                      mapType: MapType.normal,
                                      markers: Set<Marker>.of(markers),
                                      myLocationEnabled: false,
                                      zoomGesturesEnabled: true,
                                      tiltGesturesEnabled: true,
                                      zoomControlsEnabled: true,
                                      onMapCreated: (controller) {
                                        setState(() {
                                          mapController1 = controller;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ) : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: viewData()),
                                const SizedBox(width: 15,),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: notifier.getWhiteblackColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: bottomButtons()),
                                      const SizedBox(height: 15,),
                                      SizedBox(
                                       height: 180,
                                       child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: GoogleMap(
                                        gestureRecognizers: {
                                          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                                        },
                                        initialCameraPosition: CameraPosition(target: LatLng(lathome, longhome), zoom: 13),
                                        mapType: MapType.normal,
                                        markers: Set<Marker>.of(markers),
                                        myLocationEnabled: false,
                                        zoomGesturesEnabled: true,
                                        tiltGesturesEnabled: true,
                                        zoomControlsEnabled: true,
                                        onMapCreated: (controller) {
                                          setState(() {
                                            mapController1 = controller;
                                          });
                                        },
                                      ),
                                       ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: kIsWeb ? 10 : 0,),
                          kIsWeb ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                            child: footer(context),
                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget bottomButtons(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(0),
                    alignment: Alignment.center,
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 12)
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        side: BorderSide(color: PurpleColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: const WidgetStatePropertyAll(Colors.transparent)
                ),
                onPressed: () {
                  setState(() {
                    if(subcatId == 0){

                      postadController.catId = catId;
                      postadController.subcatId = "0";

                      Get.to(const Chooselocation(), arguments: {
                        "route" : Routes.myadsView,
                        "latmap" : myadlistCont.myadlistData!.myadList![prodIndex].lats,
                        "longmap" : myadlistCont.myadlistData!.myadList![prodIndex].longs,
                        "postaddress" : myadlistCont.myadlistData!.myadList![prodIndex].fullAddress,
                        "adIndex" : prodIndex,
                      }, transition: Transition.noTransition);
                    }
                    else if(subcatId <= 6) {
                      propertiesCont.catId = catId;
                      propertiesCont.subcatId = subcatId.toString();

                      subcategoryCont.subcatType(subcatID: subcatId.toString()).then((value) {
                        Get.to(const Addproperties(), arguments: {
                          "subcatId" : subcatId.toString(),
                          "adIndex" : prodIndex,
                          "postingType" : "Edit"
                        }, transition: Transition.noTransition);
                      },);

                    } else if(subcatId <= 9) {

                      postmobileCont.catId = catId;
                      postmobileCont.subcatId = subcatId.toString();
                      subcategoryCont.subcatType(subcatID: subcatId.toString()).then((value) {
                        Get.to(const Addmobiles(), arguments: {
                          "subcatId" : subcatId.toString(),
                          "adIndex" : prodIndex,
                          "postingType" : "Edit"
                        }, transition: Transition.noTransition);
                      },);

                    } else if (subcatId <= 24) {

                      postadController.catId = catId;
                      postadController.subcatId = subcatId.toString();
                      Get.to(const AddjobDetail(), arguments: {
                        "jobType": subcatId.toString(),
                        "subcatId" : subcatId.toString(),
                        "adIndex" : prodIndex,
                        "postingType" : "Edit"
                      }, transition: Transition.noTransition);

                    } else if(subcatId <= 26 || subcatId == 28){

                      postbikeCont.catId = catId;
                      postbikeCont.subcatId = subcatId.toString();

                      bikescooterCvehicleCont.getvehicle(subcatId: subcatId.toString()).then((value) {
                        Get.to(const Addbikes(), arguments: {
                          "subcatId" : subcatId.toString(),
                          "adIndex" : prodIndex,
                          "postingType" : "Edit"
                        }, transition: Transition.noTransition);
                      },);

                    } else if(subcatId == 39 || subcatId == 40){

                      postcvehicleCont.catId = catId;
                      postcvehicleCont.subcatId = subcatId.toString();
                      bikescooterCvehicleCont.getvehicle(subcatId: subcatId.toString()).then((value) {
                        Get.to(const AddcVehicle(), arguments: {
                          "subcatId" : subcatId.toString(),
                          "adIndex" : prodIndex,
                          "postingType" : "Edit"
                        }, transition: Transition.noTransition);
                      },);
                    } else if(58 <= subcatId && subcatId <= 66) {
                      postadController.catId = catId;
                      postadController.subcatId = subcatId.toString();
                      subcategoryCont.subcatType(subcatID: subcatId.toString()).then((value) {
                        Get.to(const Addservices(), arguments: {
                          "subcatId" : subcatId.toString(),
                          "adIndex" : prodIndex,
                          "postingType" : "Edit"
                        }, transition: Transition.noTransition);
                      },);
                    } else {
                      commonPostCont.catId = catId;
                      commonPostCont.subcatId = subcatId.toString();
                      Get.to(const Adcommonpost(), transition: Transition.noTransition, arguments: {
                        "subcatId" : subcatId.toString(),
                        "adIndex" : prodIndex,
                        "postingType" : "Edit"
                      });
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(kIsWeb ? 10 : 0),
                  child: Text("Edit".tr, style: TextStyle(color: PurpleColor, letterSpacing: 1, fontFamily: FontFamily.gilroyMedium, fontWeight: ui.FontWeight.w700, fontSize: 18),),
                )),
          ),
          const SizedBox(width: 10,),
          myadlistCont.myadlistData!.myadList![prodIndex].isApprove == "0" ? const SizedBox() : (myadlistCont.myadlistData!.myadList![prodIndex].isExpire == "1" && myadlistCont.myadlistData!.myadList![prodIndex].isSold == "1") ? const SizedBox() : (myadlistCont.myadlistData!.myadList![prodIndex].isExpire == "0" && myadlistCont.myadlistData!.myadList![prodIndex].isSold == "1") ? Expanded(child: Text("Already soldout.".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontWeight: FontWeight.w600, color: notifier.getTextColor, fontSize: 18),textAlign: TextAlign.center,))
              : Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(0),
                    alignment: Alignment.center,
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 12)
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(PurpleColor)
                ),
                onPressed: () {
                  if(myadlistCont.myadlistData!.myadList![prodIndex].isExpire == "0" && myadlistCont.myadlistData!.myadList![prodIndex].isSold == "0"){
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
                                                              markSoldCont.getMarskSold(postId: myadlistCont.myadlistData!.myadList![prodIndex].postId!, soldType: selectedMark == 0 ? "inside" : "outside").then((value) {
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
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                        context: context, builder: (context) {
                        return LayoutBuilder(
                            builder: (context, constraints) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
                                    child: BackdropFilter(
                                      filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
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
                                              Text("Featured Ad".tr, style: TextStyle(color: notifier.getTextColor, fontSize: 18,fontFamily: FontFamily.gilroyBold,),),
                                              const SizedBox(height: 10,),
                                              listpackageCont.isLoading ? Center(child: CircularProgressIndicator(color: PurpleColor,)) : ListView.separated(
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
                                                txt1: "${"Pay".tr} \$${listpackageCont.listpackageData!.packageData![selectedPackage].price}",
                                                containcolor: PurpleColor,
                                                onPressed1: () {
                                                  selectedindex = 0;
                                                  isMakeFeature = true;
                                                  setState((){});
                                                  showModalBottomSheet(
                                                    backgroundColor: Colors.transparent,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                                    context: context,
                                                    builder: (context) {
                                                      return bottomsheet(isFeature: true);
                                                    },);
                                                },),
                                              const SizedBox(height: 20,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              );
                            }
                        );
                      },);
                    },);
                  }
                }, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 10 : 0),
                child: Text((myadlistCont.myadlistData!.myadList![prodIndex].isExpire == "0" && myadlistCont.myadlistData!.myadList![prodIndex].isSold == "0") ? "Mark as Sold".tr : "Republish Ad".tr, style: TextStyle(color: WhiteColor, fontFamily: FontFamily.gilroyRegular, fontWeight: ui.FontWeight.w700, letterSpacing: 1, fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 1,),
              ),
            )),
          ),
        ],
      ),
    );
  }
  Widget viewData(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(myadlistCont.myadlistData!.myadList![prodIndex].postTitle!, style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 21),overflow: TextOverflow.ellipsis, maxLines: 2,)),
                  myadlistCont.myadlistData!.myadList![prodIndex].adPrice == "0" ? const SizedBox() : Text("$currency ${addCommas(myadlistCont.myadlistData!.myadList![prodIndex].adPrice!)}", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 18),),
                ],
              ),
              const SizedBox(height: 6,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset("assets/location.png", height: 16, color: notifier.iconColor),
                        const SizedBox(width: 5,),
                        Flexible(child: Text(getAddress(address: myadlistCont.myadlistData!.myadList![prodIndex].fullAddress!), style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 14),overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Text("$daysAgo ${"Days ago".tr}", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 12),),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        subcatId == 0 ? vehicleData()
         : (subcatId <= 6) ? propertyData()
            : (subcatId <= 9 || subcatId == 28 || (58 <= subcatId && subcatId <= 64)) ? brandData()
              : (subcatId <= 26 || subcatId == 40) ? otherData()
                : commonPost(),
      ],
    );
  }
  Widget vehicleData () {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  for(int i = 0; i < 3; i++)
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(detailImage[i], scale: 1.5, color: notifier.iconColor),
                          const SizedBox(width: 5,),
                          Text(i == 0 ? "${myadlistCont.myadlistData!.myadList![prodIndex].kmDriven ?? ""} km" : i == 1 ? myadlistCont.myadlistData!.myadList![prodIndex].transmission ?? "" : myadlistCont.myadlistData!.myadList![prodIndex].fuel ?? "", style: TextStyle(fontSize: height / 67, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10,),
              Divider(color: lightGreyColor, thickness: 0.5,),
              const SizedBox(height: 10,),
              Row(
                children: [
                  for(int i = 0; i < 3; i++)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(detailImage2[i], height: 16, color: notifier.iconColor,),
                          const SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i == 0 ? area : detail2[i], style: TextStyle(fontSize: height / 67, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                Text(i == 0 ? city : i == 1 ? myadlistCont.myadlistData!.myadList![prodIndex].noOwner ?? "" : formatDate(myadlistCont.myadlistData!.myadList![prodIndex].postDate.toString().split(" ").first), style: TextStyle(fontSize: height / 60, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700),overflow: TextOverflow.ellipsis, maxLines: 1,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              ReadMoreText(
                myadlistCont.myadlistData!.myadList![prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Brand".tr, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                    ],
                  ),
                  Text(brandName, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: notifier.borderColor, thickness: 1,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Model".tr, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                    ],
                  ),
                  Text(model, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: notifier.borderColor, thickness: 1,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Year".tr, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                    ],
                  ),
                  Text(myadlistCont.myadlistData!.myadList![prodIndex].postYear!, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: notifier.borderColor, thickness: 1,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Fuel Type".tr, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                    ],
                  ),
                  Text(myadlistCont.myadlistData!.myadList![prodIndex].fuel!, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget propertyData () {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: (subcatId == 4 || subcatId == 5) ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              subcatId == 4 ? const SizedBox() : detailRow("TYPE".tr,brandName),
              SizedBox(height: subcatId == 4 ? 0 : 10,),
              detailRow("LISTED BY".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FURNISHING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyFurnishing ?? "-"),
              const SizedBox(height: 10,),
              detailRow("SUPER BUILTUP AREA (FT²)".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertySuperbuildarea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CARPET AREA (FT²)".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyCarpetarea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("MAINTENANCE (MONTHLY)".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyMaintainceMonthly ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CAR PARKING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyCarParking ?? "-"),
              const SizedBox(height: 10,),
              detailRow("WASHROOMS".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyBathroom ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, myadlistCont.myadlistData!.myadList![prodIndex].projectName ?? "-"),
            ],
          ) : brandName.isEmpty ? ListView.separated(
            shrinkWrap: true,
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return shimmer(baseColor: notifier.shimmerbase2, context: context, height: 30);
          },) : subcatId <= 2 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
              const SizedBox(height: 10,),
              detailRow("BEDROOMS".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyBedroom ?? "-"),
              const SizedBox(height: 10,),
              detailRow("BATHROOMS".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyBathroom ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FURNISHING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyFurnishing ?? "-"),
              const SizedBox(height: 10,),
              subcatId == 2 ? const SizedBox() : detailRow("CONSTRUCTION STATUS".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyConstructionStatus ?? "-"),
              subcatId == 2 ? const SizedBox() : const SizedBox(height: 10,),
              detailRow("LISTED BY".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("SUPER BUILTUP AREA (FT²)".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertySuperbuildarea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CARPET AREA (FT²)".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyCarpetarea ?? "-"),
              subcatId == 2 ? const SizedBox() : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  detailRow("MAINTENANCE (MONTHLY)".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyMaintainceMonthly ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("TOTAL FLOORS".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyTotalFloor ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("FLOOR NO".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyFloorNo ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("CAR PARKING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyCarParking ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("FACING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyFacing ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("PROJECT NAME".tr, myadlistCont.myadlistData!.myadList![prodIndex].projectName ?? "-"),
                ],
              ),
            ],
          )
              : subcatId == 3 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
              const SizedBox(height: 10,),
              detailRow("LISTED BY".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PLOT AREA".tr, myadlistCont.myadlistData!.myadList![prodIndex].plotArea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("LENGTH".tr, myadlistCont.myadlistData!.myadList![prodIndex].plotLength ?? "-"),
              const SizedBox(height: 10,),
              detailRow("BREADTH".tr, myadlistCont.myadlistData!.myadList![prodIndex].plotBreadth ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FACING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyFacing ?? "-"),
             const SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, myadlistCont.myadlistData!.myadList![prodIndex].projectName ?? "-"),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
              const SizedBox(height: 10,),
              detailRow("LISTED BY".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("MEALS INCLUDED".tr, myadlistCont.myadlistData!.myadList![prodIndex].pgMealsInclude == "1" ? "Yes".tr : "No".tr),
              const SizedBox(height: 10,),
              detailRow("FURNISHING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyFurnishing ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CAR PARKING".tr, myadlistCont.myadlistData!.myadList![prodIndex].propertyCarParking ?? "-"),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              ReadMoreText(
                myadlistCont.myadlistData!.myadList![prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget otherData() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: subcatId <= 24 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("POSITION TYPE".tr, myadlistCont.myadlistData!.myadList![prodIndex].jobPositionType ?? "-"),
              detailRow("SALARY FROM".tr, myadlistCont.myadlistData!.myadList![prodIndex].jobSalaryFrom ?? "-"),
              detailRow("SALARY TO".tr, myadlistCont.myadlistData!.myadList![prodIndex].jobSalaryTo ?? "-"),
              detailRow("SALARY PERIOD".tr, myadlistCont.myadlistData!.myadList![prodIndex].jobSalaryPeriod ?? "-"),
            ],
          ) : (brandName.isEmpty && model.isEmpty) ? ListView.separated(
            shrinkWrap: true,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return shimmer(baseColor: notifier.shimmerbase2, context: context, height: 30);
            },) : subcatId <= 29 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
               detailRow("BRAND".tr, brandName),
              detailRow("MODEL".tr, model),
              detailRow("YEAR".tr, myadlistCont.myadlistData!.myadList![prodIndex].postYear ?? "-"),
              detailRow("KM DRIVEN".tr, myadlistCont.myadlistData!.myadList![prodIndex].kmDriven ?? "-"),
            ],
          )
              : subcatId == 39 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
               detailRow("BRAND".tr, model),
              detailRow("YEAR".tr, myadlistCont.myadlistData!.myadList![prodIndex].postYear ?? "-"),
              detailRow("KM DRIVEN".tr, myadlistCont.myadlistData!.myadList![prodIndex].kmDriven ?? "-"),
            ],
          )
                : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              ReadMoreText(
                myadlistCont.myadlistData!.myadList![prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget brandData() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              brandName.isEmpty ? shimmer(baseColor: notifier.shimmerbase2, context: context, height: 30) :
                (subcatId == 8 || (58 <= subcatId && subcatId <= 64)) ? detailRow("TYPE".tr, brandName) :  detailRow("BRAND".tr, brandName),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              ReadMoreText(
                myadlistCont.myadlistData!.myadList![prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget commonPost (){
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              ReadMoreText(
                myadlistCont.myadlistData!.myadList![prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: GreyColor,),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            flex: 7,
            child: Text(value, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
          ),
        ],
      ),
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
                                        border: Border.all(color: selectedindex == index ? PurpleColor : backGrey)
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
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: mainButton(
                            context: context,
                            txt1: "Continue".tr,
                            containcolor: PurpleColor,
                            onPressed1: () async {

                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              prefs.setString("statuspayment", paymentgaewayCont.gatewayData!.paymentdata![selectedindex].status ?? "");
                              prefs.setString("paymentfor", selectedPayment == "Razorpay" ? "myAdsRazorpay" : "myAds");
                              prefs.setBool("isFeature", isFeature!);

                              if (kIsWeb) {
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
                                else if(selectedPayment == "Paypal"){
                                  List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!.split(",");
                                  prefs.setString("clientId", keyList[0]);
                                  prefs.setString("secretId", keyList[1]);
                                  if (kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/paypal/index.php");
                                  } else {
                                   paypalPayment(mainAmount, keyList[0], keyList[1], isFeature);
                                  }
                                }
                                else if(selectedPayment == "Stripe"){
                                  List<String> keyList = paymentgaewayCont.gatewayData!.paymentdata![selectedindex].attributes!.split(",");
                                  Get.back();
                                  prefs.setString("secretKey", keyList[1]);
                                  if(kIsWeb){
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/stripe/index.php");
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
                                      paystackCont.getPaystack(amount: mainAmount).then(
                                        (value) {
                                          Get.to(() => PaymentWebVIew(
                                                    initialUrl: value["data"]
                                                        ["authorization_url"],
                                                    navigationDelegate:
                                                        (NavigationRequest
                                                            request) async {
                                                      final uri =
                                                          Uri.parse(request.url);
                                                      var status =
                                                          uri.queryParameters["status"];

                                                      if (uri.queryParameters[
                                                              "status"] ==
                                                          null) {
                                                        accessToken = uri
                                                            .queryParametersAll[
                                                                "trxref"]
                                                            .toString();
                                                      } else {
                                                        if (status == "success") {
                                                          payerID = uri
                                                              .queryParametersAll[
                                                                  "trxref"]
                                                              .toString();
                                                          Get.back(result: payerID);
                                                        } else {
                                                          Get.back();
                                                          showToastMessage(
                                                              "${uri.queryParameters["status"]}");
                                                        }
                                                      }

                                                      return NavigationDecision
                                                          .navigate;
                                                    },
                                                  ))!
                                              .then((otid) {
                                            Get.back();

                                            if (otid != null) {
                                              showToastMessage(
                                                  "Payment done Successfully".tr);
                                              popup();
                                              isFeature
                                                  ? makeFeatureCont.getMakeFeature(
                                                      postId: myadlistCont
                                                          .myadlistData!
                                                          .myadList![selectedPost]
                                                          .postId
                                                          .toString(),
                                                      transactionId: "0",
                                                      pMethodId: "5",
                                                      wallAmt: walletMain.toString(),
                                                      packageId: listpackageCont
                                                          .listpackageData!
                                                          .packageData![selectedPackage]
                                                          .id
                                                          .toString(),
                                                      mainAmt: mainAmount,
                                                      paymentMethod: selectedPayment,
                                                      walletAmt: walletMain.toString())
                                                  : repubCont.getRepublish(
                                                      postId: myadlistCont
                                                          .myadlistData!
                                                          .myadList![selectedPost]
                                                          .postId
                                                          .toString(),
                                                      transId: "0",
                                                      pMethod: "5",
                                                      package: listpackageCont
                                                          .listpackageData!
                                                          .packageData![selectedPackage]
                                                          .id
                                                          .toString(),
                                                      isPaid: "1",
                                                      walletAmt: walletMain.toString(),
                                                      mainAmt: mainAmount,
                                                      paymentMethod: selectedPayment);
                                            }
                                          });
                                        },
                                      );
                                   }
                                 }
                                else if(selectedPayment == "FlutterWave") {
                                  kIsWeb ? webPaymentCont.getPaymentUrl(
                                      body: {
                                        "email": getData.read("UserLogin")["email"],
                                        "amount": mainAmount
                                      }, url: "${Config.paymentBaseUrl}w_payment/flutterwave/index.php") : Get.to(() => PaymentWebVIew(
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
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
                                  });
                                }
                                else if(selectedPayment == "Paytm") {
                                  if(kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "uid": getData.read("UserLogin")["id"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/paytm/index.php");
                                  } else {
                                   Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}paytm/index.php?amt=$mainAmount&uid=${getData.read("UserLogin")["id"]}",
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
                                          popup();
                                          showToastMessage("${uri.queryParameters["status"]}");
                                        }
                                      }
                                      return NavigationDecision.navigate;
                                    },))!.then((otid) {
                                    Get.back();

                                    if (otid != null) {
                                      showToastMessage("Payment done Successfully".tr);
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
                                  });
                                  }
                                }
                                else if(selectedPayment == "SenangPay") {
                                  if(kIsWeb){
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount,
                                      "name": getData.read("UserLogin")["name"],
                                      "phone": getData.read("UserLogin")["mobile"],
                                      "detail": "Wallet TopUp"
                                    }, url: "${Config.paymentBaseUrl}w_payment/senangpay/index.php");
                                  } else {
                                   Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}result.php?detail=Movers&amount=$mainAmount&order_id=$notificationId&name=${getData.read("UserLogin")["name"]}&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}",
                                    navigationDelegate: (NavigationRequest request) async {

                                      final uri = Uri.parse(request.url);
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
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
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
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
                                  });
                                }
                                else if(selectedPayment == "Payfast"){
                                  if(kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount,
                                      "name": getData.read("UserLogin")["name"]
                                    }, url: "${Config.paymentBaseUrl}w_payment/payfast/index.php");
                                  } else {
                                   Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}Payfast/index.php?amt=$mainAmount",
                                    navigationDelegate: (NavigationRequest request) async {
                                      final uri = Uri.parse(request.url);

                                      if (uri.queryParameters["status"] == null) {
                                        accessToken = uri.queryParameters["Transaction_id"];
                                      } else {
                                        if (uri.queryParameters["status"] == "success") {
                                          payerID = uri.queryParameters["payment_id"]!;
                                          Get.back(result: uri.queryParameters["payment_id"]);
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
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
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
                                    Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}Midtrans/index.php?name=test&email=${getData.read("UserLogin")["email"]}&phone=${getData.read("UserLogin")["ccode"]+getData.read("UserLogin")["mobile"]}&amt=$mainAmount",
                                    navigationDelegate: (NavigationRequest request) async {
                                      final uri = Uri.parse(request.url);
                                      if (uri.queryParameters["transaction_status"] == null) {
                                        accessToken = uri.queryParameters["order_id"];
                                      } else {
                                        if (uri.queryParameters["transaction_status"] == "capture") {
                                          payerID = uri.queryParameters["order_id"]!;
                                          Get.back(result: payerID);
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
                                      popup();
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
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
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
                                  });
                                }
                                else if(selectedPayment == "Khalti Payment"){
                                  if(kIsWeb) {
                                    webPaymentCont.getPaymentUrl(body: {
                                      "email": getData.read("UserLogin")["email"],
                                      "amount": mainAmount
                                    }, url: "${Config.paymentBaseUrl}w_payment/khalti/index.php");
                                  } else {
                                    Get.to(() => PaymentWebVIew(
                                    initialUrl: "${Config.paymentBaseUrl}Khalti/index.php?amt=$mainAmount",
                                    navigationDelegate: (NavigationRequest request) async {
                                      final uri = Uri.parse(request.url);

                                      if (uri.queryParameters["status"] == null) {
                                        accessToken = uri.queryParameters["merchant_account_id"];
                                      } else {
                                        if (uri.queryParameters["status"] == "Completed") {
                                          payerID = uri.queryParameters["transaction_id"]!;
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
                                      isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                                          : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);                                    }
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

  stripePayment(isFeature) {
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
              );
            });
      },
    );
  }

  void _validateInputs(bool isFeature) {
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
          popup();
          isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
              : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);        }
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
              isFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
                  : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);            },
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

    isMakeFeature ? makeFeatureCont.getMakeFeature(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transactionId: "0", pMethodId: "5", wallAmt: walletMain.toString(), packageId: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment, walletAmt: walletMain.toString())
        : repubCont.getRepublish(postId: myadlistCont.myadlistData!.myadList![selectedPost].postId.toString(), transId: "0", pMethod: "5", package: listpackageCont.listpackageData!.packageData![selectedPackage].id.toString(), isPaid: "1", walletAmt: walletMain.toString(), mainAmt: mainAmount, paymentMethod: selectedPayment);  }
  void handlePaymentError(PaymentFailureResponse response) {}
  void handleExternalWallet(ExternalWalletResponse response) {}
}

class showImages extends StatefulWidget {
  final int selectdIndex;
  const showImages({super.key, required this.selectdIndex});

  @override
  State<showImages> createState() => _showImagesState();
}

class _showImagesState extends State<showImages> {

  List<Map> poductImages = [
    {
      "iphone": [
        "assets/iphone.png",
        "assets/iphone2.png",
        "assets/iphone3.png",
        "assets/iphone4.png",
      ],
    },
  ];

  final GlobalKey<FormState> Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GalleryImage(
        numOfShowImages: 4,
        key: Key,
        imageUrls: poductImages[widget.selectdIndex]["iphone"],
      ),
    );
  }
}