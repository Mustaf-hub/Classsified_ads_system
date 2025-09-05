import 'dart:convert';

import 'package:get/get.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/model/listpackagemodel.dart';

class ListpackageController extends GetxController implements GetxService {

  bool isLoading = true;
  ListpackageModel? listpackageData;

  Future listofPackage ({required String packageType}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "package_type": packageType
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.listPackage),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        listpackageData = ListpackageModel.fromJson(result);
        isLoading = false;
        update();
      }
    } else {
      return jsonDecode(response.body);
    }
  }
}