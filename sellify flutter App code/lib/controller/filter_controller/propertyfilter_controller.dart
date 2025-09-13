import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class PropertyFilController extends GetxController implements GetxService {



  bool isloading = true;
  FilterModel? filterData;

}