import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/model/addProductModel/carvariation_model.dart';
import 'package:sellify/model/addProductModel/carvariationtype_model.dart';

class CarvariationController extends GetxController implements GetxService {

  bool isloading = true;
  CarvariationModel? carvariationData;
  Future carvariation({String? brandId}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "brand_id": brandId
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.carvariation),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        carvariationData = CarvariationModel.fromJson(result);
        isloading = false;
        update();
        return result["Result"];
      }
    }
  }

  CarvariationTypeModel? carvarTypeData;
  Future carvariantType({required String brandId, required String variationId}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "brand_id": brandId,
      "variation_id": variationId
    };

    var response = await http.post(Uri.parse(Config.path + Config.carvariationType),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        carvarTypeData = CarvariationTypeModel.fromJson(result);
        isloading = false;
        update();
        return result["Result"];
      }
    }
  }
}