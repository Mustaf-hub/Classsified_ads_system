import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';

import '../api_config/store_data.dart';

class TopupWalletController extends GetxController implements GetxService {

  Future getTopupWallet({required String amount}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "wallet": amount
    };

    var response = await http.post(Uri.parse(Config.path + Config.walletup),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      return result;
    } else {
      return jsonDecode(response.body);
    }
  }
}