import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/models/region_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class RegionRepository {
  static Future<List<RegionModel>> find(
      DisplayLanguageTypeEnum displayLanguageTypeEnum) async {
    final db = await DbUtil.instance.db;

    String name;

    if (displayLanguageTypeEnum == DisplayLanguageTypeEnum.Burmese) {
      name = 'zawgyi as name';
    } else {
      name = 'name';
    }

    final sql = 'SELECT id, $name FROM region';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<RegionModel> list = List();

    for (final map in maps) {
      list.add(RegionModel.fromMap(map));
    }
    return list;
  }
}
