import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/filter_controller/filters_controller.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/screens/filterpost_screen.dart';

import '../api_config/config.dart';
import '../controller/addfav_controller.dart';
import '../helper/c_widget.dart';
import '../helper/font_family.dart';
import '../utils/Colors.dart';
import '../utils/dark_lightMode.dart';

class FilterpostList extends StatefulWidget {
  const FilterpostList({super.key});

  @override
  State<FilterpostList> createState() => _FilterpostListState();
}

class _FilterpostListState extends State<FilterpostList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i < filtersCont.filterData!.filter!.length; i++){
      setState(() {
        isFav.add(false);
      });
    }
  }

  List<bool> isFav = [];

  late ColorNotifire notifier;

  FiltersController filtersCont = Get.find();
  AddfavController addfavCont = Get.find();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: backGreyColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getBgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Browse Categories", style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
        centerTitle: true,
      ),
      body: StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: filtersCont.filterData!.filter!.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      filtersCont.isloading ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
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
                        },)
                          : filtersCont.filterData!.filter!.isNotEmpty ? ListView.builder(
                             physics: const NeverScrollableScrollPhysics(),
                             shrinkWrap: true,
                             padding: EdgeInsets.zero,
                             scrollDirection: Axis.vertical,
                             itemCount: filtersCont.filterData!.filter!.length,
                             itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, screenTransDown(routes: FilterpostScreen(prodIndex: index,), context: context)).then((value) {
                                  setState(() {
                                    isFav[index] = value["isFav"];
                                  });
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
                                          image: Config.imageUrl + filtersCont.filterData!.filter![index].postImage!,
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
                                              filtersCont.filterData!.filter![index].isPaid == "0" ? const SizedBox() : Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                padding: const EdgeInsets.all(3),
                                                child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if(isFav[index] == false){
                                                    addfavCont.addFav(postId: filtersCont.filterData!.filter![index].postId!).then((value) {
                                                      setState((){
                                                        isFav[index] = true;
                                                      });
                                                    },);
                                                  } else {
                                                    unFavBottomSheet(
                                                      context: context,
                                                      description: filtersCont.filterData!.filter![index].adDescription ?? "",
                                                      title: filtersCont.filterData!.filter![index].postTitle ?? "",
                                                      image: "${Config.imageUrl}${filtersCont.filterData!.filter![index].postImage}",
                                                      price: "$currency${addCommas(filtersCont.filterData!.filter![index].adPrice!)}",
                                                      // price: "${filtersCont.filterData!.currency}${filtersCont.filterData!.filter![index].adPrice}",
                                                      removeFun: () {
                                                        setState(() {
                                                          addfavCont.addFav(postId: filtersCont.filterData!.filter![index].postId!).then((value) {
                                                            setState((){
                                                              isFav[index] = false;
                                                            });
                                                          },);
                                                        });
                                                        Get.back();
                                                      },
                                                    );
                                                  }
                                                },
                                                child: isFav[index] ? Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,)
                                                    : Image.asset("assets/heart.png", height: 20,),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: filtersCont.filterData!.filter![index].isPaid == "0" ? 0 : 10,),
                                          Text("${filtersCont.filterData!.filter![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 18, fontFamily: FontFamily.gilroyBold),),
                                          const SizedBox(height: 10,),
                                          Text("${filtersCont.filterData!.filter![index].adDescription}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child: Text("${filtersCont.filterData!.filter![index].fullAddress}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                              const SizedBox(width: 10,),
                                              Text("${filtersCont.filterData!.filter![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },)
                          : Center(
                          child: Image.asset("assets/emptyOrder.png", height: 200)),
                    ],
                  ),
                )
            );
          }
      ),
    );
  }
}
