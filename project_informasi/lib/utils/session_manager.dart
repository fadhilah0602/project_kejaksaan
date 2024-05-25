import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? id_user;
  String? nama;
  String? email;
  String? no_telp;
  String? ktp;
  String? alamat;
  String? role;

  Future<void> saveSession(
      int val, String id_user, String nama, String email, String no_telp, String ktp, String alamat, String role) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id_user", id_user);
    pref.setString("nama", nama);
    pref.setString("email", email);
    pref.setString("no_telp", no_telp);
    pref.setString("ktp", ktp);
    pref.setString("alamat", alamat);
    pref.setString("role", role);
  }

  Future<bool> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    value = pref.getInt("value");
    id_user = pref.getString("id_user");
    nama = pref.getString("nama");
    email = pref.getString("email");
    no_telp = pref.getString("no_telp");
    ktp = pref.getString("ktp");
    alamat = pref.getString("alamat");
    role = pref.getString("role");

    print('Log sess nama : $nama');
    print('Log sess id_user : $id_user');

    return nama != null;
  }

  Future<void> clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

SessionManager sessionManager = SessionManager();
