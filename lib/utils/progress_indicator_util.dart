import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProgressIndicatorUtil {
  static Logger logger = new Logger();
  static bool isProgressShown = false;
  static BuildContext currentContext;

  static closeProgressIndicator() {
    print('closeProgressAlert........................');
    if (currentContext != null) {
      print('currentContext != null......................');

      // Navigator.pop(currentContext, true);
      // Navigator.of(currentContext).pop();
      Navigator.of(currentContext, rootNavigator: true).pop(true);

      currentContext = null;
    }
  }

  static showProgressIndicator(BuildContext context) {
    // logger.d('showProgressIndicator......');
    // closeProgressIndicator();
    currentContext = context;

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    // isProgressShown = true;
  }

  // static closeProgressIndicator() {
  //   print('closeProgressAlert...');
  //   if (isProgressShown) {
  //     isProgressShown = false;

  //     // Navigator.pop(currentContext, true);
  //     Navigator.of(currentContext).pop();
  //   }
  // }

  // static closeProgressIndicator() {
  //   // logger.d('closeProgressIndicator 2');
  //   // Navigator.of(currentContext).pop(); // not working
  //   Navigator.of(currentContext, rootNavigator: true).pop();
  //   // Navigator.of(currentContext, rootNavigator: true).pop('dialog');
  // }

}
