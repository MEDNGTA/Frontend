import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_app/src/screens/login_screen.dart';
import 'package:pet_app/src/services/auth_service.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pet_app/src/local/dbHelper.dart';
import '../mixins/validation_mixin.dart';
import '../screens/confirm_register.dart';

class FormBloc with ValidationMixin {
  final _email = new BehaviorSubject<String>();
  final _password = new BehaviorSubject<String>();
  final _username = new BehaviorSubject<String>();
  final _first = new BehaviorSubject<String>();
  final _last = new BehaviorSubject<String>();
  final _phone = new BehaviorSubject<PhoneNumber>();
  final _errorMessage = new BehaviorSubject<String>();
  final _code = new BehaviorSubject<String>();

  // getters: Changers
  Function(String) get changeEmail {
    addError(null);
    return _email.sink.add;
  }

  Function(String) get changePassword {
    addError(null);
    return _password.sink.add;
  }

  Function(String) get changeUsername {
    addError(null);
    return _username.sink.add;
  }

  Function(String) get changeFirst {
    addError(null);
    return _first.sink.add;
  }

  Function(String) get changeLast {
    addError(null);
    return _last.sink.add;
  }

  Function(PhoneNumber) get changePhone {
    addError(null);
    return _phone.sink.add;
  }

  Function(String) get changeCode {
    addError(null);
    return _code.sink.add;
  }

  Function(String) get addError => _errorMessage.sink.add;
  // getters: Add stream
  Stream<String> get email => _email.stream.transform(validatorEmail);
  Stream<String> get password => _password.stream.transform(validatorPassword);
  Stream<String> get username => _username.stream.transform(validatorUsername);
  Stream<String> get first => _first.stream.transform(validatorFirst);
  Stream<String> get last => _last.stream.transform(validatorlast);
  Stream<String> get phone => _phone.stream.transform(validatorPhone);
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<String> get code => _code.stream.transform(validatorCode);
  Stream<bool> get submitValidForm => Rx.combineLatest7(
        email,
        password,
        username,
        first,
        last,
        phone,
        errorMessage,
        (e, p, u, f, l, ph, er) => true,
      );
  Stream<bool> get submitLoginForm => Rx.combineLatest3(
        email,
        password,
        errorMessage,
        (e, p, er) => true,
      );
  Stream<bool> get submitForEmForm => Rx.combineLatest2(
        email,
        errorMessage,
        (e, er) => true,
      );
  Stream<bool> get submitForCoForm => Rx.combineLatest2(
        code,
        errorMessage,
        (c, er) => true,
      );
  Stream<bool> get submitForPaForm => Rx.combineLatest3(
        password,
        password,
        errorMessage,
        (p, rp, er) => true,
      );

  var authInfo;

  // rgister
  dynamic register(BuildContext context) async {
    try {
      //print(_phone.value);
      authInfo = AuthService();
      final res = await authInfo.register(
          _email.value,
          _password.value,
          _username.value,
          _first.value,
          _last.value,
          _phone.value.completeNumber);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) {
        addError(data['message']);
        debugPrint("i m stuck here !!!!  ==>  ${res.statusCode} ");
      } else {
        debugPrint(" begin to create a user table ${data["user_id"]}");
        var id = await DbHelper.dbHelper.addUserToDatabase(User(
            userId: data["user_id"],
            email: data["email"].toString(),
            phone: int.parse(data["phone"]),
            code: data["code"],
            adId: "fffffff".toString(),
            macAdd: "FF:FF:FF:FF:FF".toString(),
            ipAdd: "0.0.0.0".toString()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmRegister(
                    cEmail: data["email"], cCode: data["code"])));
        print("the id after insetion is $id");
        print("the code from request is ${data["code"]}");
        return id;
      }
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  // login
  dynamic login(BuildContext context) async {
    authInfo = AuthService();
    final res = await authInfo.login(_email.value, _password.value);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    try {
      if (res.statusCode != 200) {
        addError(data['message']);
      } else {
        debugPrint(" begin to create a user table ${data["user_id"]}");
        var id = await DbHelper.dbHelper.addTokenToDatabase(Token.withOutId(
            token: data["token"],
            expireT: data["expire_t"],
            refToken: data["refrechToken"],
            expireRt: data["expire_rt"]));
        print("the id of insertion is $id");
        Navigator.pushNamed(context, '/home');
        AuthService.setToken(data['token'], data['refreshToken']);
        return data;
      }
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  dynamic confirm(BuildContext context, String email) async {
    authInfo = AuthService();
    try {
      final res = await authInfo.confirm(email);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] != 200) {
        return addError(data['message']);
      } else {
        return data;
      }
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  dynamic confirmForg(BuildContext context, String email) async {
    authInfo = AuthService();
    try {
      final res = await authInfo.confirmForg(email);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      print("${res.statusCode}");
      if (res.statusCode != 200) {
        return addError(data['message']);
      } else {
        return data;
      }
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  dynamic confirmPass(
      BuildContext context, String email, String password) async {
    authInfo = AuthService();
    try {
      final res = await authInfo.confirmPass(email, password);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] != 200) {
        return addError(data['message']);
      } else {
        return data;
      }
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  // close streams
  dispose() {
    _email.close();
    _password.close();
    _username.close();
    _first.close();
    _last.close();
    _phone.close();
    _errorMessage.close();
    _code.close();
  }
}
