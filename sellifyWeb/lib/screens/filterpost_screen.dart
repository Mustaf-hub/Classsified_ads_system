import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sellify/controller/filter_controller/filters_controller.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/screens/catwisepost_list.dart';
import 'package:sellify/screens/profileposts_screen.dart';
import 'package:sellify/screens/storypage.dart';
import 'dart:ui' as ui;

import '../api_config/config.dart';
import '../api_config/store_data.dart';
import '../controller/addfav_controller.dart';
import '../controller/carbrandlist_controller.dart';
import '../controller/carvariation_controller.dart';
import '../controller/catgorylist_controller.dart';
import '../controller/myfav_controller.dart';
import '../controller/postad/bikecvehiclecontoller.dart';
import '../controller/profilewisepost_controller.dart';
import '../firebase/chat_screen.dart';
import '../helper/appbar_screen.dart';
import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../language/translatelang.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';
import '../utils/mq.dart';
import 'loginscreen.dart';

class FilterpostScreen extends StatefulWidget {
  final int prodIndex;
  const FilterpostScreen({super.key, required this.prodIndex});

  @override
  State<FilterpostScreen> createState() => _FilterpostScreenState();
}

class _FilterpostScreenState extends State<FilterpostScreen> {

  List<String> locationPart = [];
  String area = "";
  String city = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dayAgo();
    isMeassageAvalable(filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "0");
    setState(() {
      postType = filtersCont.filterData!.filter![widget.prodIndex].postType ?? "";
      subcatId = int.parse(filtersCont.filterData!.filter![widget.prodIndex].subcatId!);
      filtersCont.filterData!.filter![widget.prodIndex].isFavourite == 1 ? isFav = true : isFav = false;
    });

    if(subcatId == 0) {
      carbrandlistCon.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
        for(int i = 0; i < carbrandlistCon.carbrandData!.carbrandlist!.length;i++){
          if(filtersCont.filterData!.filter![widget.prodIndex].brandId == carbrandlistCon.carbrandData!.carbrandlist![i].id){
            setState(() {
              brandName = carbrandlistCon.carbrandData!.carbrandlist![i].title!;
            });
            carvariationCont.carvariation(brandId: carbrandlistCon.carbrandData!.carbrandlist![i].id).then((value) {
              for(int i = 0; i < carvariationCont.carvariationData!.carvariationlist!.length; i++){
                if(filtersCont.filterData!.filter![widget.prodIndex].variantId == carvariationCont.carvariationData!.carvariationlist![i].id){
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
        for(int i = 0; i < subcategoryCont.subcatTypeData!.subtypelist!.length; i++){
          if(filtersCont.filterData!.filter![widget.prodIndex].mobileBrand == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].propertyType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].bicyclesBrandId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].serviceTypeId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].pgSubtype == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].accessoriesType == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].sparepartTypeId == subcategoryCont.subcatTypeData!.subtypelist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].tabletType == subcategoryCont.subcatTypeData!.subtypelist![i].id){
            setState(() {
              brandName = subcategoryCont.subcatTypeData!.subtypelist![i].title!;
            });
          }
        }
      },);
    } else if((25 == subcatId || 26 == subcatId) || subcatId == 39){
      bikescooterCvehicleCont.getvehicle(subcatId: subcatId.toString()).then((value) {
        for(int i = 0; i < bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist!.length; i++){
          if (filtersCont.filterData!.filter![widget.prodIndex].motocycleBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].scooterBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id ||
              filtersCont.filterData!.filter![widget.prodIndex].commercialBrandId == bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id) {
            setState(() {
              brandName = bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].title!;
            });
          }
          bikescooterCvehicleCont.getModel(brandId: bikescooterCvehicleCont.bikescootercvehicle!.bikescooterbrandlist![i].id!).then((value) {
            for(int i = 0; i < bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist!.length; i++){
              if(filtersCont.filterData!.filter![widget.prodIndex].motorcycleModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id ||
                 filtersCont.filterData!.filter![widget.prodIndex].scooterModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id ||
                 filtersCont.filterData!.filter![widget.prodIndex].commercialModelId == bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].id){
                setState(() {
                  model = bikescooterCvehicleCont.vehiclemodel!.bikescootermodellist![i].title!;
                });
              }
            }
          },);
        }
      },);
    }

    lathome = double.parse(filtersCont.filterData!.filter![widget.prodIndex].lats!);
    longhome = double.parse(filtersCont.filterData!.filter![widget.prodIndex].longs!);
    _onAddMarkerButtonPressed(lathome, longhome);

    String partsOfArea = filtersCont.filterData!.filter![widget.prodIndex].fullAddress!;

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


    for (int i = 0; i < filtersCont.filterData!.filter![widget.prodIndex].postAllImage!.length; i++) {
      stories.add(filtersCont.filterData!.filter![widget.prodIndex].postAllImage![i]);
    }
  }


  
  FiltersController filtersCont = Get.find();
  CarbrandlistController carbrandlistCon = Get.find();
  CarvariationController carvariationCont = Get.find();
  CategoryListController subcategoryCont = Get.find();
  BikescooterCvehicleContoller bikescooterCvehicleCont = Get.find();
  AddfavController addfavController = Get.find();
  AddfavController addfavCont = Get.find();
  MyfavController myfavCont = Get.find();
  ProfilewiseController profilewiseCont = Get.find();

  var lathome;
  var longhome;


  List detailImage = [
    "assets/km.png",
    "assets/geartype.png",
    "assets/fueltype.png",
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

  List detail2 = [
    "",
    "Owner".tr,
    "Posting date".tr
  ];

  List interdetail = [
    "",
    "1st",
    "26-Aug-2023"
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

  List proDetail = [
    "Honda",
    "Dream Yuga",
    "2022",
    "Petrol"
  ];

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
  String postType = "";

  int daysAgo = 0;

  dayAgo(){
    setState(() {
      DateTime postDate = DateTime.parse("${filtersCont.filterData!.filter![widget.prodIndex].postDate}");

      DateTime currentDate = DateTime.now();

      Duration difference = currentDate.difference(postDate);

      daysAgo = difference.inDays;
    });
  }

  String userName = "";
  Future<dynamic> isMeassageAvalable(String uid) async {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('sellify_user');
    collectionReference.doc(uid).get().then((value) {
      var fields;
      fields = value.data();

      setState(() {
        userName = fields["name"];
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        setState(() {});
        return await Get.to(CatwisepostList(catID: int.parse(filtersCont.filterData!.filter![widget.prodIndex].catId ?? ""), subcatId: int.parse(filtersCont.filterData!.filter![widget.prodIndex].subcatId ?? "")), transition: Transition.noTransition);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: backGreyColor,
            bottomNavigationBar: 750 < constraints.maxWidth ? const SizedBox()
                : Padding(
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(PurpleColor)
                        ),
                        onPressed: () {
                          Navigator.push(context, screenTransDown(
                              routes: ChatScreen(
                                initialTab: 0,
                                  mobile: filtersCont.filterData!.filter![widget.prodIndex].ownerMobile!,
                                  profilePic: filtersCont.filterData!.filter![widget.prodIndex].ownerImg!,
                                  adPrice: filtersCont.filterData!.filter![widget.prodIndex].adPrice ?? "",
                                  title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                  adImage: filtersCont.filterData!.filter![widget.prodIndex].postImage!,
                                  resiverUserId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "",
                                  resiverUsername: userName),
                              context: context));
                        }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/chats-dots.png", color: WhiteColor, height: 22,),
                        const SizedBox(width: 10,),
                        Text("Chat".tr, style: TextStyle(color: WhiteColor, letterSpacing: 1, fontFamily: FontFamily.gilroyMedium, fontWeight: ui.FontWeight.w700, fontSize: 18),),
                      ],
                    )),
                  ),
                  const SizedBox(width: 10,),
                  filtersCont.filterData!.filter![widget.prodIndex].adPrice == "0" ? const SizedBox() : Expanded(
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
                        Navigator.push(context, screenTransDown(
                            routes: ChatScreen(
                                initialTab: 1,
                                mobile: filtersCont.filterData!.filter![widget.prodIndex].ownerMobile!,
                                profilePic: filtersCont.filterData!.filter![widget.prodIndex].ownerImg!,
                                adPrice: filtersCont.filterData!.filter![widget.prodIndex].adPrice ?? "",
                                title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                adImage: filtersCont.filterData!.filter![widget.prodIndex].postImage!,
                                resiverUserId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "",
                                resiverUsername: userName),
                            context: context));
                      }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/makeoffer.svg", height: 22, colorFilter: ColorFilter.mode(WhiteColor, BlendMode.srcIn,)),
                        const SizedBox(width: 6),
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
                                    backgroundColor: backGreyColor,
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
                                    actions: [
                                      Padding(
                                        padding: EdgeInsets.only(right: rtl ? 0 : 1600 < constraints.maxWidth ? 400 : 1200 < constraints.maxWidth ? 200 : 900 < constraints.maxWidth ? 50 : 0, left: rtl ? 1600 < constraints.maxWidth ? 400 : 1200 < constraints.maxWidth ? 200 : 900 < constraints.maxWidth ? 50 : 0 : 0),
                                        child: Row(
                                          children: [
                                            GetBuilder<FiltersController>(
                                                builder: (filtersCont) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if(isFav == false){
                                                        addfavCont.addFav(postId: filtersCont.filterData!.filter![widget.prodIndex].postId!).then((value) {
                                                          setState(() {
                                                            isFav = true;
                                                          });
                                                        },);
                                                      } else {
                                                        unFavBottomSheet(
                                                          context: context,
                                                          description: filtersCont.filterData!.filter![widget.prodIndex].adDescription ?? "",
                                                          title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                                          image: "${Config.imageUrl}${filtersCont.filterData!.filter![widget.prodIndex].postImage}",
                                                          price: "$currency${addCommas(filtersCont.filterData!.filter![widget.prodIndex].adPrice!)}",
                                                          removeFun: () {
                                                            setState(() {
                                                              addfavCont.addFav(postId: filtersCont.filterData!.filter![widget.prodIndex].postId!).then((value) {
                                                                setState(() {
                                                                  isFav = false;
                                                                });
                                                              },);
                                                            });
                                                            Get.back();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: WhiteColor,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: backGrey),
                                                      ),
                                                      padding: const EdgeInsets.all(10),
                                                      child: isFav ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                          : Image.asset("assets/heart.png", height: 20,),
                                                    ),
                                                  );
                                                }
                                            ),
                                            const SizedBox(width: 10,),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: WhiteColor,
                                                border: Border.all(color: backGrey),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset("assets/arrow-export.png", height: 20,),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    ],
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: Storypage(stories: stories, title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "", isFeatured: filtersCont.filterData!.filter![widget.prodIndex].isFeatureAd ?? "",),
                                    ),
                                  )
                                  : SliverAppBar(
                                    elevation: 0,
                                    expandedHeight: 400,
                                    floating: false,
                                    pinned: true,
                                    backgroundColor: backGreyColor,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Get.back(result: {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: WhiteColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: backGrey),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, height: 20,),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          GetBuilder<FiltersController>(
                                              builder: (filtersCont) {
                                                return InkWell(
                                                  onTap: () {
                                                    if(isFav == false){
                                                      addfavCont.addFav(postId: filtersCont.filterData!.filter![widget.prodIndex].postId!).then((value) {
                                                        setState(() {
                                                          isFav = true;
                                                        });
                                                      },);
                                                    } else {
                                                      unFavBottomSheet(
                                                        context: context,
                                                        description: filtersCont.filterData!.filter![widget.prodIndex].adDescription ?? "",
                                                        title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                                        image: "${Config.imageUrl}${filtersCont.filterData!.filter![widget.prodIndex].postImage}",
                                                        price: "$currency${addCommas(filtersCont.filterData!.filter![widget.prodIndex].adPrice!)}",
                                                        removeFun: () {
                                                          setState(() {
                                                            addfavCont.addFav(postId: filtersCont.filterData!.filter![widget.prodIndex].postId!).then((value) {
                                                              setState(() {
                                                                isFav = false;
                                                              });
                                                            },);
                                                          });
                                                          Get.back();
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: WhiteColor,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: backGrey),
                                                    ),
                                                    padding: const EdgeInsets.all(10),
                                                    child: isFav ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                        : Image.asset("assets/heart.png", height: 20,),
                                                  ),
                                                );
                                              }
                                          ),
                                          const SizedBox(width: 10,),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: WhiteColor,
                                              border: Border.all(color: backGrey),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Image.asset("assets/arrow-export.png", height: 20,),
                                          ),
                                          const SizedBox(width: 10,),
                                        ],
                                      ),
                                    ],
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: Storypage(stories: stories, title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "", isFeatured: filtersCont.filterData!.filter![widget.prodIndex].isFeatureAd ?? "",),
                                    ),
                                  )
                                ];
                              }, body: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 1600 < constraints.maxWidth ? 395 : 1200 < constraints.maxWidth ? 195 : 900 < constraints.maxWidth ? 45 : 12),
                                    child: constraints.maxWidth < 850 ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        viewData(),
                                        const SizedBox(height: 15,),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: notifier.getWhiteblackColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Owner".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
                                              const SizedBox(height: 10,),
                                              InkWell(
                                                onTap:  () {
                                                  if(getData.read("UserLogin") == null){
                                                    Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                                  } else {
                                                    profilewiseCont.getProfilewise(profileId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "").then((value) {
                                                      Get.to(const ProfilepostsScreen(), transition: Transition.noTransition);
                                                    },);
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: backGrey),
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                        Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(fit: BoxFit.fitHeight, image: filtersCont.filterData!.filter![widget.prodIndex].ownerImg != null ? NetworkImage(Config.imageUrl+ filtersCont.filterData!.filter![widget.prodIndex].ownerImg!) : const AssetImage("assets/userprofile.png",)),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(filtersCont.filterData!.filter![widget.prodIndex].ownerName ?? "", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                                                          Text("See profile".tr, style: TextStyle(fontSize: 14, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),)
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(context, screenTransDown(
                                                              routes: ChatScreen(
                                                                initialTab: 0,
                                                                  mobile: filtersCont.filterData!.filter![widget.prodIndex].ownerMobile!,
                                                                  profilePic: filtersCont.filterData!.filter![widget.prodIndex].ownerImg!,
                                                                  adPrice: filtersCont.filterData!.filter![widget.prodIndex].adPrice ?? "",
                                                                  title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                                                  adImage: filtersCont.filterData!.filter![widget.prodIndex].postImage!,
                                                                  resiverUserId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "",
                                                                  resiverUsername: userName),
                                                              context: context));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: PurpleColor,
                                                              shape: BoxShape.circle
                                                          ),
                                                          padding: const EdgeInsets.all(10),
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
                                    )
                                        : Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: viewData()),
                                        const SizedBox(width: 15,),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              getData.read("UserLogin") == null ? const SizedBox() : Container(
                                                decoration: BoxDecoration(
                                                  color: notifier.getWhiteblackColor,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.all(20),
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
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                              ),
                                                              backgroundColor: WidgetStatePropertyAll(PurpleColor)
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(context, screenTransDown(
                                                                routes: ChatScreen(
                                                                    initialTab: 0,
                                                                    mobile: filtersCont.filterData!.filter![widget.prodIndex].ownerMobile!,
                                                                    profilePic: filtersCont.filterData!.filter![widget.prodIndex].ownerImg!,
                                                                    adPrice: filtersCont.filterData!.filter![widget.prodIndex].adPrice ?? "",
                                                                    title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                                                    adImage: filtersCont.filterData!.filter![widget.prodIndex].postImage!,
                                                                    resiverUserId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "",
                                                                    resiverUsername: userName),
                                                                context: context));
                                                          }, child: Padding(
                                                            padding: const EdgeInsets.all(10),
                                                            child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                            Image.asset("assets/chats-dots.png", color: WhiteColor, height: 22,),
                                                            const SizedBox(width: 10,),
                                                            Text("Chat".tr, style: TextStyle(color: WhiteColor, letterSpacing: 1, fontFamily: FontFamily.gilroyMedium, fontWeight: ui.FontWeight.w700, fontSize: 18),),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    filtersCont.filterData!.filter![widget.prodIndex].adPrice == "0" ? const SizedBox() : Expanded(
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
                                                          Navigator.push(context, screenTransDown(
                                                              routes: ChatScreen(
                                                                  initialTab: 1,
                                                                  mobile: filtersCont.filterData!.filter![widget.prodIndex].ownerMobile!,
                                                                  profilePic: filtersCont.filterData!.filter![widget.prodIndex].ownerImg!,
                                                                  adPrice: filtersCont.filterData!.filter![widget.prodIndex].adPrice ?? "",
                                                                  title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                                                  adImage: filtersCont.filterData!.filter![widget.prodIndex].postImage!,
                                                                  resiverUserId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "",
                                                                  resiverUsername: userName),
                                                              context: context));
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SvgPicture.asset("assets/makeoffer.svg", height: 22, colorFilter: ColorFilter.mode(WhiteColor, BlendMode.srcIn,)),
                                                            const SizedBox(width: 6),
                                                            Text("Make Offer", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 18, color: WhiteColor),),
                                                          ],
                                                                                                          ),
                                                        ),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: getData.read("UserLogin") == null ? 0 : 15,),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: notifier.getWhiteblackColor,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Owner".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
                                                    const SizedBox(height: 10,),
                                                    InkWell(
                                                      onTap:  () {
                                                        if(getData.read("UserLogin") == null){
                                                          Get.offAll(const Loginscreen(), transition: Transition.noTransition);
                                                        } else {
                                                          profilewiseCont.getProfilewise(profileId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "").then((value) {
                                                            Get.to(const ProfilepostsScreen(), transition: Transition.noTransition);
                                                          },);
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(color: backGrey),
                                                        ),
                                                        padding: const EdgeInsets.all(10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 60,
                                                              width: 60,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(fit: BoxFit.fitHeight, image: filtersCont.filterData!.filter![widget.prodIndex].ownerImg != null ? NetworkImage(Config.imageUrl+ filtersCont.filterData!.filter![widget.prodIndex].ownerImg!) : const AssetImage("assets/userprofile.png",)),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(filtersCont.filterData!.filter![widget.prodIndex].ownerName ?? "", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                                                                Text("See profile".tr, style: TextStyle(fontSize: 14, letterSpacing: 0.7, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),)
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(context, screenTransDown(
                                                                    routes: ChatScreen(
                                                                        initialTab: 0,
                                                                        mobile: filtersCont.filterData!.filter![widget.prodIndex].ownerMobile!,
                                                                        profilePic: filtersCont.filterData!.filter![widget.prodIndex].ownerImg!,
                                                                        adPrice: filtersCont.filterData!.filter![widget.prodIndex].adPrice ?? "",
                                                                        title: filtersCont.filterData!.filter![widget.prodIndex].postTitle ?? "",
                                                                        adImage: filtersCont.filterData!.filter![widget.prodIndex].postImage!,
                                                                        resiverUserId: filtersCont.filterData!.filter![widget.prodIndex].postOwnerId ?? "",
                                                                        resiverUsername: userName),
                                                                    context: context));
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: PurpleColor,
                                                                    shape: BoxShape.circle
                                                                ),
                                                                padding: const EdgeInsets.all(10),
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
                    );
                  }
              ),
            ),
          );
        }
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
                  Flexible(child: Text(filtersCont.filterData!.filter![widget.prodIndex].postTitle!, style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 21),overflow: TextOverflow.ellipsis, maxLines: 2,)),
                  filtersCont.filterData!.filter![widget.prodIndex].adPrice == "0" ? const SizedBox() : Text("$currency ${addCommas(filtersCont.filterData!.filter![widget.prodIndex].adPrice!)}", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 18),),
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
                        Flexible(child: Text(filtersCont.filterData!.filter![widget.prodIndex].fullAddress!, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 14),overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Text("$daysAgo Days ago", style: TextStyle(fontWeight: FontWeight.w700, fontFamily: FontFamily.gilroyRegular, color: notifier.getTextColor, fontSize: 12),),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15,),
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
                          Text(i == 0 ? "${filtersCont.filterData!.filter![widget.prodIndex].kmDriven ?? ""} km" : i == 1 ? filtersCont.filterData!.filter![widget.prodIndex].transmission ?? "" : filtersCont.filterData!.filter![widget.prodIndex].fuel ?? "", style: TextStyle(fontSize: height / 67, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                          Image.asset(detailImage2[i], height: 16, color: notifier.iconColor),
                          const SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i == 0 ? area : detail2[i], style: TextStyle(fontSize: height / 67, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                Text(i == 0 ? city : i == 1 ? filtersCont.filterData!.filter![widget.prodIndex].noOwner ?? "" : formatDate(filtersCont.filterData!.filter![widget.prodIndex].postDate.toString().split(" ").first), style: TextStyle(fontSize: height / 60, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700),overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                filtersCont.filterData!.filter![widget.prodIndex].adDescription!,
                trimLines: 3,
                trimExpandedText: "...${"show less".tr}",
                style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,fontSize: 14),
                lessStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
                moreStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,color: notifier.getTextColor,fontSize: 12),
              )
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
                  Text(filtersCont.filterData!.filter![widget.prodIndex].postYear!, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
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
                  Text(filtersCont.filterData!.filter![widget.prodIndex].fuel!, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5, color: notifier.getTextColor, fontWeight: ui.FontWeight.w700),),
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
              detailRow("LISTED BY".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FURNISHING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyFurnishing ?? "-"),
              const SizedBox(height: 10,),
              detailRow("SUPER BUILTUP AREA (FT²)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertySuperbuildarea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CARPET AREA (FT²)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyCarpetarea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("MAINTENANCE (MONTHLY)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyMaintainceMonthly ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CAR PARKING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyCarParking ?? "-"),
              const SizedBox(height: 10,),
              detailRow("WASHROOMS".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyBathroom ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, filtersCont.filterData!.filter![widget.prodIndex].projectName ?? "-"),
            ],
          )
              : brandName.isEmpty ? ListView.separated(
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
              detailRow("BEDROOMS".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyBedroom ?? "-"),
              const SizedBox(height: 10,),
              detailRow("BATHROOMS".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyBathroom ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FURNISHING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyFurnishing ?? "-"),
              const SizedBox(height: 10,),
              subcatId == 2 ? const SizedBox() : detailRow("CONSTRUCTION STATUS".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyConstructionStatus ?? "-"),
              subcatId == 2 ? const SizedBox() : const SizedBox(height: 10,),
              detailRow("LISTED BY".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("SUPER BUILTUP AREA (FT²)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertySuperbuildarea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CARPET AREA (FT²)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyCarpetarea ?? "-"),
              subcatId == 2 ? const SizedBox() : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  detailRow("MAINTENANCE (MONTHLY)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyMaintainceMonthly ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("TOTAL FLOORS".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyTotalFloor ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("FLOOR NO".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyFloorNo ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("CAR PARKING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyCarParking ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("FACING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyFacing ?? "-"),
                  const SizedBox(height: 10,),
                  detailRow("PROJECT NAME".tr, filtersCont.filterData!.filter![widget.prodIndex].projectName ?? "-"),
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
              detailRow("LISTED BY".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PLOT AREA".tr, filtersCont.filterData!.filter![widget.prodIndex].plotArea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("LENGTH".tr, filtersCont.filterData!.filter![widget.prodIndex].plotLength ?? "-"),
              const SizedBox(height: 10,),
              detailRow("BREADTH".tr, filtersCont.filterData!.filter![widget.prodIndex].plotBreadth ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FACING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyFacing ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, filtersCont.filterData!.filter![widget.prodIndex].projectName ?? "-"),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
              const SizedBox(height: 10,),
              detailRow("LISTED BY".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyListedBy ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PLOT AREA".tr, filtersCont.filterData!.filter![widget.prodIndex].plotArea ?? "-"),
              const SizedBox(height: 10,),
              detailRow("LENGTH".tr, filtersCont.filterData!.filter![widget.prodIndex].plotLength ?? "-"),
              const SizedBox(height: 10,),
              detailRow("BREADTH".tr, filtersCont.filterData!.filter![widget.prodIndex].plotBreadth ?? "-"),
              const SizedBox(height: 10,),
              detailRow("FACING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyFacing ?? "-"),
              const SizedBox(height: 10,),
              detailRow("CAR PARKING".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyCarParking ?? "-"),
              const SizedBox(height: 10,),
              detailRow("MAINTENANCE (MONTHLY)".tr, filtersCont.filterData!.filter![widget.prodIndex].propertyMaintainceMonthly ?? "-"),
              const SizedBox(height: 10,),
              detailRow("PROJECT NAME".tr, filtersCont.filterData!.filter![widget.prodIndex].projectName ?? "-"),
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
                filtersCont.filterData!.filter![widget.prodIndex].adDescription!,
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
              detailRow("POSITION TYPE", filtersCont.filterData!.filter![widget.prodIndex].jobPositionType ?? "-"),
              detailRow("SALARY FROM".tr, filtersCont.filterData!.filter![widget.prodIndex].jobSalaryFrom ?? "-"),
              detailRow("SALARY TO".tr, filtersCont.filterData!.filter![widget.prodIndex].jobSalaryTo ?? "-"),
              detailRow("SALARY PERIOD".tr, filtersCont.filterData!.filter![widget.prodIndex].jobSalaryPeriod ?? "-"),
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
              detailRow("YEAR".tr, filtersCont.filterData!.filter![widget.prodIndex].postYear ?? "-"),
              detailRow("KM DRIVEN".tr, filtersCont.filterData!.filter![widget.prodIndex].kmDriven ?? "-"),
            ],
          )
              : subcatId == 39 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details".tr, style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, ),),
              const SizedBox(height: 10,),
              detailRow("TYPE".tr, brandName),
               detailRow("BRAND".tr, model),
              detailRow("YEAR".tr, filtersCont.filterData!.filter![widget.prodIndex].postYear ?? "-"),
              detailRow("KM DRIVEN".tr, filtersCont.filterData!.filter![widget.prodIndex].kmDriven ?? "-"),
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
                filtersCont.filterData!.filter![widget.prodIndex].adDescription!,
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
                filtersCont.filterData!.filter![widget.prodIndex].adDescription!,
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
                filtersCont.filterData!.filter![widget.prodIndex].adDescription!,
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
          const SizedBox(width: 10,),
          Expanded(
            flex: 7,
            child: Text(value, style: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
          ),
        ],
      ),
    );
  }
}
