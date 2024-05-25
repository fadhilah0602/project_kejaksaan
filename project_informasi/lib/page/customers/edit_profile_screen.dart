import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_informasi/page/customers/profile_screen.dart';

import '../../models/model_user.dart';
import '../../utils/session_manager.dart';

class EditProfile extends StatefulWidget {
  final ModelUsers currentUser;

  const EditProfile({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? _name;
  String? _email;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _noTelpController = TextEditingController();
  TextEditingController _ktpController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.currentUser.nama;
    _emailController.text = widget.currentUser.email; // Inisialisasi nilai email dari model
    _noTelpController.text = widget.currentUser.no_telp;
    _ktpController.text = widget.currentUser.ktp;
    _alamatController.text = widget.currentUser.alamat;
    _roleController.text = widget.currentUser.alamat;
  }

  void saveChanges(String newNama, String newEmail, String newNotelp, String newKtp, String newAlamat, String newRole ) async {
    // Validasi input sebelum menyimpan perubahan
    if (newNama.isEmpty || newEmail.isEmpty || newNotelp.isEmpty || newKtp.isEmpty || newAlamat.isEmpty || newRole.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    // Validasi format email menggunakan regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(newEmail)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid email format')));
      return;
    }

    try {
      var url = Uri.parse('http://192.168.42.183/informasi/updateUser.php');
      var response = await http.post(url, body: {
        'id_user': widget.currentUser.id_user.toString(),
        'nama': newNama,
        'email': newEmail,
        'no_telp': newNotelp,
        'ktp': newKtp,
        'alamat': newAlamat,
      });

      var data = json.decode(response.body);

      if (data['is_success']) {
        setState(() {
          widget.currentUser.nama = newNama;
          widget.currentUser.email = newEmail;
          widget.currentUser.no_telp = newNotelp;
          widget.currentUser.ktp = newKtp;
          widget.currentUser.alamat = newAlamat;

          sessionManager.saveSession(
            200,
            widget.currentUser.id_user.toString(),
            newNama,
            newEmail,
            newNotelp,
            newKtp,
            newAlamat,
            newRole,
          );
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));
        Navigator.pop(context);

        // Ganti halaman ke halaman profil yang diperbarui
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(currentUser: widget.currentUser)),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFD2B48C),
            title: Text('Edit Profile'),
          ),
          backgroundColor: Color(0xFFD2B48C),
          body: Form(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Name Tidak Boleh kosong"
                                      : null;
                                },
                                controller: _namaController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Name',
                                  suffixIcon: _name != null && _name!.isNotEmpty
                                      ? Icon(Icons.check, color: Colors.brown)
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _name = value.trim();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Email Tidak Boleh kosong"
                                      : null;
                                },
                                controller: _emailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Email',
                                  suffixIcon: _email != null &&
                                      _email!.isNotEmpty
                                      ? Icon(Icons.check, color: Colors.brown)
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _email = value.trim();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Name Tidak Boleh kosong"
                                      : null;
                                },
                                controller: _noTelpController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'No Telp',
                                  suffixIcon: _name != null && _name!.isNotEmpty
                                      ? Icon(Icons.check, color: Colors.brown)
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _name = value.trim();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Name Tidak Boleh kosong"
                                      : null;
                                },
                                controller: _ktpController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Ktp',
                                  suffixIcon: _name != null && _name!.isNotEmpty
                                      ? Icon(Icons.check, color: Colors.brown)
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _name = value.trim();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Name Tidak Boleh kosong"
                                      : null;
                                },
                                controller: _alamatController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Alamat',
                                  suffixIcon: _name != null && _name!.isNotEmpty
                                      ? Icon(Icons.check, color: Colors.brown)
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _name = value.trim();
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width:
                              MediaQuery.of(context).size.width - (2 * 98),
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 7,
                                  backgroundColor: Color(0xFF8B4513),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  // Implement logic to save changes
                                  String newNama = _namaController.text;
                                  String newEmail = _emailController.text; // Ambil nilai dari controller email
                                  String newNotelp = _noTelpController.text;
                                  String newKtp = _ktpController.text;
                                  String newAlamat = _alamatController.text;
                                  String newRole = _roleController.text;

                                  // Panggil fungsi untuk menyimpan perubahan
                                  saveChanges(newNama, newEmail, newNotelp, newKtp, newAlamat, newRole );
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
