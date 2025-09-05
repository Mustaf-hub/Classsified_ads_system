import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/helper/c_widget.dart';

import '../api_config/store_data.dart';

class PaystackController extends GetxController implements GetxService {

  String randomKey = "";
  String status = "";

  Future getPaystack({required String amount}) async {

    Map body = {
      "email": getData.read("UserLogin")["email"],
      "amount": amount
    };
    
    var response = await http.post(Uri.parse("https://gomeet.cscodetech.cloud/paystack/index.php"),
      body: jsonEncode(body)
    );
    
    if(response.statusCode == 200){
      
      var result = jsonDecode(response.body);
      
      if(result["status"] == true){
        randomKey = result["data"]["reference"];
        return result;
      } else {
        showToastMessage(result["message"]);
      }
    } else {
      return showToastMessage(jsonDecode(response.body)["message"]);
    }
  }
  
  Future checkPaystack({required String sKey}) async {


  }
}