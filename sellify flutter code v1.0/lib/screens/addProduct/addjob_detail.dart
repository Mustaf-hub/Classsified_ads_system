import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/inboxcontroller.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class AddjobDetail extends StatefulWidget {
  const AddjobDetail({super.key});

  @override
  State<AddjobDetail> createState() => _AddjobDetailState();
}

class _AddjobDetailState extends State<AddjobDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(postingType == "Edit") {
      adindex = Get.arguments["adIndex"];

      postadController.salaryPeriod = myadlistCont.myadlistData!.myadList![adindex].jobSalaryPeriod ?? "";
      salaryPeriod.text = myadlistCont.myadlistData!.myadList![adindex].jobSalaryPeriod ?? "";
      postadController.salaryfrom.text = myadlistCont.myadlistData!.myadList![adindex].jobSalaryFrom ?? "";
      postadController.salaryto.text = myadlistCont.myadlistData!.myadList![adindex].jobSalaryTo ?? "";
      postadController.adTitle.text = myadlistCont.myadlistData!.myadList![adindex].postTitle ?? "";
      postadController.description.text = myadlistCont.myadlistData!.myadList![adindex].adDescription ?? "";
      postadController.position = myadlistCont.myadlistData!.myadList![adindex].jobPositionType;
      position.text = myadlistCont.myadlistData!.myadList![adindex].jobPositionType;
    } else {
      postadController.salaryPeriod = "";
      postadController.salaryfrom.text = "";
      postadController.salaryto.text = "";
      postadController.position = "";
      postadController.adTitle.text = "";
      postadController.description.text = "";
    }
  }

  bool adType = true;
  PostadController postadController = Get.find();
  CategoryListController subcatTypeCont = Get.find();
  MyadlistController myadlistCont = Get.find();

  String subcatID = Get.arguments["subcatId"];
  int adindex = 0;
  String postingType = Get.arguments["postingType"];

  InboxController inbox = InboxController();

  TextEditingController salaryPeriod = TextEditingController();
  TextEditingController position = TextEditingController();

  bool isOpened = false;
  late ColorNotifire notifier;
  final _formKey = GlobalKey<FormState>();
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
        child: mainButton(containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () {
          if (_formKey.currentState!.validate()) {
            Get.toNamed(Routes.addImages, arguments: {
              "subcatId" : subcatID,
              "price" : "0",
              "adIndex" : adindex,
              "postingType" : postingType,
            });
          }
        },),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                 children: [
                   textFeild(validMsg: "Please complete the required field, Salary period is mandatory".tr, textController: salaryPeriod, readStatus: true, hinttext: "Salary Period *".tr, context: context, onPressed1: () {
                     if(isOpened) return;

                     isOpened = true;
                     setState(() {});
                     periodpopUp(context: context,).then((value) {
                       isOpened = false;
                       setState(() {});
                     },);
                   },),
                   SizedBox(height: 15,),
                   textFeild(validMsg: "Please complete the required field, Position type is mandatory".tr, textController: position, readStatus: true, hinttext: "Position type *".tr, context: context, onPressed1: () {
                     if(isOpened) return;

                     isOpened = true;
                     setState(() {});
                     positionpopUp(context: context).then((value) {
                       isOpened = false;
                       setState(() {});
                     },);
                   },),
                   SizedBox(height: 15,),
                   textFeild(textController: postadController.salaryfrom, textInputType: TextInputType.number, hinttext: "Salary from".tr, context: context,),
                   SizedBox(height: 15,),
                   textFeild(textController: postadController.salaryto, textInputType: TextInputType.number, hinttext: "Salary to".tr, context: context,),
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
              )),
      ),
    );
  }
  Future periodpopUp({context,}){
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
                                            child: Text("${"Job".tr}  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),)),
                                      ),
                                      Text(">  ${"Salary Period".tr}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: inbox.salaryPeriod.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState((){
                                            postadController.salaryPeriod = inbox.salaryPeriodData[index];
                                            salaryPeriod.text = inbox.salaryPeriod[index];
                                          });
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: Text(inbox.salaryPeriod[index], style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
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

  Future positionpopUp({context,}){
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
                                            child: Text("${"Job".tr}  ", style: TextStyle(color: GreyColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),)),
                                      ),
                                      Text(">  ${"Position Type".tr}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium,),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: inbox.positionType.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState((){
                                            postadController.position = inbox.positionTypeData[index];
                                            position.text = inbox.positionType[index];
                                          });
                                          Get.back();
                                        },
                                        child: Container(
                                            height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: Text(inbox.positionType[index], style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 16,),)),
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
