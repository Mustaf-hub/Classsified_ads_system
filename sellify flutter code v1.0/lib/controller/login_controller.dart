
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/firebase/auth_service.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

var currency;

class LoginController extends GetxController implements GetxService {

  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();


  String countryCode = "";
  String userMessage = "";
  String resultCheck = "";


  Future getLoginData(context) async {

    final prefs = await SharedPreferences.getInstance();
    final FirebaseMessaging _firestore = FirebaseMessaging.instance;

    print(":S:S:S:S:S:S:S:S $countryCode");
    Map body = {
      "mobile": mobile.text,
      "ccode": countryCode,
      "password": password.text,
    };

    var response = await http.post(Uri.parse(Config.path + Config.login),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var result = jsonDecode(response.body);

      userMessage = result["ResponseMsg"];
      resultCheck = result["Result"];

      showToastMessage(userMessage);
      print("><<<<<<<< $resultCheck");
      if(resultCheck == "true") {
        save("UserLogin", result["UserLogin"]);
        prefs.setBool('Firstuser', true);
        print(" USER ID :- ${getData.read("UserLogin")["id"]}");
        setDataFirebseLogin(name: getData.read("UserLogin")["name"], context: context, profilePic: getData.read("UserLogin")["profile_pic"], mobile: "${getData.read("UserLogin")["ccode"]}${getData.read("UserLogin")["mobile"]}");
        var sendTags = {'user_id': getData.read("UserLogin")["id"].toString()};
        if(kIsWeb == false) {
          OneSignal.User.addTags(sendTags);
        }
      }
      update();
      return resultCheck;
    }
  }

  void setDataFirebseLogin({context, required String name, required String profilePic, required String mobile}) async {


    AuthService authService = AuthService();
    try{
      await authService.signInStroreData(name: name, uid: getData.read("UserLogin")["id"], profilePic: profilePic,  mobileNumber: mobile,);
    } catch (e) {
      print(e);
    }
  }

  Future forgotPassword() async {
    Map body = {
      "mobile": mobile.text,
      "ccode": countryCode,
      "password": password.text,
    };

    var response = await http.post(Uri.parse(Config.path + Config.login),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );
  }
}