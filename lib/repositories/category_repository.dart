import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/models/category_model.dart';
import 'package:tolymoly/utils/db_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class CategoryRepository {
  static final tableName = 'category';

  static Future<List<CategoryModel>> findByParentId(int parentId) async {
    // bool isEnglish = UserPreferenceUtil.displayLanguageTypeEnum ==
    //     DisplayLanguageTypeEnum.English;
    // String sqlName = isEnglish ? 'name' : 'mm_unicode';
    final db = await DbUtil.instance.db;
    // String name;

    // if (displayLanguageTypeEnum == DisplayLanguageTypeEnum.Burmese) {
    //   name = 'mm_unicode as name';
    // } else {
    //   name = 'name';
    // }

    final sql =
        'SELECT id, name, mm_unicode, category_id_level1, category_id_level2, category_id_level3, has_child, has_quantity FROM $tableName where parent_id = $parentId order by display_order';
    // final sql = '''SELECT * FROM category''';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    List<CategoryModel> list = List();

    for (final map in maps) {
      list.add(CategoryModel.fromMap(map));
    }

    return list;
  }

  static Future<CategoryModel> findById(int categoryId) async {
    final db = await DbUtil.instance.db;

    final sql =
        'SELECT id, name, mm_unicode, category_id_level1, category_id_level2, category_id_level3 FROM $tableName where id = $categoryId';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    if (maps.length > 0) {
      return CategoryModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<CategoryModel>> findHasQuantity(int parentId) async {
    final db = await DbUtil.instance.db;

    final sql =
        'SELECT id, name, mm_unicode, category_id_level1, category_id_level2, category_id_level3 FROM $tableName where parent_id = $parentId and has_quantity = 1 order by display_order';

    List<Map> maps = await db.rawQuery(sql);

    List<CategoryModel> list = List();

    for (final map in maps) {
      list.add(CategoryModel.fromMap(map));
    }

    return list;
  }

  // static Future<List<CategoryModel>> findLevel1HasQuantity() async {
  //   final db = await DbUtil.instance.db;

  //   final sql = 'select distinct c1.category_id_level1, '
  //       'c2.id, c2.name, c2.category_id_level2, c2.category_id_level3, c2.zawgy, c2.has_child '
  //       'from $tableName c1 left join $tableName c2 on c1. category_id_level1 = c2.id where c1.has_quantity =1';
  //   // final sql = '''SELECT * FROM category''';

  //   List<Map> maps = await db.rawQuery(sql);

  //   print(sql);

  //   List<CategoryModel> list = List();

  //   for (final map in maps) {
  //     list.add(CategoryModel.fromMap(map));
  //   }

  //   return list;
  // }

  // static Future<List<CategoryModel>> findHasQuantity(
  //     int level, int parentId) async {
  //   final db = await DbUtil.instance.db;

  //   // bool isEnglish =
  //   //     UserPreferenceUtil.languageTypeEnum == LanguageTypeEnum.English;
  //   // String sqlName = isEnglish ? 'name' : 'zawgyi';
  //   List<CategoryModel> list = List();

  //   String levelColumn = '';
  //   switch (level) {
  //     case 1:
  //       levelColumn = 'category_id_level1';
  //       break;
  //     case 2:
  //       levelColumn = 'category_id_level2';
  //       break;
  //     case 3:
  //       levelColumn = 'category_id_level3';
  //       break;
  //     default:
  //       return list;
  //   }

  //   final sql = 'select distinct c1.$levelColumn, '
  //       'c2.id, c2.name, c2.mm_unicode, c2.category_id_level1, c2.category_id_level2, c2.category_id_level3, c2.mm_unicode, c2.has_child '
  //       'from $tableName c1 left join $tableName c2 on c1.$levelColumn = c2.id where '
  //       'c2.parent_id = $parentId and c1.has_quantity =1';
  //   // final sql = '''SELECT * FROM category''';

  //   List<Map> maps = await db.rawQuery(sql);

  //   print(sql);

  //   for (final map in maps) {
  //     list.add(CategoryModel.fromMap(map));
  //   }
  //   // print(list.length.toString());

  //   return list;
  // }

  static Future<bool> updateHasQuantity(List<dynamic> ids) async {
    final db = await DbUtil.instance.db;

    String idSql = '';
    for (var i = 0; i < ids.length; i++) {
      idSql = '$idSql,${ids[i]}';
    }
    idSql = idSql.replaceFirst(',', '');
    final sql =
        'UPDATE $tableName SET has_quantity = CASE WHEN id in ($idSql) THEN (1) ELSE 0 END';

    int count = await db.rawUpdate(sql);

    print(sql);

    return count == 0 ? false : true;
  }
}
