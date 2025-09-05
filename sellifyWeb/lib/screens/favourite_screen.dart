import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/addfav_controller.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/controller/myfav_controller.dart';
import 'package:sellify/controller/postview_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/screens/favourite_view.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/msg_otp_controller.dart';
import '../helper/appbar_screen.dart';
import '../utils/admob.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  MyfavController myfavCont = Get.find();
  late ColorNotifire notifier;
  AddfavController addfavCont = Get.find();
  PostviewController postviewCont = Get.find();

  bool removed = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(!kIsWeb){
      BannerAd(
          size: AdSize.banner,
          adUnitId: AdHelper.bannerAdUnitId,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                bannerAd = ad as BannerAd?;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
          request: const AdRequest()
      ).load();
    }
  }

  BannerAd? bannerAd;
  MsgOtpController smsTypeCont = Get.find();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: notifier.getBgColor,
            appBar: kIsWeb ? PreferredSize(
                preferredSize: const Size.fromHeight(125),
                child: CommonAppbar(title: "My Favourites".tr, fun: () {
                  Get.back();
                },)) : AppBar(
              elevation: 0,
              backgroundColor: notifier.getWhiteblackColor,
              automaticallyImplyLeading: false,
              leading: kIsWeb ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
                ),
              ) : const SizedBox(),
              title: Text("My Favourites".tr, style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
              centerTitle: true,
            ),
            body: ScrollConfiguration(
              behavior: CustomBehavior(),
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 2),
                        () {
                      myfavCont.getMyFav();
                    },
                  );
                },
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return GetBuilder<MyfavController>(
                        builder: (myfavCont) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                myfavCont.isloading ? Padding(
                                  padding: EdgeInsets.only(left: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 20, right: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 20, bottom: kIsWeb ? 0 : 110),
                                  child: ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 5,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: notifier.borderColor),
                                            color: notifier.getWhiteblackColor,
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
                                )
                                    : myfavCont.myfavData == null ? Center(
                                       child: Image.asset("assets/emptyOrder.png", height: 200))
                                    : myfavCont.myfavData!.myadList!.isEmpty ? Center(
                                    child: Image.asset("assets/emptyOrder.png", height: 200))
                                    : Padding(
                                      padding: EdgeInsets.only(left: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20, right: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20, top: 750 < constraints.maxWidth ? 0 : 20, bottom: kIsWeb ? 0 : 110),
                                      child: Column(
                                        children: [
                                          (smsTypeCont.smstypeData != null && smsTypeCont.smstypeData!.admobEnabled == "Yes") ? (bannerAd != null ? SizedBox(
                                              height: bannerAd!.size.height.toDouble(),
                                              width: bannerAd!.size.width.toDouble(),
                                              child: AdWidget(ad: bannerAd!)
                                          ) : const SizedBox()) : const SizedBox(),
                                          SizedBox(height: smsTypeCont.smstypeData != null && smsTypeCont.smstypeData!.admobEnabled == "Yes" && bannerAd != null ? 10 : 0,),
                                          ListView.separated(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemCount: myfavCont.myfavData!.myadList!.length,
                                            separatorBuilder: (context, index) => const SizedBox(height: 14,),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(const FavouriteView(), arguments: {"productindex" : index,});
                                                  postviewCont.getPostview(postId: myfavCont.myfavData!.myadList![index].postId ?? "");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: notifier.borderColor),
                                                    color: notifier.getWhiteblackColor,
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
                                                              return shimmer(baseColor: notifier.shimmerbase2, height: 120, context: context);
                                                            },
                                                            image: Config.imageUrl + myfavCont.myfavData!.myadList![index].postImage!,
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
                                                                myfavCont.myfavData!.myadList![index].isPaid == "0" ? const SizedBox() : Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.black.withOpacity(0.5),
                                                                      borderRadius: BorderRadius.circular(5)
                                                                  ),
                                                                  padding: const EdgeInsets.all(3),
                                                                  child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                                ),
                                                               StatefulBuilder(
                                                                 builder: (context, setState) {
                                                                   return InkWell(
                                                                          onTap: () {
                                                                        setState((){
                                                                          unFavBottomSheet(
                                                                            context: context,
                                                                            description: myfavCont.myfavData!.myadList![index].adDescription ?? "",
                                                                            title: myfavCont.myfavData!.myadList![index].postTitle ?? "",
                                                                            image: "${Config.imageUrl}${myfavCont.myfavData!.myadList![index].postImage}",
                                                                            price: "$currency${addCommas(myfavCont.myfavData!.myadList![index].adPrice!)}",
                                                                            removeFun: () {
                                                                              setState(() {
                                                                                addfavCont.addFav(postId: myfavCont.myfavData!.myadList![index].postId!).then((value) {
                                                                                  myfavCont.getMyFav();
                                                                                },);
                                                                              });
                                                                              Get.back();
                                                                            },
                                                                          );
                                                                      });
                                                                      },
                                                                     child: Image.asset("assets/heartdark.png", height: 20, color: Colors.red.shade300,));
                                                                 }
                                                               )
                                                              ],
                                                            ),
                                                            SizedBox(height: myfavCont.myfavData!.myadList![index].isPaid == "0" ? 0 : 10,),
                                                            Text(myfavCont.myfavData!.myadList![index].adPrice == "0" ? "$currency ${myfavCont.myfavData!.myadList![index].jobSalaryFrom} - ${myfavCont.myfavData!.myadList![index].jobSalaryTo} / ${myfavCont.myfavData!.myadList![index].jobSalaryPeriod}" : "$currency${addCommas(myfavCont.myfavData!.myadList![index].adPrice!)}", style: TextStyle(color: notifier.getTextColor, fontSize: myfavCont.myfavData!.myadList![index].catId == "4" ? 16 : 18, fontFamily: FontFamily.gilroyBold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                            const SizedBox(height: 10,),
                                                            Text("${myfavCont.myfavData!.myadList![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                            const SizedBox(height: 10,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset("assets/location-pin.png", height: 16, color: notifier.iconColor),
                                                                      Flexible(child: Text(getAddress(address: myfavCont.myfavData!.myadList![index].fullAddress!), style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 10,),
                                                                Text("${myfavCont.myfavData!.myadList![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },),
                                        ],
                                      ),
                                    ),
                                kIsWeb ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
                                  child: footer(context),
                                ) : const SizedBox(),
                              ],
                            ),
                          );
                        }
                    );
                  }
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Future popup(){
    return showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(color: PurpleColor,),
      );
    },
    );
  }
}
