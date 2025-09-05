import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:sellify/utils/colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';


PackageInfo? packageInfo;
String? appName;
String? packageName;

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
                SizedBox(height: 20),
                SizedBox(
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
  print("!!!!!.+_.-.-._+.!!!!!" + appName.toString());
  print("!!!!!.+_.-.-._+.!!!!!" + packageName.toString());

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
  return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(selected == true ? Colors.transparent : containcolor),
              elevation: WidgetStatePropertyAll(0),
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
        readOnly: readStatus == null ? false : readStatus,
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
          prefix: prefixIcon == null ? SizedBox() : Image.asset(prefixIcon, scale: 3,),
          suffixIcon: suffixIcon == null ? SizedBox() : Image.asset("${visible ? suffix2 : suffixIcon}", color: visible ? BlackColor : lightGreyColor, scale: 3,),
          helperText: helperText,
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
          readOnly: readStatus == null ? false : readStatus,
          onTap: onPressed1,
          style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifier.textfield,
            hintText: hinttext,
            hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
            prefix: prefixIcon == null ? SizedBox() : Image.asset(prefixIcon, scale: 3,),
            suffixIcon: suffixIcon == null ? SizedBox() : Image.asset("${visible ? suffix2 : suffixIcon}", color: visible ? BlackColor : lightGreyColor, scale: 3,),
            helperText: helperText,
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
      print("SDSDSDSDSDSDSDSD ${loginController.countryCode}");
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
            prefix: prefixIcon == null ? SizedBox() : Image.asset(prefixIcon, height: 20,),
            suffixIcon: suffixIcon == null ? SizedBox() : InkWell(
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
        );
      }
  );
}

Widget shimmer({context, required Color baseColor, double? height, double? width}){
  notifier = Provider.of<ColorNotifire>(context, listen: true);
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: notifier.isDark ? Color(0xFF475569) : Color(0xFFeaeff4),
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

 Route ScreenTransDown({context, required Widget routes}) {
   return PageRouteBuilder(
     pageBuilder: (context, animation, secondaryAnimation) {
       return routes;
     },
     transitionsBuilder: (context, animation, secondaryAnimation, child) {
       const begin = Offset(0.0, 1.0);
       const end = Offset.zero;
       const curve = Curves.ease;
       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
       return SlideTransition(
         position: animation.drive(tween),
         child: child,
       );
     },
   );
 }

 Route ScreenTransRight({context, required Widget routes}) {
   return PageRouteBuilder(
     pageBuilder: (context, animation, secondaryAnimation) {
       return routes;
     },
     transitionsBuilder: (context, animation, secondaryAnimation, child) {
       const begin = Offset(1.0, 0.0);
       const end = Offset.zero;
       const curve = Curves.ease;
       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
       return SlideTransition(
         position: animation.drive(tween),
         child: child,
       );
     },
   );
 }

Future unFavBottomSheet({context, required String image, required String title, required String description, required String price, required void Function() removeFun}){
  return Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
          color: notifier.getBgColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
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
            SizedBox(height: 20),
            Text("Remove from Favourite?".tr,style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 18),),
            SizedBox(height: 20),
            Divider(color: backGrey, thickness: 1,),
            SizedBox(height: 20),
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
                SizedBox(width: 10,),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyBold, fontSize: 16),overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 5,),
                      Text(description,style: TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 5,),
                      Text(price,style: TextStyle(color: PurpleColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                  SizedBox(width: 10),
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
            SizedBox(height: 20,),
          ],
        ),
      ),
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

  print("FORMATTTT $formatted");
  for(int i = length-1; i >= 0; i--){
    formatted = priceStr[i] + formatted;
    count++;

    print("I VA<LUREE  $i");
    if (count == 3 && i > 0) {
      print("I VA<LUREE  $i");
      formatted = ",$formatted";
    } else if (count > 3 && (count - 3) % 2 == 0 && i > 0) {

      print("Lengtthhht ++ ++  > >$count");
      formatted = ",$formatted";
    }
  }
  return formatted;
}

String formatChatDate(DateTime dbDate) {

  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));

  print("C CODE DATE $dbDate");
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
      formatted = ',' + remaining.substring(remaining.length - 2) + formatted;
      remaining = remaining.substring(0, remaining.length - 2);
    }

    return remaining + formatted + ',' + lastThree;
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


class CustomBehavior extends ScrollBehavior {

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, _) {
    // TODO: implement buildOverscrollIndicator
    return child;
  }
}