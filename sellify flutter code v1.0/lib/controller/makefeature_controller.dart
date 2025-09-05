import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/FeatureAdded.dart';

class MakeFeatureController extends GetxController implements GetxService {

  Future getMakeFeature({required String postId, required String transactionId, required String pMethodId, required String wallAmt, required String packageId}) async {

    Map body = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "post_id" : postId,
      "transaction_id" : transactionId,
      "p_method_id" : pMethodId,
      "wall_amt" : wallAmt,
      "package_id" : packageId
    };

    print("FEATURE BODY $body");
    
    var response = await http.post(Uri.parse(Config.path + Config.makefeature),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      print("FEATURED ADS $result");
      if(result["Result"] == "true"){
        showToastMessage(result["ResponseMsg"]);
        Get.offAll(Featureadded());
      } else {
        showToastMessage(result["ResponseMsg"]);
        Get.back();
      }
    } else {
      print("PROBLEM : ${response.body}");
      showToastMessage("Something went wrong!");
      Get.back();
    }
  }
}