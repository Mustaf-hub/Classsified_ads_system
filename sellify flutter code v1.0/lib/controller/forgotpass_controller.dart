import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';

class ForgotpassController extends GetxController implements GetxService {


  bool isloading = true;
  Future forgotPassword({required String mobile, required String ccode, required String password}) async {
    
    Map body = {
      "mobile": mobile,
      "password": password,
      "ccode": ccode
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.forgotpass),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);
      isloading = false;
      print(">>>>>>>>>>>>>>>>>>>>>>>>> $result");
      update();
      return result;
    }
    return response.body;
  }
}