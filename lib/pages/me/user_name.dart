import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/api/user_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/enum/error_code_enum.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:flutter/services.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:dio/dio.dart';

class UserName extends StatefulWidget {
  final String _userName;

  UserName(this._userName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserNameState();
  }
}

class _UserNameState extends State<UserName> {
  TextEditingController txtController;

  UserService userProfileService = new UserService();

  @override
  void initState() {
    // TODO: implement initState
    txtController =
        new TextEditingController(text: BurmeseUtil.toZawgyi(widget._userName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () async {
          return _discardAlert(context);
          // return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              // title: new Text(widget.data['categoryName']),
              title: new Text(LocaleUtil.get('User name')),
              backgroundColor: ColorConstant.primary,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(12.0)),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: new TextField(
                      style: BurmeseUtil.textStyle(context),
                      autofocus: true,
                      controller: txtController,
                      maxLength: 20,
                      maxLines: null,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 2, left: 10),
                      child: Text(
                        LocaleUtil.get('Letternumberunderscoreperiodsonly'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 2, left: 10),
                    child: Text(
                      LocaleUtil.get('Nomorethanoneunderscore'),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2, left: 10),
                    child: Text(
                      LocaleUtil.get('Letternumbercharacters'),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: CustomButton(
                            onPressed: () {
                              _updateName(txtController.text);
                            },
                            text: 'Submit',
                            buttonTypeEnum: ButtonTypeEnum.primary)),
                  ),
                ],
              ),
            )));
  }

  void _updateDb() async {
    var responseData = await UserApi.getUserProfile();
    bool isUpdateDb = await userProfileService.update(responseData);

    if (!isUpdateDb) return;
  }

  Future<bool> _discardAlert(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discard any changes to this Description?'),
          content: const Text(''),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  _updateName(String text) {
    RegExp(r'^(?=.{5,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$')
            .hasMatch(text)
        ? changeName(text)
        : ToastUtil.error('Invalid user name');
  }

  Future changeName(String text) async {
    var response;

    try {
      response = await UserApi.putName(text);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.

      if (e.response.statusCode == 400) {
        String message = e.response.data['message'];

        if (message == null) return null;

        if (message.contains('[${ErrorCodeEnum.InvalidUsername.index}]')) {
          ToastUtil.error(LocaleUtil.get(LabelConstant.invalidUsername));
        } else if (message
            .contains('[${ErrorCodeEnum.UsernameExists.index}]')) {
          ToastUtil.error(LocaleUtil.get(LabelConstant.usernameExists));
        }

        return null;
      }
    }

    if (response.statusCode == 200) {
      _updateDb();
      ToastUtil.success();

      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else {
      return ToastUtil.error("Invalid Username");
    }
  }
}
