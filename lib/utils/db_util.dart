import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DbUtil {
  // DbUtil._();

  // static final DbUtil db = DbUtil._();
  // static Database _db;

  DbUtil._();

  static final DbUtil instance = DbUtil._();
  Database _db;
  final String dbName = 'tolymoly.db';

  Future<Database> get db async {
    if (_db == null) _db = await init();

    return _db;
  }

  Future<Database> init() async {
    print('init db');

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    // delete existing if any
    // await deleteDatabase(path);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_error) {
        print('error');
      }

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  // Future<Database> init2() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, 'tolymoly.db');
  //   return await openDatabase(path, version: 1, onCreate: onCreate);
  // }

  Future<void> onCreate(Database db, int version) async {
    //await createyTable(db);
  }

  // Future<void> createyTable(Database db) async {
  //   final sql = '''CREATE TABLE category
  //   (
  //     id INTEGER PRIMARY KEY,
  //     parent_id INTEGER,
  //     name TEXT,
  //     zawgyi TEXT
  //   )''';

  //   await db.execute(sql);

  //   var batch = db.batch();

  //   List sqls = CategoryData.sql.split(';');

  //   for (final sql in sqls) {
  //     batch.execute(sql);
  //   }

  //   await batch.commit();
  // }
}
