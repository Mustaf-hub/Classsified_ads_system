
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/postad/bikecvehiclecontoller.dart';
import 'package:sellify/model/addProductModel/bikecvehiclemodel.dart';
import 'package:sellify/model/addProductModel/vehiclemodel.dart';

class BikescooterCvehicleContoller extends GetxController implements GetxService {

  bool isLoading = true;

  BikescootercvehicleModel? bikescootercvehicle;
  Future getvehicle({required String subcatId}) async {
    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "subcat_id": subcatId
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.bikescootervehicle),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

        print("DSLKDLSKLSDLSKD ${response.body}");
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        bikescootercvehicle = BikescootercvehicleModel.fromJson(result);
        isLoading = false;
        update();
      }
    }
  }

  bool modelisLoading = true;
  VehicleModel? vehiclemodel;
  Future getModel({required String brandId}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "brand_id": brandId
    };

    var response = await http.post(Uri.parse(Config.path + Config.bikescootermodel),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        vehiclemodel = VehicleModel.fromJson(result);
        modelisLoading = false;
        update();
        return result;
      } else {
        return jsonDecode(response.body);
      }
    }
  }
}