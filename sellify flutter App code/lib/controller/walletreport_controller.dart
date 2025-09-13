import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/model/walletreportmodel.dart';
import '../api_config/store_data.dart';

class WalletreportController extends GetxController implements GetxService {


  WalletreportModel? walletData;

  bool isloading = true;
  Future getWalletReport() async {
    
    Map body ={
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0"
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.walletreport),
      body: jsonEncode(body)
    );

        print("WALLET DTA ${body}");
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true") {
        walletData = WalletreportModel.fromJson(result);
        isloading= false;
        update();
        return result["Result"];
      } else {
        showToastMessage(result["ResponseMsg"]);
        return result["Result"];
      }
    } else {
      showToastMessage("Somrthing went wrong!");
      isloading = false;
      update();
    }
  }
  
  
  
}