import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class CommerfilterController extends GetxController implements GetxService {

  bool isloading = true;
  FilterModel? filterData;

  Future getCommerfilter({required String sort, required String budgetStart, required String budgetEnd, required String brandId, required String yearStart, required String yearEnd, required String subcatId, required String kmStart, required String kmEnd}) async {

    Map vehiclebody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "year_start": yearStart.isNotEmpty ? yearStart : "0",
      "year_end": yearEnd.isNotEmpty ? yearEnd : "0",
      "km_start": kmStart.isNotEmpty ? kmStart : "0",
      "km_end": kmEnd.isNotEmpty ? kmEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "brand_id": brandId.isNotEmpty ? brandId : "0",
      "post_type":"commercial_post",
      "subcat_id": subcatId
    };

    Map spareSpartBody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "brand_id": brandId.isNotEmpty ? brandId : "0",
      "post_type":"sparepart_post",
      "subcat_id": subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.commerFilter),
      body: jsonEncode(subcatId == "40" ? spareSpartBody : vehiclebody),
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        update();
      }
    }
  }
}