import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/model_register.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  String? _name;
  String? _email;

  TextEditingController txtNama = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtNotelp = TextEditingController();
  TextEditingController txtKtp = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<ModelRegister?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(
        Uri.parse('http://192.168.42.183/informasi/register.php'),
        body: {
          "nama": txtNama.text,
          "password": txtPassword.text,
          "email": txtEmail.text,
          "no_telp": txtNotelp.text,
          "ktp": txtKtp.text,
          "alamat": txtAlamat.text,
        },
      );

      ModelRegister data = modelRegisterFromJson(res.body);
      //cek kondisi respon
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          //kondisi berhasil dan pindah ke page login
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
          );
        });
        //kondisi email sudah ada
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        });
        //kondisi gagal daftar
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFD2B48C),
          body: Form(
            key: keyForm,
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
                        child: Text(
                          'Join us to start searching',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Lets get started! Create your account to access all the features.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
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
                                controller: txtNama,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
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
                                controller: txtEmail,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
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
                              height: 10,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Password Tidak Boleh kosong"
                                      : null;
                                },
                                controller: txtPassword,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
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
                                      ? "No Telepon Tidak Boleh kosong"
                                      : null;
                                },
                                controller: txtNotelp,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'No Telp',
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
                              height: 10,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "KTP Tidak Boleh kosong"
                                      : null;
                                },
                                controller: txtKtp,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'KTP',
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
                              height: 10,
                            ),
                            Container(
                              width: 450,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "Alamat Tidak Boleh kosong"
                                      : null;
                                },
                                controller: txtAlamat,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Alamat',
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
                            SizedBox(height: 50,),
                            Container(
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width - (2 * 98),
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
                                  if (keyForm.currentState?.validate() ==
                                      true) {
                                    registerAccount();
                                  }
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  // Menambahkan jarak vertikal di antara dua link
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: Text(
                                      'Have an account? Log in',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
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
