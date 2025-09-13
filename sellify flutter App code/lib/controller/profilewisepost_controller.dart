import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/model/profilewisepost_model.dart';
import '../api_config/store_data.dart';

class ProfilewiseController extends GetxController implements GetxService {

  bool isloading = true;
  ProfilewisepostModel? profilewiseData;
  Future getProfilewise({required String profileId}) async {

    Map body = {
      "lats" : getData.read("lat").toString(),
      "longs" : getData.read("long").toString(),
      "uid" : getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "profile_id" : profileId
    };

    var response = await http.post(Uri.parse(Config.path + Config.profilewisepost),
      body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);

      if(result["Result"] == "true"){

        profilewiseData = ProfilewisepostModel.fromJson(result);
        isloading = false;
        update();
      }
    }
  }
}