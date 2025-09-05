import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/myadlist_controller.dart';
import 'package:sellify/controller/postad/properties_cont.dart';
import 'package:sellify/controller/postad_controller.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class AddpriceScreen extends StatefulWidget {
  const AddpriceScreen({super.key});

  @override
  State<AddpriceScreen> createState() => _AddpriceScreenState();
}

class _AddpriceScreenState extends State<AddpriceScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("SB ID $subcatID");
    if(postingType == "Edit"){
      setState(() {
        adindex = Get.arguments["adIndex"];
        priceStr = myadlistCont.myadlistData!.myadList![adindex].adPrice!;
        price.text = addCommas(myadlistCont.myadlistData!.myadList![adindex].adPrice!);
      });
    }
  }

  TextEditingController price = TextEditingController();

  PostadController postadController = Get.find();
  PropertiesController propertiesCont = Get.find();
  MyadlistController myadlistCont = Get.find();

  late ColorNotifire notifier;

  final _formKey = GlobalKey<FormState>();

  String subcatID = Get.arguments["subcatId"];
  String postingType = Get.arguments["postingType"];
  int adindex = 0;

  String priceStr = "";
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.getBgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/arrowLeftIcon.png", color: notifier.iconColor, scale: 3,),
          ),
        ),
        title: Text("Set a price".tr, style: TextStyle(fontSize: 20, fontFamily: FontFamily.gilroyBold, color: BlackColor),),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: mainButton(containcolor: PurpleColor, context: context, txt1: "Next".tr, onPressed1: () {

          if (_formKey.currentState!.validate()) {
              if (price.text.isNotEmpty) {
                Get.toNamed(Routes.addlocationScreen, arguments: {
                  "subcatId" : subcatID,
                  "price" : priceStr,
                  "adIndex" : adindex,
                  "postingType" : postingType,
                  "route" : Routes.addpriceScreen,
                });
              } else {
              showToastMessage("Please select the transmission type of your vehicle".tr);
            }
          }
        },),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
              inputFormatters: [TextFormat()],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Price is required, Please enter price.".tr;
                }
                return null;
              },
              onChanged: (value) {
                priceStr = price.text.replaceAll(",", "");
                setState(() {});
                print("PRICE TEXT ${priceStr}");
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: notifier.textfield,
                hintText: "Add price".tr,
                hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                helperText: "Add price".tr,
                helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: PurpleColor),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(16)
                ),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(16)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
        ),
      ),
    );
  }
}
