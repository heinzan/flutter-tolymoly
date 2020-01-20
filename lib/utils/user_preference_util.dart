import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';

class UserPreferenceUtil {
  static KeyboardTypeEnum keyboardTypeEnum = KeyboardTypeEnum.Zawgyi;
  static DisplayLanguageTypeEnum displayLanguageTypeEnum =
      DisplayLanguageTypeEnum.Burmese;
  // static LocationPickerDto locationPickerDto;
  static int regionId;
  static String regionName;
  static int townshipId;
  static String townshipName;
  static int sellRegionId;
  static String sellRegionName;
  static int sellTownshipId;
  static String sellTownshipName;
}
