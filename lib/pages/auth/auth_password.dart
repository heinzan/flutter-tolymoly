import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tolymoly/api/login_api.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/enum/error_code_enum.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class AuthPassword extends StatefulWidget {
  final onLogin;
  AuthPassword(this.onLogin);

  _AuthPasswordState createState() => _AuthPasswordState();
}

class _AuthPasswordState extends State<AuthPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            style: BurmeseUtil.textStyle(context),
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter';
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            obscureText: obscureText, //This will obscure text dynamically
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter';
              }
              return null;
            },
          ),
          // TextFormField(
          //   style: BurmeseUtil.textStyle(context),
          //   controller: passwordController,
          //   decoration: InputDecoration(labelText: 'Password'),
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return 'Please enter';
          //     }
          //     return null;
          //   },
          // ),
          SizedBox(height: 10),
          CustomButton(
            onPressed: () async {
              if (!_formKey.currentState.validate()) return;

              String username = usernameController.text.trim();
              String password = passwordController.text.trim();

              Response response;

              try {
                response = await LoginApi.postPassword(username, password);
              } on DioError catch (e) {
                if (e.response.statusCode == 401) {
                  String message = e.response.data['message'];

                  if (message != null &&
                      message.contains(
                          '[${ErrorCodeEnum.InvalidUsernameOrPassword.index}]'))
                    ToastUtil.error(
                        LocaleUtil.get(LabelConstant.wrongUsernameOrPassword));
                  return;
                } else {
                  HttpUtil.validateResponse(e.response);
                }
              }

              if (response.statusCode != 200) return;

              widget.onLogin(response.data);
            },
            text: 'Login',
            buttonTypeEnum: ButtonTypeEnum.origin,
          )
        ],
      ),
    );
  }
}
