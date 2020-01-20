import 'package:tolymoly/models/buy_filter_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class BuyFilterRepository {
  final tableName = 'buy_filter';

  Future<bool> save(BuyFilterModel model) async {
    final db = await DbUtil.instance.db;

    int recordId = await db.insert(tableName, {
      // 'region_id': model.regionId,
      // 'region_name': model.regionName,
      // 'township_id': model.townshipId,
      // 'township_name': model.townshipName,
      // 'category_id': model.categoryId,
      // 'category_name': model.categoryName,
      'sort_id': model.sortId,
      'condition_id': model.conditionId,
      'price_from': model.priceFrom,
      'price_to': model.priceTo,
      'price_type': model.priceType,
    });

    return recordId == 0 ? false : true;
  }

  delete() async {
    final db = await DbUtil.instance.db;
    final sql = 'DELETE FROM $tableName';

    await db.rawDelete(sql);
  }

  Future<BuyFilterModel> find() async {
    final db = await DbUtil.instance.db;

    final sql = 'SELECT * FROM $tableName';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    if (maps.length > 0) {
      return BuyFilterModel.fromMap(maps.first);
    }
    return null;
  }
}
