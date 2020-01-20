import 'package:flutter/material.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/models/user_model.dart';
import 'package:tolymoly/pages/auth/auth_facebook.dart';
import 'package:tolymoly/pages/auth/auth_password.dart';
import 'package:tolymoly/pages/auth/auth_sms.dart';
import 'package:tolymoly/pages/home/home_bottom_navigation.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'package:tolymoly/utils/toast_util.dart';

class AuthLogin extends StatefulWidget {
  final showPassword;

  AuthLogin.register() : showPassword = false;
  AuthLogin.login() : showPassword = true;

  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  UserService _userService = new UserService();
  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List();
    list.add(AuthFacebook(onLogin));
    // list.add(SizedBox(height: 20));
    // list.add(AuthSms(onLogin));
    if (widget.showPassword) {
      list.add(SizedBox(height: 20));
      list.add(Text('OR'));
      list.add(SizedBox(height: 20));
      list.add(AuthPassword(onLogin));
      list.add(SizedBox(height: 250)); // to avoid keyboard
    }
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: list,
            )));
  }

  onLogin(Map data) async {
    // _showMaterialDialog();
    bool userSaved = await _userService.login(UserModel.fromJson(data));

    if (!userSaved) {
      ToastUtil.error('Error: save user to db');

      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
