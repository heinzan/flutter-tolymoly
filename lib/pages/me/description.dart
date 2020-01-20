import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tolymoly/api/user_api.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/utils/toast_util.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/burmese_util.dart';
import 'package:flutter/services.dart';
import 'package:tolymoly/constants/color_constant.dart';

class Description extends StatefulWidget {
  final String hint;

  Description(this.hint);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DescriptionState();
  }
}

class _DescriptionState extends State<Description> {
  TextEditingController txtController;

  UserService userProfileService = new UserService();

  @override
  void initState() {
    // TODO: implement initState
    txtController =
        new TextEditingController(text: BurmeseUtil.toZawgyi(widget.hint));
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
              title: new Text(LocaleUtil.get('Description')),
              backgroundColor: ColorConstant.primary,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(12.0)),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: new TextField(
                      style: BurmeseUtil.textStyle(context),
                      autofocus: true,
                      controller: txtController,
                      maxLength: 1500,
                      maxLines: null,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: CustomButton(
                            onPressed: () {
                              _updateDescription(txtController.text);
                            },
                            text: LocaleUtil.get('Submit'),
                            buttonTypeEnum: ButtonTypeEnum.primary)),
                  ),
                ],
              ),
            )));
  }

  Future _updateDescription(String text) async {
    var response;
    response = await UserApi.putDescription(text);

    if (response.statusCode == 200) {
      ToastUtil.success();
      _updateDb();

      Navigator.of(context).pop();
    }
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
          title: Text(LocaleUtil.get('Discard any changes')),
          content: const Text(''),
          actions: <Widget>[
            FlatButton(
              child:  Text(LocaleUtil.get('Cancel')),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text(LocaleUtil.get('Ok')),
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
