import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/screens/repubsuccessful.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config/apiwrapper.dart';
import '../api_config/store_data.dart';
import '../helper/c_widget.dart';

class RepubController extends GetxController implements GetxService {
  
  bool isloading = false;

  Future getRepubWeb(transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> postData = Map<String, String>.from(jsonDecode(prefs.getString("republicdata")!));

    postData["transaction_id"] = transId.toString();
    update();

    ApiWrapper.rePubWeb(postData);
  }

  Future getRepublish({required String postId, required String transId, required String pMethod, required String package, required String isPaid, required String mainAmt, required String paymentMethod, required String walletAmt}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "post_id" : postId,
      "transaction_id" : transId,
      "p_method_id" : pMethod,
      "wall_amt" : walletAmt,
      "is_paid" : isPaid,
      "package_id" : package
    };


    if (paymentMethod == "Razorpay" || (walletAmt != "0" && mainAmt == "0")) {
      var response = await http.post(Uri.parse(Config.path + Config.republishAd),
        body: jsonEncode(body)
      );
      if (response.statusCode == 200) {

        var result = jsonDecode(response.body);

        if (result["Result"] == "true") {
          isloading = false;
          update();
          showToastMessage(result["ResponseMsg"]);
          Get.offAll(const Repubsuccessful(), transition: Transition.noTransition);
        } else {
          isloading = false;
          update();
          Get.back();
          showToastMessage(result["ResponseMsg"]);
        }
      } else {
        isloading = false;
        update();
        Get.back();
        showToastMessage('Request failed. Please try again.');
      }
    } else {
      prefs.setString("republicdata", jsonEncode(body));
    }
  }
}