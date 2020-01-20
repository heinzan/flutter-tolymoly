import 'package:flutter/material.dart';
import 'package:tolymoly/constants/route_constant.dart';

class AuthUtil {
  static bool isLoggedIn = false;
  static int userId = 0;

  static bool validate(BuildContext context) {
    if (!AuthUtil.isLoggedIn) {
      Navigator.of(context).pushNamed(RouteConstant.authTab);

      return false;
    }
    return true;
  }
}
