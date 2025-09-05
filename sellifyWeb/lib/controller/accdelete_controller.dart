import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/loginscreen.dart';
import '../api_config/store_data.dart';

class AccDeletController extends GetxController implements GetxService {

  Future accdelete() async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.accdelete),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var accData = jsonDecode(response.body);
      
      if(accData["Result"] == "true") {
        Get.to(const Loginscreen());
        showToastMessage(accData["ResponseMsg"]);
      }
    }
  }
}