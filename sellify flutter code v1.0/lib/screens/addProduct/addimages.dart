import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/helper/mediaservices.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class AddImages extends StatefulWidget {
  const AddImages({super.key});

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("POSTING TYPE $subcatID");

    if(postingType == "Edit"){
      setState(() {
        adindex = Get.arguments["adIndex"];
        for(int i = 0; i < myadlistCont.myadlistData!.myadList![adindex].postAllImage!.length; i++){
          selectedImages.add(myadlistCont.myadlistData!.myadList![adindex].postAllImage![i]);
        }
      });
      print("IMAGES ${myadlistCont.myadlistData!.myadList![adindex].postAllImage!}");
    }
    Mediaservices().loadAlbums(RequestType.image).then((value) {
      if (value != null) {
        setState(() {
          albumList = value;
          selectedAlbum = value[0];
        });
        Mediaservices().loadAssets(selectedAlbum!).then((value) {
          setState(() {
            assetList = value;
          });
        },);
      }
    },);

  }

  int adindex = 0;
  String postingType = Get.arguments["postingType"];
  MyadlistController myadlistCont = Get.find();

  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  List selectedImages = [];

  String subcatID = Get.arguments["subcatId"];

  Future<Uint8List?> _loadThumbnail(AssetEntity entity) async {
    return await entity.thumbnailDataWithSize(const ThumbnailSize(200, 200));
  }

  Future<String?> getImagePath(AssetEntity asset) async {
    File? file = await asset.file;

    return file?.path;
  }


  PageController pageController = PageController();
  int selectedIndex = 0;
  late ColorNotifire notifier;
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
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Upload Photos".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(selected: (selectedAssetList.isNotEmpty || postingType == "Edit") ? false : true, containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () async {
          prodImage = [];
          updateImage = "";

          if(postingType == "Edit") {

            if (selectedImages.isNotEmpty) {

             for(AssetEntity asset in selectedAssetList){
                String? path = await getImagePath(asset);
                if (path != null) {
                  print('Image Path: $path');
                  prodImage.add(path.toString());
                  print("IMAGE LIST > > > < < < $selectedImages");
                } else {
                  print('Failed to get path for asset: ${asset.id}');
                }
              }

              setState(() {
                updateImage = selectedImages.join('\$;');
              });
              print("ASSETENTITY >>> > >>> > $updateImage");


              if(10 <= int.parse(subcatID) && int.parse(subcatID) <= 24) {
                Get.toNamed(Routes.addlocationScreen, arguments: {
                  "subcatId" : subcatID,
                  "price" : "0",
                  "adIndex" : adindex,
                  "postingType" : postingType,
                  "route" : Routes.addImages
                });
              } else {
                Get.toNamed(Routes.addpriceScreen, arguments: {
                  "subcatId" : subcatID,
                  "adIndex" : adindex,
                  "postingType" : postingType,
                });
              }
            } else {
              print("nbn  nnboo kn,dfmnm,d ");
              if(selectedAssetList.isNotEmpty) {

                for(AssetEntity asset in selectedAssetList){
                  String? path = await getImagePath(asset);
                  if (path != null) {
                    print('Image Path: $path');
                    prodImage.add(path.toString());
                    print("IMAGE LIST > > > < < < $selectedImages");
                  } else {
                    print('Failed to get path for asset: ${asset.id}');
                  }
                  print("ASSETENTITY >>> > >>> > ${subcatID}");
                }

                setState(() {
                  updateImage = selectedImages.join('\$;');
                });
                if(10 <= int.parse(subcatID) && int.parse(subcatID) <= 24) {

                  Get.toNamed(Routes.addlocationScreen, arguments: {
                    "subcatId" : subcatID,
                    "price" : "0",
                    "adIndex" : adindex,
                    "postingType" : postingType,
                  });
                } else {
                  Get.toNamed(Routes.addpriceScreen, arguments: {
                    "subcatId" : subcatID,
                    "adIndex" : adindex,
                    "postingType" : postingType,
                  });
                }
              }
            }
          } else if(selectedAssetList.isNotEmpty){
              for(AssetEntity asset in selectedAssetList){
                String? path = await getImagePath(asset);
                if (path != null) {
                  print('Image Path: $path');

                  prodImage.add(path);

                  print("IMAGE LIST > > > < < < $prodImage");
                } else {
                  print('Failed to get path for asset: ${asset.id}');
                }
                print("ASSETENTITY >>> > >>> > ${subcatID}");
                }
                if(10 <= int.parse(subcatID) && int.parse(subcatID) <= 24) {
                  Get.toNamed(Routes.addlocationScreen, arguments: {
                    "subcatId" : subcatID,
                    "price" : "0",
                    "adIndex" : adindex,
                    "postingType" : postingType,
                  });
                } else {
                  Get.toNamed(Routes.addpriceScreen, arguments: {
                    "subcatId" : subcatID,
                    "adIndex" : adindex,
                    "postingType" : postingType,
                  });
                }
              }
              print(prodImage);
            }
        ,),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedAssetList.isEmpty) SizedBox() else SizedBox(
              height: 250,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: selectedAssetList.length,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ViewImage(selectedImages: selectedAssetList, initialImage: selectedIndex);
                          },));
                        },
                        child: FutureBuilder<Uint8List?>(
                          future: _loadThumbnail(selectedAssetList[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return Image.memory(
                                snapshot.data!,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      );
                  },),
                  Positioned(
                    bottom: 10,
                      left: 10,
                      child: Text("${selectedIndex + 1} / ${selectedAssetList.length}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: WhiteColor, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            (postingType == "Edit" && selectedImages.isNotEmpty) ? Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Existing Images".tr,
                      style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                    SizedBox(height: 10),
                    editImage(),
                    SizedBox(height: 15,),
                    Text("Select more Images".tr,
                      style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                    SizedBox(height: 10,),
                    assets(),
                  ],
                ),
              ),
            ) : SizedBox(),
            (postingType == "Edit" && selectedImages.isNotEmpty) ? SizedBox() : Expanded(child: assets()),
          ],
        ),
      ),
    );
  }
  Widget editImage(){
    return StatefulBuilder(
      builder: (context, setState) {
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 110
          ),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: selectedImages.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                  setState(() {
                    selectedImages.removeAt(index);
                  });
              },
              child: Stack(
                children: [
                  Image.network(
                    Config.imageUrl + selectedImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      height: 16,
                      width: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: redColor,
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: redColor, width: 1)
                      ),
                      child: Image.asset("assets/cancel.png", height: 30, color: WhiteColor,),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
    );
  }

  Widget assets(){
    return assetList.isEmpty ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            mainAxisExtent: 110
        ),
        shrinkWrap: true,
        itemCount: 18,
        itemBuilder:  (context, index) {
          return shimmer(context: context, baseColor: notifier.shimmerbase2, height: 110);
        },)
        : GridView.builder(
          physics: (postingType == "Edit" && selectedImages.isNotEmpty) ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 110
          ),
          shrinkWrap: true,
          itemCount: assetList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (selectedAssetList.contains(assetList[index])) {
                    setState(() {
                      selectedAssetList.remove(assetList[index]);
                    });
                } else{
                    getImagePath(assetList[index]).then((value) {
                       setState(() {
                         if(value.toString().split(".").last != "HEIC"){
                             selectedAssetList.add(assetList[index]);
                             print("IMAGE  FORMAT ${value}");
                         } else {
                           showToastMessage("Format not valid, Please select only jpg, png or jpeg format images.");
                         }
                       });
                    },);
                }
              },
              child: Stack(
                children: [
                  FutureBuilder<Uint8List?>(
                    future: _loadThumbnail(assetList[index]),
                    builder: (context, snapshot) {
                      print("IMAGE FORMATTTTT T T T T${assetList[index]}");
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  selectedAssetList.contains(assetList[index]) ? Container(
                    color: Colors.white.withOpacity(0.4),
                  ) : SizedBox(),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      height: 16,
                      width: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedAssetList.contains(assetList[index]) ? PurpleColor : lightGreyColor,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: selectedAssetList.contains(assetList[index]) ? Colors.transparent : notifier.getWhiteblackColor, width: selectedAssetList.contains(assetList[index]) ? 0 : 1)
                      ),
                      child: Text(selectedAssetList.contains(assetList[index])
                          ? "${selectedAssetList.indexOf(assetList[index])+1}" : "",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 10, color: notifier.getWhiteblackColor, fontFamily: FontFamily.gilroyMedium),),
                    ),
                  )
                ],
              ),
            );
          },
        );
  }
}

class ViewImage extends StatefulWidget {
  final List<AssetEntity> selectedImages;
  final int initialImage;
  const ViewImage({super.key, required this.selectedImages, required this.initialImage});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {

  Future<Uint8List?> _loadThumbnail(AssetEntity entity) async {
    return await entity.thumbnailDataWithSize(const ThumbnailSize(200, 200));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexNumber = widget.initialImage;
  }
  int indexNumber = 0;
  late ColorNotifire notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: BlackColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: double.infinity,

                child: PageView.builder(
                  controller: PageController(initialPage: widget.initialImage),
                  itemCount: widget.selectedImages.length,
                  onPageChanged: (value) {
                    setState(() {
                      indexNumber = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return FutureBuilder<Uint8List?>(
                      future: _loadThumbnail(widget.selectedImages[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text("${indexNumber + 1} / ${widget.selectedImages.length}", style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: WhiteColor, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// setState(() {
// selectedAlbum = value;
// });
// Mediaservices().loadAssets(selectedAlbum!).then((value) {
// setState(() {
// assetList = value;
// });
// },);