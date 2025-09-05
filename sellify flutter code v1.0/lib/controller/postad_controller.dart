import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';

import '../screens/successful_screen.dart';


List prodImage = [];
String updateImage = "0";

class PostadController extends GetxController implements GetxService {

  bool isloading = false;

  String catId = "0";
  String subcatId = "0";
  String subTypeId = "0";

  String caradTitle = "";
  String caradDescription = "";

  String address = "";
  String lats = "";
  String longs = "";
  String adPrice = "";
  String brandId = "0";
  String variantId = "0";
  String varianttypeID = "0";
  String transType = "0";
  String transactionId = "0";
  String pmethodId = "0";
  String packageId = "0";
  String walletAmt = "0";

  TextEditingController year = TextEditingController();
  TextEditingController fuel = TextEditingController();
  TextEditingController kmdriven = TextEditingController();
  TextEditingController noOfowners = TextEditingController();

  TextEditingController adTitle = TextEditingController();
  TextEditingController description = TextEditingController();

  var headers = {'content-type': 'application/json'};


  Future<void> carpostAd({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

      print("Starting carpostAd process...${description.text}");
      print("Number of images: ${prodImage.length}");

      Uri updateuri = Uri.parse(Config.path + Config.updatePost);
      Uri posturi = Uri.parse(Config.path + Config.postad);

      var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

      if(postType == "Edit") {

        request.fields.addAll({
          'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
          'cat_id': updatecatId,
          'subcat_id': subcatId,
          'ad_type': "car_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'brand_id': brandId,
          'variant_id': variantId,
          'variant_type_id': varianttypeID,
          'car_year': year.text,
          'fuel': fuel.text,
          'transmission': transType,
          'km_driven': kmdriven.text,
          'no_owner': noOfowners.text,
          'is_paid': isPaid.toString(),
          'transaction_id': transactionId,
          'p_method_id': pmethodId,
          'package_id' : packageId,
          'record_id' : recordId,
          'oldfileurl' : updateImage != "" ? updateImage : "0",
        });

        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(
              await http.MultipartFile.fromPath('photo$i', prodImage[i]));
          print("Added image: ${prodImage[i]} as photo$i");
        }

      } else {
        request.fields.addAll({
          'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
          'cat_id': catId,
          'subcat_id': subcatId,
          'ad_type': "car_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'brand_id': brandId,
          'variant_id': variantId,
          'variant_type_id': varianttypeID,
          'car_year': year.text,
          'fuel': fuel.text,
          'transmission': transType,
          'km_driven': kmdriven.text,
          'no_owner': noOfowners.text,
          'is_paid': isPaid.toString(),
          'transaction_id': transactionId,
          'p_method_id': pmethodId,
          'package_id' : packageId,
          "wall_amt" : walletAmt
        });
        // Adding images to the request
        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(
              await http.MultipartFile.fromPath('photo$i', prodImage[i]));
          print("Added image: ${prodImage[i]} as photo$i");
        }
      }

      print("Headers: $headers");
      request.headers.addAll(headers);

      print("Final Request Fields: ${request.fields}");

      http.StreamedResponse response = await request.send();

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



  String salaryPeriod = "";
  String position = "";
  TextEditingController salaryfrom = TextEditingController();
  TextEditingController salaryto = TextEditingController();
  TextEditingController jobadTitle = TextEditingController();
  TextEditingController jobdescription = TextEditingController();

  Future postJob ({required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit") {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "job_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'size': prodImage.length.toString(),
        'job_salary_period': salaryPeriod,
        'job_position_type': position,
        'job_salary_from': salaryfrom.text,
        'job_salary_to': salaryto.text,
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
        'ad_type': "job_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'size': prodImage.length.toString(),
        'job_salary_period': salaryPeriod,
        'job_position_type': position,
        'job_salary_from': salaryfrom.text,
        'job_salary_to': salaryto.text,
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

  String servicetypeId = "0";

  Future postServices ({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId}) async {

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

    if(postType == "Edit") {
      request.fields.addAll({
        'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        'cat_id': updatecatId,
        'subcat_id': subcatId,
        'ad_type': "service_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price' : adPrice,
        'size': prodImage.length.toString(),
        'service_type_id': servicetypeId,
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
        'ad_type': "service_post",
        'ad_title': adTitle.text,
        'ad_description': description.text,
        'full_address': address,
        'lats': getData.read("lat").toString(),
        'longs': getData.read("long").toString(),
        'ad_price' : adPrice,
        'size': prodImage.length.toString(),
        'service_type_id': servicetypeId,
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
    print("SUBCAT IDD $subcatId");

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