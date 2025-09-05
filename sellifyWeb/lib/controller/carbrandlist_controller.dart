import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/model/addProductModel/carbrandlist_model.dart';

class CarbrandlistController extends GetxController implements GetxService {

  CarbrandlistModel? carbrandData;
  bool isloading = true;
  Future carbrandlist({required String uid}) async {
    Map body = {
      "uid": uid
    };

    var response = await http.post(Uri.parse(Config.path + Config.carbrandlist),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        carbrandData = CarbrandlistModel.fromJson(result);
        isloading = false;
        update();
      }
    }
  }
}