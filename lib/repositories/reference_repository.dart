import 'package:tolymoly/models/reference.dart';
import 'package:tolymoly/utils/db_util.dart';

class ReferenceRepository {
  static Future<List<Reference>> find(String table) async {
    return findWhere(table, '');
  }

  static Future<List<Reference>> findWhere(
      String table, String whereSql) async {
    final db = await DbUtil.instance.db;

    final sql = 'SELECT id, name FROM $table $whereSql';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<Reference> list = List();

    for (final map in maps) {
      list.add(Reference.fromMap(map));
    }
    return list;
  }

  static Future<String> findName(String table, int id) async {
    final db = await DbUtil.instance.db;

    final sql = '''SELECT name FROM $table where id = $id''';

    final result = await db.rawQuery(sql);

    print(sql);

    return result[0]['name'];
  }

  static Future<List<Reference>> findCondition() async {
    return find('condition_type');
  }

  static Future<List<Reference>> findPriceType() async {
    return find('price_type');
  }
}
