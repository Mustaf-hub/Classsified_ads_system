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

class PostmobileController extends GetxController implements GetxService {

  var headers = {'content-type': 'application/json'};

  String mobileBrand = "" ;
  String tabletBrand = "";
  String accessoriesType = "0";

  TextEditingController adTitle = TextEditingController();
  TextEditingController description = TextEditingController();
  String catId = "0";
  String subcatId = "0";
  String transactionId = "0";
  String pmethodId = "0";
  String packageId = "0";
  String walletAmt = "0";

  bool isloading = false;
  Future postmobileWeb(transId) async {
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

  Future postmobile ({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId, required String mainAmt, required String paymentMethod}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    Map<String, String> body = {
      'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      'cat_id': catId,
      'subcat_id': subcatId,
      'ad_type': "mobile_post",
      'ad_title': adTitle.text,
      'ad_description': description.text,
      'full_address': address,
      'lats': getData.read("lat").toString(),
      'longs': getData.read("long").toString(),
      'ad_price': adPrice,
      'size': prodImage.length.toString(),
      'mobile_brand': mobileBrand,
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
          'cat_id': updatecatId,
          'subcat_id': subcatId,
          'ad_type': "mobile_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'mobile_brand': mobileBrand,
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
          Get.offAll(const SuccessfulScreen(), transition: Transition.noTransition);
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

  Future postAccessoriesWeb(transId) async {
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

  Future postAccessories({required String adPrice,  required String address, required String postType, required String recordId, required String updatecatId, required String mainAmt, required String paymentMethod}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    Map<String, String> body = {
      'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      'cat_id': catId,
      'subcat_id': subcatId,
      'ad_type': "accessories_post",
      'ad_title': adTitle.text,
      'ad_description': description.text,
      'full_address': address,
      'lats': getData.read("lat").toString(),
      'longs': getData.read("long").toString(),
      'ad_price': adPrice,
      'size': prodImage.length.toString(),
      'accessories_type': accessoriesType,
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
          'cat_id': updatecatId,
          'subcat_id': subcatId,
          'ad_type': "accessories_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'accessories_type': accessoriesType,
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
          Get.offAll(const SuccessfulScreen(), transition: Transition.noTransition);
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

  Future postTabletWeb(transId) async {
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

  Future postTablet ({required String adPrice, required String address, required String postType, required String recordId, required String updatecatId, required String mainAmt, required String paymentMethod}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri updateuri = Uri.parse(Config.path + Config.updatePost);
    Uri posturi = Uri.parse(Config.path + Config.postad);

    Map<String, String> body = {
      'uid': getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      'cat_id': catId,
      'subcat_id': subcatId,
      'ad_type': "tablet_post",
      'ad_title': adTitle.text,
      'ad_description': description.text,
      'full_address': address,
      'lats': getData.read("lat").toString(),
      'longs': getData.read("long").toString(),
      'ad_price': adPrice,
      'size': prodImage.length.toString(),
      'tablet_type': tabletBrand,
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
          'cat_id': updatecatId,
          'subcat_id': subcatId,
          'ad_type': "tablet_post",
          'ad_title': adTitle.text,
          'ad_description': description.text,
          'full_address': address,
          'lats': getData.read("lat").toString(),
          'longs': getData.read("long").toString(),
          'ad_price': adPrice,
          'size': prodImage.length.toString(),
          'tablet_type': tabletBrand,
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