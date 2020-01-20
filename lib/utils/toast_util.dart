import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class ToastUtil {
  static success() {
    _show(LocaleUtil.get('Success'), Colors.green, 3, ToastPosition.top);
  }

  static error(String text) {
    _show(text, Colors.red, 3, ToastPosition.top);
  }

  static info(String text) {
    _show(text, Colors.blue, 3, ToastPosition.top);
  }

  static noMoreData() {
    _show('No more data', Colors.blue, 3, ToastPosition.center);
  }

  // static pending() {
  //   _show('Successful, Please wait for approval, it may take 1 day or more',
  //       Colors.green, 3);
  // }

  static _show(String text, Color color, int seconds, ToastPosition position) {
    showToast(text,
        position: position,
        backgroundColor: color,
        radius: 3.0,
        textStyle: TextStyle(fontSize: 20),
        duration: Duration(seconds: seconds));
  }
}
