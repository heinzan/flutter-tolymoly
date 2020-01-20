import 'package:tolymoly/models/property_type_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class PropertyTypeRepository {
  static Future<List<PropertyTypeModel>> find() async {
    final db = await DbUtil.instance.db;

    final sql = 'SELECT id, name FROM property_type where data_status = 1';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<PropertyTypeModel> list = List();

    for (final map in maps) {
      list.add(PropertyTypeModel.fromMap(map));
    }
    return list;
  }
}
