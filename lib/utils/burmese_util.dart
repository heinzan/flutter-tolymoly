import 'package:flutter/material.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:zawgyi_converter/zawgyi_converter.dart';

class BurmeseUtil {
  static ZawgyiConverter zawgyiConverter = ZawgyiConverter();

  static bool isZawgyi() {
    return UserPreferenceUtil.keyboardTypeEnum == KeyboardTypeEnum.Zawgyi
        ? true
        : false;
  }

  static String toUnicode(String text) {
    return isZawgyi() ? zawgyiConverter.zawgyiToUnicode(text) : text;
  }

  static String toZawgyi(String text) {
    return isZawgyi() ? zawgyiConverter.unicodeToZawgyi(text) : text;
  }

  static TextStyle textStyle(BuildContext context) {
    return isZawgyi()
        ? TextStyle(fontFamily: 'Zawgyi')
        : TextStyle(fontFamily: 'Unicode');
  }
}
