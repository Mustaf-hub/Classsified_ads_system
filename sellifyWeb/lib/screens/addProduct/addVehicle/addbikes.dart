import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/bikecvehiclecontoller.dart';
import 'package:sellify/controller/postad/postbike_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/addProduct/addimages.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class Addbikes extends StatefulWidget {
  const Addbikes({super.key});

  @override
  State<Addbikes> createState() => _AddbikesState();
}

class _AddbikesState extends State<Addbikes> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {

      if(postingType == "Edit"){
        postbikeCont.subcatId = subcatID;
        adindex = Get.arguments["adIndex"];
        postbikeCont.catId = myadlistCont.myadlistData!.myadList![adindex].catId ?? "";

        if (subcatID == "28") {
          postbikeCont.brandId = myadlistCont.myadlistData!.myadList![adindex].bicyclesBrandId ?? "";
        } else if(subcatID == "26") {
          postbikeCont.brandId = myadlistCont.myadlistData!.myadList![adindex].scooterBrandId ?? "";
          postbikeCont.modelId = myadlistCont.myadlistData!.myadList![adindex].scooterModelId ?? "";
        } else {
          postbikeCont.brandId = myadlistCont.myadlistData!.myadList![adindex].motocycleBrandId ?? "";
          postbikeCont.modelId = myadlistCont.myadlistData!.myadList![adindex].motorcycleModelId ?? "";
        }
        postbikeCont.year.text = myadlistCont.myadlistData!.myadList![adindex].postYear ?? "";
        postbikeCont.kmdriven.text = myadlistCont.myadlistData!.myadList![adindex].kmDriven ?? "";
        postbikeCont.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle ?? "";
        postbikeCont.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription ?? "";

        if(subcatID == "28") {
          subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
            for(int i = 0; i < subcatTypeCont.subcatTypeData!.subtypelist!.length; i++) {
              if(postbikeCont.brandId == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
                setState(() {
                  bikeBrand.text = "${subcatTypeCont.subcatTypeData!.subtypelist![i].title}";
                  adBrandModel = false;
                });
              }
            }
          },);

        } else {
          bikeScoCvehicleCon.getvehicle(subcatId: subcatID).then((value) {
            for(int i = 0; i < bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length; i++) {
              if(postbikeCont.brandId == bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].id){
                bikeScoCvehicleCon.getModel(brandId: bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].id!).then((value) {
                  for(int j = 0; j < bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist!.length; j++) {
                    if(postbikeCont.modelId == bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![j].id){
                      setState(() {
                        bikeBrand.text = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].title} / ${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![j].title}";
                        adBrandModel = false;
                      });
                    }
                  }
                },);
              }
            }
          },);
        }
      }
      else {
        postbikeCont.brandId = "";
        postbikeCont.modelId = "";
        bikeBrand.text = "";
        postbikeCont.year.text = "";
        postbikeCont.kmdriven.text = "";
        postbikeCont.adTitle.text = "";
        postbikeCont.description.text = "";
      }
    });
  }

  late ColorNotifire notifier;

  TextEditingController bikeBrand = TextEditingController();

  PostbikeController postbikeCont = Get.find();
  CategoryListController subcatTypeCont = Get.find();
  MyadlistController myadlistCont = Get.find();
  BikescooterCvehicleContoller bikeScoCvehicleCon = Get.find();

  String subcatID = Get.arguments["subcatId"];
  String postingType = Get.arguments["postingType"];
  int adindex = 0;
  final _formKey = GlobalKey<FormState>();

  int selectedBrand = 0;
  int selectedModel = 0;
  bool brandStatus = false;
  bool modelStatus = false;

  bool adBrandModel = true;

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
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Include some details".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: kIsWeb ? const SizedBox() : LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 15),
            child: mainButton(context: context, txt1: "Next".tr, containcolor: PurpleColor, onPressed1: () {
              if (_formKey.currentState!.validate()) {
                Get.to(const AddImages(), arguments: {
                  "subcatId" : subcatID,
                  "adIndex" : adindex,
                  "postingType" : postingType,
                }, transition: Transition.noTransition);
              }
            },),
          );
        }
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
         return (adBrandModel && postingType == "Edit") ? Padding(
         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
        child: ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 15,);
          },
          itemBuilder: (context, index) {
            return shimmer(context: context, baseColor: notifier.shimmerbase2, height: 50,);
          },),
      ) : GetBuilder<PostbikeController>(
        builder: (postbikeCont) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (subcatID == "25" || subcatID == "26") ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textFeild(validMsg: "Please enter details".tr, textController: bikeBrand, textInputType: TextInputType.number, context: context, hinttext: "Brand *".tr, readStatus: true, onPressed1: () {
                                if(isOpened) return;
                                isOpened = true;
                                setState(() {});
                                bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.isEmpty ? Text("Not Found".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16),)
                                    : popUp(context: context, title: "Bikes", subtitle: "Brands".tr).then((value) {
                                        isOpened = false;
                                        setState(() {});
                                    },);
                              },),
                              const SizedBox(height: 15,),
                              textFeild(validMsg: "Please enter details".tr, textController: postbikeCont.year, textInputType: TextInputType.number, context: context, hinttext: "Year *".tr, onPressed2:(p0) {
                                if(int.parse(postbikeCont.year.text) > DateTime.now().year){
                                  postbikeCont.year.text = DateTime.now().year.toString();
                                }
                              }),
                              const SizedBox(height: 15,),
                              textFeild(validMsg: "Please enter details".tr, textController: postbikeCont.kmdriven, textInputType: TextInputType.number, context: context, hinttext: "KM driven *".tr,),
                            ],
                          ) : const SizedBox(),
                          subcatID == "28" ? textFeild(validMsg: "Please enter details".tr, textController: bikeBrand, textInputType: TextInputType.number, context: context, hinttext: "Brand *".tr, readStatus: true, onPressed1: () {
                            if(isOpened) return;
                            subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
                              popUp(context: context , title: "Bikes".tr, subtitle: "Brands".tr).then((value) {
                                isOpened = false;
                                setState(() {});
                              },);
                            },);
                          },) : const SizedBox(),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: postbikeCont.adTitle,
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
                                  borderSide: const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(16)
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
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: postbikeCont.description,
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
                                  borderSide: const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(16)
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
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    kIsWeb ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 15),
                      child: mainButton(context: context, txt1: "Next".tr, containcolor: PurpleColor, onPressed1: () {
                        if (_formKey.currentState!.validate()) {
                          Get.to(const AddImages(), transition: Transition.noTransition, arguments: {
                            "subcatId" : subcatID,
                            "adIndex" : adindex,
                            "postingType" : postingType,
                          });
                        }
                      },),
                    ) : const SizedBox(),
                    const SizedBox(height: kIsWeb ? 10 : 0,),
                    kIsWeb ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                      child: footer(context),
                    ) : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        }
      );
        },
      )
    );
  }
  Future popUp({context, required String title, required String subtitle}){
    return showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return StatefulBuilder(
                builder: (context, setState) {
                  return ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                      child: Transform.scale(
                        scale: a1.value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                          child: Dialog(
                            elevation: 0,
                            backgroundColor: notifier.getWhiteblackColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: brandStatus ? InkWell(
                                            onTap: () {
                                              setState((){
                                                brandStatus = false;
                                              });
                                            },
                                            child: Text("${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].title}  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),overflow: TextOverflow.ellipsis,)) : InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Text("$title  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),overflow: TextOverflow.ellipsis,)),
                                      ),
                                      Text(">  $subtitle", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: subcatID == "28" ? subcatTypeCont.subcatTypeData!.subtypelist!.length : brandStatus ? bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist!.length : bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return brandStatus ? InkWell(
                                            onTap: () {
                                              setState((){
                                                selectedModel = index;
                                                brandStatus = false;
                                                postbikeCont.brandId = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].id}";
                                                postbikeCont.modelId = "${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![selectedModel].id}";

                                                bikeBrand.text = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].title} / ${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![selectedModel].title}";
                                              });
                                              Get.back();
                                            },
                                            child: Container(
                                                height: 40,
                                                alignment: Alignment.centerLeft,
                                                child: Text("${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![index].title}",
                                                  style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
                                          ) : InkWell(
                                            onTap: () {
                                              if (subcatID == "28") {
                                                setState(() {
                                                  postbikeCont.brandId = "${subcatTypeCont.subcatTypeData!.subtypelist![index].id}";
                                                  bikeBrand.text = "${subcatTypeCont.subcatTypeData!.subtypelist![index].title}";
                                                });
                                                Get.back();
                                              } else {
                                                 bikeScoCvehicleCon.getModel(brandId: "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].id}").then((value){
                                                     if(value["Result"] == "true") {
                                                       setState((){
                                                         brandStatus = true;
                                                         selectedBrand = index;
                                                       });
                                                     } else {
                                                       showToastMessage(value["ResponseMsg"]);
                                                     }
                                                   });
                                              }
                                            },
                                            child: subcatID == "28" ? Container(
                                                height: 40,
                                                alignment: Alignment.centerLeft,
                                                child: Text("${subcatTypeCont.subcatTypeData!.subtypelist![index].title}",
                                                  style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),))
                                             : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                    height: 40,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].title}",
                                                      style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
                                                brandStatus ? const SizedBox() : Image.asset("assets/right.png", height: 20, color: notifier.getTextColor,)
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                        onTap: () {
                                          brandStatus = false;
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
