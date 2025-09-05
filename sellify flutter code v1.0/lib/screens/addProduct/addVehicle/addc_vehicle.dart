import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/bikecvehiclecontoller.dart';
import 'package:sellify/controller/postad/postcvehicle_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class AddcVehicle extends StatefulWidget {
  const AddcVehicle({super.key});

  @override
  State<AddcVehicle> createState() => _AddcVehicleState();
}

class _AddcVehicleState extends State<AddcVehicle> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      if(postingType == "Edit"){
        adindex = Get.arguments["adIndex"];
        if (subcatID == "40") {
          postcvehicleCont.brandId = myadlistCont.myadlistData!.myadList![adindex].sparepartTypeId!;
        } else {
          postcvehicleCont.brandId = myadlistCont.myadlistData!.myadList![adindex].commercialBrandId!;
        }
        postcvehicleCont.modelId = myadlistCont.myadlistData!.myadList![adindex].commercialModelId!;
        postcvehicleCont.year.text = myadlistCont.myadlistData!.myadList![adindex].postYear!;
        postcvehicleCont.kmdriven.text = myadlistCont.myadlistData!.myadList![adindex].kmDriven!;
        postcvehicleCont.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle!;
        postcvehicleCont.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription!;

        if (int.parse(subcatID) == 40) {
          print(">>>>>>>>>>>>>> $subcatID");
          subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
            for(int i = 0; i < subcatTypeCont.subcatTypeData!.subtypelist!.length; i++) {
              if(postcvehicleCont.brandId == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
                setState(() {
                  type.text = "${subcatTypeCont.subcatTypeData!.subtypelist![i].title}";
                  adBrandModel = false;
                });
              }
            }
          },);
        } else {
          bikeScoCvehicleCon.getvehicle(subcatId: subcatID).then((value) {
            for(int i = 0; i < bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length; i++) {
              if(postcvehicleCont.brandId == bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].id){
                if (bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].modelCount != 0) {
                  bikeScoCvehicleCon.getModel(brandId: bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].id!).then((value) {
                    for(int j = 0; j < bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist!.length; j++) {
                      if(postcvehicleCont.modelId == bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![j].id){
                        setState(() {
                          type.text = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].title} / ${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![j].title}";
                          adBrandModel = false;
                        });
                      }
                    }
                   },
                  );
                } else {
                  setState(() {
                    type.text = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![i].title}";
                    adBrandModel = false;
                  });
                }
              }
            }
          },);
        }
      } else {
        postcvehicleCont.brandId = "";
        postcvehicleCont.modelId = "";
        postcvehicleCont.year.text = "";
        postcvehicleCont.kmdriven.text = "";
        postcvehicleCont.adTitle.text = "";
        postcvehicleCont.description.text = "";
      }
    });
  }

  late ColorNotifire notifier;

  MyadlistController myadlistCont = Get.find();
  PostcvehicleController postcvehicleCont = Get.find();
  CategoryListController subcatTypeCont = Get.find();
  BikescooterCvehicleContoller bikeScoCvehicleCon = Get.find();

  String subcatID = Get.arguments["subcatId"];
  String postingType = Get.arguments["postingType"];
  int adindex = 0;
  final _formKey = GlobalKey<FormState>();

  TextEditingController type = TextEditingController();

  int selectedBrand = 0;
  int selectedModel = 0;
  bool brandStatus = false;
  bool modelStatus = false;

  bool isOpened = false;
  bool adBrandModel = true;
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
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                textFeild(validMsg: "Please enter details".tr, textController: type, context: context, hinttext: "Type *".tr, readStatus: true, onPressed1: () {
                  if(isOpened) return;
                  
                  isOpened = true;
                  setState(() {});
                   subcatID == "40" ? subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
                     popUp(context: context, title: "Commercial Vehicles".tr, subtitle: "Type".tr).then((value) {
                       isOpened = false;
                       setState(() {});
                     },);
                   },) : popUp(context: context, title: "Commercial Vehicles".tr, subtitle: "Type".tr).then((value) {
                     isOpened = false;
                     setState(() {});
                   },);
                },),
                SizedBox(height: 15,),
                subcatID == "40" ? SizedBox() : Column(
                  children: [
                    textFeild(validMsg: "Please enter details".tr, textController: postcvehicleCont.year, textInputType: TextInputType.number, context: context, hinttext: "Year *".tr, onPressed2: (p0) {
                      if(int.parse(postcvehicleCont.year.text) > DateTime.now().year){
                        postcvehicleCont.year.text = DateTime.now().year.toString();
                      }
                    },),
                    SizedBox(height: 15,),
                    textFeild(validMsg: "Please enter details".tr, textController: postcvehicleCont.kmdriven, textInputType: TextInputType.number, context: context, hinttext: "KM driven *".tr,),
                    SizedBox(height: 15,),
                  ],
                ),
                TextFormField(
                  controller: postcvehicleCont.adTitle,
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
                  controller: postcvehicleCont.description,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future popUp({context, required String title, required String subtitle}){
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
                        backgroundColor: notifier.getWhiteblackColor,
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
                                  brandStatus ? SizedBox() : Text(">  $subtitle", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: subcatID == "40" ? subcatTypeCont.subcatTypeData!.subtypelist!.length : brandStatus ? bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist!.length : bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist!.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return brandStatus ? InkWell(
                                        onTap: () {
                                          setState((){
                                            selectedModel = index;
                                            brandStatus = false;
                                            postcvehicleCont.brandId = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].id}";
                                            postcvehicleCont.modelId = "${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![selectedModel].id}";
                                  
                                            type.text = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].title} / ${bikeScoCvehicleCon.vehiclemodel!.bikescootermodellist![selectedModel].title}";
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
                                          if (subcatID == "40") {
                                            setState(() {
                                              postcvehicleCont.brandId = "${subcatTypeCont.subcatTypeData!.subtypelist![index].id}";
                                              type.text = "${subcatTypeCont.subcatTypeData!.subtypelist![index].title}";
                                            });
                                            Get.back();
                                          } else {
                                            bikeScoCvehicleCon.getModel(brandId: "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].id}").then((value){
                                              if (bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].modelCount != 0) {
                                                if(value["Result"] == "true") {
                                                  setState((){
                                                    brandStatus = true;
                                                    selectedBrand = index;
                                                  });
                                                }
                                              } else {
                                                brandStatus = false;
                                                selectedBrand = index;
                                                postcvehicleCont.brandId = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].id}";
                                                type.text = "${bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![selectedBrand].title}";
                                                Get.back();
                                              }
                                            });
                                          }
                                        },
                                        child: subcatID == "40" ? Container(
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
                                            (brandStatus || bikeScoCvehicleCon.bikescootercvehicle!.bikescooterbrandlist![index].modelCount == 0 ) ? SizedBox() : Image.asset("assets/right.png", height: 20, color: notifier.getTextColor,)
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
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
    );
  }
}
