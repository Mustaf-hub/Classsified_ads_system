import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/controller/signup_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/model/smstypemodel.dart';

class MsgOtpController extends GetxController implements GetxService {

  SignupController signupController = Get.put(SignupController());

  SmstypeModel? smstypeData;
  Future smstype() async {

    var response = await http.get(Uri.parse(Config.path + Config.smstype),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var smsType = jsonDecode(response.body);
      smstypeData = SmstypeModel.fromJson(smsType);
      update();
      print(" SMS CODE TYPE >>>>>>>>>>>>>> : : : : : :${smsType["SMS_TYPE"]}");
      return smsType;
    }
  }

  bool msgCheck = false;
  String otpCode = "";

  Future sendOtp({required String mobile}) async {

    Map body = {
      "mobile": mobile,
    };

    var response = await http.post(Uri.parse(Config.path + Config.msgotp),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    print("><<<<<<<<<<<<<<<<<<$body");

    if(response.statusCode == 200){
      var msgdecode = jsonDecode(response.body);

      if(msgdecode["Result"] == "true"){

        var msgotpData = jsonDecode(response.body);
        msgCheck = bool.parse(msgotpData["Result"]);
        otpCode = msgotpData["otp"].toString();
        print("><<<<<<<<<<<<<<<<<<$otpCode");
        update();
        return msgdecode;
      } else {
        showToastMessage(msgdecode["ResponseMsg"]);
      }
    } else {
      showToastMessage("Something went wrong!");
    }
  }

  String twilloCode = "";
  bool twillioCheck = false;
  Future twilloOtp({required String mobile}) async {

    Map body = {
      "mobile" : mobile
    };

    var response = await http.post(Uri.parse(Config.path + Config.twillotp),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    print("><<<<<<<<<<<<<<<<<<$body");

    if(response.statusCode == 200){
      var msgdecode = jsonDecode(response.body);

      if(msgdecode["Result"] == "true"){
        print(" OTP CODE : >>> ${msgdecode["otp"]}");
        update();
        return msgdecode;
      } else {
        showToastMessage('Invalid Mobile Number');
      }
    } else {
      showToastMessage("Something went wrong!");
    }
  }

}
