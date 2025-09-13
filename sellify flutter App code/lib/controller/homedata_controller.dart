import 'dart:convert';

import 'package:get/get.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/model/homedatamodel.dart';

class HomedataController extends GetxController implements GetxService {

  bool isloading = true;
  HomedataModel? homedata;
  Future gethomedata() async {

    print("object${getData.read("lat")}");
    print("object${getData.read("long")}");
    Map body = {
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0"
    };

    var response = await http.post(Uri.parse(Config.path + Config.homedata),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      print("BODY ?????? ${response.body}");
      var result = jsonDecode(response.body);
      print(">>>>>HOME DATa>>>>>>>> $result");
      if(result["Result"] == "true"){
        homedata = HomedataModel.fromJson(result);
        print("<<<<<<<<<<<>>>>>>>>>>>>> >>>>>>>>>>>${result}");
        isloading = false;
        currency = homedata!.currency;
        update();
      }
    } else {
      isloading = false;
      update();
    }
  }
}