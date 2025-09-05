import 'dart:convert';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/controller/signup_controller.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellify/screens/home_screen.dart';
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


PackageInfo? packageInfo;
String? appName;
String? packageName;

Widget footer(context){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return LayoutBuilder(
    builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: notifier.getWhiteblackColor,
            borderRadius: BorderRadius.circular(18)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100,),
              Text("Contact Us", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor)),
              const SizedBox(height: 20,),
              RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                    text: "Let's",
                    style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: greyText),
                  children: [
                    TextSpan(
                      text: " discuss ",
                      style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor),
                      children: [
                        TextSpan(
                          text: "your",
                          style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: greyText),
                        )
                      ]
                    )
                  ]
                ),
              ),
              const SizedBox(height: 6,),
              constraints.maxWidth < 600 ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("vision ", style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: greyText),),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: PurpleColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Text("LET'S TALK", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: WhiteColor),),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PurpleColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("assets/arrow-right.png", height: 16, color: WhiteColor,),
                        ),
                      ),
                    ],
                  ),
                 Text("with us", style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor),),
                ],
              ) : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("vision ", style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: greyText),),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: PurpleColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Text("LET'S TALK", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: WhiteColor),),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PurpleColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset("assets/arrow-right.png", height: 16, color: WhiteColor,),
                    ),
                  ),
                  Text(" with us", style: TextStyle(fontSize: 40, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor),),
                ],
              ),
              const SizedBox(height: 10,),
              Divider(
                color: lightGreyColor,
                thickness: 2,
              ),
              const SizedBox(height: 10,),
              constraints.maxWidth < 600 ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(const HomePage(), transition: Transition.noTransition);
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/sellifyLogo.png", height: 30,),
                        Text("Sellify", style: TextStyle(fontSize: 30, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text("© Sellify 2025, All Rights Reserved", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: greyText)),
                ],
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(const HomePage(), transition: Transition.noTransition);
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/sellifyLogo.png", height: 30,),
                        Text("Sellify", style: TextStyle(fontSize: 30, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor)),
                      ],
                    ),
                  ),
                  Text("© Sellify 2025, All Rights Reserved", style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: greyText)),
                ],
              ),
              const SizedBox(height: 100,),
            ],
          ),
        ),
      );
    }
  );
}

Widget backAppbar({String? title, void Function()? fun, String? isFeatured}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: notifier.getWhiteblackColor,
    ),
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        InkWell(
            onTap: fun,
            child: Image.asset("assets/arrowLeftIcon.png", height: 25, color: notifier.iconColor,)),
        const SizedBox(width: 10,),
        title == null ? const SizedBox() : Expanded(
          child: Row(
            children: [
              const SizedBox(width: 20,),
              Text(title,style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 18, color: notifier.getTextColor,),),
              const SizedBox(width: 20,),
            ],
          ),
        ),
        isFeatured == null || isFeatured == "0" ? const SizedBox() : const Spacer(),
        isFeatured == null || isFeatured == "0" ? const SizedBox() : Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30)
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text("Featured".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: WhiteColor),),
        )
      ],
    ),
  );
}

String getAddress({required String address}){
  String myaddress = "";
  List partArea = address.split(", ");
  if(partArea[0] != "") {
    myaddress = " $address";
  } else {
    myaddress = " ${partArea[1]}, ${partArea[2]}";
  }
  return myaddress;
}

Future popupPayment(){
  return Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                   size: 30,
                   color: PurpleColor,
                 ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  child: Text(
                    'Please don`t press back until the transaction is complete',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5),
                  ),
                ),
              ],
            );
          }
      ),
    ),
    barrierDismissible: false,
  );
}

void getPackage() async {
  //! App details get
  packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo!.appName;
  packageName = packageInfo!.packageName;
}

Future<void> share() async {

  final String text =
      'Hey! Now use our app to share with your family or friends. '
      'Download $appName app and sale your items';

  final String linkUrl = 'https://play.google.com/store/apps/details?id=$packageName';

  await Share.share(
    '$text\n$linkUrl',
    subject: appName,
  );
}
Widget mainButton({String? txt1,String? txt2,required Color containcolor, bool? loading, bool? selected, context, required void Function() onPressed1}){
  return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(selected == true ? Colors.transparent : containcolor),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(side: BorderSide(color: selected == true ? PurpleColor : Colors.transparent), borderRadius: BorderRadius.circular(26)),
              ),
          ),
          onPressed: onPressed1,
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: (loading != null && loading) ? 12 : 18),
        child: (loading != null && loading) ? LoadingAnimationWidget.staggeredDotsWave(
          size: 30,
          color: WhiteColor,
        )
            : Text(txt1!, style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontWeight: FontWeight.w600, color: selected == true ? PurpleColor : WhiteColor, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis,),
      )),
  );
}

late ColorNotifire notifier;
bool visible = true;
bool focused = false;

Widget textFeild({String? validMsg ,int? maxlength, bool? readStatus, context,void Function()? onPressed1, void Function(String)? onPressed2, String? hinttext, TextInputType? textInputType, required TextEditingController textController, String? helperText, String? prefixIcon, String? suffixIcon, String? suffix2}){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        controller: textController,
        keyboardType: textInputType,
        maxLength: maxlength,
        readOnly: readStatus ?? false,
        onTap: onPressed1,
        onChanged: onPressed2,
        style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validMsg;
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: notifier.textfield,
          hintText: hinttext,
          hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
          prefix: prefixIcon == null ? const SizedBox() : Image.asset(prefixIcon, scale: 3,),
          suffixIcon: suffixIcon == null ? const SizedBox() : Image.asset("${visible ? suffix2 : suffixIcon}", color: visible ? BlackColor : lightGreyColor, scale: 3,),
          helperText: helperText,
          helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: PurpleColor),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16)
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(16)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16)
          ),
        ),
      );
    }
  );
}

Widget optextFeild({String? validMsg ,int? maxlength, bool? readStatus, context,void Function()? onPressed1, String? hinttext, TextInputType? textInputType, required TextEditingController textController, String? helperText, String? prefixIcon, String? suffixIcon, String? suffix2}){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: textController,
          keyboardType: textInputType,
          maxLength: maxlength,
          readOnly: readStatus ?? false,
          onTap: onPressed1,
          style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifier.textfield,
            hintText: hinttext,
            hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
            prefix: prefixIcon == null ? const SizedBox() : Image.asset(prefixIcon, scale: 3,),
            suffixIcon: suffixIcon == null ? const SizedBox() : Image.asset("${visible ? suffix2 : suffixIcon}", color: visible ? BlackColor : lightGreyColor, scale: 3,),
            helperText: helperText,
            helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: PurpleColor),
            ),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
          ),
        );
      }
  );
}

SignupController signupController = Get.put(SignupController());
LoginController loginController = Get.put(LoginController());

Widget phoneField({required TextEditingController mobileNumber, String? hintText, String? countryCode, context }){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return IntlPhoneField(
    style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
    controller: mobileNumber,
    onChanged: (value) {

      loginController.countryCode = value.countryCode;
      signupController.countryCode = value.countryCode;
      countryCode = value.countryCode;
    },
    initialCountryCode: "IN",
    disableLengthCheck: true,
    showCountryFlag: false,
    showDropdownIcon: false,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    dropdownIcon: Icon(
      Icons.arrow_drop_down,
      color: lightGreyColor,
    ),
    dropdownTextStyle: TextStyle(fontSize: 14, fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      filled: true,
      fillColor: notifier.textfield,
      hintText: hintText,
      hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: PurpleColor),
      ),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(16)
      ),
      disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(16)
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(16)
      ),
    ),
  );
}

Widget passTextFeild({String? validMsg, TextInputType? textInputType, FocusNode? focusnode,context, String? hinttext, required TextEditingController textController, String? prefixIcon, String? suffixIcon, String? suffix2}){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: textController,
          obscureText: visible,
          focusNode: focusnode,
          keyboardType: textInputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validMsg;
            }
            return null;
          },
          style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration
            (
            filled: true,
            fillColor: notifier.textfield,
            hintText: hinttext,
            hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
            prefix: prefixIcon == null ? const SizedBox() : Image.asset(prefixIcon, height: 20,),
            suffixIcon: suffixIcon == null ? const SizedBox() : InkWell(
              onTap: () {
                setState((){
                   visible = !visible;
                });
              },
              child: Image.asset("${visible ? suffix2 : suffixIcon}", color: (focusnode!.hasFocus && notifier.isDark) ? notifier.iconColor : focusnode.hasFocus ? BlackColor : lightGreyColor, scale: 3,),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: PurpleColor),
            ),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16)
            ),
          ),
        );
      }
  );
}

Widget shimmer({context, required Color baseColor, double? height, double? width}){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: notifier.isDark ? const Color(0xFF475569) : const Color(0xFFeaeff4),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: notifier.getWhiteblackColor,
          border: Border.all(color: backGrey),
          borderRadius: BorderRadius.circular(12)
      ),
    ),
  );
}

 Route screenTransDown({context, required Widget routes}) {
   return PageRouteBuilder(
     pageBuilder: (context, animation, secondaryAnimation) {
       return routes;
     },
   );
 }

 Route screenTransRight({context, required Widget routes}) {
   return PageRouteBuilder(
     pageBuilder: (context, animation, secondaryAnimation) {
       return routes;
     },
   );
 }

Future unFavBottomSheet({context, required String image, required String title, required String description, required String price, required void Function() removeFun}){
  return Get.bottomSheet(
    backgroundColor: Colors.transparent,
    LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 0),
          child: Container(
            decoration: BoxDecoration(
                color: notifier.getBgColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  Center(
                    child: Container(
                      width: 40,
                      height: 8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: lightGreyColor
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Remove from Favourite?".tr,style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 18),),
                  const SizedBox(height: 20),
                  Divider(color: backGrey, thickness: 1,),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return shimmer(baseColor: notifier.shimmerbase2, height: 120, context: context);
                            },
                            image: image,
                            placeholder:  "assets/ezgif.com-crop.gif",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 16),overflow: TextOverflow.ellipsis,),
                            const SizedBox(height: 5,),
                            Text(description,style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),overflow: TextOverflow.ellipsis,),
                            const SizedBox(height: 5,),
                            Text(price,style: TextStyle(color: PurpleColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: mainButton(
                            context: context,
                            txt1: "Cancel".tr,
                            selected: true,
                            containcolor: Colors.transparent,
                            onPressed1: () {
                              Get.back();
                            },),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: mainButton(
                              context: context,
                              txt1: "Yes, Remove".tr,
                              containcolor: PurpleColor,
                              onPressed1: removeFun,
                            )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        );
      }
    ),
  );
}

showToastMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: BlackColor.withOpacity(0.9),
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

String addCommas(String priceStr){
  int length = priceStr.length;

  if(length <= 3) return priceStr;


  String formatted = "";
  int count = 0;

  for(int i = length-1; i >= 0; i--){
    formatted = priceStr[i] + formatted;
    count++;
    if (count == 3 && i > 0) {
      formatted = ",$formatted";
    } else if (count > 3 && (count - 3) % 2 == 0 && i > 0) {
      formatted = ",$formatted";
    }
  }
  return formatted;
}

String formatChatDate(DateTime dbDate) {

  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));

  if (DateFormat('yyyy-MM-dd').format(dbDate) == DateFormat('yyyy-MM-dd').format(now)) {
    return "Today";
  } else if (DateFormat('yyyy-MM-dd').format(dbDate) == DateFormat('yyyy-MM-dd').format(yesterday)) {
    return "Yesterday";
  } else {
    return DateFormat("dd MMM yyyy").format(dbDate).replaceFirst(" ", "");
  }
}

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat("dd MMM yyyy").format(date);
}

class TextFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(',', ''); // Remove existing commas
    if (newText.isEmpty) return newValue;

    String formattedText = _formatIndianNumber(newText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatIndianNumber(String input) {
    int value = int.tryParse(input) ?? 0;
    String numStr = value.toString();

    if (numStr.length <= 3) return numStr;

    String lastThree = numStr.substring(numStr.length - 3);
    String remaining = numStr.substring(0, numStr.length - 3);

    String formatted = '';
    while (remaining.length > 2) {
      formatted = ',${remaining.substring(remaining.length - 2)}$formatted';
      remaining = remaining.substring(0, remaining.length - 2);
    }

    return '$remaining$formatted,$lastThree';
  }
}

List<int> generatePercentageValues(int baseValue, {int count = 4}) {
  List<int> values = [];

  List<double> percentages = [-0.20, -0.10, -0.05, 0.05, 0.10, 0.20];
  List<double> lessPercentages = [-0.02, -0.01,  -0.005, 0.005, 0.01, 0.02];

  for (var percentage in (baseValue.toString().length >= 6 ? lessPercentages : percentages)) {
    int newValue = (baseValue * (1 + percentage)).round();
    values.add(newValue);
  }

  values.sort();

  return values;
}

Future<bool> paymentCheck({required String status,}) async {
  if(status == "successful"){
    return true;
  } else if(status == "COMPLETED") {
    return true;
  } else if(status == "success"){
    return true;
  } if(status == "Payment_was_successful"){
    return true;
  } else if(status == "capture"){
    return true;
  } else if(status == "Completed"){
    return true;
  } else if(status == "TXN_SUCCESS") {
    return true;
  } else if(status == "complete") {
    return true;
    } else if(status == "completed"){
    return true;
    } else {
    return false;
  }
}

Future storeValues({required Map postdata}) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString("postData", jsonEncode(postdata));
}

ConfettiController confettiController = ConfettiController();
Widget confet(){
  return ConfettiWidget(
      confettiController: confettiController,
    blastDirectionality: BlastDirectionality.directional,
    blastDirection: BorderSide.strokeAlignCenter,
    emissionFrequency: 0.2,
    numberOfParticles: 50,
    maxBlastForce: 5,
  );
}

class CustomBehavior extends ScrollBehavior {

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, details) {
    // TODO: implement buildOverscrollIndicator
    return child;
  }
}