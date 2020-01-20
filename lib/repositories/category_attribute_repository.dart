import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/models/attribute_model.dart';
import 'package:tolymoly/utils/db_util.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class CategoryAttributeRepository {
  static Future<List<AttributeModel>> find(int categoryId) async {
    final db = await DbUtil.instance.db;
    bool isEnglish = UserPreferenceUtil.displayLanguageTypeEnum ==
        DisplayLanguageTypeEnum.English;
    String sqlLabel = isEnglish ? 'label_name' : 'label_name_unicode';

    final sql =
        'select a.id, a.name_camel as name, a.$sqlLabel as label_name, a.table_name, a.attribute_type, a.textbox_input_type, a.is_required from category_attribute ca left join attribute a on ca.attribute_id = a.id where ca.category_id = $categoryId';
    // final sql = '''SELECT * FROM category''';

    final result = await db.rawQuery(sql);

    List<AttributeModel> list = List();

    for (final item in result) {
      list.add(AttributeModel.fromMap(item));
    }
    return list;
  }
}
