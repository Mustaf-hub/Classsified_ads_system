import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api_config/config.dart';
import '../../api_config/store_data.dart';
import '../../model/filtermodel.dart';

class FiltersController extends GetxController implements GetxService {

  FilterModel? filterData;
  bool isloading = true;

  bool filterUploded = false;

  Future getCarFilter({required String fuel, required String ownerLength, required String transmission, required String sort, required String budgetStart, required String budgetEnd, required String brandId, required String yearStart, required String yearEnd, required String kmStart, required String kmEnd}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : 0,
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : 0,
      "year_start": yearStart.isNotEmpty ? yearStart : 0,
      "year_end": yearEnd.isNotEmpty ? yearEnd : 0,
      "km_start": kmStart.isNotEmpty ? kmStart : 0,
      "km_end": kmEnd.isNotEmpty ? kmEnd : 0,
      "owner_length": ownerLength.isNotEmpty ? ownerLength : 0,
      "fuel": fuel.isNotEmpty ? fuel : 0,
      "transmission": transmission.isNotEmpty ? transmission : 0,
      "sort": sort.isNotEmpty ? sort : 0,
      "brand_id": brandId.isNotEmpty ? brandId : 0,
    };

    var response = await http.post(Uri.parse(Config.path + Config.carfilterpost),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        update();
      } 
    } 
  }

  Future getPropFilter({required String pgsubtype, required String mealIncluded, required String plotareaEnd, required String plotareaStart,required String constStatus, required String propertyListedBy, required String bachelor, required String furnishing, required String bedroom, required String bathroom, required String propertyType, required String buildareaEnd, required String buildareaStart, required String sort, required String budgetStart, required String budgetEnd, required String subcatId,}) async {
    Map rentHousebody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "buildarea_start": buildareaStart.isNotEmpty ? buildareaStart : "0",
      "buildarea_end": buildareaEnd.isNotEmpty ? buildareaEnd : "0",
      "property_type": propertyType.isNotEmpty ? propertyType : "0",
      "property_bedroom": bathroom.isNotEmpty ? bathroom : "0",
      "property_bathroom": bedroom.isNotEmpty ? bedroom : "0",
      "property_furnishing": furnishing.isNotEmpty ? furnishing : "0",
      "bachloar": bachelor.isNotEmpty ? bachelor : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "property_listed_by": propertyListedBy.isNotEmpty
          ? propertyListedBy
          : "0",
      "subcat_id": subcatId,
      "post_type": "renthouse_post"
    };

    Map saleHousebody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "buildarea_start": buildareaStart.isNotEmpty ? buildareaStart : "0",
      "buildarea_end": buildareaEnd.isNotEmpty ? buildareaEnd : "0",
      "property_type": propertyType.isNotEmpty ? propertyType : "0",
      "property_bedroom": bathroom.isNotEmpty ? bathroom : "0",
      "property_bathroom": bedroom.isNotEmpty ? bedroom : "0",
      "property_furnishing": furnishing.isNotEmpty ? furnishing : "0",
      "property_construction_status": constStatus.isNotEmpty
          ? constStatus
          : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "property_listed_by": propertyListedBy.isNotEmpty
          ? propertyListedBy
          : "0",
      "subcat_id": subcatId,
      "post_type": "salehouse_post"
    };

    Map plotbody = {
        "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
        "lats": getData.read("lat").toString(),
        "longs": getData.read("long").toString(),
        "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
        "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
        "plotdarea_start": plotareaStart.isNotEmpty ? plotareaStart : "0",
        "plotdarea_end": plotareaEnd.isNotEmpty ? plotareaEnd : "0",
        "property_type": propertyType.isNotEmpty ? propertyType : "0",
        "sort": sort.isNotEmpty ? sort : "0",
        "property_listed_by":propertyListedBy.isNotEmpty
            ? propertyListedBy
            : "0",
        "subcat_id": subcatId,
        "post_type": "land_post"
      };

    Map rentOfficebody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "buildarea_start": buildareaStart.isNotEmpty ? buildareaStart : "0",
      "buildarea_end": buildareaEnd.isNotEmpty ? buildareaEnd : "0",
      "property_furnishing": furnishing.isNotEmpty ? furnishing : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "property_listed_by": propertyListedBy.isNotEmpty
          ? propertyListedBy
          : "0",
      "subcat_id": subcatId,
      "post_type": "rentoffice_post"
    };

    Map saleOfficebody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "buildarea_start": buildareaStart.isNotEmpty ? buildareaStart : "0",
      "buildarea_end": buildareaEnd.isNotEmpty ? buildareaEnd : "0",
      "property_furnishing": furnishing.isNotEmpty ? furnishing : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "property_listed_by": propertyListedBy.isNotEmpty
          ? propertyListedBy
          : "0",
      "subcat_id": subcatId,
      "property_construction_status": constStatus.isNotEmpty
          ? constStatus
          : "0",
      "post_type": "saleoffice_post"
    };

    Map pgbody = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "pg_subtype": pgsubtype.isNotEmpty ? pgsubtype : "0",
      "property_furnishing": furnishing.isNotEmpty ? furnishing : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "property_listed_by": propertyListedBy.isNotEmpty
          ? propertyListedBy
          : "0",
      "pg_meals_include": mealIncluded.isNotEmpty ? mealIncluded : "0",
      "subcat_id": subcatId,
      "post_type": "pg_post"
    };
    var response = await http.post(
      Uri.parse(Config.path + Config.propFilter),
      body: jsonEncode(subcatId == "1" ? saleHousebody : subcatId == "2"
          ? rentHousebody
          : subcatId == "3" ? plotbody : subcatId == "4"
          ? rentOfficebody
          : subcatId == "5" ? saleOfficebody : pgbody),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (result["Result"] == "true") {
        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 
  }

  Future getmobileFilter({required String brandId, required String subcatId, required String sort, required String budgetStart, required String budgetEnd}) async {

    Map body = {
      "uid": getData.read("UserLogin") != null ? getData.read("UserLogin")["id"] : "0",
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "type_id": brandId.isNotEmpty ? brandId : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "subcat_id": subcatId,
      "post_type": subcatId == "7" ? "mobile_post" : subcatId == "8" ? "accessories_post" : "tablet_post"
    };

    var response = await http.post(Uri.parse(Config.path + Config.mobilefilter),
        body: jsonEncode(body)
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){

        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 
  }

  Future getjobFilter({required String subcatId, required String positionType, required String salaryPeriod, required String sort}) async {

    Map body = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "job_position_type": positionType.isNotEmpty ? positionType : "0",
      "job_salary_period": salaryPeriod.isNotEmpty ? salaryPeriod : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "subcat_id": subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.jobfilter),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 
  }

  Future getBikeFilter({required String sort, required String budgetStart, required String budgetEnd, required String brandId, required String subcatId, required String yearStart, required String yearEnd, required String kmStart, required String kmEnd}) async {

    Map body = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "year_start": yearStart.isNotEmpty ? yearStart : "0",
      "year_end": yearEnd.isNotEmpty ? yearEnd : "0",
      "km_start": kmStart.isNotEmpty ? kmStart : "0",
      "km_end": kmEnd.isNotEmpty ? kmEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "brand_id": brandId.isNotEmpty ? brandId : "0",
      "post_type": subcatId == "26" ? "scooter_post" : "motorcycle_post",
      "subcat_id": subcatId
    };

    Map body2 = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "brand_id": brandId.isNotEmpty ? brandId : "0",
      "post_type":"bicycles_post",
      "subcat_id": subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.bikefilter),
      body: jsonEncode(subcatId == "28" ? body2 : body),
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 
  }

  Future getCommerfilter({required String sort, required String budgetStart, required String budgetEnd, required String brandId, required String yearStart, required String yearEnd, required String subcatId, required String kmStart, required String kmEnd}) async {

    Map vehiclebody = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "year_start": yearStart.isNotEmpty ? yearStart : "0",
      "year_end": yearEnd.isNotEmpty ? yearEnd : "0",
      "km_start": kmStart.isNotEmpty ? kmStart : "0",
      "km_end": kmEnd.isNotEmpty ? kmEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "brand_id": brandId.isNotEmpty ? brandId : "0",
      "post_type":"commercial_post",
      "subcat_id": subcatId
    };

    Map spareSpartBody = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "brand_id": brandId.isNotEmpty ? brandId : "0",
      "post_type":"sparepart_post",
      "subcat_id": subcatId
    };

    var response = await http.post(Uri.parse(Config.path + Config.commerFilter),
      body: jsonEncode(subcatId == "40" ? spareSpartBody : vehiclebody),
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 
  }

  Future getCommonfilter({required String budgetStart, required String budgetEnd, required String sort, required String subcatId, required int catId}) async {

    Map body = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "budget_start": budgetStart.isNotEmpty ? budgetStart : "0",
      "budget_end": budgetEnd.isNotEmpty ? budgetEnd : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "subcat_id": subcatId
    };



    Uri uri = Uri.parse("${Config.path}${catId == 6 ? Config.elecFilter : catId == 8 ? Config.furniturefilter : catId == 9 ? Config.fashionfilter : catId == 10 ? Config.booksportfilter : Config.petfilter}");
    var response = await http.post(
      uri,
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 
  }

  Future getserviceFilter({required String subcatId, required String sort, required String byType}) async {

    Map body = {
      "uid": getData.read("UserLogin")["id"],
      "lats": getData.read("lat").toString(),
      "longs": getData.read("long").toString(),
      "type_id": byType.isNotEmpty ? byType : "0",
      "sort": sort.isNotEmpty ? sort : "0",
      "subcat_id": subcatId
    };

    var response = await http.post(
      Uri.parse(Config.path + Config.servicesfilter),
      body: jsonEncode(body),
headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        filterData = FilterModel.fromJson(result);
        isloading = false;
        
        update();
      } 
    } 

  }

}