import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/catgorylist_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/addProduct/reviewyourdetail.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/screens/categorylist_screen.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../home_screen.dart';
import '../subcategory_screen.dart';

int isPaid = 0;

class AddproductScreen extends StatefulWidget {
  const AddproductScreen({super.key});

  @override
  State<AddproductScreen> createState() => _AddproductScreenState();
}

class _AddproductScreenState extends State<AddproductScreen> {

 CategoryListController categoryListCont = Get.find();
 PostadController postadController = Get.find();
 PropertiesController propertiesCont = Get.find();

  List categories = [
    "Cars",
    "Properties",
    "Mobiles",
    "Jobs",
    "Bikes",
    "More Categories"
  ];

  late ColorNotifire notifier;

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
              Get.offAll(kIsWeb ? HomePage() : const BottombarScreen());
            },
            child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
          ),
        ),
        title: Text("Add Ads".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      body: GetBuilder<CategoryListController>(
        builder: (categoryListCont) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: categoryListCont.isloading ? GridView.builder(
                itemCount: 8,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 120,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2
                ),
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: backGrey),
                        color: notifier.getWhiteblackColor
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 70, width: 70),
                        SizedBox(height: 8,),
                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 12, width: 100),
                      ],
                    ),
                  );
                },)
                 : categoryListCont.categorylistData!.categorylist!.isEmpty ? Center(
                  child: Image.asset("assets/emptyOrder.png", height: 200))
                  : GridView.builder(
                itemCount: 10,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 120,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {

                        if (categoryListCont.categorylistData!.categorylist![index].subcatCount == 0) {
                          isPaid = categoryListCont.categorylistData!.categorylist![index].isPaid!;

                          // isPaid = categoryListCont.categorylistData!.categorylist![index].isPaid!;
                           if(index == 0) {
                             postadController.catId = "${categoryListCont.categorylistData!.categorylist![index].id}";
                             postadController.subcatId = "0";

                             Get.toNamed(Routes.chooseLocation, arguments: {
                               "route" : Routes.addproductScreen,
                             });

                           } else {
                             Get.toNamed(addproductRoute[index]);
                           }
                        } else if(index == 9){
                          Navigator.push(context, ScreenTransDown(routes: CategorylistScreen(route: Routes.addproductScreen), context: context));
                        } else {
                          isPaid = categoryListCont.categorylistData!.categorylist![index].isPaid!;
                          categoryListCont.subIsloading = true;
                            Get.to(SubcategoryScreen(
                              route: Routes.addproductScreen,
                              title: categoryListCont.categorylistData!.categorylist![index].title ?? "",
                              catId: categoryListCont.categorylistData!.categorylist![index].id.toString(),
                            ));
                          categoryListCont.subCategory(catId: categoryListCont.categorylistData!.categorylist![index].id!);
                        }
                        });
                        print(">>>>>>>>>>>> ${categoryListCont.categorylistData!.categorylist![index].id}");
                        print("isPaid >>>>>>>>>>>>>>> ${categoryListCont.categorylistData!.categorylist![index].isPaid}");
                        print("isPaid >>>>>>>>>>>>>>> ${isPaid}");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: notifier.borderColor),
                          color: notifier.getWhiteblackColor
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            index == 9 ? SvgPicture.asset("assets/more.svg", height: 45, color: PurpleColor,) : FadeInImage.assetNetwork(
                              height: 45,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return shimmer(context: context, baseColor: notifier.shimmerbase2, height: 45,);
                              },
                              image: "${Config.imageUrl}${categoryListCont.categorylistData!.categorylist![index].img ?? ""}",
                              placeholder:  "assets/ezgif.com-crop.gif",
                            ),
                            SizedBox(height: 8,),
                            Flexible(
                              child: Text(index == 9 ? "More Categories".tr : "${categoryListCont.categorylistData!.categorylist![index].title}",
                                style: TextStyle(fontSize: 12, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },),
            ),
          );
        }
      ),
    );
  }
}
