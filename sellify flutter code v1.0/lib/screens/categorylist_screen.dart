 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/catwisepost_controller.dart';
import 'package:sellify/controller/filter_controller/filters_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/catwisepost_list.dart';
import 'package:sellify/screens/search_screen.dart';
import 'package:sellify/screens/subcategory_screen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/filter_update.dart';

class CategorylistScreen extends StatefulWidget {
  final String route;
  const CategorylistScreen({super.key, required this.route});

  @override
  State<CategorylistScreen> createState() => _CategorylistScreenState();
}

class _CategorylistScreenState extends State<CategorylistScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      if(categoryListCont.categorylistData!.categorylist!.isNotEmpty){
        for(int i = 0; i < categoryListCont.categorylistData!.categorylist!.length; i++) {
          expanded.add(false);
        }
      }

  }

  late ColorNotifire notifier;

  CategoryListController categoryListCont = Get.find();
  PropertiesController propertiesCont = Get.find();
  PostadController postadController = Get.find();
  CatwisePostController catwisePostCont = Get.find();
  FiltersController filtersCont = Get.find();

  List<bool> expanded = [];
  int selectedIndex = 0;

  List addproductRoute = [
    Routes.addlocationScreen,
    Routes.addproperties,
    Routes.addmobiles,
    Routes.addjobDetail,
    Routes.addbikes,
    Routes.adcommonpost,
    Routes.addcVehicle,
    Routes.adcommonpost,
    Routes.addservices
  ];

  Future getclose() async {
    for(int i = 0;i < expanded.length; i++){
      if(expanded[i] == true){
        print("Expanded OR NOT INDEX ${i}");
        setState(() {
          expanded[i] = false;
        });
      }
    }
  }

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
        title: Text("Choose Category".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      body: GetBuilder<CategoryListController>(
        builder: (categoryListCont) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 55,
                  //   child: TextField(
                  //     readOnly: true,
                  //     onTap: () {
                  //       Navigator.push(context, ScreenTransDown(routes: const SearchScreen(), context: context));
                  //     },
                  //     style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),
                  //     decoration: InputDecoration(
                  //         prefixIcon: Padding(
                  //           padding: const EdgeInsets.only(left: 8),
                  //           child: Image.asset("assets/searchIcon.png", scale: 2.8,),
                  //         ),
                  //         hintStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),
                  //         hintText: "Search ".tr,
                  //         filled: true,
                  //         fillColor: notifier.textfield,
                  //         focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(35),
                  //           borderSide: BorderSide(color: notifier.borderColor),
                  //         ),
                  //         enabledBorder:  OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(35),
                  //           borderSide: BorderSide(color: notifier.borderColor, width: 2),
                  //         ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  categoryListCont.isloading ? Expanded(
                    child: ListView.separated(
                      itemCount: 12,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10,);
                      },
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            iconColor: notifier.borderColor,
                            tilePadding: const EdgeInsets.only(right: 10),
                            leading: shimmer(context: context, baseColor: notifier.shimmerbase2, height: 40, width: 50),
                            title: shimmer(context: context, baseColor: notifier.shimmerbase2, height: 25,),
                          );
                    }, ),
                  )
                      : Expanded(
                         child: ListView.separated(
                           itemCount: categoryListCont.categorylistData!.categorylist!.length,
                           shrinkWrap: true,
                           padding: EdgeInsets.zero,
                           scrollDirection: Axis.vertical,
                           separatorBuilder: (context, index) {
                             return SizedBox(height: 20,);
                           },
                           itemBuilder: (context, index) {
                             return InkWell(
                               onTap: () {
                                 print("ASDASD ${widget.route}");
                                 if (widget.route == Routes.addproductScreen) {
                                   setState(() {
                                     isPaid = categoryListCont.categorylistData!.categorylist![index].isPaid!;
                                   });
                                     if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                       if (index == 7 || index == 8 || index == 9 || index == 10) {
                                         Get.toNamed(addproductRoute[7]);
                                       } else if(index == 0){
                                         postadController.catId = categoryListCont.categorylistData!.categorylist![index].id.toString();
                                         postadController.subcatId = "0";
                                         Get.toNamed(Routes.chooseLocation, arguments: {
                                           "route" : Routes.addproductScreen,
                                         });
                                       } else {
                                         Get.toNamed(addproductRoute[index]);
                                       }
                                     } else {
                                       Get.to(
                                           SubcategoryScreen(
                                         route: Routes.addproductScreen,
                                         title: categoryListCont.categorylistData!.categorylist![index].title ?? "",
                                         catId: categoryListCont.categorylistData!.categorylist![index].id.toString(),
                                       ));
                                       setState(() {
                                         propertiesCont.catId = categoryListCont.categorylistData!.categorylist![index].id.toString();
                                       });
                                     }
                                   categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id!);
                                 } else {

                                   if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                       Navigator.push(context, ScreenTransRight(routes: CatwisepostList(subcatId: 0, catID: int.parse(categoryListCont.categorylistData!.categorylist![index].id!,),), context: context));
                                     catwisePostCont.getCatwisePost(catId: categoryListCont.categorylistData!.categorylist![index].id ?? "", subcatId: categoryListCont.subcategoryData!.subcategorylist![index].id ?? "");
                                   } else {
                                     categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id.toString()).then((value) {
                                       print("ISLOADING OR NOT  ${categoryListCont.isloading}");
                                       setState(() {
                                         selectedIndex = index;
                                         // expanded[index] = !expanded[index];
                                         print("Expanded INDEX >>>>>> ${expanded[index]}");
                                         if(expanded[index] == false){
                                           // for(int i = 0; i < expanded.length; i++){
                                           getclose().then((value) {
                                             print("Expanded INDEX ${index}");
                                           },);
                                           expanded[index] = true;
                                         } else {
                                           expanded[index] = false;
                                         }
                                       });
                                       print("Expanded OR NOT >> ${expanded[index]}$index");
                                     },);
                                   }
                                 }
                               },
                               child: Container(
                                 padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                                 decoration: BoxDecoration(
                                   color: notifier.getWhiteblackColor,
                                   borderRadius: BorderRadius.all(Radius.circular(30))
                                 ),
                                 child: Column(
                                   children: [
                                     Row(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Row(
                                           children: [
                                             FadeInImage.assetNetwork(
                                               height: 40,
                                               fit: BoxFit.cover,
                                               imageErrorBuilder: (context, error, stackTrace) {
                                                 return shimmer(baseColor: notifier.shimmerbase2, height: 40, context: context);
                                               },
                                               image: "${Config.imageUrl}${categoryListCont.categorylistData!.categorylist![index].img ?? ""}",
                                               placeholder:  "assets/ezgif.com-crop.gif",
                                             ),
                                             SizedBox(width: 20,),
                                             Text("${categoryListCont.categorylistData!.categorylist![index].title}",
                                               style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),
                                               maxLines: 2,
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                           ],
                                         ),
                                         (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0 || widget.route == Routes.addproductScreen)
                                             ? Image.asset("assets/right.png", height: 20, color: notifier.iconColor,) : expanded[index]
                                             ? Image.asset("assets/angle-up.png", height: 20, color: notifier.iconColor,) : Image.asset("assets/angle-down.png", height: 20, color: notifier.borderColor,),
                                       ],
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
