import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/model/paymentgatewaymodel.dart';

class PaymentgaewayController extends GetxController implements GetxService {

  bool isloading = true;
  PaymentgatewayModel? gatewayData;
  Future getPaymentgateway() async {

    var response = await http.get(Uri.parse(Config.path + Config.paymentgateway));

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        gatewayData = PaymentgatewayModel.fromJson(result);
        isloading = false;
        update();
      }
    }
  }
}