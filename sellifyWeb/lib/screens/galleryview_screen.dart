import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';

import '../helper/appbar_screen.dart';

class GalleryviewScreen extends StatefulWidget {
  final List<String> galleryImage;
  final String title;
  String? isFeatured;
  GalleryviewScreen({super.key, required this.galleryImage, required this.title, this.isFeatured});

  @override
  State<GalleryviewScreen> createState() => _GalleryviewScreenState();
}

class _GalleryviewScreenState extends State<GalleryviewScreen> {

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> imageKey = GlobalKey();

  int selectedIndex = 0;

  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(135),
              child: CommonAppbar(isFeatured: widget.isFeatured, title: widget.title, fun: () {
                Get.back();
              },)) : AppBar(
            backgroundColor: notifier.getWhiteblackColor,
            elevation: 0,
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
                child: Image.asset("assets/arrowLeftIcon.png", height: 20, scale: 3.5, color: notifier.iconColor,)),
            title: Text(widget.title,style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 18, color: notifier.getTextColor,),),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: widget.galleryImage.length,
                  onPageChanged: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return FadeInImage.assetNetwork(
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Center(child: Image.asset("assets/emty.gif", fit: BoxFit.cover,height: Get.height,),);
                      },
                      image: Config.imageUrl + widget.galleryImage[index],
                      placeholder:  "assets/ezgif.com-crop.gif",
                    );
                },),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 90,
                  child: ListView.separated(
                    itemCount: widget.galleryImage.length,
                    shrinkWrap: true,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10,);
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            pageController.jumpToPage(index);
                          });
                        },
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          height: selectedIndex == index ? 80 : 70,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: selectedIndex == index ? 80 : 70,
                              width: selectedIndex == index ? 80 : 70,
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Center(child: Image.asset("assets/emty.gif", fit: BoxFit.cover,height: selectedIndex == index ? 80 : 70,),);
                                },
                                image: Config.imageUrl + widget.galleryImage[index],
                                placeholder:  "assets/ezgif.com-crop.gif",
                              ),
                            ),
                          ),
                        ),
                      );
                  },),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
