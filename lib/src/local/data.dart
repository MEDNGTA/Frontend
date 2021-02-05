import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = "petisland.db";
  static final _dbVersion = 1;
  //------ user table -----
  static final _dbUser = "user";
  static final _urId = "user_id";
  static final _urMail = "email";
  static final _urPhone = "phone";
  static final _urCode = "code";
  static final _urAdid = "ad_id";
  static final _urMac = "mac_add";
  static final _urIp = "ip_add";
  //------ location table -----
  static final _dbLocation = "location";
  static final _lcId = "id";
  static final _lcLang = "lang";
  static final _lcLat = "lat";
  static final _lcCountry = "country";
  //----- Token table ------
  static final _dbAutorisation = "autorisation";
  static final _auToken = "token";
  static final _auTokenExp = "expire_t";
  static final _auRefToken = "ref_token";
  static final _auRefTokenExp = "expire_rt";

  // make it singleton class
  DatabaseHelper._();
  static final DatabaseHelper dbHelper = DatabaseHelper._();
  //DatabaseHelper._privateConstructor();
  Future<Database> _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  dynamic _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $_dbUser ( 
        $_urId integer primary key,
        $_urMail text not null,
        $_urPhone text not null,
        $_urCode text not null, 
        $_urAdid text not null,
        $_urMac text not null,
        $_urIp text not null)
      ''');
      //   await db.execute('''
      //   create table $_dbLocation (
      //     $_lcId integer primary key autoincrement,
      //     $_lcLang text not null,
      //     $_lcLat text not null,
      //     $_lcCountry text not null)
      //   ''');
      //   await db.execute('''
      //   create table $_dbAutorisation (
      //     $_auToken integer primary key autoincrement,
      //     $_auTokenExp text not null,
      //     $_auRefToken text not null,
      //     $_auRefTokenExp text not null)
      //   ''');
    });
  }

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await dbHelper.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> selectAll(String tableName) async {
    Database db = await dbHelper.database;
    return await db.query(tableName);
  }

  Future<int> update(
      String tableName, Map<String, dynamic> row, String champs) async {
    Database db = await dbHelper.database;
    final att = row["$champs"];
    return await db
        .update(tableName, row, where: '$champs = ?', whereArgs: [att]);
  }

  Future<int> delete(String tableName, String champs, String value) async {
    Database db = await dbHelper.database;

    return await db.delete(tableName, where: '$champs = ?', whereArgs: [value]);
  }
}
