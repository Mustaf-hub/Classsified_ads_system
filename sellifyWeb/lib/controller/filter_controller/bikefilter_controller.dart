import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class BikefilterController extends GetxController implements GetxService {


  FilterModel? filterData;
  bool isLoading = true;

  Future getBikeFilter({required String sort, required String budgetStart, required String budgetEnd, required String brandId, required String subcatId, required String yearStart, required String yearEnd, required String kmStart, required String kmEnd}) async {
    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart,
      "budget_end": budgetEnd,
      "year_start": yearStart,
      "year_end": yearEnd,
      "km_start": kmStart,
      "km_end": kmEnd,
      "sort": sort,
      "brand_id": brandId,
      "post_type": subcatId == "26" ? "scooter_post" : "motorcycle_post",
      "subcat_id": subcatId
    };

    Map body2 = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart,
      "budget_end": budgetEnd,
      "sort": sort,
      "brand_id": brandId,
      "post_type":"bicycles_post",
      "subcat_id": subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.bikefilter),
      body: jsonEncode(subcatId == "28" ? body2 : body),
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isLoading = false;
        update();
      }
    }
  }
}