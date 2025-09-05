
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/controller/mapsugestion.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/addProduct/addVehicle/addcar_detail.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/screens/splesh_screen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/msg_otp_controller.dart';
import '../helper/appbar_screen.dart';
import '../utils/mq.dart';
import 'home_screen.dart';

class Chooselocation extends StatefulWidget {
  const Chooselocation({super.key});

  @override
  State<Chooselocation> createState() => _ChooselocationState();
}

class _ChooselocationState extends State<Chooselocation> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(route == "AddlocationScreen"){
      subcatID = Get.arguments["subcatId"];
      price = Get.arguments["price"];
    }

      lathome = getData.read("lat");
      longhome = getData.read("long");

    if(lathome == null && longhome == null){
      fun();
    } else if(route == Routes.myadsView){
      String lat = Get.arguments["latmap"];
      String long = Get.arguments["longmap"];
      String address = Get.arguments["postaddress"];
      adindex = Get.arguments["adIndex"];
      setState(() {
        lathome = double.parse(lat);
        longhome = double.parse(long);
        addresshome = address;
        searchCont.text = addresshome;
      });
      _onAddMarkerButtonPressed(lathome, longhome);
    } else if(route == "AddlocationScreen") {
      postingType = Get.arguments["postingType"];
      if(postingType == "Edit"){
        setState(() {
          adindex = Get.arguments["adIndex"];
          lathome = double.parse(myadlistCont.myadlistData!.myadList![adindex].lats ?? "");
          longhome = double.parse(myadlistCont.myadlistData!.myadList![adindex].longs ?? "");
          addresshome = myadlistCont.myadlistData!.myadList![adindex].fullAddress ?? "";
          searchCont.text = addresshome;
          _onAddMarkerButtonPressed(lathome, longhome);
        });
      } else {
        _onAddMarkerButtonPressed(lathome, longhome);
        setState(() {
          addresshome = getData.read("address");
          searchCont.text = addresshome;
        });
      }
    } else {
      _onAddMarkerButtonPressed(lathome, longhome);
      setState(() {
        addresshome = getData.read("address");
        searchCont.text = addresshome;
      });
    }

  }

  String price = "";
  String subcatID = "";
  late GoogleMapController mapController1;
  TextEditingController searchCont = TextEditingController();

  late ColorNotifire notifier;

  Future fun() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
    var currentLocation = await locateUser();
    debugPrint('location: ${currentLocation.latitude}');
    _onAddMarkerButtonPressed(currentLocation.latitude, currentLocation.longitude);
    getCurrentLatAndLong(
      currentLocation.latitude,
      currentLocation.longitude,
    );
  }


  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
  }

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

  Future getCurrentLatAndLong(double latitude, double longitude) async {

    lathome = latitude;
    longhome = longitude;

    await placemarkFromCoordinates(lathome, longhome).then((List<Placemark> placemarks) {
      addresshome = '${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.country}';
      searchCont.text = addresshome;
    });

  }

  String addresshome = "";
  var lathome;
  var longhome;

  String route = Get.arguments["route"];
  String postingType = "";

  getLocation() async {
    save("lat", lathome);
    save("long", longhome);
    getEnter = false;
    setState(() {});
  }

  void _animateToUser() {
    mapController1.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lathome, longhome),
          zoom: 14.0,
        ),
      ),
    );
  }

  int adindex = 0;

  bool getEnter = false;
  CategoryListController categoryListCont = Get.find();
  HomedataController homedataCont = Get.find();
  FocusNode focusNode = FocusNode();
  MapSuggestGetApiController mapCont = Get.find();
  PostadController postadController = Get.find();
  MyadlistController myadlistCont = Get.find();
  MsgOtpController smsTypeCont = Get.find();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          bottomNavigationBar: kIsWeb ? const SizedBox() : Padding(
            padding: const EdgeInsets.all(15),
            child: mainButton(txt1: route == Routes.addproductScreen ? "Continue".tr : "Use Current Location".tr, loading: getEnter, context: context, containcolor: (addresshome.isEmpty && lathome == null && longhome == null) ? circleGrey : PurpleColor, onPressed1: () {
              getEnter = true;
              setState(() {});
              if (route == Routes.addproductScreen || route == Routes.categorylistScreen) {
                save("address", addresshome);
                Get.to(const AddcarDetail(), transition: Transition.noTransition, arguments: {
                  "postingType" : "newPost",
                });
                getLocation();

              } else if(route == Routes.myadsView){
                save("address", addresshome);
                Get.to(const AddcarDetail(), transition: Transition.noTransition, arguments: {
                  "postingType" : "Edit",
                  "adIndex" : adindex,
                });
                getLocation();
              } else if(route == "AddlocationScreen"){
                save("address", addresshome);
                Get.back(
                  result: {
                    "addresshome" : addresshome,
                    "subcatId" : subcatID,
                    "price" : price,
                    "postingType" : postingType,
                    "adIndex" : adindex,
                    "route" : Routes.chooseLocation,
                  },
                );
                getLocation();
              }
              else if(lathome != null && longhome != null){
                if (route == Routes.signupScreen) {
                  save("address", addresshome);
                  smsTypeCont.smstype().then((value) {
                    setState(() {
                      androidinId = smsTypeCont.smstypeData!.inId.toString();
                      iosinId = smsTypeCont.smstypeData!.iosInId.toString();
                      androidBannerid = smsTypeCont.smstypeData!.bannerId.toString();
                      iosBannerid = smsTypeCont.smstypeData!.iosBannerId.toString();
                      androidNativeid = smsTypeCont.smstypeData!.nativeAd.toString();
                      iosNativeid = smsTypeCont.smstypeData!.iosNativeAd.toString();
                    });
                    homedataCont.gethomedata().then((value) {
                      categoryListCont.categoryList().then((value) {
                        Get.offAndToNamed(Routes.bottomBarScreen);
                        getLocation();
                      },);
                    },);
                  });

                } else if(route == Routes.loginScreen){
                  save("address", addresshome);
                  smsTypeCont.smstype().then((value) {
                    setState(() {
                      androidinId = smsTypeCont.smstypeData!.inId.toString();
                      iosinId = smsTypeCont.smstypeData!.iosInId.toString();
                      androidBannerid = smsTypeCont.smstypeData!.bannerId.toString();
                      iosBannerid = smsTypeCont.smstypeData!.iosBannerId.toString();
                      androidNativeid = smsTypeCont.smstypeData!.nativeAd.toString();
                      iosNativeid = smsTypeCont.smstypeData!.iosNativeAd.toString();
                    });
                    homedataCont.gethomedata().then((value) {
                      categoryListCont.categoryList().then((value) {
                        Get.offAndToNamed(Routes.bottomBarScreen);
                        getLocation();
                      },);
                    },);
                  });

                } else if(route == Routes.homePage){
                  homedataCont.gethomedata().then((value) {
                    categoryListCont.categoryList().then((value) {
                      save("address", addresshome);
                      Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen(), transition: Transition.noTransition);
                      getLocation();
                    },);
                  },);
                }
              } else {
                showToastMessage("Please enter the location!");
              }

              setState(() {});
            }),
          ),
          appBar: (route == Routes.loginScreen || route == Routes.otpScreen || route == Routes.signupScreen) ? const PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox()) : kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: "Add Location".tr, fun: () {
                Get.back();
              },)) : AppBar(
            elevation: 0,
            backgroundColor: notifier.getWhiteblackColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
              ),
            ),
            title: Text("Add Location".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
          ),
          body: ScrollConfiguration(
            behavior: CustomBehavior(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: 750 < constraints.maxWidth ? Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 1200 > constraints.maxWidth ? 2 : 1,
                              child: mapLocation()
                          ),
                          const Spacer(),
                        ],
                      )
                     : mapLocation()
                    ),
                    const SizedBox(height: kIsWeb ? 10 : 0,),
                    750 < constraints.maxWidth ? Row(
                      children: [
                        const Spacer(),
                        Expanded(
                            flex: 1200 > constraints.maxWidth ? 2 : 1,
                            child: mainButton(txt1: route == Routes.addproductScreen ? "Continue".tr : "Use Current Location".tr, loading: getEnter, context: context, containcolor: (addresshome.isEmpty && lathome == null && longhome == null) ? circleGrey : PurpleColor, onPressed1: () {
                              getEnter = true;
                              setState(() {});
                              if (route == Routes.addproductScreen || route == Routes.categorylistScreen) {
                                save("address", addresshome);
                                Get.to(const AddcarDetail(), transition: Transition.noTransition, arguments: {
                                  "postingType" : "newPost",
                                });
                                getLocation();

                              } else if(route == Routes.myadsView){
                                save("address", addresshome);
                                Get.to(const AddcarDetail(), transition: Transition.noTransition, arguments: {
                                  "postingType" : "Edit",
                                  "adIndex" : adindex,
                                });
                                getLocation();
                              } else if(route == "AddlocationScreen"){
                                save("address", addresshome);
                                Get.back(
                                  result: {
                                    "addresshome" : addresshome,
                                    "subcatId" : subcatID,
                                    "price" : price,
                                    "postingType" : postingType,
                                    "adIndex" : adindex,
                                    "route" : Routes.chooseLocation,
                                  },
                                );
                                getLocation();
                              } else if(lathome != null && longhome != null){
                                if (route == Routes.signupScreen) {
                                  save("address", addresshome);
                                  smsTypeCont.smstype().then((value) {
                                    setState(() {
                                      androidinId = smsTypeCont.smstypeData!.inId.toString();
                                      iosinId = smsTypeCont.smstypeData!.iosInId.toString();
                                      androidBannerid = smsTypeCont.smstypeData!.bannerId.toString();
                                      iosBannerid = smsTypeCont.smstypeData!.iosBannerId.toString();
                                      androidNativeid = smsTypeCont.smstypeData!.nativeAd.toString();
                                      iosNativeid = smsTypeCont.smstypeData!.iosNativeAd.toString();
                                    });
                                    homedataCont.gethomedata().then((value) {
                                      categoryListCont.categoryList().then((value) {
                                        Get.offAndToNamed(Routes.bottomBarScreen);
                                        getLocation();
                                      },);
                                    },);
                                  });

                                } else if(route == Routes.loginScreen){
                                  save("address", addresshome);
                                  smsTypeCont.smstype().then((value) {
                                    setState(() {
                                      androidinId = smsTypeCont.smstypeData!.inId.toString();
                                      iosinId = smsTypeCont.smstypeData!.iosInId.toString();
                                      androidBannerid = smsTypeCont.smstypeData!.bannerId.toString();
                                      iosBannerid = smsTypeCont.smstypeData!.iosBannerId.toString();
                                      androidNativeid = smsTypeCont.smstypeData!.nativeAd.toString();
                                      iosNativeid = smsTypeCont.smstypeData!.iosNativeAd.toString();
                                    });
                                    homedataCont.gethomedata().then((value) {
                                      categoryListCont.categoryList().then((value) {
                                        Get.offAll(kIsWeb ? const HomePage() :const BottombarScreen(), transition: Transition.noTransition);
                                        getLocation();
                                      },);
                                    },);
                                  });

                                } else if(route == Routes.homePage){
                                  homedataCont.gethomedata().then((value) {
                                    categoryListCont.categoryList().then((value) {
                                      save("address", addresshome);
                                      Get.offAll(kIsWeb ? const HomePage() : const BottombarScreen(), transition: Transition.noTransition);
                                      getLocation();
                                    },);
                                  },);
                                }
                              } else {
                                showToastMessage("Please enter the location!");
                              }

                              setState(() {});
                            })),
                        const Spacer(),
                      ],
                    )
                        : const SizedBox(),
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
        );
      }
    );
  }

  Widget mapLocation(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: (route == Routes.loginScreen || route == Routes.otpScreen || route == Routes.signupScreen) ? 50 : 30,),
        Text("Choose your location".tr, style: TextStyle(fontSize: 24, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700,letterSpacing: 1),),
        const SizedBox(height: 10,),
        Text("Come on, find ads around you. Select a location below to get started.".tr,style: TextStyle(fontSize: 16, color: GreyColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 1, height: 1.3),),
        const SizedBox(height: 20,),
        TextField(
          controller: searchCont,
          focusNode: focusNode,
          keyboardType: TextInputType.streetAddress,
          style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifier.textfield,
            hintText: "Search Location".tr,
            hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
            prefixIcon: Image.asset("assets/searchIcon.png", scale: 3,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: PurpleColor),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
          ),
          onChanged: (value) {
            setState(() {
              mapCont.mapApi(context: context, suggestkey: searchCont.text).then((value) {
                setState((){});
              },);
            });
          },
        ),
        const SizedBox(height: 5),
        (mapCont.mapApiModel == null || searchCont.text.isEmpty) ? const SizedBox() : focusNode.hasFocus ? ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: mapCont.mapApiModel!.results!.length,
          separatorBuilder: (context, index) {
            return Divider(color: lightGreyColor,);
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                  onTap: () {
                    setState((){
                      lathome = mapCont.mapApiModel!.results![index].geometry!.location!.lat!;
                      longhome = mapCont.mapApiModel!.results![index].geometry!.location!.lng!;
                      markers.clear();
                      _onAddMarkerButtonPressed(lathome, longhome);

                      addresshome = "${mapCont.mapApiModel!.results![index].name}, ${mapCont.mapApiModel!.results![index].formattedAddress}";
                      searchCont.text = addresshome;
                      focusNode.unfocus();
                    });
                  },
                  child: Text("${mapCont.mapApiModel!.results![index].name}, ${mapCont.mapApiModel!.results![index].formattedAddress}", style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, letterSpacing: 0.5),)),
            );
          },) : const SizedBox(),
        const SizedBox(height: 20),
        (kIsWeb && route == "AddlocationScreen") ? const SizedBox() : focusNode.hasFocus ? const SizedBox() : Text("Current Location".tr, style: TextStyle(fontSize: 16, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700, letterSpacing: 0.5),),
        const SizedBox(height: 10,),
        (kIsWeb && route == "AddlocationScreen") ? const SizedBox() : focusNode.hasFocus ? const SizedBox() : lathome == null ? shimmer(context: context, baseColor: notifier.shimmerbase2, height: 300,) : SizedBox(
          height: height/2.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GoogleMap(
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
              },
              initialCameraPosition: CameraPosition(target: LatLng(lathome, longhome), zoom: 13),
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              onTap: (argument) {
                setState(() {});
                _onAddMarkerButtonPressed(argument.latitude, argument.longitude);
                getCurrentLatAndLong(
                  argument.latitude,
                  argument.longitude,
                );
              },
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              zoomControlsEnabled: true,

              onMapCreated: (controller) {
                setState(() {
                  mapController1 = controller;
                  _animateToUser();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: notifier.getBgColor,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backGrey,
            shape: BoxShape.circle,
          ),
          child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
        ),
      ),
    );
  }
}
