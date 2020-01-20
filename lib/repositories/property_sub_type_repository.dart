import 'package:tolymoly/models/property_sub_type_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class PropertySubTypeRepository {
  static Future<List<PropertySubTypeModel>> find(int propertyTypeId) async {
    final db = await DbUtil.instance.db;

    final sql =
        'SELECT id, name FROM property_sub_type where property_type_id = $propertyTypeId and data_status = 1';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<PropertySubTypeModel> list = List();

    for (final map in maps) {
      list.add(PropertySubTypeModel.fromMap(map));
    }
    return list;
  }
}
