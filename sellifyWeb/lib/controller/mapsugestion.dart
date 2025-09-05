import 'dart:convert';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/api_config/config.dart';
import 'package:sellify/model/mapapimodel.dart';

class MapSuggestGetApiController extends GetxController implements GetxService {

  MapApiModel? mapApiModel;
  bool isLoading = true;
  Future mapApi({required context,required String suggestkey}) async{

    Map<String,String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.get(Uri.parse("${Config.path}${Config.map}?query=$suggestkey",),headers: userHeader);

    var data = jsonDecode(response.body);


    if(data["status"] == "OK"){
      mapApiModel = mapApiModelFromJson(response.body);
      isLoading = false;
      update();
    }
  }
}