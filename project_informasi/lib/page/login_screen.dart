import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_informasi/models/model_user.dart';
import 'package:project_informasi/page/admin/homeAdmin_screen.dart';
import 'package:project_informasi/page/signup_screen.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import '../models/model_login.dart';
import '../utils/session_manager.dart';
import 'customers/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  String? _name;

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('http://192.168.42.183/informasi/login.php'),
        body: {
          "login": "1",
          "email": txtEmail.text,
          "password": txtPassword.text,
        },
      );

      if (res.statusCode == 200) {
        ModelLogin data = ModelLogin.fromJson(json.decode(res.body));
        if (data.sukses) {
          if (data.data != null &&
              data.data.id_user != null &&
              data.data.nama != null &&
              data.data.email != null &&
              data.data.no_telp != null &&
              data.data.ktp != null &&
              data.data.alamat != null &&
              data.data.role != null) {
            // Save session
            sessionManager.saveSession(
              data.status,
              data.data.id_user,
              data.data.nama,
              data.data.email,
              data.data.no_telp,
              data.data.ktp,
              data.data.alamat,
              data.data.role,
            );

            // Use AuthService to set the current user
            final authService = Provider.of<AuthService>(context, listen: false);
            authService.setCurrentUser(ModelUsers(
              id_user: data.data.id_user,
              nama: data.data.nama,
              email: data.data.email,
              no_telp: data.data.no_telp,
              ktp: data.data.ktp,
              alamat: data.data.alamat,
              role: data.data.role,
            ));

            // Navigate to the appropriate screen based on user role
            if (data.data.role == 'Admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeAdminScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${data.pesan}')));
          } else {
            throw Exception('Data pengguna tidak lengkap atau null');
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.pesan}')));
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD2B48C),
      body: SingleChildScrollView(
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
                    'Welcome To Culture Application',
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
                    'It\'s great to see you again. Log in to continue your journey.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: keyForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
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
                              // fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Email',
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
                        SizedBox(height: 10),
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
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width - (2 * 98),
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
                              if (keyForm.currentState?.validate() == true) {
                                loginAccount();
                              }
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpScreen()),
                                  );
                                },
                                child: Text(
                                  'Don\'t have an account? Join us',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
