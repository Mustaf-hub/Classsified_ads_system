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
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../controller/msg_otp_controller.dart';
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
            print("AD failed to load ${error.message}");
            ad.dispose();
          },
        ),
        request: AdRequest()
    ).load();
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
      child: Scaffold(
        backgroundColor: notifier.getBgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: notifier.getWhiteblackColor,
          automaticallyImplyLeading: false,
          title: Text("My Favourites".tr, style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
          centerTitle: true,
        ),
        body: ScrollConfiguration(
          behavior: CustomBehavior(),
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 2),
                    () {
                  myfavCont.getMyFav();
                },
              );
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return GetBuilder<MyfavController>(
                    builder: (myfavCont) {
                      return SafeArea(
                          child: myfavCont.isloading ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 110),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(height: 14,),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: notifier.borderColor),
                                        color: notifier.getWhiteblackColor,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        shimmer(context: context, baseColor: notifier.shimmerbase2, height: 120, width: 100),
                                        SizedBox(width: 10,),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14),
                                              SizedBox(height: 10,),
                                              shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  shimmer(context: context, baseColor: notifier.shimmerbase2, height: 14, width: 100),
                                                  SizedBox(width: 10,),
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
                          )
                              : myfavCont.myfavData == null ? Center(
                                 child: Image.asset("assets/emptyOrder.png", height: 200))
                              : myfavCont.myfavData!.myadList!.isEmpty ? Center(
                              child: Image.asset("assets/emptyOrder.png", height: 200))
                              : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 110),
                              child: Column(
                                children: [
                                  (smsTypeCont.smstypeData != null && smsTypeCont.smstypeData!.admobEnabled == "Yes") ? (bannerAd != null ? SizedBox(
                                      height: bannerAd!.size.height.toDouble(),
                                      width: bannerAd!.size.width.toDouble(),
                                      child: AdWidget(ad: bannerAd!)
                                  ) : SizedBox()) : SizedBox(),
                                  SizedBox(height: smsTypeCont.smstypeData != null && smsTypeCont.smstypeData!.admobEnabled == "Yes" && bannerAd != null ? 10 : 0,),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount: myfavCont.myfavData!.myadList!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 14),
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.favouriteView, arguments: {"productindex" : index,});
                                            postviewCont.getPostview(postId: myfavCont.myfavData!.myadList![index].postId ?? "");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: notifier.borderColor),
                                              color: notifier.getWhiteblackColor,
                                            ),
                                            padding: EdgeInsets.all(10),
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
                                                SizedBox(width: 10,),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          myfavCont.myfavData!.myadList![index].isPaid == "0" ? SizedBox() : Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.5),
                                                                borderRadius: BorderRadius.circular(5)
                                                            ),
                                                            padding: EdgeInsets.all(3),
                                                            child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 12, color: WhiteColor),),
                                                          ),
                                                         StatefulBuilder(
                                                           builder: (context, setState) {
                                                             return GestureDetector(
                                                                    onTap: () {
                                                                  setState((){
                                                                    unFavBottomSheet(
                                                                      context: context,
                                                                      description: myfavCont.myfavData!.myadList![index].adDescription ?? "",
                                                                      title: myfavCont.myfavData!.myadList![index].postTitle ?? "",
                                                                      image: "${Config.imageUrl}${myfavCont.myfavData!.myadList![index].postImage}" ?? "",
                                                                      price: "$currency${addCommas(myfavCont.myfavData!.myadList![index].adPrice!)}" ?? "",
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
                                                      SizedBox(height: 10,),
                                                      Text("${myfavCont.myfavData!.myadList![index].postTitle}", style: TextStyle(color: notifier.getTextColor, fontSize: 16, fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Flexible(child: Text("${myfavCont.myfavData!.myadList![index].fullAddress}", style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                          SizedBox(width: 10,),
                                                          Text("${myfavCont.myfavData!.myadList![index].postDate}".toString().split(" ").first, style: TextStyle(color: notifier.getTextColor, fontSize: 14, fontFamily: FontFamily.gilroyMedium),overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                                    },),
                                ],
                              ),
                            ),
                          )
                      );
                    }
                );
              }
            ),
          ),
        ),
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
