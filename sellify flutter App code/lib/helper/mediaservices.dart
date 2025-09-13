import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/splesh_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mediaservices {
  Future loadAlbums(RequestType requestType) async {
    var permission  = await PhotoManager.requestPermissionExtend();

    List<AssetPathEntity> albumList = [];

    if (Platform.isAndroid) {
      if(getData.read("androidversion") > 32){
        print("PERMISSION GRANTEDDDDDD");
        var permission = await Permission.photos.request();
        if(permission.isGranted){
              albumList = await PhotoManager.getAssetPathList(type: requestType);
              return albumList;
            } else {
              showToastMessage("Please allow storage to get photos");
            }
      } else
        if(getData.read("androidversion") <= 32){
          print("${getData.read("androidversion")}");
        var permission = await Permission.storage.request();
        if(permission.isGranted){
              albumList = await PhotoManager.getAssetPathList(type: requestType);
              return albumList;
            } else {
              showToastMessage("Please allow storage to get photos");
            }
      }
    } else if(Platform.isIOS){
      var permission = await PhotoManager.requestPermissionExtend();
      if(permission.isAuth){
        albumList = await PhotoManager.getAssetPathList(type: requestType);
        return albumList;
      } else {
        showToastMessage("Please allow storage to get photos");
      }
    }

  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(start: 0, end: await selectedAlbum.assetCountAsync);
    return assetList;
  }
}