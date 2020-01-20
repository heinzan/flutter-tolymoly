import 'package:flutter/material.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';

class DialogUtil {
  static Future<bool> confirmation(BuildContext context, String title) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: const Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text(LocaleUtil.get(LabelConstant.cancel)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }
}
