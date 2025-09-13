import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/model/myfavmodel.dart';

class MyfavController extends GetxController implements GetxService {

  bool isloading = true;
  MyfavModel? myfavData;
  Future getMyFav() async {
    
    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0"
    };
    
    var response = await http.post(
      Uri.parse(Config.path + Config.myfav),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        myfavData = MyfavModel.fromJson(result);
        isloading = false;
        update();
      }
    } else {
      isloading = false;
      update();
    }
  }
}