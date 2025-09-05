 import 'package:flutter/foundation.dart';
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
import 'package:sellify/screens/addProduct/adcommonpost.dart';
import 'package:sellify/screens/addProduct/addVehicle/addbikes.dart';
import 'package:sellify/screens/addProduct/addVehicle/addc_vehicle.dart';
import 'package:sellify/screens/addProduct/addjob_detail.dart';
import 'package:sellify/screens/addProduct/addmobiles.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/addProduct/addproperties.dart';
import 'package:sellify/screens/addProduct/addservices.dart';
import 'package:sellify/screens/catwisepost_list.dart';
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/subcategory_screen.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../helper/appbar_screen.dart';

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

  List<Widget> addproductRoute = [
    const Chooselocation(),
    const Addproperties(),
    const Addmobiles(),
    const AddjobDetail(),
    const Addbikes(),
    const Adcommonpost(),
    const AddcVehicle(),
    const Adcommonpost(),
    const Addservices()
  ];

  Future getclose() async {
    for(int i = 0;i < expanded.length; i++){
      if(expanded[i] == true){
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
      appBar: kIsWeb ? PreferredSize(
          preferredSize: const Size.fromHeight(125),
          child: CommonAppbar(title: "Choose Category".tr, fun: () {
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
        title: Text("Choose Category".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GetBuilder<CategoryListController>(
            builder: (categoryListCont) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 55,
                      //   child: TextField(
                      //     readOnly: true,
                      //     onTap: () {
                      //       Navigator.push(context, screenTransDown(routes: const SearchScreen(), context: context));
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
                      const SizedBox(height: kIsWeb ? 5 : 0,),
                      categoryListCont.isloading ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                        child: ListView.separated(
                          itemCount: 12,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10,);
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
                          : (categoryListCont.categorylistData == null || categoryListCont.categorylistData!.categorylist!.isEmpty) ? Center(
                          child: Image.asset("assets/emptyOrder.png", height: 200))
                          : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                            child: ListView.separated(
                              itemCount: categoryListCont.categorylistData!.categorylist!.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 20,);
                              },
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (widget.route == Routes.addproductScreen) {
                                      setState(() {
                                        isPaid = categoryListCont.categorylistData!.categorylist![index].isPaid!;
                                      });
                                        if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                          if (index == 7 || index == 8 || index == 9 || index == 10) {
                                            Get.to(addproductRoute[7], transition: Transition.noTransition);
                                          } else if(index == 0){
                                            postadController.catId = categoryListCont.categorylistData!.categorylist![index].id.toString();
                                            postadController.subcatId = "0";
                                            Get.to(const Chooselocation(), arguments: {
                                              "route" : Routes.addproductScreen,
                                            }, transition: Transition.noTransition);
                                          } else {
                                            Get.to(addproductRoute[index], transition: Transition.noTransition);
                                          }
                                        } else {
                                          Get.to(
                                              SubcategoryScreen(
                                            route: Routes.addproductScreen,
                                            title: categoryListCont.categorylistData!.categorylist![index].title ?? "",
                                            catId: categoryListCont.categorylistData!.categorylist![index].id.toString(),
                                          ), transition: Transition.noTransition);
                                          setState(() {
                                            propertiesCont.catId = categoryListCont.categorylistData!.categorylist![index].id.toString();
                                          });
                                        }
                                      categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id!);
                                    } else {

                                      if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                        catwisePostCont.getCatwisePost(catId: categoryListCont.categorylistData!.categorylist![index].id ?? "", subcatId: categoryListCont.subcategoryData!.subcategorylist![index].id ?? "");
                                         Get.to(screenTransRight(routes: CatwisepostList(subcatId: 0, catID: int.parse(categoryListCont.categorylistData!.categorylist![index].id!,),), context: context), transition: Transition.noTransition);
                                      } else {
                                        categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id.toString()).then((value) {
                                          setState(() {
                                            selectedIndex = index;
                                            // expanded[index] = !expanded[index];
                                            if(expanded[index] == false){
                                              // for(int i = 0; i < expanded.length; i++){
                                              getclose().then((value) {
                                              },);
                                              expanded[index] = true;
                                            } else {
                                              expanded[index] = false;
                                            }
                                          });
                                        },);
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: notifier.getWhiteblackColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(30))
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
                                                const SizedBox(width: 20,),
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
                          ),
                      const SizedBox(height: kIsWeb ? 10 : 0,),
                      kIsWeb ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                        child: footer(context),
                      ) : const SizedBox(),
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}
