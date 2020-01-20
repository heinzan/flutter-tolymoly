import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/models/township_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class TownshipRepository {
  static Future<List<TownshipModel>> find(
      int regionId, DisplayLanguageTypeEnum displayLanguageTypeEnum) async {
    final db = await DbUtil.instance.db;

    String name;

    if (displayLanguageTypeEnum == DisplayLanguageTypeEnum.Burmese) {
      name = 'zawgyi as name';
    } else {
      name = 'name';
    }

    final sql =
        'SELECT id, $name, region_id FROM township where region_id = $regionId';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<TownshipModel> list = List();

    for (final map in maps) {
      list.add(TownshipModel.fromMap(map));
    }
    return list;
  }
}
