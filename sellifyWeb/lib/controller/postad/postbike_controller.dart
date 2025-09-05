import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_config/apiwrapper.dart';
import '../../screens/successful_screen.dart';

class PostbikeController extends GetxController implements GetxService {

  bool isloading = false;

  String catId = "0";
  String subcatId = "0";
  String subTypeId = "0";

  TextEditingController year = TextEditingController();
  TextEditingController kmdriven = TextEditingController();
  TextEditingController adTitle = TextEditingController();
  TextEditingController description = TextEditingController();

  String brandId = "";
  String modelId = "";

  String transactionId = "0";
  String pmethodId = "0";
  String packageId = "0";
  String walletAmt = "0";

  var headers = {'content-type': 'application/json'};

  Future postbikeWeb(transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> postData = Map<String, String>.from(jsonDecode(prefs.getString("adpostData")!));

    Map images = Map.from(jsonDecode(prefs.getString("postImageList")!));

    prodImage = images["postimagelist"];
    prodImageBytes = images["postimagebytelist"];
    postData["transaction_id"] = transId;
    update();

    Uri posturi = Uri.parse(Config.path + Config.postad);

    ApiWrapper.dataPost(posturi, postData, prodImage, prodImageBytes);
  }

  Future postBike ({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId, required String mainAmt, required String paymentMethod}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    Map<String, String> body = {
      'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      'cat_id': catId,
      'subcat_id': subcatId,
      'ad_type': "motorcycle_post",
      'ad_title': adTitle.text,
      'ad_description': description.text,
      'full_address': address,
      'lats': getData.read("lat").toString(),
      'longs': getData.read("long").toString(),
      'ad_price': adPrice,
      'size': prodImage.length.toString(),
      'motocycle_brand_id': brandId,
      'motorcycle_model_id': modelId,
      'motorcycle_year': year.text,
      'km_driven': kmdriven.text,
      'is_paid': isPaid.toString(),
      'transaction_id': transactionId,
      'p_method_id': pmethodId,
      'package_id': packageId,
      "wall_amt" : walletAmt
    };

    if (paymentMethod == "Razorpay" || (walletAmt != "0" && mainAmt == "0") || !kIsWeb || postType == "Edit") {
      var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

      if(postType == "Edit"){
        request.fields.addAll({
          'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
          'cat_id': catId,
          'subcat_id': subcatId,
          'ad_type': "motorcycle_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'motocycle_brand_id': brandId,
          'motorcycle_model_id': modelId,
          'motorcycle_year': year.text,
          'km_driven': kmdriven.text,
          'is_paid': isPaid.toString(),
          'transaction_id': transactionId,
          'p_method_id': pmethodId,
          'package_id': packageId,
          'record_id' : recordId,
          'oldfileurl' : updateImage != "" ? updateImage : "0",
        });

        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(await (kIsWeb ? http.MultipartFile.fromBytes('photo$i', prodImageBytes[i], filename: prodImage[i]) : http.MultipartFile.fromPath('photo$i', prodImage[i])));
        }
      } else {
        request.fields.addAll(body);
        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(await (kIsWeb ? http.MultipartFile.fromBytes('photo$i', prodImageBytes[i], filename: prodImage[i]) : http.MultipartFile.fromPath('photo$i', prodImage[i])));
        }
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();


      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();

        final responseData = jsonDecode(responseString);

        if (responseData["Result"] == "true") {
          isloading = false;
          update();
          showToastMessage(responseData["ResponseMsg"]);
          Get.offAll(const SuccessfulScreen());
        } else {
          isloading = false;
          update();
          Get.back();
          showToastMessage(responseData["ResponseMsg"]);
        }
      } else {
        isloading = false;
        update();
        Get.back();
        showToastMessage('Request failed. Please try again.');
      }
    } else {
      prefs.setString("postImageList", jsonEncode({"postimagelist" : prodImage, "postimagebytelist" : prodImageBytes}));
      prefs.setString("adpostData", jsonEncode(body));
    }
  }

  Future postScooterWeb(transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> postData = Map<String, String>.from(jsonDecode(prefs.getString("adpostData")!));

    Map images = Map.from(jsonDecode(prefs.getString("postImageList")!));

    prodImage = images["postimagelist"];
    prodImageBytes = images["postimagebytelist"];
    postData["transaction_id"] = transId;
    update();

    Uri posturi = Uri.parse(Config.path + Config.postad);

    ApiWrapper.dataPost(posturi, postData, prodImage, prodImageBytes);
  }

  Future postScooter ({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId, required String mainAmt, required String paymentMethod}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    Map<String, String> body = {
      'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      'cat_id': catId,
      'subcat_id': subcatId,
      'ad_type': "scooter_post",
      'ad_title': adTitle.text,
      'ad_description': description.text,
      'full_address': address,
      'lats': getData.read("lat").toString(),
      'longs': getData.read("long").toString(),
      'ad_price': adPrice,
      'size': prodImage.length.toString(),
      'scooter_brand_id': brandId,
      'scooter_model_id': modelId,
      'scooter_year': year.text,
      'km_driven': kmdriven.text,
      'is_paid': isPaid.toString(),
      'transaction_id': transactionId,
      'p_method_id': pmethodId,
      'package_id': packageId,
      "wall_amt" : walletAmt
    };

    if (paymentMethod == "Razorpay" || (walletAmt != "0" && mainAmt == "0") || !kIsWeb || postType == "Edit") {
      var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

      if(postType == "Edit") {
        request.fields.addAll({
          'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
          'cat_id': catId,
          'subcat_id': subcatId,
          'ad_type': "scooter_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'scooter_brand_id': brandId,
          'scooter_model_id': modelId,
          'scooter_year': year.text,
          'km_driven': kmdriven.text,
          'is_paid': isPaid.toString(),
          'transaction_id': transactionId,
          'p_method_id': pmethodId,
          'package_id': packageId,
          'record_id' : recordId,
          'oldfileurl' : updateImage != "" ? updateImage : "0",
        });
        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(await (kIsWeb ? http.MultipartFile.fromBytes('photo$i', prodImageBytes[i], filename: prodImage[i]) : http.MultipartFile.fromPath('photo$i', prodImage[i])));
        }
      } else {
        request.fields.addAll(body);

        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(await (kIsWeb ? http.MultipartFile.fromBytes('photo$i', prodImageBytes[i], filename: prodImage[i]) : http.MultipartFile.fromPath('photo$i', prodImage[i])));
        }
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();

        final responseData = jsonDecode(responseString);

        if (responseData["Result"] == "true") {
          isloading = false;
          update();
          showToastMessage(responseData["ResponseMsg"]);
          Get.offAll(const SuccessfulScreen());
        } else {
          isloading = false;
          update();
          Get.back();
          showToastMessage(responseData["ResponseMsg"]);
        }
      } else {
        isloading = false;
        update();
        Get.back();
        showToastMessage('Request failed. Please try again.');
      }
    } else {
      prefs.setString("postImageList", jsonEncode({"postimagelist" : prodImage, "postimagebytelist" : prodImageBytes}));
      prefs.setString("adpostData", jsonEncode(body));
    }
  }

  Future postBicycleWeb(transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> postData = Map<String, String>.from(jsonDecode(prefs.getString("adpostData")!));

    Map images = Map.from(jsonDecode(prefs.getString("postImageList")!));

    prodImage = images["postimagelist"];
    prodImageBytes = images["postimagebytelist"];
    postData["transaction_id"] = transId;
    update();

    Uri posturi = Uri.parse(Config.path + Config.postad);

    ApiWrapper.dataPost(posturi, postData, prodImage, prodImageBytes);
  }

  Future postBicycle ({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId, required String mainAmt, required String paymentMethod}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    Map<String, String> body = {
      'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
    'cat_id': catId,
    'subcat_id': subcatId,
    'ad_type': "bicycles_post",
    'ad_title': adTitle.text,
    'ad_description': description.text,
    'full_address': address,
    'lats': getData.read("lat").toString(),
    'longs': getData.read("long").toString(),
    'ad_price': adPrice,
    'size': prodImage.length.toString(),
    'bicycles_brand_id': brandId,
    'is_paid': isPaid.toString(),
    'transaction_id': transactionId,
    'p_method_id': pmethodId,
    'package_id': packageId,
    "wall_amt" : walletAmt
    };

    if (paymentMethod == "Razorpay" || (walletAmt != "0" && mainAmt == "0") || !kIsWeb || postType == "Edit") {
      var request = http.MultipartRequest('POST', postType == "Edit" ? updateuri : posturi);

      if(postType == "Edit") {
        request.fields.addAll({
          'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
          'cat_id': updatecatId,
          'subcat_id': subcatId,
          'ad_type': "bicycles_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'bicycles_brand_id': brandId,
          'is_paid': isPaid.toString(),
          'transaction_id': transactionId,
          'p_method_id': pmethodId,
          'package_id': packageId,
          'record_id' : recordId,
          'oldfileurl' : updateImage != "" ? updateImage : "0",
        });
        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(await (kIsWeb ? http.MultipartFile.fromBytes('photo$i', prodImageBytes[i], filename: prodImage[i]) : http.MultipartFile.fromPath('photo$i', prodImage[i])));
        }
      } else {
        request.fields.addAll(body);
        for (int i = 0; i < prodImage.length; i++) {
          request.files.add(await (kIsWeb ? http.MultipartFile.fromBytes('photo$i', prodImageBytes[i], filename: prodImage[i]) : http.MultipartFile.fromPath('photo$i', prodImage[i])));
        }
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();

        final responseData = jsonDecode(responseString);

        if (responseData["Result"] == "true") {
          isloading = false;
          update();
          showToastMessage(responseData["ResponseMsg"]);
          Get.offAll(const SuccessfulScreen());
        } else {
          isloading = false;
          update();
          Get.back();
          showToastMessage(responseData["ResponseMsg"]);
        }
      } else {
        isloading = false;
        update();
        Get.back();

        showToastMessage('Request failed. Please try again.');
      }
    } else {
      prefs.setString("postImageList", jsonEncode({"postimagelist" : prodImage, "postimagebytelist" : prodImageBytes}));
      prefs.setString("adpostData", jsonEncode(body));
    }
  }

}