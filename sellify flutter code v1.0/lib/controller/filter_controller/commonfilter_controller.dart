import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class CommonfilterController extends GetxController implements GetxService {

  FilterModel? filterData;
  bool isLoading = true;


}