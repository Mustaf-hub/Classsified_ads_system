import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/myads_screen.dart';
import '../api_config/store_data.dart';

class MarkSoldController extends GetxController implements GetxService {

  bool isloading = false;
  
  Future getMarskSold({required String postId, required String soldType}) async {
    Map body = {
      "post_id" : postId,
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "sold_type" : soldType
    };

    print("BODYYYYYY > $body");
    var response = await http.post(Uri.parse(Config.path + Config.markSold),
      body: jsonEncode(body)
    );

    print("LSLDSLDLSDLSLDSD ${response.body}");
    var result = jsonDecode(response.body);

    if(response.statusCode == 200){

      if(result["Result"] == "true"){
        showToastMessage(result["ResponseMsg"]);
        isloading = false;
        update();
      } else {
        isloading = false;
        update();
        Get.back();
        showToastMessage(result["ResponseMsg"]);
      }
    } else {
      Get.to(const MyadsScreen());
      showToastMessage(result["ResponseMsg"]);
    }
  }
}