import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellify/api_config/config.dart';

import '../api_config/store_data.dart';
import 'package:http/http.dart' as http;

import '../helper/c_widget.dart';

class ImageuploadController extends GetxController implements GetxService {

  String? path;
  String? base64Image;
  File? imageFile;

  Future openGallery({required String screenRoute}) async {
    if(!kIsWeb){
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        path = pickedFile.path;
        update();
        imageFile = File(path.toString());

        List<int> imageBytes = imageFile!.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
        imageupload(base64Image);
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        Uint8List bytes = result.files.single.bytes!;
        base64Image = base64Encode(bytes);
        update();
        imageupload(base64Image);
      }
    }
  }

  Future imageupload(String? base64image) async {


    var request = http.Request('POST', Uri.parse(Config.path + Config.profileimage));
    request.body = '''{"uid": "${getData.read("UserLogin")["id"]}", "img": "$base64image"}''';

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();

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