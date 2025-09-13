import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/screens/repubsuccessful.dart';
import '../api_config/store_data.dart';
import '../helper/c_widget.dart';

class RepubController extends GetxController implements GetxService {
  
  bool isloading = false;
  Future getRepublish({required String postId, required String transId, required String pMethod, required String package, required String isPaid, required String walletAmt}) async {

    Map body = {
      "uid" : getData.read("UserLogin") != null ? int.parse(getData.read("UserLogin")["id"]) : 0,
      "post_id" : postId,
      "transaction_id" : transId,
      "p_method_id" : pMethod,
      "wall_amt" : walletAmt,
      "is_paid" : isPaid,
      "package_id" : package
    };

    print("BODY > > $body");
    
    var response = await http.post(Uri.parse(Config.path + Config.republishAd),
      body: jsonEncode(body)
    );
    print("RESPONSE > > ${response.body}");
    if (response.statusCode == 200) {

      var result = jsonDecode(response.body);
      print('Parsed Response Data: $result');

      if (result["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(result["ResponseMsg"]);
        Get.offAll(const Repubsuccessful());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${result["ResponseMsg"]}');
        showToastMessage(result["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }
}