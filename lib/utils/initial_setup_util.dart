import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/models/user_model.dart';
import 'package:tolymoly/models/user_preference_model.dart';
import 'package:tolymoly/services/user_preference_service.dart';
import 'package:tolymoly/services/user_service.dart';
import 'package:tolymoly/utils/chat_util.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

import 'auth_util.dart';

final UserPreferenceService userPreferenceService = new UserPreferenceService();
UserService userService = new UserService();

class InitialSetupUtil {
  static Future<void> setup() async {
    await _loadAuth();
    await _loadUserPreference();
    await _setChatToken();

    // if (AuthUtil.isLoggedIn) ChatUtil.periodicUnreadCount();
  }

  static Future<void> _loadAuth() async {
    print('load auth from db........');
    // AuthUtil.isLoggedIn = await userService.isLoggedIn();
    UserModel userModel = await userService.find();

    if (userModel == null) {
      AuthUtil.isLoggedIn = false;
      AuthUtil.userId = 0;
    } else {
      AuthUtil.isLoggedIn = true;
      AuthUtil.userId = userModel.id;
      HttpUtil.token = userModel.token;
    }
    print('isLoggedIn: ${AuthUtil.isLoggedIn}');
    print('userId: ${AuthUtil.userId}');
    // print('joined date: ${userModel.joinedDate}');
    // print('token: ${userModel.token == null}');
  }

  static Future<void> _loadUserPreference() async {
    print('load user preference from db........');

    UserPreferenceModel model = await userPreferenceService.find();
    KeyboardTypeEnum keyboardTypeEnum;
    if (model.keyboardType == KeyboardTypeEnum.Zawgyi.index) {
      keyboardTypeEnum = KeyboardTypeEnum.Zawgyi;
    } else if (model.keyboardType == KeyboardTypeEnum.Unicode.index) {
      keyboardTypeEnum = KeyboardTypeEnum.Unicode;
    }

    DisplayLanguageTypeEnum displayLanguageTypeEnum;
    if (model.displayLanguageType == DisplayLanguageTypeEnum.English.index) {
      displayLanguageTypeEnum = DisplayLanguageTypeEnum.English;
    } else if (model.displayLanguageType ==
        DisplayLanguageTypeEnum.Burmese.index) {
      displayLanguageTypeEnum = DisplayLanguageTypeEnum.Burmese;
    }

    UserPreferenceUtil.keyboardTypeEnum = keyboardTypeEnum;
    UserPreferenceUtil.displayLanguageTypeEnum = displayLanguageTypeEnum;

    UserPreferenceUtil.regionId = model.regionId;
    UserPreferenceUtil.regionName = model.regionName;
    UserPreferenceUtil.townshipId = model.townshipId;
    UserPreferenceUtil.townshipName = model.townshipName;

    UserPreferenceUtil.sellRegionId = model.sellRegionId;
    UserPreferenceUtil.sellRegionName = model.sellRegionName;
    UserPreferenceUtil.sellTownshipId = model.sellTownshipId;
    UserPreferenceUtil.sellTownshipName = model.sellTownshipName;

    print('keyboardTypeEnum: ${UserPreferenceUtil.keyboardTypeEnum.index}');
    print(
        'displayLanguageTypeEnum: ${UserPreferenceUtil.displayLanguageTypeEnum.index}');
    print('regionId: ${UserPreferenceUtil.regionId}');
    print('regionName: ${UserPreferenceUtil.regionName}');
    print('townshipId: ${UserPreferenceUtil.townshipId}');
    print('townshipName: ${UserPreferenceUtil.townshipName}');
    print('sellRegionId: ${UserPreferenceUtil.sellRegionId}');
    print('sellRegionName: ${UserPreferenceUtil.sellRegionName}');
    print('sellTownshipId: ${UserPreferenceUtil.sellTownshipId}');
    print('sellTownshipName: ${UserPreferenceUtil.sellTownshipName}');
  }

  static Future<void> _setChatToken() async {
    if (AuthUtil.isLoggedIn) {
      await ChatUtil.setToken();
    }

    print('hasFcmToken: ${ChatUtil.hasFcmToken}');
  }
}
