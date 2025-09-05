import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../api_config/store_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReferController extends GetxController implements GetxService {

  bool isloading = true;

  PackageInfo? packageInfo;
  String appName = "";
  String packageName = "";

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  String referCredit = "";
  String signupCredit = "";
  String referCode = "";

  Future getReferData() async {
    Map body = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0"
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.referData),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        referCredit = result["refercredit"];
        signupCredit = result["signupcredit"];
        referCode = result["code"];
        isloading = false;
        update();
        return result;
      }
    } else {
      return "";
    }
  }
}