import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/model/pagelist_model.dart';

class PageListController extends GetxController implements GetxService {

  bool isloading = true;
  PagelistModel? pagelistdata;

  Future getPageList() async {
    
    Map body = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0"
    };

    var response = await http.post(Uri.parse(Config.path + Config.pagelist),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        isloading = false;
        pagelistdata = PagelistModel.fromJson(result);
        update();
      }
    }
  }
}