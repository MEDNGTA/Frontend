import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AuthService {
  static String _serverIP =
      Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2';
  static const int SERVER_PORT = 5000;
  static String _connectUrl = '$_serverIP:$SERVER_PORT';

  // ignore: non_constant_identifier_names

  static final SESSION = FlutterSession();

  Future<dynamic> register(String email, String password, String username,
      String first, String last, String phone) async {
    try {
      var res = await http.post(
        '$_connectUrl/json-reg',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'username': username,
          'firstname': first,
          'lastname': last,
          'phonenumber': phone,
        }),
      );

      return res;
    } finally {
      // done you can do something here
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      var res = await http.post(
        '$_connectUrl/json-login',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      return res;
    } finally {
      // you can do somethig here
    }
  }

  Future<dynamic> confirm(String email) async {
    try {
      var res = await http.post(
        '$_connectUrl/update-reg',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      return res;
    } finally {
      // you can do somethig here
    }
  }

  Future<dynamic> confirmForg(String email) async {
    try {
      var res = await http.post(
        '$_connectUrl/forgot-pass',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );
      //print("${res.statusCode}");
      //print("${res.body}");
      return res;
    } finally {
      // you can do somethig here
      //print("error forgot pass");
    }
  }

  Future<dynamic> confirmPass(String email, String password) async {
    try {
      var res = await http.post(
        '$_connectUrl/fp-conf',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      return res;
    } finally {
      // you can do somethig here
    }
  }

  static setToken(String token, String refreshToken) async {
    _AuthData data = _AuthData(token, refreshToken);
    await SESSION.set('tokens', data);
  }

  static Future<Map<String, dynamic>> getToken() async {
    return await SESSION.get('tokens');
  }

  static removeToken() async {
    await SESSION.prefs.clear();
  }
}

class _AuthData {
  String token, refreshToken;
  _AuthData(this.token, this.refreshToken);

  // toJson
  // required by Session lib
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
