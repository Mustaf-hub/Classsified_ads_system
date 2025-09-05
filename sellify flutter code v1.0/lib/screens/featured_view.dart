import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/addfav_controller.dart';
import 'package:sellify/controller/carbrandlist_controller.dart';
import 'package:sellify/controller/carvariation_controller.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/myfav_controller.dart';
import 'package:sellify/controller/postad/bikecvehiclecontoller.dart';
import 'package:sellify/controller/postview_controller.dart';
import 'package:sellify/firebase/chat_screen.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/storypage.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:sellify/utils/mq.dart';

import '../controller/login_controller.dart';
import '../controller/profilewisepost_controller.dart';
import 'loginscreen.dart';

class FeaturedView extends StatefulWidget {
  final int prodIndex;
  const FeaturedView({super.key, required this.prodIndex});

  @override
  State<FeaturedView> createState() => _FeaturedViewState();
}

class _FeaturedViewState extends State<FeaturedView> {

  List<String> locationPart = [];
  String area = "";
  String city = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dayAgo();
    isMeassageAvalable(homedataCont.homedata!.featurelist![widget.prodIndex].postOwnerId ?? "");

    setState(() {
      postType = homedataCont.homedata!.featurelist![widget.prodIndex].postType ?? "";
      subcatId = int.parse(homedataCont.homedata!.featurelist![widget.prodIndex].subcatId!);
    });
    print("SUBCAT ID ? $subcatId");

    if(subcatId == 0) {
      carbrandlistCon.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
        for(int i = 0; i < carbrandlistCon.carbrandData!.carbrandlist!.length;i++){
          if(homedataCont.homedata!.featurelist![widget.prodIndex].brandId == carbrandlistCon.carbrandData!.carbrandlist![i].id){
            setState(() {
              brandName = carbrandlistCon.carbrandData!.carbrandlist![i].title!;
            });
            carvariationCont.carvariation(brandId: carbrandlistCon.carbrandData!.carbrandlist![i].id).then((value) {
              for(int i = 0; i < carvariationCont.carvariationData!.carvariationlist!.length; i++){
                if(homedataCont.homedata!.featurelist![widget.prodIndex].variantId == carvariationCont.carvariationData!.carvariationlist![i].id){
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
          print(":::::::::: >?>L>SDSDS>D>${subcategoryCont.subcatTypeData!.subtypelist}");
        for(int i = 0; i < subcategoryCont.subcatTypeData!.subtypelist!.length; i++){
          if(homedataCont.homedata!.featurelist![widget.prodIndex].mobileBrand == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].propertyType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].bicyclesBrandId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].serviceTypeId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].accessoriesType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].tabletType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].sparepartTypeId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].pgSubtype == subcategoryCont.subcatTypeData!.subtypelist![i].id){
            setState(() {
              brandName = subcategoryCont.subcatTypeData!.subtypelist![i].title!;
            });
            print("BRAND NAME > $brandName");
          }
        }
      },);
    } else if((25 == subcatId || 26 == subcatId) || subcatId == 39){
      print("SUBCAT ID BIKE $subcatId");
      bikescooterCvehicleCont.getvehicle(subcatId: subcatId.toString()).then((value) {
        for(int i = 0; i < bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist!.length; i++){
          if (homedataCont.homedata!.featurelist![widget.prodIndex].motocycleBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].scooterBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id ||
              homedataCont.homedata!.featurelist![widget.prodIndex].commercialBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id) {
            setState(() {
              brandName = bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].title!;
            });
          }
          bikescooterCvehicleCont.getModel(brandId: bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id!).then((value) {
            for(int i = 0; i < bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist!.length; i++){
              if(homedataCont.homedata!.featurelist![widget.prodIndex].motorcycleModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id ||
                  homedataCont.homedata!.featurelist![widget.prodIndex].scooterModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id ||
                  homedataCont.homedata!.featurelist![widget.prodIndex].commercialModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id){
                setState(() {
                  model = bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].title!;
                });
              }
            }
          },);
        }
      },);
    }

    lathome = double.parse(homedataCont.homedata!.featurelist![widget.prodIndex].lats!);
    longhome = double.parse(homedataCont.homedata!.featurelist![widget.prodIndex].longs!);
    _onAddMarkerButtonPressed(lathome, longhome);
    
    area = homedataCont.homedata!.featurelist![widget.prodIndex].fullAddress.toString().split(",").first;

    String location = homedataCont.homedata!.featurelist![widget.prodIndex].fullAddress!;

    
    List<String> parts = location.split(", ");

    city = parts[parts.length-1];

    for (int i = 0; i < homedataCont.homedata!.featurelist![widget.prodIndex].postAllImage!.length; i++) {
      stories.add(homedataCont.homedata!.featurelist![widget.prodIndex].postAllImage![i]);
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  MyadlistController myadlistCont = Get.find();
  HomedataController homedataCont = Get.find();
  CarbrandlistController carbrandlistCon = Get.find();
  CarvariationController carvariationCont = Get.find();
  CategoryListController subcategoryCont = Get.find();
  BikescooterCvehicleContoller bikescooterCvehicleCont = Get.find();
  AddfavController addfavController = Get.find();
  AddfavController addfavCont = Get.find();
  MyfavController myfavCont = Get.find();
  ProfilewiseController profilewiseCont = Get.find();
  PostviewController postviewCont = Get.find();

  var lathome;
  var longhome;


  List detailImage = [
    "assets/km.png",
    "assets/geartype.png",
    "assets/fueltype.png",
  ];


  List detailImage2 = [
    "assets/location.png",
    "assets/owner.png",
    "assets/postingdate.png"
  ];

  List detail2 = [
    "",
    "Owner".tr,
    "Posting date".tr
  ];

  List contactImage = [
    "assets/phone.png",
    "assets/message.png",
    "assets/map.png"
  ];

  late GoogleMapController mapController1;
  Set<Marker> markers = Set();
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  Future<void> _onAddMarkerButtonPressed(double? lat, long) async {
    final Uint8List markIcon = await getImages("assets/pinIcon.png", 80);
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
  String postType = "";

  int daysAgo = 0;

  dayAgo(){
    setState(() {
      DateTime postDate = DateTime.parse("${homedataCont.homedata!.featurelist![widget.prodIndex].postDate}");

      DateTime currentDate = DateTime.now();

      Duration difference = currentDate.difference(postDate);

      daysAgo = difference.inDays;
    });
  }

  Future<dynamic> isMeassageAvalable(String uid) async {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('sellify_user');
    collectionReference.doc(uid).get().then((value) {
      var fields;
      fields = value.data();
      print("MSG DATA $fields");
      setState(() {
        userName = fields["name"];
      });
    });
  }

  String userName = "";

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(0),
                      alignment: Alignment.center,
                      padding: WidgetStatePropertyAll(
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
                      Navigator.push(context, ScreenTransDown(
                          routes: ChatScreen(
                            initialTab: 0,
                            mobile: homedataCont.homedata!.featurelist![widget.prodIndex].ownerMobile!,
                            profilePic: homedataCont.homedata!.featurelist![widget.prodIndex].ownerImg!,
                            adPrice: homedataCont.homedata!.featurelist![widget.prodIndex].adPrice ?? "",
                            title: homedataCont.homedata!.featurelist![widget.prodIndex].postTitle ?? "",
                            adImage: homedataCont.homedata!.featurelist![widget.prodIndex].postImage!,
                            resiverUserId: homedataCont.homedata!.featurelist![widget.prodIndex].postOwnerId ?? "",
                            resiverUsername: userName),
                          context: context));

                  }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/chats-dots.png", color: WhiteColor, height: 22,),
                  SizedBox(width: 10,),
                  Text("Chat".tr, style: TextStyle(color: WhiteColor, letterSpacing: 1, fontFamily: FontFamily.gilroyMedium, fontWeight: ui.FontWeight.w700, fontSize: 18),),
                ],
              )),
            ),
            SizedBox(width: 10,),
            homedataCont.homedata!.featurelist![widget.prodIndex].adPrice == "0" ? SizedBox() : Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(0),
                    alignment: Alignment.center,
                    padding: WidgetStatePropertyAll(
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
                  Navigator.push(context, ScreenTransDown(
                      routes: ChatScreen(
                          initialTab: 1,
                          mobile: homedataCont.homedata!.featurelist![widget.prodIndex].ownerMobile!,
                          profilePic: homedataCont.homedata!.featurelist![widget.prodIndex].ownerImg!,
                          adPrice: homedataCont.homedata!.featurelist![widget.prodIndex].adPrice ?? "",
                          title: homedataCont.homedata!.featurelist![widget.prodIndex].postTitle ?? "",
                          adImage: homedataCont.homedata!.featurelist![widget.prodIndex].postImage!,
                          resiverUserId: homedataCont.homedata!.featurelist![widget.prodIndex].postOwnerId ?? "",
                          resiverUsername: userName),
                      context: context));
                }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/makeoffer.svg", height: 22, colorFilter: ColorFilter.mode(WhiteColor, BlendMode.srcIn,)),
                  SizedBox(width: 6),
                  Text("Make Offer", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 18, color: WhiteColor),),
                ],
              ),),
            ),
          ],
        ),
      ),
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
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
                            padding: EdgeInsets.all(10),
                            child: Image.asset("assets/arrowLeftIcon.png", height: 20, color: notifier.iconColor,),
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          children: [
                            GetBuilder<HomedataController>(
                              builder: (homedataCont) {
                                return GestureDetector(
                                  onTap: () {

                                    if(getData.read("UserLogin") == null){
                                      Get.offAll(Loginscreen());
                                    } else {
                                      if(homedataCont.homedata!.featurelist![widget.prodIndex].isFavourite == 0){
                                        addfavCont.addFav(postId: homedataCont.homedata!.featurelist![widget.prodIndex].postId!).then((value) {
                                          homedataCont.gethomedata().then((value) {
                                            setState((){});
                                          },);
                                        },);
                                      } else {
                                        unFavBottomSheet(
                                          context: context,
                                          description: homedataCont.homedata!.featurelist![widget.prodIndex].adDescription ?? "",
                                          title: homedataCont.homedata!.featurelist![widget.prodIndex].postTitle ?? "",
                                          image: "${Config.imageUrl}${homedataCont.homedata!.featurelist![widget.prodIndex].postImage}",
                                          price: "$currency${addCommas(homedataCont.homedata!.featurelist![widget.prodIndex].adPrice!)}",
                                          removeFun: () {
                                              addfavCont.addFav(postId: homedataCont.homedata!.featurelist![widget.prodIndex].postId!).then((value) {
                                                homedataCont.gethomedata().then((value) {
                                                  setState((){});
                                                },);
                                            });
                                            Get.back();
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: notifier.getWhiteblackColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: notifier.borderColor),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: homedataCont.homedata!.featurelist![widget.prodIndex].isFavourite == 1 ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                   : Image.asset("assets/heart.png", height: 20, color: notifier.iconColor,),
                                  ),
                                );
                              }
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: () {
                                if(getData.read("UserLogin") == null){
                                  Get.offAll(Loginscreen());
                                } else {
                                  getPackage();
                                  setState((){});
                                  share();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: notifier.getWhiteblackColor,
                                  border: Border.all(color: notifier.borderColor),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Image.asset("assets/arrow-export.png", height: 20, color: notifier.iconColor),
                              ),
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Storypage(stories: stories, title: homedataCont.homedata!.featurelist![widget.prodIndex].postTitle ?? "",),
                      ),
                    )
                  ];
                }, body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          viewData(),
                          SizedBox(height: 15,),
                          Container(
                            decoration: BoxDecoration(
                              color: notifier.getWhiteblackColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Owner".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap:  () {
                                    if(getData.read("UserLogin") == null){
                                      Get.offAll(Loginscreen());
                                    } else {
                                      profilewiseCont.getProfilewise(profileId: homedataCont.homedata!.featurelist![widget.prodIndex].postOwnerId ?? "").then((value) {
                                        Get.toNamed(Routes.profilepostsScreen);
                                      },);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: backGrey),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                      Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(fit: BoxFit.fitHeight, image: homedataCont.homedata!.featurelist![widget.prodIndex].ownerImg != null ? NetworkImage(Config.imageUrl+ homedataCont.homedata!.featurelist![widget.prodIndex].ownerImg!) : AssetImage("assets/userprofile.png",)),
                                      ),
                                    ),
                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap: () {
                                            if(getData.read("UserLogin") == null){
                                              Get.offAll(Loginscreen());
                                            } else {
                                              profilewiseCont.getProfilewise(profileId: homedataCont.homedata!.featurelist![widget.prodIndex].postOwnerId ?? "").then((value) {
                                                Get.toNamed(Routes.profilepostsScreen);
                                              },);
                                            }

                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(homedataCont.homedata!.featurelist![widget.prodIndex].ownerName ?? "", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
                                              Text("See profile".tr, style: TextStyle(fontSize: 14, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),)
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, ScreenTransDown(
                                                routes: ChatScreen(
                                                  initialTab: 0,
                                                    mobile: homedataCont.homedata!.featurelist![widget.prodIndex].ownerMobile!,
                                                    profilePic: homedataCont.homedata!.featurelist![widget.prodIndex].ownerImg!,
                                                    adPrice: homedataCont.homedata!.featurelist![widget.prodIndex].adPrice ?? "",
                                                    title: homedataCont.homedata!.featurelist![widget.prodIndex].postTitle ?? "",
                                                    adImage: homedataCont.homedata!.featurelist![widget.prodIndex].postImage!,
                                                    resiverUserId: homedataCont.homedata!.featurelist![widget.prodIndex].postOwnerId ?? "",
                                                    resiverUsername: userName),
                                                context: context));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: PurpleColor,
                                                shape: BoxShape.circle
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Image.asset("assets/chats-dots.png", height: 18, color: WhiteColor,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15,),
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
              ),
            );
          }
        ),
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(homedataCont.homedata!.featurelist![widget.prodIndex].postTitle!, style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 21),overflow: TextOverflow.ellipsis, maxLines: 2,)),
                  homedataCont.homedata!.featurelist![widget.prodIndex].adPrice == "0" ? SizedBox() : Text("$currency ${addCommas(homedataCont.homedata!.featurelist![widget.prodIndex].adPrice!)}", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 18),),
                ],
              ),
              SizedBox(height: 6,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset("assets/location.png", height: 16, color: notifier.iconColor),
                        SizedBox(width: 5,),
                        Flexible(child: Text(homedataCont.homedata!.featurelist![widget.prodIndex].fullAddress!, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 14),overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text("$daysAgo ${"Days ago".tr}", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 12),),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        subcatId == 0 ? vehicleData()
            : (subcatId <= 6) ? propertyData()
            : (subcatId <= 9 || subcatId == 28 || (58 <= subcatId && subcatId <= 64)) ? brandData()
            : (subcatId <= 26 || subcatId == 39 || subcatId == 40) ? otherData()
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  for(int i = 0; i < 3; i++)
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(detailImage[i], scale: 1.5, color: notifier.iconColor),
                          SizedBox(width: 5,),
                          Text(i == 0 ? "${homedataCont.homedata!.featurelist![widget.prodIndex].kmDriven ?? ""} km" : i == 1 ? homedataCont.homedata!.featurelist![widget.prodIndex].transmission ?? "" : homedataCont.homedata!.featurelist![widget.prodIndex].fuel ?? "", style: TextStyle(fontSize: height / 67, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(color: lightGreyColor, thickness: 0.5,),
              SizedBox(height: 10,),
              Row(
                children: [
                  for(int i = 0; i < 3; i++)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(detailImage2[i], height: 16, color: notifier.iconColor),
                          SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i == 0 ? area : detail2[i], style: TextStyle(fontSize: height / 67, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis,),
                                Text(i == 0 ? city.toString().split(" ").first : i == 1 ? homedataCont.homedata!.featurelist![widget.prodIndex].noOwner ?? "" : homedataCont.homedata!.featurelist![widget.prodIndex].postDate.toString().split(" ").first, style: TextStyle(fontSize: height / 60, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700),),
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
        SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              ReadMoreText(
                homedataCont.homedata!.featurelist![widget.prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              )
            ],
          ),
        ),
        SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
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
                  Text(homedataCont.homedata!.featurelist![widget.prodIndex].postYear!, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
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
                  Text(homedataCont.homedata!.featurelist![widget.prodIndex].fuel!, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
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
          padding: EdgeInsets.all(20),
          child: (subcatId == 4 || subcatId == 5) ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              subcatId == 4 ? SizedBox() : detailRow("TYPE".tr.tr, brandName ?? "-"),
              SizedBox(height: subcatId == 4 ? 0 : 10,),
              detailRow("LISTED BY".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyListedBy ?? "-"),
              SizedBox(height: 10,),
              detailRow("FURNISHING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyFurnishing ?? "-"),
              SizedBox(height: 10,),
              detailRow("SUPER BUILTUP AREA (FT²)".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertySuperbuildarea ?? "-"),
              SizedBox(height: 10,),
              detailRow("CARPET AREA (FT²)".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyCarpetarea ?? "-"),
              SizedBox(height: 10,),
              detailRow("MAINTENANCE (MONTHLY)".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyMaintainceMonthly ?? "-"),
              SizedBox(height: 10,),
              detailRow("CAR PARKING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyCarParking ?? "-"),
              SizedBox(height: 10,),
              detailRow("WASHROOMS".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyBathroom ?? "-"),
              SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, homedataCont.homedata!.featurelist![widget.prodIndex].projectName ?? "-"),
            ],
          )
              : brandName.isEmpty ? ListView.separated(
            shrinkWrap: true,
            itemCount: 8,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return shimmer(baseColor: notifier.shimmerbase2, context: context, height: 30);
            },) : subcatId <= 2 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName ?? "-"),
              SizedBox(height: 10,),
              detailRow("BEDROOMS".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyBedroom ?? "-"),
              SizedBox(height: 10,),
              detailRow("BATHROOMS".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyBathroom ?? "-"),
              SizedBox(height: 10,),
              detailRow("FURNISHING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyFurnishing ?? "-"),
              SizedBox(height: 10,),
              subcatId == 2 ? SizedBox() : detailRow("CONSTRUCTION STATUS".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyConstructionStatus ?? "-"),
              subcatId == 2 ? SizedBox() : SizedBox(height: 10,),
              detailRow("LISTED BY".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyListedBy ?? "-"),
              SizedBox(height: 10,),
              detailRow("SUPER BUILTUP AREA (FT²)".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertySuperbuildarea ?? "-"),
              SizedBox(height: 10,),
              detailRow("CARPET AREA (FT²)".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyCarpetarea ?? "-"),
              subcatId == 2 ? SizedBox() : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  detailRow("MAINTENANCE (MONTHLY)".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyMaintainceMonthly ?? "-"),
                  SizedBox(height: 10,),
                  detailRow("TOTAL FLOORS".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyTotalFloor ?? "-"),
                  SizedBox(height: 10,),
                  detailRow("FLOOR NO".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyFloorNo ?? "-"),
                  SizedBox(height: 10,),
                  detailRow("CAR PARKING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyCarParking ?? "-"),
                  SizedBox(height: 10,),
                  detailRow("FACING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyFacing ?? "-"),
                  SizedBox(height: 10,),
                  detailRow("PROJECT NAME".tr, homedataCont.homedata!.featurelist![widget.prodIndex].projectName ?? "-"),
                ],
              ),
            ],
          )
              : subcatId == 3 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
              SizedBox(height: 10,),
              detailRow("LISTED BY".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyListedBy ?? "-"),
              SizedBox(height: 10,),
              detailRow("PLOT AREA".tr, homedataCont.homedata!.featurelist![widget.prodIndex].plotArea ?? "-"),
              SizedBox(height: 10,),
              detailRow("LENGTH".tr, homedataCont.homedata!.featurelist![widget.prodIndex].plotLength ?? "-"),
              SizedBox(height: 10,),
              detailRow("BREADTH".tr, homedataCont.homedata!.featurelist![widget.prodIndex].plotBreadth ?? "-"),
              SizedBox(height: 10,),
              detailRow("FACING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyFacing ?? "-"),
              SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, homedataCont.homedata!.featurelist![widget.prodIndex].projectName ?? "-"),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName ?? "-"),
              SizedBox(height: 10,),
              detailRow("LISTED BY".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyListedBy ?? "-"),
              SizedBox(height: 10,),
              detailRow("MEALS INCLUDED".tr, homedataCont.homedata!.featurelist![widget.prodIndex].pgMealsInclude == "1" ? "Yes".tr : "No".tr),
              SizedBox(height: 10,),
              detailRow("FURNISHING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyFurnishing ?? "-"),
              SizedBox(height: 10,),
              detailRow("CAR PARKING".tr, homedataCont.homedata!.featurelist![widget.prodIndex].propertyCarParking ?? "-"),
            ],
          ),
        ),
        SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              ReadMoreText(
                homedataCont.homedata!.featurelist![widget.prodIndex].adDescription!,
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
          padding: EdgeInsets.all(20),
          child: subcatId <= 24 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              detailRow("POSITION TYPE", homedataCont.homedata!.featurelist![widget.prodIndex].jobPositionType ?? "-"),
              detailRow("SALARY FROM".tr, homedataCont.homedata!.featurelist![widget.prodIndex].jobSalaryFrom ?? "-"),
              detailRow("SALARY TO".tr, homedataCont.homedata!.featurelist![widget.prodIndex].jobSalaryTo ?? "-"),
              detailRow("SALARY PERIOD".tr, homedataCont.homedata!.featurelist![widget.prodIndex].jobSalaryPeriod ?? "-"),
            ],
          ) : (brandName.isEmpty && model.isEmpty) ? ListView.separated(
            shrinkWrap: true,
            itemCount: 4,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return shimmer(baseColor: notifier.shimmerbase2, context: context, height: 30);
            },) : subcatId <= 29 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
               detailRow("BRAND".tr, brandName),
              detailRow("MODEL".tr, model),
              detailRow("YEAR".tr, homedataCont.homedata!.featurelist![widget.prodIndex].postYear ?? "-"),
              detailRow("KM DRIVEN".tr, homedataCont.homedata!.featurelist![widget.prodIndex].kmDriven ?? "-"),
            ],
          )
              : subcatId == 39 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
               detailRow("BRAND".tr, model),
              detailRow("YEAR".tr, homedataCont.homedata!.featurelist![widget.prodIndex].postYear ?? "-"),
              detailRow("KM DRIVEN".tr, homedataCont.homedata!.featurelist![widget.prodIndex].kmDriven ?? "-"),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
            ],
          ),
        ),
        SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              ReadMoreText(
                homedataCont.homedata!.featurelist![widget.prodIndex].adDescription!,
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              brandName.isEmpty ? shimmer(baseColor: notifier.shimmerbase2, context: context, height: 30) :
              (subcatId == 8 || (58 <= subcatId && subcatId <= 64)) ? detailRow("TYPE".tr, brandName) :  detailRow("BRAND".tr, brandName),
            ],
          ),
        ),
        SizedBox(height: 15,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              ReadMoreText(
                homedataCont.homedata!.featurelist![widget.prodIndex].adDescription!,
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Descriptions".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              SizedBox(height: 10,),
              ReadMoreText(
                homedataCont.homedata!.featurelist![widget.prodIndex].adDescription!,
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
          SizedBox(width: 10,),
          Expanded(
            flex: 7,
            child: Text(value, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
          ),
        ],
      ),
    );
  }
}
