import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/bottombar_screen.dart';

import '../../screens/successful_screen.dart';

class PropertiesController extends GetxController implements GetxService {

  propertiesCont() {
    PropertiesController();
  }

  String catId = "0";
  String subcatId = "0";
  String transactionId = "0";
  String pmethodId = "0";
  String packageId = "0";
  String walletAmt = "0";
  String propType = "0";
  String  bathroom = "0";
  String  bedroom = "0";
  String adType = "";
  String address = "";
  var headers = {'content-type': 'application/json'};

  TextEditingController adTitle = TextEditingController();
  TextEditingController description = TextEditingController();

  String adPrice = "";

  String furnishing = "";
  String constructionStatus = "";
  String listedBy = "";
  String propertyFacing = "";

  TextEditingController superbuildarea = TextEditingController();
  TextEditingController carpetarea = TextEditingController();
  TextEditingController maintaince = TextEditingController();
  TextEditingController totalFloor = TextEditingController();
  TextEditingController floorNo = TextEditingController();
  TextEditingController carParking = TextEditingController();
  TextEditingController projectName = TextEditingController();


  bool isloading = false;

  Future saleHome({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit"){
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': catId,
        'subcat_id': subcatId,
        'ad_type': "salehouse_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_type': propType,
        'property_bedroom': bedroom,
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_construction_status': constructionStatus,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'property_maintaince_monthly': maintaince.text,
        'property_total_floor': totalFloor.text,
        'property_floor_no': floorNo.text,
        'property_car_parking': carParking.text,
        'property_facing': propertyFacing,
        'project_name': projectName.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        'record_id' : recordId,
        'oldfileurl' : updateImage != "" ? updateImage : "0",
      });
      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    } else {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "salehouse_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_type': propType,
        'property_bedroom': bedroom,
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_construction_status': constructionStatus,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'property_maintaince_monthly': maintaince.text,
        'property_total_floor': totalFloor.text,
        'property_floor_no': floorNo.text,
        'property_car_parking': carParking.text,
        'property_facing': propertyFacing,
        'project_name': projectName.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        "wall_amt" : walletAmt
      });

      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    }

    request.headers.addAll(headers);

    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("success4");

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      print('Parsed Response Data: $responseData');

      if (responseData["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(responseData["ResponseMsg"]);
        Get.offAll(const SuccessfulScreen());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${responseData["ResponseMsg"]}');
        showToastMessage(responseData["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }

  Future rentHome({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit"){
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "renthouse_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_type': propType,
        'property_bedroom': bedroom,
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        'record_id' : recordId,
        'oldfileurl' : updateImage != "" ? updateImage : "0",
      });
      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    } else {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': catId,
        'subcat_id': subcatId,
        'ad_type': "renthouse_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_type': propType,
        'property_bedroom': bedroom,
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        "wall_amt" : walletAmt
      });

      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    }

    request.headers.addAll(headers);

    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("success4");

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      print('Parsed Response Data: $responseData');

      if (responseData["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(responseData["ResponseMsg"]);
        Get.offAll(const SuccessfulScreen());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${responseData["ResponseMsg"]}');
        showToastMessage(responseData["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }


  TextEditingController length = TextEditingController();
  TextEditingController plotArea = TextEditingController();
  TextEditingController breadth = TextEditingController();

  Future saleLandPlot({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit"){
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "land_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_type': propType,
        'plot_area': plotArea.text,
        'plot_length': length.text,
        'property_listed_by' : listedBy,
        'plot_breadth': breadth.text,
        'property_facing': propertyFacing,
        'property_car_parking': carParking.text,
        'project_name': projectName.text,
        'property_maintaince_monthly': maintaince.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        'record_id' : recordId,
        'oldfileurl' : updateImage != "" ? updateImage : "0",
      });
      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    } else {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': catId,
        'subcat_id': subcatId,
        'ad_type': "land_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_type': propType,
        'plot_area': plotArea.text,
        'plot_length': length.text,
        'property_listed_by' : listedBy,
        'plot_breadth': breadth.text,
        'property_facing': propertyFacing,
        'property_car_parking': carParking.text,
        'project_name': projectName.text,
        'property_maintaince_monthly': maintaince.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        "wall_amt" : walletAmt
      });

      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    }

    request.headers.addAll(headers);

    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("success4");




    if (response.statusCode == 200) {

      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      print('Parsed Response Data: $responseData');

      if (responseData["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(responseData["ResponseMsg"]);
        Get.offAll(const SuccessfulScreen());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${responseData["ResponseMsg"]}');
        showToastMessage(responseData["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }

  Future saleOffice({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit"){
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "saleoffice_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_construction_status': constructionStatus,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'property_car_parking': carParking.text,
        'project_name': projectName.text,
        'property_maintaince_monthly': maintaince.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        'record_id' : recordId,
        'oldfileurl' : updateImage != "" ? updateImage : "0",
      });
      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    } else {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': catId,
        'subcat_id': subcatId,
        'ad_type': "saleoffice_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_construction_status': constructionStatus,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'property_car_parking': carParking.text,
        'project_name': projectName.text,
        'property_maintaince_monthly': maintaince.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        "wall_amt" : walletAmt
      });

      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    }


    request.headers.addAll(headers);

    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("success4");

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      print('Parsed Response Data: $responseData');

      if (responseData["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(responseData["ResponseMsg"]);
        Get.offAll(const SuccessfulScreen());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${responseData["ResponseMsg"]}');
        showToastMessage(responseData["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }

  Future rentOffice({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit"){
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "rentoffice_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'property_car_parking': carParking.text,
        'project_name': projectName.text,
        'property_maintaince_monthly': maintaince.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        'record_id' : recordId,
        'oldfileurl' : updateImage != "" ? updateImage : "0",
      });
      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    } else {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': catId,
        'subcat_id': subcatId,
        'ad_type': "rentoffice_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'property_bathroom': bathroom,
        'property_furnishing': furnishing,
        'property_listed_by': listedBy,
        'property_superbuildarea': superbuildarea.text,
        'property_carpetarea': carpetarea.text,
        'property_car_parking': carParking.text,
        'project_name': projectName.text,
        'property_maintaince_monthly': maintaince.text,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        "wall_amt" : walletAmt
      });

      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    }

    request.headers.addAll(headers);
    
    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("success4");

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      print('Parsed Response Data: $responseData');

      if (responseData["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(responseData["ResponseMsg"]);
        Get.offAll(const SuccessfulScreen());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${responseData["ResponseMsg"]}');
        showToastMessage(responseData["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }

  String pgMealsincluded = "";

  Future pgpost({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit"){
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "pg_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'pg_subtype': propType,
        'property_furnishing': furnishing,
        'property_listed_by': listedBy,
        'property_car_parking': carParking.text,
        'pg_meals_include': pgMealsincluded,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        'record_id' : recordId,
        'oldfileurl' : updateImage != "" ? updateImage : "0",
      });
      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    } else {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': catId,
        'subcat_id': subcatId,
        'ad_type': "pg_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price': adPrice,
        'size': prodImage.length.toString(),
        'pg_subtype': propType,
        'property_furnishing': furnishing,
        'property_listed_by': listedBy,
        'property_car_parking': carParking.text,
        'pg_meals_include': pgMealsincluded,
        'is_paid': isPaid.toString(),
        'transaction_id': transactionId,
        'p_method_id': pmethodId,
        'package_id': packageId,
        "wall_amt" : walletAmt
      });

      for (int i = 0; i < prodImage.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('photo$i', prodImage[i]));
        print("PRODUCT IMAGE > : > : > : > $prodImage");
      }
    }

    request.headers.addAll(headers);

    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("success4");

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Raw Response String: $responseString');

      final responseData = jsonDecode(responseString);
      print('Parsed Response Data: $responseData');

      if (responseData["Result"] == "true") {
        isloading = false;
        update();
        showToastMessage(responseData["ResponseMsg"]);
        Get.offAll(const SuccessfulScreen());
      } else {
        isloading = false;
        update();
        Get.back();
        print('API returned an error: ${responseData["ResponseMsg"]}');
        showToastMessage(responseData["ResponseMsg"]);
      }
    } else {
      isloading = false;
      update();
      Get.back();
      print('Request failed with status: ${response.statusCode}, reason: ${response.reasonPhrase}');
      showToastMessage('Request failed. Please try again.');
    }
  }
}