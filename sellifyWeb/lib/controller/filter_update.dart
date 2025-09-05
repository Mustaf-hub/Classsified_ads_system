import 'package:get/get.dart';

class FilterupdateController extends GetxController {

  List selectedFiltersList = [];
  List selectedFiltersListData = [];

  String sendData = "";
 Future updateCheckbox({String? selectedData, required String checkData, required List filterData}) async {
    if(selectedFiltersList.contains(checkData)) {
      selectedFiltersList.remove(checkData);
      selectedFiltersListData.remove(selectedData);

      sendData = filterData.join(',');
      update();
    } else {
      selectedFiltersList.add(checkData);
      selectedFiltersListData.add(selectedData);
      sendData = filterData.join(',');
      update();
    }

  update();
    return sendData;
  }

  String selected = "";
  Future updateSelection({required String optionsList, }) async {
    if(selectedFiltersList.contains(optionsList)){
      selectedFiltersList.remove(optionsList);
      selected = "";
      update();
    } else {
      if (selectedFiltersList.contains(selected)) {
        selectedFiltersList.remove(selected);
        selectedFiltersList.add(optionsList);
        selectedFiltersListData.remove(selected);
        selectedFiltersListData.add(optionsList);
        selected = optionsList;
      } else {
        selectedFiltersList.add(optionsList);
        selectedFiltersListData.add(optionsList);
        selected = optionsList;
        update();
      }
    }
    return selected;
  }

  String range = "";
  Future updateSlider({required String sliderData}) async {
    if(selectedFiltersList.contains(range)){
      selectedFiltersList.remove(range);
      selectedFiltersListData.remove(range);
      selectedFiltersListData.add(sliderData);
      selectedFiltersList.add(sliderData);
      range = sliderData;
      update();
    } else {
        selectedFiltersList.add(sliderData);
        selectedFiltersListData.add(sliderData);
        range = sliderData;
        update();
    }
    return range;
  }

}