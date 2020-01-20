import 'package:sqflite/sqflite.dart';
import 'package:tolymoly/enum/search_type_enum.dart';
import 'package:tolymoly/models/user_search_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class UserSearchRepository {
  static final tableName = 'user_search';

  static Future<List<UserSearchModel>> find() async {
    final db = await DbUtil.instance.db;

    final sql = 'SELECT * FROM $tableName';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<UserSearchModel> list = List();

    for (final map in maps) {
      list.add(UserSearchModel.fromDb(map));
    }
    return list;
  }

  static Future<bool> exist(String text, SearchTypeEnum searchTypeEnum) async {
    final db = await DbUtil.instance.db;

    int count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $tableName where text = '$text' and type = ${searchTypeEnum.index}"));

    if (count > 0) return true;

    return false;
  }

  static Future<bool> save(String text, SearchTypeEnum searchTypeEnum) async {
    final db = await DbUtil.instance.db;
    String sql =
        "INSERT INTO $tableName (text, type) VALUES ('$text', ${searchTypeEnum.index})";
    // int recordId = await db.insert(tableName, {'name': name});

    print(sql);

    await db.rawQuery(sql);

    // return recordId == 0 ? false : true;
    return true;
  }

  static delete() async {
    final db = await DbUtil.instance.db;
    final sql = 'DELETE FROM $tableName';

    await db.rawDelete(sql);
  }

  static Future<bool> deleteOne(
      String text, SearchTypeEnum searchTypeEnum) async {
    final db = await DbUtil.instance.db;
    int count = await db.rawDelete(
        'DELETE FROM $tableName WHERE text = ? and type = ?',
        [text, searchTypeEnum.index]);
    if (count > 0) return true;

    return false;
  }
}
