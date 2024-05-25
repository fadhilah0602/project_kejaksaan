import 'dart:convert';

List<ModelUsers> modelUsersFromJson(String str) =>
    List<ModelUsers>.from(json.decode(str).map((x) => ModelUsers.fromJson(x)));

String modelUsersToJson(List<ModelUsers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelUsers {
  String id_user;
  String nama;
  String email;
  String no_telp;
  String ktp;
  String alamat;
  String role;

  ModelUsers({
    required this.id_user,
    required this.nama,
    required this.email,
    required this.no_telp,
    required this.ktp,
    required this.alamat,
    required this.role,
  });

  factory ModelUsers.fromJson(Map<String, dynamic> json) => ModelUsers(
    id_user: json["id_user"],
    nama: json["nama"],
    email: json["email"],
    no_telp: json["no_telp"],
    ktp: json["ktp"],
    alamat: json["alamat"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id_user": id_user,
    "nama": nama,
    "email": email,
    "no_telp": no_telp,
    "ktp": ktp,
    "alamat": alamat,
    "role": role,
  };
}
