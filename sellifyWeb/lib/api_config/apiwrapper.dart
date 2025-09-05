import 'dart:convert';

import 'package:get/get.dart';
import 'package:sellify/screens/paymentfail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/c_widget.dart';
import '../screens/FeatureAdded.dart';
import '../screens/repubsuccessful.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

class ApiWrapper {

  static dataPost(appUrl, method, imageList, imageBytes) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("paymentfor", "");
      var request = http.MultipartRequest('POST', appUrl);
      request.fields.addAll(method);
      for (int i = 0; i < imageList.length; i++) {
        request.files.add(
            (http.MultipartFile.fromBytes('photo$i', imageBytes[i].cast<int>(), filename: imageList[i])));
      }

      request.headers.addAll({'content-type': 'application/json'});


      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();

        final responseData = jsonDecode(responseString);

        if (responseData["Result"] == "true") {
          showToastMessage(responseData["ResponseMsg"]);
          prefs.setString("paymentfor", "adposted");
        } else {
          showToastMessage(responseData["ResponseMsg"]);
          prefs.setString("paymentfor", "adposted");
        }
      } else {
        showToastMessage('Request failed. Please try again.');
        prefs.setString("paymentfor", "adposted");
        Get.offAll(const PaymentfailScreen());
      }
  }

  static makeFeatureWeb(method) async {
    var response = await http.post(Uri.parse(Config.path + Config.makefeature),
        body: jsonEncode(method),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        showToastMessage(result["ResponseMsg"]);
        Get.offAll(Featureadded());
      } else {
        showToastMessage(result["ResponseMsg"]);
        Get.back();
      }
    } else {
      showToastMessage("Something went wrong!");
      Get.back();
    }
  }

  static rePubWeb(method) async {
    var response = await http.post(Uri.parse(Config.path + Config.republishAd),
        body: jsonEncode(method)
    );
    if (response.statusCode == 200) {

      var result = jsonDecode(response.body);

      if (result["Result"] == "true") {
        showToastMessage(result["ResponseMsg"]);
        Get.offAll(const Repubsuccessful());
      } else {
        Get.back();
        showToastMessage(result["ResponseMsg"]);
      }
    } else {
      Get.back();
      showToastMessage('Request failed. Please try again.');
    }
  }
}