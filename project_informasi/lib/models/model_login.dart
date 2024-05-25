import 'dart:convert';

ModelLogin modelLoginFromJson(String str) =>
    ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  bool sukses;
  int status;
  String pesan;
  Data data;

  ModelLogin({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: json["data"] != null
        ? Data.fromJson(json["data"])
        : Data(
      id_user: "",
      nama: "",
      email: "",
      password: "",
      no_telp: "",
      ktp: "",
      alamat: "",
      role: "",
    ),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": data.toJson(),
  };
}

class Data {
  String id_user;
  String nama;
  String email;
  String password;
  String no_telp;
  String ktp;
  String alamat;
  String role;

  Data({
    required this.id_user,
    required this.nama,
    required this.email,
    required this.password,
    required this.no_telp,
    required this.ktp,
    required this.alamat,
    required this.role,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id_user: json["id_user"],
    nama: json["nama"],
    email: json["email"],
    password: json["password"],
    no_telp: json["no_telp"],
    ktp: json["ktp"],
    alamat: json["alamat"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id_user": id_user,
    "nama": nama,
    "email": email,
    "password": password,
    "no_telp": no_telp,
    "ktp": ktp,
    "alamat": alamat,
    "role": role,
  };
}
