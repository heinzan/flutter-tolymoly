import 'package:flutter/material.dart';
import 'package:tolymoly/api/user_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';
import 'package:tolymoly/enum/button_type_enum.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  UserService userService = new UserService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleUtil.get('Password')),
            backgroundColor: ColorConstant.primary,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text(LocaleUtil.get('New password'),
                  style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 4.0),
                child: TextField(
                  controller: passwordController,
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0 , top: 4),
                child: Text(LocaleUtil.get('At least or more characters')  ,
                    style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0 , top: 4),
                child: Text(LocaleUtil.get('At least number'),
    style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CustomButton(
                      onPressed: () {
                        _updatePassword(passwordController.text);
                      },
                      text: LocaleUtil.get('Submit'),
                      buttonTypeEnum: ButtonTypeEnum.primary)),
            ],
          )),
      onWillPop: () async {
        return _discardAlert(context);
        // return true;
      },
    );
  }

  Future _updatePassword(String text) async {
    RegExp(r'^(?=.*[0-9])(?=\S+$).{8,40}$').hasMatch(text)
        ? changePassword(text)
        : ToastUtil.error('Invalid Password');
  }

  Future changePassword(String text) async {
    var response;
    response = await UserApi.putPassword(text);
    if (response.statusCode == 200) {
      ToastUtil.success();
      _updateDb();

      Navigator.of(context).pop();
    } else {
      ToastUtil.error('Something wrong.Try again');
    }
  }

  void _updateDb() async {
    var responseData = await UserApi.getUserProfile();
    bool isUpdateDb = await userService.update(responseData);
  }

  Future<bool> _discardAlert(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discard any changes to this Password?'),
          content: const Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text(LocaleUtil.get('Cancel')),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text(LocaleUtil.get('OK')),
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
