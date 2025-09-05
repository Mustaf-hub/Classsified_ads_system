import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/FeatureAdded.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_config/apiwrapper.dart';

class MakeFeatureController extends GetxController implements GetxService {

  Future getMakeFeatureWeb(transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> postData = Map.from(jsonDecode(prefs.getString("makefeaturedata")!));

    postData["transaction_id"] = transId;
    update();

    ApiWrapper.makeFeatureWeb(postData);
  }

  Future getMakeFeature({required String postId, required String transactionId, required String pMethodId, required String wallAmt, required String packageId, required String mainAmt, required String paymentMethod, required String walletAmt}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "post_id" : postId,
      "transaction_id" : transactionId,
      "p_method_id" : pMethodId,
      "wall_amt" : wallAmt,
      "package_id" : packageId
    };


    if (paymentMethod == "Razorpay" || (walletAmt != "0" && mainAmt == "0")) {
      var response = await http.post(Uri.parse(Config.path + Config.makefeature),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
      );

      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        if(result["Result"] == "true"){
          showToastMessage(result["ResponseMsg"]);
          Get.offAll(Featureadded(), transition: Transition.noTransition);
        } else {
          showToastMessage(result["ResponseMsg"]);
          Get.back();
        }
      } else {
        showToastMessage("Something went wrong!");
        Get.back();
      }
    } else {
      prefs.setString("makefeaturedata", jsonEncode(body));
    }
  }
}