import 'dart:convert';

import 'package:get/get.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/model/myadlistmodel.dart';

class MyadlistController extends GetxController implements GetxService {

  bool isloading = true;
  MyadlistModel? myadlistData;
  Future myadlist () async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0"
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.myadlist),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      print("BODY ?????? ${response.body}");
      var result = jsonDecode(response.body);
      print(">>>>>>>>>>>>> $result");
      if(result["Result"] == "true"){
        myadlistData = MyadlistModel.fromJson(result);
        print("<<<<<<<<<<<>>>>>>>>>>>>> >>>>>>>>>>>$myadlistData");

        isloading = false;
        update();
      }
    } else {
      isloading = false;
      update();
    }
  }
}