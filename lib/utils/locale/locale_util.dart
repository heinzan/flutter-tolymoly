import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/utils/locale/english.dart';
import 'package:tolymoly/utils/locale/mm_unicode.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class LocaleUtil {
  static get(String text) {
    if (UserPreferenceUtil.displayLanguageTypeEnum ==
        DisplayLanguageTypeEnum.English) {
      return English.map[text] == null ? text : English.map[text];
    } else {
      return MmUnicode.map[text] == null ? text : MmUnicode.map[text];
    }
  }
}
