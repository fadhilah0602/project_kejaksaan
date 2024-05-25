import 'dart:convert';

ModelRegister modelRegisterFromJson(String str) =>
    ModelRegister.fromJson(json.decode(str));

String modelRegisterToJson(ModelRegister data) => json.encode(data.toJson());

class ModelRegister {
  int value;
  String nama;
  String email;
  String no_telp;
  String ktp;
  String password;
  String alamat;
  String role;
  String message;

  ModelRegister({
    required this.value,
    required this.nama,
    required this.email,
    required this.no_telp,
    required this.ktp,
    required this.password,
    required this.alamat,
    required this.role,
    required this.message,
  });

  factory ModelRegister.fromJson(Map<String, dynamic> json) => ModelRegister(
    value: json["value"],
    message: json["message"],
    nama: 'json["nama"]',
    email: 'json["email"]',
    no_telp: 'json["no_telp]',
    ktp: 'json["ktp"]',
    password: 'json["password"]',
    alamat: 'json["alamat"]',
    role: 'json["role"]',
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "nama": nama,
    "email": email,
    "no_telp": no_telp,
    "ktp": ktp,
    "password": password,
    "alamat": alamat,
    "role": role,
  };
}
