import 'dart:convert';

import 'package:get/get.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/model/addProductModel/subcategorytypemodel.dart';
import 'package:sellify/model/categorylist_model.dart';
import 'package:sellify/model/subcategorylist_model.dart';

class CategoryListController extends GetxController implements GetxService {

  bool isloading = true;
  CategoryModel? categorylistData;

  Future categoryList() async {
    Map body = {
      "uid": getData.read("UserLogin") == null ? "0"
        : "${getData.read("UserLogin")["id"]}"
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.categorylist),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){

        categorylistData = CategoryModel.fromJson(result);

        isloading = false;
        update();
      }
    }
  }

  SubcategoryModel? subcategoryData;
  bool subIsloading = true;

  Future subCategory({required String catId}) async {
    subIsloading = true;
    update();
    Map body = {
      "uid": getData.read("UserLogin") == null ? "0"
          : "${getData.read("UserLogin")["id"]}",
      "cat_id": catId
    };

    var response = await http.post(Uri.parse(Config.path + Config.subcategorylist),
        body: jsonEncode(body)
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){

        subcategoryData = SubcategoryModel.fromJson(result);

        subIsloading = false;
        update();
      }
    }
  }

  SubcatTypeModel? subcatTypeData;
  bool subcatLoading = true;
  Future subcatType({required String subcatID}) async {

    Map body = {
      "uid": getData.read("UserLogin") == null ? "0"
          : "${getData.read("UserLogin")["id"]}",
      "subcat_id": subcatID
    };
    
    var response = await http.post(Uri.parse(Config.path + Config.subcatTypelist),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){
        subcatTypeData = SubcatTypeModel.fromJson(result);
        subcatLoading = false;
        update();
      }
    }
  }
}