import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/carbrandlist_controller.dart';
import 'package:sellify/controller/carvariation_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import '../../../controller/inboxcontroller.dart';

class AddcarDetail extends StatefulWidget {
  const AddcarDetail({super.key});

  @override
  State<AddcarDetail> createState() => _AddcarDetailState();
}

class _AddcarDetailState extends State<AddcarDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      setState(() {
        if(postingType == "Edit"){
          print("SDKKKKKKKKKKKKK");
          adindex = Get.arguments["adIndex"];

          postadController.year.text = myadlistCont.myadlistData!.myadList![adindex].postYear ?? "";
          postadController.brandId = myadlistCont.myadlistData!.myadList![adindex].brandId ?? "";
          postadController.variantId = myadlistCont.myadlistData!.myadList![adindex].variantId ?? "";
          postadController.varianttypeID = myadlistCont.myadlistData!.myadList![adindex].variantTypeId ?? "";
          postadController.varianttypeID = myadlistCont.myadlistData!.myadList![adindex].variantTypeId ?? "";
          postadController.fuel.text = myadlistCont.myadlistData!.myadList![adindex].fuel ?? "";
          postadController.address = myadlistCont.myadlistData!.myadList![adindex].fullAddress ?? "";
          postadController.kmdriven.text = myadlistCont.myadlistData!.myadList![adindex].kmDriven ?? "";
          postadController.transType = myadlistCont.myadlistData!.myadList![adindex].transmission ?? "";
          postadController.noOfowners.text = myadlistCont.myadlistData!.myadList![adindex].noOwner ?? "";
          postadController.adPrice = myadlistCont.myadlistData!.myadList![adindex].adPrice ?? "";
          postadController.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle ?? "";
          postadController.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription ?? "";
          carbrandlistCont.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
            for(int i = 0; i < carbrandlistCont.carbrandData!.carbrandlist!.length;i++){
              if(postadController.brandId == carbrandlistCont.carbrandData!.carbrandlist![i].id){
                setState(() {
                  selectedBrand = i;
                });

                carvariationCont.carvariation(brandId: carbrandlistCont.carbrandData!.carbrandlist![i].id).then((value) {
                  for(int j = 0; j < carvariationCont.carvariationData!.carvariationlist!.length; j++){
                    if(postadController.variantId == carvariationCont.carvariationData!.carvariationlist![j].id){
                      setState(() {
                        selectedVariant = j;
                      });
                      print("VARIATION ID ${carvariationCont.carvariationData!.carvariationlist![i].brandId}");
                      if (carvariationCont.carvariationData!.carvariationlist![i].variationTypeCount != 0) {
                        carvariationCont.carvariantType(
                            brandId: "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].id}",
                            variationId: "${carvariationCont.carvariationData!.carvariationlist![i].id}").then((value) {
                              print(">>>>>> ${carvariationCont.carvarTypeData!.carvariationtypelist}");
                              for(int k = 0; k < carvariationCont.carvarTypeData!.carvariationtypelist!.length; k++){
                                if(postadController.varianttypeID == carvariationCont.carvarTypeData!.carvariationtypelist![k].id){
                                  setState(() {
                                    selectedType = k;
                                  });
                                  setState(() {
                                    brandmodel.text = "${carbrandlistCont.carbrandData!.carbrandlist![i].title} / ${carvariationCont.carvariationData!.carvariationlist![j].title} / ${carvariationCont.carvarTypeData!.carvariationtypelist![k].title}";
                                    postadController.varianttypeID = "${carvariationCont.carvarTypeData!.carvariationtypelist![k].id}";
                                    postadController.variantId = "${carvariationCont.carvariationData!.carvariationlist![j].id}";
                                    postadController.brandId = "${carbrandlistCont.carbrandData!.carbrandlist![i].id}";
                                    adBrandModel = false;
                                  });
                                }
                              }
                            },);
                      } else {
                        brandmodel.text = "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].title} / ${carvariationCont.carvariationData!.carvariationlist![selectedVariant].title}";
                        postadController.variantId = "${carvariationCont.carvariationData!.carvariationlist![j].id}";
                        postadController.brandId = "${carbrandlistCont.carbrandData!.carbrandlist![i].id}";
                        adBrandModel = false;
                      }
                    }
                  }
                },);
              }
            }
          },);
        } else {
          postadController.year.text = "";
          postadController.fuel.text = "";
          postadController.address = "";
          postadController.kmdriven.text = "";
          postadController.transType = "";
          postadController.noOfowners.text = "";
          postadController.adPrice = "";
          postadController.adTitle.text = "";
          postadController.description.text = "";
        }
      });

  }

  int adindex = 0;
  MyadlistController myadlistCont = Get.find();
  InboxController inbox = Get.find();

  late ColorNotifire notifier;

  CarbrandlistController carbrandlistCont = CarbrandlistController();
  CarvariationController carvariationCont = CarvariationController();

  TextEditingController brandmodel = TextEditingController();



  bool variationStatus = false;
  bool variationTypeStatus = false;

  bool adBrandModel = true;

  String carbrandId = "0";
  String variationId = "0";
  String variationTypeId = "0";

  int selectedBrand = 0;
  int selectedType = 0;
  int selectedVariant = 0;

  String postingType = Get.arguments["postingType"];
  String selectedFuel = "";
  String selectedOwner = "";

  final _formKey = GlobalKey<FormState>();

  PostadController postadController = Get.find();

  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getWhiteblackColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
          ),
        ),
        title: Text("Include some details".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () {

          if (_formKey.currentState!.validate()) {

              Get.toNamed(Routes.addImages, arguments: {
                "subcatId" : "0",
                "adIndex" : adindex,
                "postingType" : postingType,
              });
          }
        },),
      ),
      body: (adBrandModel && postingType == "Edit") ? Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 15,);
          },
          itemBuilder: (context, index) {
            return shimmer(context: context, baseColor: notifier.shimmerbase2, height: 50,);
          },),
      ) : SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textFeild(validMsg: "Car brand and other details are required.",textController: brandmodel, context: context, hinttext: "Brand *".tr, readStatus: true, onPressed1: () {
                    if(isOpened) return;

                    isOpened = true;
                    setState(() {});
                    carbrandlistCont.carbrandlist(uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0").then((value) {
                      popUp(context: context).then((value) {
                        isOpened = false;
                        setState(() {});
                      },);
                    },);
                  },),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: postadController.year,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                    validator: (value) {
                      if (num.parse(postadController.year.text) > DateTime.now().year) {
                        return "Please enter valid year!";
                      } else if(postadController.year.text.isEmpty){
                        return "Year has been required.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if(int.parse(postadController.year.text) > DateTime.now().year){
                        postadController.year.text = DateTime.now().year.toString();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: notifier.textfield,
                      hintText: "Year *".tr,
                      hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: PurpleColor),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  textFeild(validMsg: "Fuel type is required.", textController: postadController.fuel, context: context, hinttext: "Fuel *", readStatus: true, onPressed1: () {
                    if(isOpened) return;

                    isOpened = true;
                    setState(() {});
                     fuelPopup(context: context).then((value) {
                       isOpened = false;
                       setState(() {});
                     },);
                  },),
                  SizedBox(height: 15,),
                  Text("Transmission".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              postadController.transType = "Automatic";
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: postadController.transType == "Automatic" ? PurpleColor : lightGreyColor,
                                    width: 1
                                ),
                              color: postadController.transType == "Automatic" ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Automatic".tr, style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              postadController.transType = "Manual";
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: postadController.transType == "Manual" ? PurpleColor : lightGreyColor,
                                    width: 1
                                ),
                                color: postadController.transType == "Manual" ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Manual".tr, style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  textFeild(validMsg: "Please edit how many km your car has driven.".tr, textInputType: TextInputType.number, textController: postadController.kmdriven, context: context, hinttext: "KM driven".tr),
                  SizedBox(height: 15,),
                  textFeild(validMsg: "Please add numer of owner.".tr, textInputType: TextInputType.number, textController: postadController.noOfowners, context: context, hinttext: "No. of Owners".tr, readStatus: true, onPressed1: () {
                    if(isOpened) return;
                    isOpened = true;
                    setState(() {});
                    ownerPopup(context: context).then((value) {
                      isOpened = false;
                      setState(() {});
                    },);
                  },),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: postadController.adTitle,
                    maxLength: 70,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 10) {
                        return '${"Please edit the field.".tr}\n${"atleast 10 characters are required.".tr}';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: notifier.textfield,
                      hintText: "Ad Title *".tr,
                      hintStyle: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                      helperText: "${"Mention the lwy features of your item".tr} (e.g. ${"brand".tr},\n${"model, age, type.".tr})",
                      helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: PurpleColor),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: postadController.description,
                    maxLength: 2000,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 10) {
                        return '${"Please edit the field.".tr}\n${"atleast 10 characters are required.".tr}';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: notifier.textfield,
                      hintText: "Describe what you are selling *".tr,
                      hintStyle: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                      helperText: "Include condition, features and reason for selling".tr,
                      helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: PurpleColor),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future popUp({context, List? brands}){
    return showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                child: Transform.scale(
                  scale: a1.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Dialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            variationTypeStatus ? Row(
                              children: [
                                Flexible(
                                  child: InkWell(
                                      onTap: () {
                                          setState(() {
                                            variationTypeStatus = false;
                                          });
                                      },
                                      child: Text("${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].title}  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,), overflow: TextOverflow.ellipsis,)),
                                ),
                                Text(">  ${carvariationCont.carvariationData!.carvariationlist![selectedType].title}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,), overflow: TextOverflow.ellipsis,),
                              ],
                            ) : variationStatus ? Text("${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].title}  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,), overflow: TextOverflow.ellipsis,)
                                : Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                child: Text("Cars  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),)),
                                Text(">  Brand", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Flexible(
                              child: SingleChildScrollView(
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemCount: variationTypeStatus ? carvariationCont.carvarTypeData!.carvariationtypelist!.length : variationStatus ? carvariationCont.carvariationData!.carvariationlist!.length : carbrandlistCont.carbrandData!.carbrandlist!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 20,);
                                  },
                                  itemBuilder: (context, index) {
                                    return variationTypeStatus ? InkWell(
                                      onTap: () {
                                        setState((){
                                          selectedType = index;
                                          brandmodel.text = "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].title} / ${carvariationCont.carvariationData!.carvariationlist![selectedVariant].title} / ${carvariationCont.carvarTypeData!.carvariationtypelist![selectedType].title}";
                                          postadController.varianttypeID = "${carvariationCont.carvarTypeData!.carvariationtypelist![selectedType].id}";
                                          postadController.variantId = "${carvariationCont.carvariationData!.carvariationlist![selectedVariant].id}";
                                          postadController.brandId = "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].id}";
                                          variationTypeStatus = false;
                                          variationStatus = false;
                                        });
                                        print("BRAND ID > $carbrandId");
                                        print("variationId > $variationId");
                                        print("variationTypeId > $variationTypeId");
                                        Get.back();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${carvariationCont.carvarTypeData!.carvariationtypelist![index].title}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),),
                                        ],
                                      ),
                                    ) : variationStatus ? InkWell(
                                      onTap: () {
                                        if (carvariationCont.carvariationData!.carvariationlist![index].variationTypeCount != 0) {
                                          carvariationCont.carvariantType(
                                              brandId: "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].id}",
                                              variationId: "${carvariationCont.carvariationData!.carvariationlist![index].id}").then((value) {
                                            if(value == "true"){
                                              setState(() {
                                                variationTypeStatus = true;
                                                selectedVariant = index;
                                              });
                                            }
                                          },);
                                        } else {
                                          setState((){
                                            selectedVariant = index;
                                            brandmodel.text = "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].title} / ${carvariationCont.carvariationData!.carvariationlist![selectedVariant].title}";
                                            postadController.variantId = "${carvariationCont.carvariationData!.carvariationlist![selectedVariant].id}";
                                            postadController.brandId = "${carbrandlistCont.carbrandData!.carbrandlist![selectedBrand].id}";
                                            variationTypeStatus = false;
                                            variationStatus = false;
                                          });
                                          print("BRAND ID > $carbrandId");
                                          print("variationId > $variationId");
                                          print("variationId > ${postadController.varianttypeID}");
                                          Get.back();
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${carvariationCont.carvariationData!.carvariationlist![index].title}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),),
                                          carvariationCont.carvariationData!.carvariationlist![index].variationTypeCount == 0 ? SizedBox() : Image.asset("assets/right.png", height: 20, color: notifier.getTextColor,)
                                        ],
                                      ),
                                    ) : InkWell(
                                      onTap: () {
                                          if (carbrandlistCont.carbrandData!.carbrandlist![index].variationCount != 0) {
                                            carvariationCont.carvariation(brandId: carbrandlistCont.carbrandData!.carbrandlist![index].id).then((value) {
                                              if(value == "true"){
                                                setState(() {
                                                  variationStatus = true;
                                                  selectedBrand = index;
                                                });
                                              }
                                            },);
                                          }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${carbrandlistCont.carbrandData!.carbrandlist![index].title}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),),
                                          carbrandlistCont.carbrandData!.carbrandlist![index].variationCount == 0 ? SizedBox() : Image.asset("assets/right.png", height: 20, color: notifier.getTextColor,)
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    setState(() {
                                      variationStatus = false;
                                      variationTypeStatus = false;
                                    });
                                  },
                                  child: Text("Cancel".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
    );
  }
  Future fuelPopup({context, List? brands}){
    return showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(
            builder: (context, setState) {
              return ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: Transform.scale(
                    scale: a1.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Dialog(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Text("Cars  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),)),
                                      Text(">  Fuel", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: inbox.fuelType.length,
                                    scrollDirection: Axis.vertical,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 20,);
                                    },
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState((){
                                            postadController.fuel.text = inbox.fuelType[index];
                                          });
                                          Get.back();
                                        },
                                          child: Text(inbox.fuelType[index], style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                    onTap: () {
                                      Get.back();
                                      setState(() {
                                        variationStatus = false;
                                        variationTypeStatus = false;
                                      });
                                    },
                                    child: Text("Cancel".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            }
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
    );
  }
  Future ownerPopup({context, List? brands}){
    return showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(
            builder: (context, setState) {
              return ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: Transform.scale(
                    scale: a1.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Dialog(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Text("Cars  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),)),
                                      Text(">  No. of Owners", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: inbox.owners.length,
                                    scrollDirection: Axis.vertical,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 20,);
                                    },
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState((){
                                            postadController.noOfowners.text = inbox.ownersData[index];
                                          });
                                          Get.back();
                                        },
                                          child: Text(inbox.owners[index], style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                    onTap: () {
                                      Get.back();
                                      setState(() {
                                        variationStatus = false;
                                        variationTypeStatus = false;
                                      });
                                    },
                                    child: Text("Cancel".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            }
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
    );
  }
}
