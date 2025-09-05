import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/subcategory_screen.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/catwisepost_controller.dart';
import '../helper/appbar_screen.dart';
import '../utils/Colors.dart';
import 'catwisepost_list.dart';

class CategoryseeallScreen extends StatefulWidget {
  const CategoryseeallScreen({super.key});

  @override
  State<CategoryseeallScreen> createState() => _CategoryseeallScreenState();
}

class _CategoryseeallScreenState extends State<CategoryseeallScreen> {

  late ColorNotifire notifier;

  bool isNavigate = false;
  CategoryListController categoryListCont = Get.find();
  CatwisePostController catwisePostCont = Get.find();

  int? cathoverIndex;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: "Browse Categories".tr, fun: () {
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
            title: Text("Browse Categories".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
          ),
          body: ScrollConfiguration(
            behavior: CustomBehavior(),
            child: GetBuilder<CategoryListController>(
              builder: (categoryListCont) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        categoryListCont.isloading ? Padding(
                          padding: EdgeInsets.symmetric(vertical: kIsWeb ? 0 : 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 110,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return shimmer(context: context, baseColor: notifier.shimmerbase, height: 110, width: 50);
                            },),
                        )
                            : categoryListCont.categorylistData!.categorylist!.isEmpty ? Center(
                            child: Image.asset("assets/emptyOrder.png", height: 200))
                            : Padding(
                              padding: EdgeInsets.symmetric(vertical: kIsWeb ? 0 : 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  mainAxisExtent: 110,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: categoryListCont.categorylistData!.categorylist!.length,
                                itemBuilder: (context, index) {
                                  return MouseRegion(
                                    onEnter: (_) => setState(() => cathoverIndex = index),
                                    onExit: (_) => setState(() => cathoverIndex = null),
                                    child: InkWell(
                                      onTap: () {
                                        if(isNavigate) return;
                                        setState(() {
                                          isNavigate = true;
                                        });
                                        if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                          catwisePostCont.getCatwisePost(catId: categoryListCont.categorylistData!.categorylist![index].id ?? "", subcatId: categoryListCont.subcategoryData!.subcategorylist![index].id ?? "").then((value) {
                                            Navigator.push(context, screenTransRight(routes: CatwisepostList(subcatId: 0, catID: int.parse(categoryListCont.categorylistData!.categorylist![index].id!),), context: context)).then((value) {
                                              setState(() {
                                                isNavigate = false;
                                              });
                                            },);
                                          },);
                                        } else {
                                          categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id.toString()).then((value) {
                                            Get.to(SubcategoryScreen(
                                              route: Routes.homePage,
                                              title: categoryListCont.categorylistData!.categorylist![index].title ?? "",
                                              catId: categoryListCont.categorylistData!.categorylist![index].id.toString(),
                                            ), transition: Transition.noTransition)!.then((value) {
                                              setState(() {
                                                isNavigate = false;
                                              });
                                            },);
                                          },);
                                        }
                                      },
                                      child: Container(
                                        height: 115,
                                        width: 115,
                                        decoration: BoxDecoration(
                                          color: notifier.getWhiteblackColor,
                                            border: Border.all(color: cathoverIndex == index ? circleGrey : notifier.borderColor),
                                            borderRadius: BorderRadius.circular(25)
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FadeInImage.assetNetwork(
                                              height: 50,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return shimmer(baseColor: notifier.shimmerbase2, height: 50, context: context);
                                              },
                                              image: "${Config.imageUrl}${categoryListCont.categorylistData!.categorylist![index].img ?? ""}",
                                              placeholder:  "assets/ezgif.com-crop.gif",
                                            ),
                                            const SizedBox(height: 8,),
                                            Text("${categoryListCont.categorylistData!.categorylist![index].title}",
                                              style: TextStyle(fontSize: 12, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        kIsWeb ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
                          child: footer(context),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }
}
