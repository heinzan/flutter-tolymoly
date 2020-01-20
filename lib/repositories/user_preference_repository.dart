import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/models/user_preference_model.dart';
import 'package:tolymoly/utils/db_util.dart';
import 'package:tolymoly/utils/toast_util.dart';

class UserPreferenceRepository {
  final tableName = 'user_preference';

  // Future<bool> updateKeyboardType(KeyboardTypeEnum keyboardTypeEnum) async {
  //   final db = await DbUtil.instance.db;
  //   final sql = 'UPDATE user_preference SET keyboard_type = ? WHERE id = 1';
  //   int count = await db.rawUpdate(sql, [keyboardTypeEnum.index]);

  //   print(sql);

  //   return count == 0 ? false : true;
  // }

  // Future<bool> updateDisplayLanguageType(
  //     DisplayLanguageTypeEnum displayLanguageTypeEnum) async {
  //   final db = await DbUtil.instance.db;
  //   final sql =
  //       'UPDATE user_preference SET display_language_type = ? WHERE id = 1';
  //   int count = await db.rawUpdate(sql, [displayLanguageTypeEnum.index]);

  //   print(sql);

  //   return count == 0 ? false : true;
  // }

  Future<bool> updateLanguage(DisplayLanguageTypeEnum displayLanguageTypeEnum,
      KeyboardTypeEnum keyboardTypeEnum) async {
    final db = await DbUtil.instance.db;
    final sql =
        'UPDATE user_preference SET display_language_type = ?,keyboard_type = ?  WHERE id = 1';
    int count = await db.rawUpdate(
        sql, [displayLanguageTypeEnum.index, keyboardTypeEnum.index]);

    print(sql);

    return count == 0 ? false : true;
  }

  Future<bool> updateBuyLocation(int regionId, String regionName,
      int townshipId, String townshipName) async {
    final db = await DbUtil.instance.db;
    final sql =
        'UPDATE user_preference SET region_id = ?, region_name = ? , township_id = ?, township_name = ? WHERE id = 1';
    int count = await db
        .rawUpdate(sql, [regionId, regionName, townshipId, townshipName]);

    print(sql);

    return count == 0 ? false : true;
  }

  Future<bool> updateSellLocation(int regionId, String regionName,
      int townshipId, String townshipName) async {
    final db = await DbUtil.instance.db;
    final sql =
        'UPDATE user_preference SET sell_region_id = ?, sell_region_name = ?, sell_township_id = ?, sell_township_name = ? WHERE id = 1';
    int count = await db
        .rawUpdate(sql, [regionId, regionName, townshipId, townshipName]);

    print(sql);

    return count == 0 ? false : true;
  }

  Future<UserPreferenceModel> find() async {
    final db = await DbUtil.instance.db;

    final sql = 'SELECT * FROM $tableName';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    if (maps.length > 0) {
      return UserPreferenceModel.fromMap(maps.first);
    }
    return null;
  }

  // Future<bool> isZawgyi() async {
  //   final db = await DbUtil.instance.db;

  //   final sql = 'SELECT language_type FROM $tableName';

  //   List<Map> maps = await db.rawQuery(sql);

  //   print(sql);

  //   if (maps.length > 0) {
  //     return UserPreferenceModel.fromMap(maps.first).languageType ==
  //         LanguageTypeEnum.Zawgyi.index;
  //   }

  //   return null;
  // }
}
