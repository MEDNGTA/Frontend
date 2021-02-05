import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DbHelper {
  DbHelper._();
  static final DbHelper dbHelper = DbHelper._();
  Future<Database> _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'petisland.db');
    final Future<Database> database = openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db
          .execute("create table User ("
              "'userId' integer primary key,"
              "'email' text not null,"
              "'phone' integer not null,"
              "'code' integer not null,"
              "'adId' text not null,"
              "'macAdd' text not null,"
              "'ipAdd' text not null)")
          .catchError((error) => print(error.toString()));
      await db
          .execute("create table Location ("
              "'id' integer primary key,"
              "'lang' text not null,"
              "'lat' text not null,"
              "'country' text not null)")
          .catchError((error) => print(error.toString()));
      await db
          .execute("create table Token ("
              "'id' integer primary key,"
              "'token' text not null,"
              "'expireT' TIMESTAMP not null,"
              "'refToken' text not null,"
              "'expireRt' TIMESTAMP not null)")
          .catchError((error) => print(error.toString()));
    });
    return database;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    var result = await db.query('User');
    List<User> list = result.map((e) => User.fromMap(e)).toList();
    return list;
  }

  Future<List<Token>> getAllTokens() async {
    final db = await database;
    var result = await db.query('Token');
    List<Token> list = result.map((e) => Token.fromMap(e)).toList();
    return list;
  }

  Future<User> getUserWithId(int id) async {
    final db = await database;
    var result = await db.query("User", where: "userId=?", whereArgs: [id]);
    return result.isEmpty ? User.fromMap(result.first) : null;
  }

  Future<Token> getTokenWithId(int id) async {
    final db = await database;
    var result = await db.query("Token", where: "id=?", whereArgs: [id]);
    return result.isEmpty ? Token.fromMap(result.first) : null;
  }

  addUserToDatabase(User user) async {
    final db = await database;
    var raw = await db.insert(
      "User",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('$raw');

    return raw;
  }

  addTokenToDatabase(Token t) async {
    final db = await database;
    var raw = await db.insert(
      "Token",
      t.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('$raw');

    return raw;
  }

  deleteUserWithId(int id) async {
    final db = await database;
    var result = db.delete("User", where: "userId=?", whereArgs: [id]);
    print('$id');
    return result;
  }

  deleteTokenWithId(int id) async {
    final db = await database;
    var result = db.delete("Token", where: "id=?", whereArgs: [id]);
    print('$id');
    return result;
  }

  deleteAllUsers() async {
    final db = await database;
    db.delete("User");
  }

  deleteAllTokens() async {
    final db = await database;
    db.delete("Token");
  }

  updateUser(User user) async {
    final db = await database;
    var result = db.update("User", user.toMap(),
        where: "userId=?", whereArgs: [user.userId]);
    print('$result');
    return result;
  }

  updateToken(Token t) async {
    final db = await database;
    var result =
        db.update("Token", t.toMap(), where: "id=?", whereArgs: [t.id]);
    print('$result');
    return result;
  }
}

class User {
  int userId;
  String email;
  int phone;
  int code;
  String adId;
  String macAdd;
  String ipAdd;

  User(
      {this.userId,
      this.email,
      this.phone,
      this.code,
      this.adId,
      this.macAdd,
      this.ipAdd});
  // User.withOutId(
  //     {this.userId,
  //     this.email,
  //     this.phone,
  //     this.code,
  //     this.adId,
  //     this.macAdd,
  //     this.ipAdd});

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'email': email,
        'phone': phone,
        'code': code,
        'adId': adId,
        'macAdd': macAdd,
        'ipAdd': ipAdd
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
      userId: map['UserId'],
      email: map['email'],
      phone: map['phone'],
      code: map['code'],
      adId: map['adId'],
      macAdd: map['macAdd'],
      ipAdd: map['ipAdd']);
}

class Token {
  int id;
  String token;
  String expireT;
  String refToken;
  String expireRt;

  Token({this.id, this.token, this.expireT, this.refToken, this.expireRt});
  Token.withOutId({this.token, this.expireT, this.refToken, this.expireRt});

  Map<String, dynamic> toMap() => {
        'id': id,
        'token': token,
        'expireT': expireT,
        'refToken': refToken,
        'expireRt': expireRt
      };

  factory Token.fromMap(Map<String, dynamic> map) => Token(
      id: map['id'],
      token: map['token'],
      expireT: map['expireT'],
      refToken: map['refToken'],
      expireRt: map['expireRt']);
}
