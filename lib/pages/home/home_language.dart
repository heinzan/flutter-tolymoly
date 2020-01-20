import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/constants/label_constant.dart';
import 'package:tolymoly/enum/button_type_enum.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/services/user_preference_service.dart';
import 'package:tolymoly/utils/locale/locale_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';
import 'package:tolymoly/widgets/custom_button.dart';

class HomeLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeLanguageState();
  }
}

class HomeLanguageState extends State<HomeLanguage> {
  UserPreferenceService userPreferenceService = new UserPreferenceService();
  int _groupValueDisplayLanguage =
      UserPreferenceUtil.displayLanguageTypeEnum.index;
  int _groupValueKeyboard = UserPreferenceUtil.keyboardTypeEnum.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtil.get('Language')),
        backgroundColor: ColorConstant.primary,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(LocaleUtil.get(LabelConstant.display)),
            // onTap: () {
            //   onTap(LanguageTypeEnum.English.index);
            // },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(LocaleUtil.get('English')),
                Radio(
                  value: DisplayLanguageTypeEnum.English.index,
                  groupValue: _groupValueDisplayLanguage,
                  onChanged: onTapdisplayLanguageType,
                ),
                Text(LocaleUtil.get('Burmese')),
                Radio(
                  value: DisplayLanguageTypeEnum.Burmese.index,
                  groupValue: _groupValueDisplayLanguage,
                  onChanged: onTapdisplayLanguageType,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(LocaleUtil.get(LabelConstant.keyboard)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    child: Row(
                  children: <Widget>[
                    Text(LocaleUtil.get('Zawgyi')),
                    Radio(
                      value: KeyboardTypeEnum.Zawgyi.index,
                      groupValue: _groupValueKeyboard,
                      onChanged: onTapKeyboardType,
                    ),
                  ],
                )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text(LocaleUtil.get('Unicode')),
                    Radio(
                      value: KeyboardTypeEnum.Unicode.index,
                      groupValue: _groupValueKeyboard,
                      onChanged: onTapKeyboardType,
                    ),
                  ],
                )),
              ],
            ),
            // onTap: () {
            //   Navigator.pop(context);
            // },
          ),
          Padding(
              padding: EdgeInsets.all(12),
              child: CustomButton(
                buttonTypeEnum: ButtonTypeEnum.primary,
                text: 'Apply',
                onPressed: _onApply,
              ))
        ],
      ),
    );
  }

  void onTapdisplayLanguageType(value) async {
    // DisplayLanguageTypeEnum displayLanguageTypeEnum;
    // if (value == DisplayLanguageTypeEnum.English.index) {
    //   displayLanguageTypeEnum = DisplayLanguageTypeEnum.English;
    // } else if (value == DisplayLanguageTypeEnum.Burmese.index) {
    //   displayLanguageTypeEnum = DisplayLanguageTypeEnum.Burmese;
    // }

    _groupValueDisplayLanguage = value;

    // await userPreferenceService.updateDisplayLanguage(displayLanguageTypeEnum);

    // Navigator.pop(context);

    setState(() {}); //cannot see the changes becuase already pop
  }

  void onTapKeyboardType(value) async {
    // KeyboardTypeEnum keyboardTypeEnum;
    // if (value == KeyboardTypeEnum.Zawgyi.index) {
    //   keyboardTypeEnum = KeyboardTypeEnum.Zawgyi;
    // } else if (value == KeyboardTypeEnum.Unicode.index) {
    //   keyboardTypeEnum = KeyboardTypeEnum.Unicode;
    // }

    _groupValueKeyboard = value;

    // await userPreferenceService.updateKeyboardType(keyboardTypeEnum);

    // Navigator.pop(context);

    setState(() {}); // cannot see the changes becuase already pop
  }

  void _onApply() async {
    DisplayLanguageTypeEnum displayLanguageTypeEnum;
    if (_groupValueDisplayLanguage == DisplayLanguageTypeEnum.English.index) {
      displayLanguageTypeEnum = DisplayLanguageTypeEnum.English;
    } else if (_groupValueDisplayLanguage ==
        DisplayLanguageTypeEnum.Burmese.index) {
      displayLanguageTypeEnum = DisplayLanguageTypeEnum.Burmese;
    }

    KeyboardTypeEnum keyboardTypeEnum;
    if (_groupValueKeyboard == KeyboardTypeEnum.Zawgyi.index) {
      keyboardTypeEnum = KeyboardTypeEnum.Zawgyi;
    } else if (_groupValueKeyboard == KeyboardTypeEnum.Unicode.index) {
      keyboardTypeEnum = KeyboardTypeEnum.Unicode;
    }

    await userPreferenceService.updateLanguage(
        displayLanguageTypeEnum, keyboardTypeEnum);
    Navigator.pop(context);
  }
}
