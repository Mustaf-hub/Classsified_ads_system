import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:sellify/screens/addProduct/addlocation_screen.dart';
import 'package:sellify/screens/addProduct/addprice_screen.dart';
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

    if(postingType == "Edit"){
      setState(() {
        adindex = Get.arguments["adIndex"];
        for(int i = 0; i < myadlistCont.myadlistData!.myadList![adindex].postAllImage!.length; i++){
          selectedImages.add(myadlistCont.myadlistData!.myadList![adindex].postAllImage![i]);
        }
      });
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

  Future<String?> getImagePath(var asset) async {
    File? file = kIsWeb ? File(asset) : asset.file;

    return file?.path;
  }
  
  List imageListWeb = [];
  List imageListWebBytes = [];
  PageController pageController = PageController();
  int selectedIndex = 0;
  late ColorNotifire notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: notifier.getWhiteblackColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
              ),
            ),
            title: Text("Upload Photos".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor),),
            centerTitle: true,
          ),
          bottomNavigationBar: kIsWeb ? const SizedBox() : Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 15),
            child: contButton(constraints),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                  child: Column(
                    crossAxisAlignment: kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      if (selectedAssetList.isEmpty) const SizedBox() else SizedBox(
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
                                return InkWell(
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
                                        return const Center(child: CircularProgressIndicator());
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
                      const SizedBox(height: 15,),
                      (postingType == "Edit" && selectedImages.isNotEmpty) ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Text("Existing Images".tr,
                              style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),),
                            const SizedBox(height: 10),
                            editImage(),
                            const SizedBox(height: 15,),
                            Text("Select more Images".tr,
                              style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,), textAlign: TextAlign.center,),
                            const SizedBox(height: 10,),
                            kIsWeb ? const SizedBox() : assets(),
                          ],
                        ),
                      ) : const SizedBox(),
                      kIsWeb ? webImage() : (postingType == "Edit" && selectedImages.isNotEmpty) ? const SizedBox() : Expanded(child: assets()),
                      const SizedBox(height: 10,),
                      kIsWeb ? contButton(constraints) : const SizedBox(),
                    ],
                  ),
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

  Widget contButton(constraints){
    return mainButton(selected: (selectedAssetList.isNotEmpty || imageListWeb.isNotEmpty || postingType == "Edit") ? false : true, containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () async {
      prodImage = [];
      prodImageBytes = [];
      updateImage = "";
      if(postingType == "Edit") {

        if (selectedImages.isNotEmpty) {
          if(kIsWeb){
            for (String asset in imageListWeb) {
              String? path = await getImagePath(asset);
              if (path != null) {
                prodImage.add(path.toString());
              } else {
                showToastMessage("Something went wrong!");
              }
            }
            for (var asset in imageListWebBytes) {
              prodImageBytes.add(asset);
            }
          } else {
            for (AssetEntity asset in selectedAssetList) {
              String? path = await getImagePath(asset);
              if (path != null) {
                prodImage.add(path.toString());
              } else {
              }
            }
          }

          setState(() {
            updateImage = selectedImages.join('\$;');
          });

          if(10 <= int.parse(subcatID) && int.parse(subcatID) <= 24) {
            Get.to(const AddlocationScreen(), arguments: {
              "subcatId" : subcatID,
              "price" : "0",
              "adIndex" : adindex,
              "postingType" : postingType,
              "route" : Routes.addImages
            });
          } else {
            Get.to(const AddpriceScreen(), transition: Transition.noTransition, arguments: {
              "subcatId" : subcatID,
              "adIndex" : adindex,
              "postingType" : postingType,
            });
          }
        } else {
          if(kIsWeb ? imageListWeb.isNotEmpty : selectedAssetList.isNotEmpty) {
            if(kIsWeb){
              for (String asset in imageListWeb) {
                String? path = await getImagePath(asset);
                if (path != null) {
                  prodImage.add(path.toString());
                } else {
                  showToastMessage("Something went wrong!");
                }
              }
              for (var asset in imageListWebBytes) {
                prodImageBytes.add(asset);
              }
            } else {
              for (AssetEntity asset in selectedAssetList) {
                String? path = await getImagePath(asset);
                if (path != null) {
                  prodImage.add(path.toString());
                } else {
                }
              }
            }

            setState(() {
              updateImage = selectedImages.join('\$;');
            });
            if(10 <= int.parse(subcatID) && int.parse(subcatID) <= 24) {

              Get.to(const AddlocationScreen(), arguments: {
                "subcatId" : subcatID,
                "price" : "0",
                "adIndex" : adindex,
                "postingType" : postingType,
              });
            } else {
              Get.to(const AddpriceScreen(), transition: Transition.noTransition, arguments: {
                "subcatId" : subcatID,
                "adIndex" : adindex,
                "postingType" : postingType,
              });
            }
          }
        }
      } else if(kIsWeb ? imageListWeb.isNotEmpty : selectedAssetList.isNotEmpty){
        if(kIsWeb){
          for(String asset in imageListWeb){
            String? path = await getImagePath(asset);
            if (path != null) {

              prodImage.add(path);

            } else {
              showToastMessage("Something went wrong!");
            }
          }
          for (var asset in imageListWebBytes) {
            prodImageBytes.add(asset);
          }
        } else {
          for(AssetEntity asset in selectedAssetList){
            String? path = await getImagePath(asset);
            if (path != null) {

              prodImage.add(path);

            } else {
            }
          }
        }
        if(10 <= int.parse(subcatID) && int.parse(subcatID) <= 24) {
          Get.to(const AddlocationScreen(), arguments: {
            "subcatId" : subcatID,
            "price" : "0",
            "adIndex" : adindex,
            "postingType" : postingType,
          });
        } else {
          Get.to(const AddpriceScreen(), transition: Transition.noTransition, arguments: {
            "subcatId" : subcatID,
            "adIndex" : adindex,
            "postingType" : postingType,
          });
        }
      }
    },);
  }
  bool isloading = false;
  Widget webImage(){
    return Column(
      children: [
        InkWell(
          onTap: () async {
            isloading = true;
            setState(() {});
            FilePickerResult? file = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: false,
            );

            List<PlatformFile> files = file!.files;
            for(var imgFile in files){
              final Uint8List? fileBytes = imgFile.bytes;
              final String fileName = imgFile.name;
              imageListWeb.add(fileName);
              imageListWebBytes.add(fileBytes);
            }
            isloading = false;
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              color: notifier.getWhiteblackColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: notifier.borderColor),
            ),
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Image.asset("assets/uploadImage.png", height: 200,),
                const SizedBox(height: 20,),
                Text("Upload Images", style: TextStyle(color: PurpleColor, fontFamily: FontFamily.gilroyMedium, fontSize: 20),),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
         imageListWeb.isEmpty ? const SizedBox() :  Container(
            decoration: BoxDecoration(
              color: notifier.getWhiteblackColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: notifier.borderColor),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Wrap(
                  clipBehavior: Clip.none,
                  spacing: 10,
                  children: [
                    for(int i = 0; i < imageListWeb.length; i++)
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                   border: Border.all(color: notifier.borderColor, width: 2),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                    child: Image.asset("assets/image.png", height: 100, width: 100, fit: BoxFit.contain,)),
                              ),
                              Positioned(
                                left: 10,
                                top: 10,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      imageListWeb.removeAt(i);
                                      imageListWebBytes.removeAt(i);
                                    });
                                  },
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
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(imageListWeb[i], style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
  Widget editImage(){
    return StatefulBuilder(
      builder: (context, setState) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          physics: (postingType == "Edit" && selectedImages.isNotEmpty) ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  selectedAssetList.contains(assetList[index]) ? Container(
                    color: Colors.white.withOpacity(0.4),
                  ) : const SizedBox(),
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
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: InkWell(
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