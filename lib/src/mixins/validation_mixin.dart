import 'dart:async';
import 'package:intl_phone_field/phone_number.dart';

class ValidationMixin {
  // with Provider state
  final validatorEmail = new StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      // if (email.isEmpty) {
      //   sink.addError('Email is required');
      // } else if (!email.contains('@')) {
      //   sink.addError('Please enter a valid email');
      // } else if (email.contains(' ')) {
      //   sink.addError('Space not allowd! 😏');
      // } else {
      //   sink.add(email);
      // }
      if (ValidationMixin()._validateEmail(email)) {
        sink.addError('Email is not valid');
      } else {
        sink.add(email);
      }
    },
  );

  final validatorPassword = new StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (!ValidationMixin()._validatePassword(password)) {
        sink.addError('Password is not valid!');
      } else {
        sink.add(password);
      }
    },
  );

  final validatorUsername = new StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      if (!ValidationMixin()._validateUsername(username)) {
        sink.addError('Username is not valid!');
      } else {
        sink.add(username);
      }
    },
  );

  final validatorFirst = new StreamTransformer<String, String>.fromHandlers(
    handleData: (first, sink) {
      if (!ValidationMixin()._validateFirst(first)) {
        sink.addError('Firstname is not valid!');
      } else {
        sink.add(first);
      }
    },
  );

  final validatorlast = new StreamTransformer<String, String>.fromHandlers(
    handleData: (last, sink) {
      if (!ValidationMixin()._validateLast(last)) {
        sink.addError('Lastname is not valid!');
      } else {
        sink.add(last);
      }
    },
  );

  final validatorPhone =
      new StreamTransformer<PhoneNumber, String>.fromHandlers(
    handleData: (phone, sink) {
      if (!ValidationMixin()._validatePhone(phone.completeNumber)) {
        sink.addError('Phone number is not valid!');
      } else {
        sink.add(phone.completeNumber);
      }
    },
  );

  final validatorCode = new StreamTransformer<String, String>.fromHandlers(
    handleData: (code, sink) {
      if (!ValidationMixin()._validateCode(code)) {
        sink.addError('Code number is not valid!');
      } else {
        sink.add(code);
      }
    },
  );
  // without Provider state
  bool _validateEmail(String email) {
    var regExp =
        new RegExp(r"^[a-zA-Z0-9._-]{2,}@[a-zA-Z0-9.-]{2,}\.[A-Za-z0-9]{2,5}$");
    // if (email.isEmpty) {
    //   return false;
    // }
    if (regExp.hasMatch(email)) {
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    var regExp = new RegExp(r'^.$');
    // if (password.isEmpty) {
    //   return false;
    // }
    if (password.length < 8 || password.length > 20) {
      return false;
    }
    if (regExp.hasMatch(password)) {
      return false;
    }
    return true;
  }

  bool _validateUsername(String username) {
    var regExp = new RegExp(r"^[a-zA-Z0-9\.?_?\?]$");
    // if (password.isEmpty) {
    //   return false;
    // }
    if (username.length < 8) {
      return false;
    }
    if (regExp.hasMatch(username)) {
      return false;
    }
    return true;
  }

  bool _validateFirst(String first) {
    var regExp = new RegExp(r'^[a-zA-Z]$');
    // if (password.isEmpty) {
    //   return false;
    // }
    // if (password.length < 8) {
    //   return false;
    // }
    if (regExp.hasMatch(first)) {
      return false;
    }
    return true;
  }

  bool _validateLast(String last) {
    var regExp = new RegExp(r'^[a-zA-Z]$');
    // if (password.isEmpty) {
    //   return false;
    // }
    // if (password.length < 8) {
    //   return false;
    // }
    if (regExp.hasMatch(last)) {
      return false;
    }
    return true;
  }

  bool _validatePhone(String phone) {
    var regExp = new RegExp(r'^\d+$');
    // if (password.isEmpty) {
    //   return false;
    // }
    // if (phone.length < 14) {
    //   return false;
    // }
    if (regExp.hasMatch(phone)) {
      return false;
    }
    return true;
  }

  bool _validateCode(String code) {
    var regExp = new RegExp(r'^[0-9]+$');
    // if (password.isEmpty) {
    //   return false;
    // }
    if (code.length < 6) {
      return false;
    }
    if (regExp.hasMatch(code)) {
      return false;
    }
    return true;
  }
}
