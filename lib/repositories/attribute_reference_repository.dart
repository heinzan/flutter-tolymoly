// import 'package:tolymoly/models/reference.dart';
// import 'package:tolymoly/utils/db_util.dart';

// class AttributeReferencRepository {
//   static Future<List<Reference>> find(int attributeId) async {
//     final db = await DbUtil.instance.db;

//     final sql =
//         'select id, name from attribute_reference where attribute_id = $attributeId';

//     List<Map> maps = await db.rawQuery(sql);

//     print('print result ...');
//     print(sql);

//     List<Reference> list = List();

//     for (final map in maps) {
//       list.add(Reference.fromMap(map));
//     }
//     return list;
//   }
// }
