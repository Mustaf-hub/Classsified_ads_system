import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/model/filtermodel.dart';

import '../../api_config/store_data.dart';

class CarfilterController extends GetxController implements GetxService {

  FilterModel? filterData;
  bool isLoading = true;


}