import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/postmobile_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class Addmobiles extends StatefulWidget {
  const Addmobiles({super.key});

  @override
  State<Addmobiles> createState() => _AddmobilesState();
}

class _AddmobilesState extends State<Addmobiles> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(postingType == "Edit"){
      adindex = Get.arguments["adIndex"];
      postmobileCont.mobileBrand = "22";
      postmobileCont.tabletBrand = myadlistCont.myadlistData!.myadList![adindex].tabletType ?? "";
      postmobileCont.accessoriesType = myadlistCont.myadlistData!.myadList![adindex].accessoriesType ?? "";
      postmobileCont.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle ?? "";
      postmobileCont.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription ?? "";
      print("<><><><><><><><><${postmobileCont.accessoriesType}>");
      subcatTypeCont.subcatType(subcatID: subcatID).then((value) {
        for(int i = 0; i < subcatTypeCont.subcatTypeData!.subtypelist!.length; i++){
            if(postmobileCont.mobileBrand == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
              setState(() {
                mobileBrand.text = subcatTypeCont.subcatTypeData!.subtypelist![i].title ?? "";
                adBrand = false;
              });
            } else if(postmobileCont.tabletBrand == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
              setState(() {
                tabletBrand.text = subcatTypeCont.subcatTypeData!.subtypelist![i].title ?? "";
                adBrand = false;
              });
            } else if(postmobileCont.accessoriesType == subcatTypeCont.subcatTypeData!.subtypelist![i].id){
              setState(() {
                postmobileCont.accessoriesType = subcatTypeCont.subcatTypeData!.subtypelist![i].title ?? "";
                print("<><>>>>>>>>>>>>>> ${postmobileCont.accessoriesType}>");
                if(postmobileCont.accessoriesType == "Mobile") {
                  type = 1;
                } else {
                  type = 2;
                }
                adBrand = false;
              });
            }
        }
      },);
    } else {
      postmobileCont.mobileBrand = "";
      postmobileCont.tabletBrand = "";
      postmobileCont.accessoriesType = "";
      postmobileCont.adTitle.text = "";
      postmobileCont.description.text = "";
      mobileBrand.text = "";
      tabletBrand.text = "";
      type = 0;
    }
  }

  PostmobileController postmobileCont = Get.find();
  CategoryListController subcatTypeCont = Get.find();
  MyadlistController myadlistCont = Get.find();

  String subcatID = Get.arguments["subcatId"];
  int adindex = 0;
  String postingType = Get.arguments["postingType"];

  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileBrand = TextEditingController();
  TextEditingController tabletBrand = TextEditingController();

  late ColorNotifire notifier;

  bool isOpened = false;
  bool adBrand = true;
  int type = 0;
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
      body: (adBrand && postingType == "Edit") ? Padding(
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subcatID == "7" ? textFeild(validMsg: "Please select mobile brand.".tr, textController: mobileBrand, textInputType: TextInputType.number, context: context, hinttext: "Brand *".tr, readStatus: true, onPressed1: () {
                    if(isOpened) return;

                    isOpened = true;
                    setState(() {});
                    popUp(context: context, title: "Mobile".tr, subtitle: "Type".tr).then((value) {
                      isOpened = false;
                      setState(() {});
                    },);
                  },)
                  : subcatID == "9" ? textFeild(validMsg: "Please enter details".tr, textController: tabletBrand, textInputType: TextInputType.number, context: context, hinttext: "Type *".tr, readStatus: true, onPressed1: () {
                    if(isOpened) return;

                    isOpened = true;
                    setState(() {});
                    popUp(context: context, title: "Mobile".tr, subtitle: "Type".tr).then((value) {
                      isOpened = false;
                      setState(() {});
                    },);
                  },) : SizedBox(),
                  subcatID == "8" ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,),
                       Text("Type *".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  type = 1;
                                  postmobileCont.accessoriesType = "${subcatTypeCont.subcatTypeData!.subtypelist![0].id}";
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:  type == 1 ? PurpleColor : lightGreyColor,
                                        width: 1
                                    ),
                                    color:  type == 1 ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
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
                                  type = 2;
                                  postmobileCont.accessoriesType = "${subcatTypeCont.subcatTypeData!.subtypelist![1].id}";
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:  type == 2 ? PurpleColor : lightGreyColor,
                                        width: 1
                                    ),
                                    color:  type == 2 ? Color(0xFFece3ff) : notifier.getWhiteblackColor,
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
                    ],
                  ) : SizedBox(),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: postmobileCont.adTitle,
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
                    controller: postmobileCont.description,
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
              ),
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
                              Flexible(
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: subcatTypeCont.subcatTypeData!.subtypelist!.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if(subcatID == "7"){
                                              mobileBrand.text = "${subcatTypeCont.subcatTypeData!.subtypelist![index].title}";
                                              postmobileCont.mobileBrand = "${subcatTypeCont.subcatTypeData!.subtypelist![index].id}";
                                            } else if(subcatID == "9"){
                                              postmobileCont.tabletBrand = "${subcatTypeCont.subcatTypeData!.subtypelist![index].id}";
                                              tabletBrand.text = "${subcatTypeCont.subcatTypeData!.subtypelist![index].title}";
                                            }
                                          });
                                          Get.back();
                                        },
                                        child: Container(
                                            height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: Text("${subcatTypeCont.subcatTypeData!.subtypelist![index].title}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
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
