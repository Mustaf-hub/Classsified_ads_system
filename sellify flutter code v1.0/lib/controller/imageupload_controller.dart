import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellify/api_config/config.dart';

import '../api_config/store_data.dart';
import 'package:http/http.dart' as http;

import '../helper/c_widget.dart';
import '../model/routes_helper.dart';

class ImageuploadController extends GetxController implements GetxService {

  String? path;
  String? base64Image;
  File? imageFile;

  Future openGallery({required String screenRoute}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = pickedFile.path;
      update();
      imageFile = File(path.toString());
      print(">> <> <> <> <> <> < >$imageFile");

      List<int> imageBytes = imageFile!.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      imageupload(base64Image);
    }
  }

  Future imageupload(String? base64image) async {


    var request = http.Request('POST', Uri.parse(Config.path + Config.profileimage));
    request.body = '''{"uid": "${getData.read("UserLogin")["id"]}", "img": "$base64image"}''';
    print("RERERER ERERE ${request.body}");

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      if(responseData["Result"] == "true") {
        showToastMessage("${responseData["ResponseMsg"]}");
        save("UserLogin", responseData["UserLogin"]);
      } else {
        showToastMessage("${responseData["ResponseMsg"]}");
      }
    } else {
      showToastMessage("Something went wrong!!");
    }

  }
}