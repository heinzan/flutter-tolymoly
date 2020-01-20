import 'package:tolymoly/models/attribute_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class AttributeRepository {
  // static Future<List<AttributeModel>> find(int categoryId) async {
  //   final db = await DbUtil.instance.db;

  //   final sql =
  //       '''select a.id, a.name, a.label_name,a.table_name from category_attribute ca left join attribute a on ca.attribute_id = a.id where ca.category_id = $categoryId''';
  //   // final sql = '''SELECT * FROM category''';

  //   final result = await db.rawQuery(sql);

  //   print('print result ...');
  //   print(sql);
  //   print(result.length);
  //   print(result);

  //   List<AttributeModel> list = List();

  //   for (final item in result) {
  //     list.add(AttributeModel.fromMap(item));
  //   }
  //   return list;
  // }

  static Future<List<AttributeModel>> find() async {
    final db = await DbUtil.instance.db;

    final sql = 'select id, name, label_name, table_name from attribute';
    // final sql = '''SELECT * FROM category''';

    List<Map> maps = await db.rawQuery(sql);

    print('print result ...');
    print(sql);

    List<AttributeModel> list = List();

    for (final map in maps) {
      list.add(AttributeModel.fromMap(map));
    }
    return list;
  }
}
