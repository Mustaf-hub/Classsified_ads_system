import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/inboxcontroller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class Addproperties extends StatefulWidget {
  const Addproperties({super.key});

  @override
  State<Addproperties> createState() => _AddpropertiesState();
}

class _AddpropertiesState extends State<Addproperties> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(postingType == "Edit") {
     adindex = Get.arguments["adIndex"];
     propertiesCont.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle ?? "";
     propertiesCont.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription ?? "";
     propertiesCont.propType = myadlistCont.myadlistData!.myadList![adindex].propertyType ?? "";
     propertiesCont.bathroom = myadlistCont.myadlistData!.myadList![adindex].propertyBathroom ?? "";
     bathroom.text = myadlistCont.myadlistData!.myadList![adindex].propertyBathroom ?? "";
     propertiesCont.bedroom = myadlistCont.myadlistData!.myadList![adindex].propertyBedroom ?? "";
     bedroom.text = myadlistCont.myadlistData!.myadList![adindex].propertyBedroom ?? "";
     propertiesCont.furnishing = myadlistCont.myadlistData!.myadList![adindex].propertyFurnishing ?? "";
     furnishing.text = myadlistCont.myadlistData!.myadList![adindex].propertyFurnishing ?? "";
     propertiesCont.constructionStatus = myadlistCont.myadlistData!.myadList![adindex].propertyConstructionStatus ?? "";
     constructionStatus.text = myadlistCont.myadlistData!.myadList![adindex].propertyConstructionStatus ?? "";
     propertiesCont.listedBy = myadlistCont.myadlistData!.myadList![adindex].propertyListedBy ?? "";
     listedBy.text = myadlistCont.myadlistData!.myadList![adindex].propertyListedBy ?? "";
     propertiesCont.superbuildarea.text = myadlistCont.myadlistData!.myadList![adindex].propertySuperbuildarea ?? "";
     propertiesCont.carpetarea.text = myadlistCont.myadlistData!.myadList![adindex].propertyCarpetarea ?? "";
     propertiesCont.maintaince.text = myadlistCont.myadlistData!.myadList![adindex].propertyMaintainceMonthly ?? "";
     propertiesCont.totalFloor.text = myadlistCont.myadlistData!.myadList![adindex].propertyTotalFloor ?? "";
     propertiesCont.floorNo.text = myadlistCont.myadlistData!.myadList![adindex].propertyFloorNo ?? "";
     propertiesCont.propertyFacing = myadlistCont.myadlistData!.myadList![adindex].propertyFacing ?? "";
     propertyFacing.text = myadlistCont.myadlistData!.myadList![adindex].propertyFacing ?? "";
     propertiesCont.carParking.text = myadlistCont.myadlistData!.myadList![adindex].propertyCarParking ?? "";
     propertiesCont.projectName.text = myadlistCont.myadlistData!.myadList![adindex].projectName ?? "";
     propertiesCont.length.text = myadlistCont.myadlistData!.myadList![adindex].plotLength ?? "";
     propertiesCont.breadth.text = myadlistCont.myadlistData!.myadList![adindex].plotBreadth ?? "";
     propertiesCont.plotArea.text = myadlistCont.myadlistData!.myadList![adindex].plotArea ?? "";
     propertiesCont.length.text = myadlistCont.myadlistData!.myadList![adindex].plotLength ?? "";
     propertiesCont.breadth.text = myadlistCont.myadlistData!.myadList![adindex].plotBreadth ?? "";
     propertiesCont.pgMealsincluded = myadlistCont.myadlistData!.myadList![adindex].pgMealsInclude ?? "";

       subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
         for(int i = 0; i < subcatTypeCont.subcatTypeData!.subtypelist!.length; i++){
           if(propertiesCont.propType == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
             setState(() {
               print("><><><><> ${propertyType.text}");
               propertyType.text = subcatTypeCont.subcatTypeData!.subtypelist![i].title ?? "";
               adType = false;
             });
           } else if(myadlistCont.myadlistData!.myadList![adindex].pgSubtype == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
             setState(() {
               propertiesCont.propType = myadlistCont.myadlistData!.myadList![adindex].pgSubtype!;
               propertyType.text = subcatTypeCont.subcatTypeData!.subtypelist![i].title ?? "";
               adType = false;
             });
           }
         }
       },);

    } else {
      propertiesCont.adTitle.text = "";
      propertiesCont.description.text = "";
      propertiesCont.propType = "";
      propertiesCont.bathroom = "";
      bathroom.text = "";
      propertiesCont.bedroom = "";
      bedroom.text = "";
      propertiesCont.furnishing = "";
      propertiesCont.constructionStatus = "";
      propertiesCont.listedBy = "";
      propertiesCont.superbuildarea.text = "";
      propertiesCont.carpetarea.text = "";
      propertiesCont.maintaince.text = "";
      propertiesCont.totalFloor.text = "";
      propertiesCont.floorNo.text = "";
      propertiesCont.propertyFacing = "";
      propertiesCont.carParking.text = "";
      propertiesCont.projectName.text = "";
      propertiesCont.length.text = "";
      propertiesCont.breadth.text = "";
      propertiesCont.plotArea.text = "";
      propertiesCont.length.text = "";
      propertiesCont.breadth.text = "";
      propertiesCont.pgMealsincluded = "";
      propertyType.text = "";
    }
  }

  bool adType = true;
  late ColorNotifire notifier;
  PropertiesController propertiesCont = Get.find();
  CategoryListController subcatTypeCont = Get.find();
  MyadlistController myadlistCont = Get.find();

  String subcatID = Get.arguments["subcatId"];

  final _formKey = GlobalKey<FormState>();

  String bechlorAllowed = "";
  String mealsIncluded = "";

  List bedrooms = [
    "1",
    "2",
    "3",
    "4",
    "4+"
  ];
  
  List listedby = [
    "Builder",
    "Dealer",
    "Owner".tr
  ];
  
  List carParking = [
    "0",
    "1",
    "2",
    "3",
    "3+"
  ];

  List facing = [
    "East".tr,
    "North".tr,
    "North-East".tr,
    "North-West".tr,
    "South".tr,
    "South-East".tr,
    "South-West".tr,
    "West".tr,
  ];
  List facingData = [
    "East",
    "North",
    "North-East",
    "North-West",
    "South",
    "South-East",
    "South-West",
    "West",
  ];

  TextEditingController propertyType= TextEditingController();
  TextEditingController bathroom = TextEditingController();
  TextEditingController bedroom = TextEditingController();

  InboxController inbox = InboxController();
  int adindex = 0;
  String postingType = Get.arguments["postingType"];

  TextEditingController furnishing = TextEditingController();
  TextEditingController constructionStatus = TextEditingController();
  TextEditingController listedBy = TextEditingController();
  TextEditingController propertyFacing = TextEditingController();

  bool isOpened = false;
  @override
  Widget build(BuildContext context ) {
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
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Include some details".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(context: context, txt1: "Next".tr, containcolor: PurpleColor, onPressed1: () {
          if (_formKey.currentState!.validate()) {
            Get.toNamed(Routes.addImages, arguments: {
              "subcatId" : subcatID,
              "adIndex" : adindex,
              "postingType" : postingType,
            });
          }
        },),
      ),
      body: (adType && postingType == "Edit") ? Padding(
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
      ) : GetBuilder<PropertiesController>(
        builder: (propertiesCont) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: (subcatID == "1" || subcatID == "2") ? houseProp()
                      : subcatID == "3" ? landsplots()
                      : (subcatID == "4" || subcatID == "5") ? shopOffice()
                      : pgGuest(),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  Widget houseProp(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFeild(validMsg: "Please enter details".tr, textController: propertyType, context: context, hinttext: "Type *".tr, readStatus: true, onPressed1: () {
          // subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
          //
          // },);
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          typepopUp(context: context, subtitle: "Type".tr, title: "House & Apartments".tr,).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        optextFeild(validMsg: "Bedroom", textController: bedroom, textInputType: TextInputType.number, context: context, readStatus: true, hinttext: "Bedrooms".tr, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(title: "House & Apartments".tr, subtitle: "Bedrooms".tr, context: context, typeList: bedrooms).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        optextFeild(validMsg: "Please enter details", textController: bathroom, context: context, hinttext: "Bathrooms".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context,subtitle: "Bathrooms".tr, title: "House & Apartments".tr, typeList: bedrooms).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        optextFeild(validMsg: "Please enter details".tr, textController: furnishing, context: context, hinttext: "Furnishing".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, typeList: inbox.furniture, title: "House & Apartments".tr, subtitle: "Furnishing".tr).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        subcatID == "2" ? SizedBox() : optextFeild(validMsg: "Please add Construction Status".tr, textController: constructionStatus, context: context, hinttext: "Construction Status".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, title: "House & Apartments".tr, subtitle: "Construction Status".tr, typeList: inbox.constStatus).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: subcatID == "2" ? 0 : 15,),
        optextFeild(validMsg: "Please enter listing details".tr, textController: listedBy, context: context, hinttext: "Listed by".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, subtitle: "Listed by".tr, title: "House & Apartments".tr, typeList: inbox.listedBy).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter builtup area".tr, textController: propertiesCont.superbuildarea, context: context, textInputType: TextInputType.number, hinttext: "${"Super Builtup area (ft²)".tr} *"),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter carpet area".tr, textController: propertiesCont.carpetarea, context: context, textInputType: TextInputType.number, hinttext: "${"Carpet Area (ft²)".tr} *",),
        SizedBox(height: 15,),
        subcatID == "2" ? SizedBox() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            optextFeild(validMsg: "Please enter maintanance".tr, textInputType: TextInputType.number, textController: propertiesCont.maintaince, context: context, hinttext: "Maintanance (Monthly)".tr),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textInputType: TextInputType.number, textController: propertiesCont.totalFloor, context: context, hinttext: "Total Floors".tr),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textInputType: TextInputType.number, textController: propertiesCont.floorNo, context: context, hinttext: "Floor No".tr),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textInputType: TextInputType.number, textController: propertiesCont.carParking, context: context, hinttext: "Car Parking".tr, readStatus: true, onPressed1: () {
              if(isOpened) return;

              isOpened = true;
              setState(() {});
              popUp(context: context, title: "House & Apartments".tr, subtitle: "Car Parking".tr, typeList: carParking).then((value) {
                isOpened = false;
                setState(() {});
              },);
            },),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textInputType: TextInputType.number, textController: propertyFacing, context: context, hinttext: "Facing".tr, readStatus: true, onPressed1: () {
              if(isOpened) return;

              isOpened = true;
              setState(() {});
              popUp(context: context, title: "House & Apartments".tr, subtitle: "Facing".tr, typeList: facing).then((value) {
                isOpened = false;
                setState(() {});
              },);
            },),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textController: propertiesCont.projectName, context: context, hinttext: "Project Name".tr),
          ],
        ),
        SizedBox(height: subcatID == "2" ? 0 : 15,),
        TextFormField(
          controller: propertiesCont.adTitle,
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
          controller: propertiesCont.description,
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
        SizedBox(height: 20,),
      ],
    );
  }

  String typerentsale = "";

  Widget landsplots(){
    return GetBuilder<PropertiesController>(
      builder: (propertiesCont) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type *".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        propertiesCont.propType = "${subcatTypeCont.subcatTypeData!.subtypelist![0].id}";
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:  propertiesCont.propType == "8" ? PurpleColor : lightGreyColor,
                              width: 1
                          ),
                          color:  propertiesCont.propType == "8" ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${subcatTypeCont.subcatTypeData!.subtypelist![0].title}", style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
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
                        propertiesCont.propType = "${subcatTypeCont.subcatTypeData!.subtypelist![1].id}";
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:  propertiesCont.propType == "9" ? PurpleColor : lightGreyColor,
                              width: 1
                          ),
                          color:  propertiesCont.propType == "9" ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${subcatTypeCont.subcatTypeData!.subtypelist![1].title}", style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            textFeild(validMsg: "Plot area is required.".tr, textController: propertiesCont.plotArea, context: context, hinttext: "Plot Area *".tr, textInputType: TextInputType.number),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textController: propertiesCont.length, context: context, hinttext: "Length".tr, textInputType: TextInputType.number),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textController: listedBy, textInputType: TextInputType.number, context: context, hinttext: "Listed by".tr, readStatus: true, onPressed1: () {
              if(isOpened) return;

              isOpened = true;
              setState(() {});
              popUp(context: context, title: "Land & Plots".tr, subtitle: "Listed by".tr, typeList: inbox.listedBy).then((value) {
                isOpened = false;
                setState(() {});
              },);
            },),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textController: propertiesCont.breadth, context: context, hinttext: "Breadth".tr, textInputType: TextInputType.number),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textController: propertyFacing, context: context, hinttext: "Facing".tr, readStatus: true, onPressed1: () {
              if(isOpened) return;

              isOpened = true;
              setState(() {});
              popUp(context: context, typeList: facing, title: "Land & Plots".tr, subtitle: "Facing".tr).then((value) {
                isOpened = false;
                setState(() {});
              },);
            },),
            SizedBox(height: 15,),
            optextFeild(validMsg: "Please enter details".tr, textController: propertiesCont.projectName, context: context, hinttext: "Project Name".tr),
            SizedBox(height: 15,),
            TextFormField(
              controller: propertiesCont.adTitle,
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
              controller: propertiesCont.description,
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
            SizedBox(height: 20,),
          ],
        );
      }
    );
  }

  Widget shopOffice(){
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFeild(validMsg: "Please enter details".tr,textController: bathroom, context: context, hinttext: "Bathrooms".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, subtitle: "Bathrooms".tr, title: "Shops & Office".tr, typeList: bedrooms).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr,textController: furnishing, context: context, hinttext: "Furnishing".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, subtitle: "Furnishing".tr, title: "Shops & Office".tr, typeList: inbox.furniture).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        subcatID == "4" ? SizedBox() : textFeild(validMsg: "Please add Construction Status".tr, textController: constructionStatus, context: context, hinttext: "Construction Status".tr,  readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, title: "Shops & Office".tr, subtitle: "Construction Status".tr, typeList: inbox.constStatus).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: subcatID == "4" ? 0 : 15,),
        textFeild(validMsg: "Please enter listing details".tr, textController: listedBy, textInputType: TextInputType.number, context: context, hinttext: "Listed by".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context,title: "", subtitle: "Listed by".tr, typeList: inbox.listedBy).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr, textController: propertiesCont.superbuildarea, context: context, textInputType: TextInputType.number, hinttext: "${"Super Builtup area (ft²)".tr} *"),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr, textController: propertiesCont.carpetarea, context: context, textInputType: TextInputType.number, hinttext: "${"Carpet Area (ft²)".tr} *"),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr, textController: propertiesCont.carParking, context: context, hinttext: "Car Parking".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, title: "Shops & Office".tr, subtitle: "Car Parking".tr, typeList: carParking).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        optextFeild(validMsg: "Please enter details".tr, textController: propertiesCont.projectName, context: context, hinttext: "Project Name".tr),
        SizedBox(height: 15,),
        optextFeild(validMsg: "Please enter details".tr, textInputType: TextInputType.number, textController: propertiesCont.maintaince, context: context, hinttext: "Maintanance (Monthly)".tr),
        SizedBox(height: 15,),
        TextFormField(
          controller: propertiesCont.adTitle,
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
          controller: propertiesCont.description,
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
        SizedBox(height: 20,),
      ],
    );
  }

  Widget pgGuest(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFeild(validMsg: "Please enter details".tr,textController: propertyType, context: context, hinttext: "Type *".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          typepopUp(context: context, title: "PG & Guest".tr, subtitle: "Type".tr).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr, textController: furnishing, textInputType: TextInputType.number, context: context, hinttext: "Furnishing".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, title: "PG & Guest".tr, subtitle: "Furnishing".tr, typeList: inbox.furniture).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr, textController: listedBy, context: context, hinttext: "Listed by".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, title: "PG & Guest".tr, subtitle: "Listed by".tr, typeList: inbox.listedBy).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        textFeild(validMsg: "Please enter details".tr, textController: propertiesCont.carParking, context: context, hinttext: "Car Parking".tr, readStatus: true, onPressed1: () {
          if(isOpened) return;

          isOpened = true;
          setState(() {});
          popUp(context: context, title: "PG & Guest".tr, subtitle: "Car Parking".tr, typeList: carParking).then((value) {
            isOpened = false;
            setState(() {});
          },);
        },),
        SizedBox(height: 15,),
        Text("Meals Included".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    propertiesCont.pgMealsincluded = "0";
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: propertiesCont.pgMealsincluded == "0" ? PurpleColor : lightGreyColor,
                          width: 1
                      ),
                      color: propertiesCont.pgMealsincluded == "0" ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No".tr, style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
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
                    propertiesCont.pgMealsincluded = "1";
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: propertiesCont.pgMealsincluded == "1" ? PurpleColor : lightGreyColor,
                          width: 1
                      ),
                      color: propertiesCont.pgMealsincluded == "1" ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Yes".tr, style: TextStyle(fontSize: 14, color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium),)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15,),
        TextFormField(
          controller: propertiesCont.adTitle,
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
          controller: propertiesCont.description,
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
        SizedBox(height: 20,),
      ],
    );
  }

  Future typepopUp({context, required String title, required String? subtitle}){
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
                                          child: Text("$title  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),)),
                                      Text(">  $subtitle", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: subcatTypeCont.subcatTypeData!.subtypelist!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          
                                            setState(() {
                                              propertyType.text = subcatTypeCont.subcatTypeData!.subtypelist![index].title!;
                                              propertiesCont.propType = subcatTypeCont.subcatTypeData!.subtypelist![index].id!;
                                            });
                                            print("??????????????? ${propertiesCont.propType}");
                                          Get.back();
                                        },
                                        child: Container(
                                            height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: Text("${subcatTypeCont.subcatTypeData!.subtypelist![index].title}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
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
  Future popUp({context, required String title, required String subtitle, required List typeList}){
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
                        backgroundColor: notifier.getWhiteblackColor,
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
                                      Flexible(
                                        child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Text("$title  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),overflow: TextOverflow.ellipsis,)),
                                      ),
                                      Text(">  $subtitle", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: typeList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if(subtitle == "Bedrooms".tr){
                                            setState(() {
                                              propertiesCont.bedroom = bedrooms[index];
                                              bedroom.text = bedrooms[index];
                                            });
                                          } else if(subtitle == "Bathrooms".tr){
                                            setState((){
                                              propertiesCont.bathroom = bedrooms[index];
                                              bathroom.text = bedrooms[index];
                                            });
                                          } else if(subtitle == "Furnishing".tr){
                                            setState((){
                                              propertiesCont.furnishing = inbox.furnitureData[index];
                                              furnishing.text = inbox.furniture[index];
                                              print("SDSDSDSDS ${propertiesCont.furnishing}");
                                            });
                                          } else if(subtitle == "Listed by".tr){
                                            setState((){
                                              propertiesCont.listedBy = inbox.listedByData[index];
                                              listedBy.text = inbox.listedBy[index];
                                            });
                                          } else if(subtitle == "Car Parking".tr){
                                            setState((){
                                              propertiesCont.carParking.text = carParking[index];
                                            });
                                          } else if(subtitle == "Facing".tr){
                                            setState((){
                                              propertiesCont.propertyFacing = facingData[index];
                                              propertyFacing.text = facing[index];
                                            });
                                          } else if(subtitle == "Construction Status".tr){
                                            setState((){
                                              propertiesCont.constructionStatus = inbox.constStatusData[index];
                                              constructionStatus.text = inbox.constStatus[index];
                                            });
                                          }
                                          print(">>>>> bedroom= ${propertiesCont.bedroom}, Construction Status = ${propertiesCont.constructionStatus}, athroom= ${propertiesCont.bathroom}, furn= ${propertiesCont.furnishing}, listed by = ${propertiesCont.listedBy}, maintaince ${propertiesCont.maintaince.text}, carparking =  ${propertiesCont.carParking.text}, facing= ${propertiesCont.propertyFacing}");
                                          Get.back();
                                        },
                                        child: Container(
                                            height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: Text("${typeList[index]}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
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
