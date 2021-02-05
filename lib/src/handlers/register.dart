import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  Register({
    this.userId,
    this.email,
    this.phone,
    this.code,
    this.message,
  });

  String userId;
  String email;
  String phone;
  String code;
  String message;

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone": phone,
        "code": code,
        "message": message,
      };
}
