import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/model/catwisepost_model.dart';
import '../api_config/store_data.dart';

class CatwisePostController extends GetxController implements GetxService {

  bool isloading = true;
  CatwisepostModel? catwisepostData;
  Future getCatwisePost({required String catId, required String subcatId}) async {
    isloading = true;
    update();
    Map body = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats" : getData.read("lat").toString(),
      "longs" : getData.read("long").toString(),
      "cat_id" : catId,
      "subcat_id" : subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.catwisepost),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        isloading = false;
        catwisepostData = CatwisepostModel.fromJson(result);
        update();
      } else {
        isloading = false;
        update();
      }
    }
  }
}