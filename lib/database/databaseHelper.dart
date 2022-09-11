import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'userModel.dart';

class DatabaseHelper {
  static final _databaseName = "info.db";
  static final _databaseVersion = 1;

  static final table = 'user_info';

  static final columnId = 'id';
  static final columName = 'name';
  static final columnAge = 'age';
  static final columanGender = 'gender';
  static final columanImage = 'image';
  static final columanSync = 'sync';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columName TEXT NOT NULL,
          $columnAge INTEGER NOT NULL,
          $columanGender TEXT NOT NULL,
          $columanImage TEXT NOT NULL,
          $columanSync INTEGER NOT NULL)
 ''');
  }

  Future<int> insert(UserModel userModel) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'name': userModel.name,
      'age': userModel.age,
      'gender': userModel.gender,
      'image': userModel.image,
      'sync': userModel.sync
    });
  }

  Future<List<Map<String, dynamic>>> getAllForms() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  static Future<List<UserModel>> getUsers() async {
    int i = 1;
    Database db = await instance.database;
    final List<Map<String, Object?>> qureyResult =
        await db.rawQuery('SELECT * FROM user_info WHERE sync = ?', ['0']);
    return qureyResult.map((e) => UserModel.fromMap(e)).toList();
  }

  static Future<void> updateSync(int sync, int id) async {
    Database db = await instance.database;
    await db
        .rawUpdate('UPDATE user_info SET sync = ? WHERE id = ?', [sync, id]);
  }

  Future<List<Map<String, dynamic>>> singleForm(id) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnId LIKE '%$id%'");
  }
}
