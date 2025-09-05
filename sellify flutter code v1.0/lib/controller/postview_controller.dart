import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import '../api_config/store_data.dart';

class PostviewController extends GetxController implements GetxService {

  Future getPostview({required String postId}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "post_id": postId
    };

    var response = await http.post(Uri.parse(Config.path + Config.viewpost),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
    }
  }
}