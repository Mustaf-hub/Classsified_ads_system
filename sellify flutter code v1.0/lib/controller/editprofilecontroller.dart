import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';

import '../api_config/store_data.dart';

class ProfileEditController extends GetxController implements GetxService {

  bool isloading = true;

  Future getEditprofile({required String userName, required String email, required String password}) async {
    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "name": userName,
      "email": email,
      "password": password
    };

    var response = await http.post(Uri.parse(Config.path + Config.editprofile),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        showToastMessage(result["ResponseMsg"]);
        return result;
      }
    } else {
      return jsonDecode(response.body);
    }
  }
}