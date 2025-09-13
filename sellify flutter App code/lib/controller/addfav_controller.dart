import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/homedata_controller.dart';
import 'package:sellify/helper/c_widget.dart';

class AddfavController extends GetxController implements GetxService {

  HomedataController homedataCont = Get.find();

  bool isLoading = true;
  Future addFav({required String postId}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "post_id": postId
    };
    
    var response = await http.post(
      Uri.parse(Config.path + Config.addfav),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        showToastMessage(result["ResponseMsg"]);
        isLoading = false;
        homedataCont.gethomedata();
        update();
      } else {
        showToastMessage(result["ResponseMsg"]);
      }
    } else {
      showToastMessage("Something went wrong!");
    }
  }
}