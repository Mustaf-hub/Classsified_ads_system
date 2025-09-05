import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sellify/api_config/config.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/auth_service.dart';

class SignupController extends GetxController implements GetxService {

  TextEditingController mobile = TextEditingController();
  TextEditingController fnameCont = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController repassCont = TextEditingController();
  TextEditingController rcode = TextEditingController();

  String countryCode = "";
  String userMessage = "";
  String resultCheck = "";

  Future checkMobileNumber({required String mobilenumber, countrycode}) async {

      Map map = {
        "mobile": mobilenumber,
        "ccode": countrycode,
      };
    print("> > > > MOBILE CHECK $map");
      Uri uri = Uri.parse(Config.path + Config.mobileCheck);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
        headers: {'Content-Type': 'application/json',}
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        update();
        print("MOBILE CHECK MES $result");
        return result;
      } else {
        showToastMessage("Something went wrong!");
      }
      update();
      return jsonDecode(response.body);
  }

  String signUpMsg = "";
  String sighupCheck = "";
  Future userRegister(context) async {

    final prefs = await SharedPreferences.getInstance();

    Map map = {
      "name": fnameCont.text,
      "email": email.text,
      "mobile": mobile.text,
      "ccode": countryCode,
      "password": passCont.text,
      "rcode": rcode.text.isEmpty ? "" : rcode.text
    };

    Uri uri = Uri.parse(Config.path + Config.registerUser);
    var response = await http.post(
      uri,
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      signUpMsg = result["ResponseMsg"];
      sighupCheck = result["Result"];
      if (sighupCheck == "true") {
        save("UserLogin", result["UserLogin"]);
        await prefs.setBool('Firstuser', true);
        showToastMessage(signUpMsg);
        firebaseNewuser(name: getData.read("UserLogin")["name"], profilePic: getData.read("UserLogin")["profile_pic"], mobile: "${getData.read("UserLogin")["ccode"]}${getData.read("UserLogin")["mobile"]}");
        var sendTags = {'user_id': getData.read("UserLogin")["id"].toString()};
        OneSignal.User.addTags(sendTags);
        update();
      } else {
        showToastMessage(signUpMsg);
      }
      return result;
    } else {
      return jsonDecode(response.body);
    }
  }

  void firebaseNewuser({context, required String name, required String profilePic, required String mobile}) async {

    AuthService authService = AuthService();
    try {
      await authService.signupAndStore(
          name: name,
          profilePic: profilePic,
          mobileNumber: mobile,
          uid: getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0");
    } catch (e) {
      print(e);
    }
  }
}