import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/model/searchpost_model.dart';
import '../api_config/store_data.dart';

class SearchpostController extends GetxController implements GetxService {

  TextEditingController searchValue = TextEditingController();
  String searchText = "";
  bool isLoading = true;
  SearchpostModel? searchpostData;
  List<SearchpostModel> searchData = [];

  changeValueUpdate(String value) {
    searchText = value;
    update();
  }

  Future getSearchPost() async {

    print("UID && ${getData.read("UserLogin")["id"]}");
    print("KEYWORD && ${searchValue.text}");
    print("LATS && ${getData.read("lat").toString()}");
    print("LONGS && ${getData.read("long").toString()}");

    var map = {
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "keyword" : searchValue.text,
      "lats" : getData.read("lat").toString(),
      "longs" : getData.read("long").toString(),
    };

    var response = await http.post(Uri.parse(Config.path + Config.searchpost),
        body: jsonEncode(map)
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        searchpostData = SearchpostModel.fromJson(result);
        for (var element in result["searchlist"]) {
          searchData.add(SearchpostModel.fromJson(element));
        }
        isLoading = false;
        update();
      } else {
        return result;
      }
    } else {
      showToastMessage("Something went wrong");
    }
  }
}