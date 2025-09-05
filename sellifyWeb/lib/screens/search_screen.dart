import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/searpost_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/searchview_screen.dart';

import '../api_config/config.dart';
import '../controller/addfav_controller.dart';
import '../controller/login_controller.dart';
import '../controller/postview_controller.dart';
import '../helper/appbar_screen.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchpostCont.searchValue.text = "";
  }
  late ColorNotifire notifier;

  SearchpostController searchpostCont = Get.find();
  AddfavController addfavCont = Get.find();
  PostviewController postviewCont = Get.find();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          body: ScrollConfiguration(
            behavior: CustomBehavior(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    750 < constraints.maxWidth ? SizedBox(
                       height: 75,
                        child: CommonAppbar())
                        : const SizedBox(),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1150 < constraints.maxWidth ? 300 : 800 < constraints.maxWidth ? 150 : 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset("assets/arrowLeftIcon.png", height: 30, color: notifier.iconColor,),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: GetBuilder<SearchpostController>(
                                builder: (searchpostCont) {
                                  return SizedBox(
                                    height: 50,
                                    child: TextField(
                                      controller: searchpostCont.searchValue,
                                      style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),
                                      onChanged: (value) {
                                        setState(() {
                                          searchpostCont.getSearchPost().then((value) {
                                            setState(() {});
                                          },);
                                        });
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Image.asset("assets/searchIcon.png", scale: 2.8,),
                                          ),
                                          hintStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),
                                          hintText: "Search ".tr,
                                          filled: true,
                                          fillColor: notifier.textfield,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(35),
                                            borderSide: BorderSide(color: PurpleColor),
                                          ),
                                          enabledBorder:  OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(35),
                                            borderSide: BorderSide(color: notifier.borderColor, width: 2),
                                          )
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    (searchpostCont.searchpostData == null || searchpostCont.searchValue.text.isEmpty || searchpostCont.searchpostData!.searchlist!.isEmpty) ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 200,),
                        Image.asset("assets/emptyOrder.png", height: 200),
                        const SizedBox(height: kIsWeb ? 200 : 0,),
                        kIsWeb ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                          child: footer(context),
                        ) : const SizedBox(),
                      ],
                    )
                        : searchpostCont.isLoading ? Column(
                          children: [
                            Padding(
                             padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1150 < constraints.maxWidth ? 300 : 800 < constraints.maxWidth ? 150 : 20),
                              child: ListView.separated(
                                itemCount: 5,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: searchBorder),
                                        color: notifier.getWhiteblackColor
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120, width: 100),
                                        const SizedBox(width: 10,),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14),
                                              const SizedBox(height: 10,),
                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                              const SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                                  const SizedBox(width: 10,),
                                                  shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 70),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },),
                            ),
                            const SizedBox(height: kIsWeb ? 100 : 0,),
                            kIsWeb ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                              child: footer(context),
                            ) : const SizedBox(),
                            const SizedBox(height: kIsWeb ? 50 : 0,),
                          ],
                        )
                        : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1150 < constraints.maxWidth ? 300 : 800 < constraints.maxWidth ? 150 : 20),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: searchpostCont.searchpostData!.searchlist!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, screenTransDown(routes: SearchviewScreen(prodIndex: index), context: context));
                                        postviewCont.getPostview(postId: searchpostCont.searchpostData!.searchlist![index].postId ?? "").then((value) {
                                        },);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: searchBorder),
                                            color: notifier.getWhiteblackColor
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: SizedBox(
                                                height: 120,
                                                width: 100,
                                                child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Center(child: Image.asset("assets/emty.gif", fit: BoxFit.cover,height: 120,),);
                                                  },
                                                  image: Config.imageUrl + searchpostCont.searchpostData!.searchlist![index].postImage!,
                                                  placeholder:  "assets/ezgif.com-crop.gif",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      searchpostCont.searchpostData!.searchlist![index].isPaid == "0" ? const SizedBox() : Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.5),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        padding: const EdgeInsets.all(3),
                                                        child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: searchpostCont.searchpostData!.searchlist![index].isPaid == "0" ? 0 : 10,),
                                                  Text(searchpostCont.searchpostData!.searchlist![index].adPrice == "0" ? "$currency ${searchpostCont.searchpostData!.searchlist![index].jobSalaryFrom} - ${searchpostCont.searchpostData!.searchlist![index].jobSalaryTo} / ${searchpostCont.searchpostData!.searchlist![index].jobSalaryPeriod}" : "$currency${addCommas(searchpostCont.searchpostData!.searchlist![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: searchpostCont.searchpostData!.searchlist![index].catId == "4" ? 16 : 18, fontFamily: FontFamily.gilroyBold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                  const SizedBox(height: 10,),
                                                  Text("${searchpostCont.searchpostData!.searchlist![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                                                      Flexible(child: Text(getAddress(address: searchpostCont.searchpostData!.searchlist![index].fullAddress!), style: TextStyle(color: notifier.iconColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Image.asset("assets/postingdate.png", height: 16, color: notifier.iconColor),
                                                      Text(" ${searchpostCont.searchpostData!.searchlist![index].postDate.toString().split(" ").first}", style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
