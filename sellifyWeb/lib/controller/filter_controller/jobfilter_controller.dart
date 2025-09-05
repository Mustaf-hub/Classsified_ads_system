import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class JobfilterController extends GetxController implements GetxService {

  FilterModel? filterData;
  bool isLoading = true;

  Future getjobFilter({required String subcatId, required String positionType, required String salaryPeriod, required String sort}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "job_position_type": positionType,
      "job_salary_period": salaryPeriod,
      "sort": sort,
      "subcat_id": subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.jobfilter),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
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