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
        title: Text("Browse Categories".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: GetBuilder<CategoryListController>(
          builder: (categoryListCont) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: categoryListCont.isloading ? GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 110,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return shimmer(context: context, baseColor: notifier.shimmerbase, height: 110, width: 50);
                  },)
                    : categoryListCont.categorylistData!.categorylist!.isEmpty ? Center(
                    child: Image.asset("assets/emptyOrder.png", height: 200))
                    : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          mainAxisExtent: 110,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: categoryListCont.categorylistData!.categorylist!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if(isNavigate) return;
                              setState(() {
                                isNavigate = true;
                              });
                              if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                                catwisePostCont.getCatwisePost(catId: categoryListCont.categorylistData!.categorylist![index].id ?? "", subcatId: categoryListCont.subcategoryData!.subcategorylist![index].id ?? "").then((value) {
                                  Navigator.push(context, ScreenTransRight(routes: CatwisepostList(subcatId: 0, catID: int.parse(categoryListCont.categorylistData!.categorylist![index].id!),), context: context)).then((value) {
                                    setState(() {
                                      isNavigate = false;
                                    });
                                  },);
                                },);
                              } else {
                                categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id.toString()).then((value) {
                                  Navigator.push(context, ScreenTransDown(routes: SubcategoryScreen(
                                    route: Routes.homePage,
                                    title: categoryListCont.categorylistData!.categorylist![index].title ?? "",
                                    catId: categoryListCont.categorylistData!.categorylist![index].id.toString(),
                                  ), context: context)).then((value) {
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
                                  border: Border.all(color: notifier.borderColor),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              padding: EdgeInsets.all(5),
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
                                  SizedBox(height: 8,),
                                  Text("${categoryListCont.categorylistData!.categorylist![index].title}",
                                    style: TextStyle(fontSize: 12, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
