import 'package:sqflite/sqflite.dart';
import 'package:tolymoly/models/user_model.dart';
import 'package:tolymoly/utils/db_util.dart';

class UserRepository {
  final tableName = 'user';

  Future<bool> save(UserModel model) async {
    final db = await DbUtil.instance.db;

    // int hasFacebook = ['', null].contains(model.facebookName) ? 0 : 1;
    // int hasPhone = ['', null].contains(model.facebookAccountKitPhone) ? 0 : 1;

    int recordId = await db.insert(tableName, {
      'id': model.id,
      'username': model.username,
      'image': model.image,
      'description': model.description,
      'is_registered_by_facebook': model.isRegisteredByFacebook,
      'is_registered_by_sms': model.isRegisteredBySms,
      // 'facebook_name': model.facebookName,
      // 'facebook_account_kit_phone': model.facebookAccountKitPhone,

      'facebook_messenger': model.facebookMessenger,
      'phone': model.phone,
      // 'created_date': model.createdDate.toString(),
      'joined_date': model.joinedDate,
      'token': model.token
    });

    return recordId == 0 ? false : true;
  }

  Future<bool> update(UserModel model) async {
    final db = await DbUtil.instance.db;
    final sql = 'UPDATE $tableName SET '
        'username = ?, '
        'image = ?, '
        'description = ?, '
        'is_registered_by_facebook = ?, '
        'is_registered_by_sms = ?, '
        // 'facebook_name = ?, '
        // 'facebook_account_kit_phone = ? , '
        'facebook_messenger = ? ,'
        'phone = ? ,'
        'joined_date = ?'
        // 'created_date = ? '
        'WHERE id = ?';
    int count = await db.rawUpdate(sql, [
      model.username,
      model.image,
      model.description,
      model.isRegisteredByFacebook,
      model.isRegisteredBySms,
      model.facebookMessenger,
      model.phone,
      model.joinedDate,
      model.id
    ]);

    print(sql);

    return count == 0 ? false : true;
  }

  Future<void> delete() async {
    final db = await DbUtil.instance.db;
    final sql = 'DELETE FROM $tableName';

    await db.rawDelete(sql);
  }

  Future<UserModel> find() async {
    final db = await DbUtil.instance.db;

    final sql = 'SELECT * FROM $tableName';

    List<Map> maps = await db.rawQuery(sql);

    print(sql);

    if (maps.length > 0) {
      return UserModel.fromDb(maps.first);
    }
    return null;
  }

  // Future<int> findId() async {
  //   final db = await DbUtil.instance.db;

  //   final sql = 'SELECT id FROM $tableName';

  //   List<Map> maps = await db.rawQuery(sql);

  //   print(sql);

  //   if (maps.length > 0) {
  //     UserModel user = UserModel.fromDb(maps.first);
  //     return user.id;
  //   }
  //   return null;
  // }

  // Future<String> findToken() async {
  //   final db = await DbUtil.instance.db;

  //   final sql = 'SELECT token FROM $tableName';

  //   List<Map> maps = await db.rawQuery(sql);

  //   print(sql);

  //   if (maps.length > 0) {
  //     UserModel user = UserModel.fromDb(maps.first);
  //     return user.token;
  //   }
  //   return null;
  // }

  // Future<int> count() async {
  //   final db = await DbUtil.instance.db;

  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  // }
}
