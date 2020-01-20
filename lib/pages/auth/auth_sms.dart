import 'package:flutter/material.dart';
import 'package:flutter_account_kit/flutter_account_kit.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tolymoly/api/login_api.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class AuthSms extends StatefulWidget {
  final Function onLogin;
  AuthSms(this.onLogin);

  _AuthSmsState createState() => _AuthSmsState();
}

class _AuthSmsState extends State<AuthSms> {
  FlutterAccountKit akt = FlutterAccountKit();

  Future<void> init(BuildContext context) async {
    print('Init account kit called');
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final theme = AccountKitTheme(
          headerBackgroundColor: Colors.green,
          buttonBackgroundColor: Colors.yellow,
          buttonBorderColor: Colors.yellow,
          buttonTextColor: Colors.black87);
      await akt.configure(Config()
        ..facebookNotificationsEnabled = true
        ..receiveSMS = true
        ..readPhoneStateEnabled = true
        ..theme = theme
        ..countryWhitelist = ['MM']
        ..defaultCountry = 'MM'
        ..responseType = ResponseType.code);
    } on PlatformException {
      print('Failed to initialize account kit');
    }

    final result = await akt.logInWithPhone();
    print(result.status);
    print(result.errorMessage);
    print(result.code);
    // logger.d(result.accessToken.token);
    // logger.d(result.accessToken.accountId);
    if (result.status == LoginStatus.cancelledByUser) {
      print('Login cancelled by user');
    } else if (result.status == LoginStatus.error) {
      print('Login error');
    } else {
      ProgressIndicatorUtil.showProgressIndicator(context);

      print('Login success');

      var data = {'code': result.code};
      final response = await LoginApi.postSms(data);
      if (response.statusCode != 200) return;

      // await AuthUtil.saveToken(response.data['token']);
      // await AuthUtil.saveUserId(response.data['id']);

      ProgressIndicatorUtil.closeProgressIndicator();

      widget.onLogin(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        text: 'SMS',
        buttonTypeEnum: ButtonTypeEnum.origin,
        onPressed: () {
          init(context);
        });
  }
}
