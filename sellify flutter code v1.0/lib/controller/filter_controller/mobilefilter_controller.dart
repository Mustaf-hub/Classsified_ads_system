import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class MobilefilterController extends GetxController implements GetxService {

  FilterModel? filterData;
  bool isloading = true;

  Future getmobileFilter({required String brandId, required String subcatId, required String sort, required String budgetStart, required String budgetEnd}) async {

    print(subcatId);
    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart,
      "budget_end": budgetEnd,
      "type_id": brandId,
      "sort": sort,
      "subcat_id": subcatId,
      "post_type": subcatId == "7" ? "mobile_post" : subcatId == "8" ? "accessories_post" : "tablet_post"
    };

    print("BODY $body");
    var response = await http.post(Uri.parse(Config.path + Config.mobilefilter),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      print("DATA OF FILTER: $result");
      if(result["Result"] == "true"){

        filterData = FilterModel.fromJson(result);
        isloading = false;
        update();
      }
    }
  }

}