import 'package:flutter/material.dart';
import 'package:sellify/utils/colors.dart';

class ColorNotifire with ChangeNotifier {
  bool isDark = false;
  void setIsDark(value) {
    isDark = value;
    notifyListeners();
  }

  get getIsDark => isDark;
  get getBgColor => isDark ? bgcolor : background;
  get getTextColor => isDark ? WhiteColor : BlackColor;
  get getWhiteblackColor => isDark ? whiteblack : WhiteColor;
  get borderColor => isDark ? borderDark : searchBorder;
  get iconColor => isDark ? darkcircleGrey : GreyColor;
  get textfield => isDark ? whiteblack : textFieldInput;
  get shimmerbase => getWhiteblackColor;
  get shimmerbase2 => isDark ? Colors.black45 : Colors.grey.shade200;
}
