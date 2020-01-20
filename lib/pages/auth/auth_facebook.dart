import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:tolymoly/api/login_api.dart';
import 'package:tolymoly/constants/route_constant.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/utils/progress_indicator_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class AuthFacebook extends StatelessWidget {
  final Function onLogin;
  AuthFacebook(this.onLogin);

  void init(BuildContext context) async {
    print('login......');
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    // print('facebookLoginResult.errorMessage: ' +
    //     facebookLoginResult.errorMessage);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        final token = facebookLoginResult.accessToken.token;
        print(token);
        _loginBackend(context, token);
        // onLoginStatusChanged(true);
        break;
    }
  }

  void _loginBackend(BuildContext context, var token) async {
    ProgressIndicatorUtil.showProgressIndicator(context);

    var data = {'id': new DateTime.now().toString(), 'accessToken': token};
    final response = await LoginApi.postFacebook(data);
    if (response.statusCode != 200) return;

    ProgressIndicatorUtil.closeProgressIndicator();

    onLogin(response.data);

    // await AuthUtil.saveToken(response.data['token']);
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    // setState(() {
    //   this.isLoggedIn = isLoggedIn;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        text: 'Facebook',
        buttonTypeEnum: ButtonTypeEnum.facebook,
        onPressed: () {
          init(context);
        });
    // return Padding(
    //     padding: EdgeInsets.all(10),
    //     child: CustomButton(
    //         text: 'Facebook',
    //         buttonTypeEnum: ButtonTypeEnum.facebook,
    //         onPressed: () {
    //           init(context);
    //         }));
  }
}
