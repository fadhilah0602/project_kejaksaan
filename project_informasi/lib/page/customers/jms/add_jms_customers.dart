import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_informasi/page/customers/home_screen.dart';
import 'package:project_informasi/page/customers/penilaian/add_penilaian_customers.dart';
import '../../../models/model_addJms.dart';
import '../../../utils/session_manager.dart';

class AddJmsCustomersScreen extends StatefulWidget {
  const AddJmsCustomersScreen({Key? key}) : super(key: key);

  @override
  State<AddJmsCustomersScreen> createState() => _AddJmsCustomersScreenState();
}

class _AddJmsCustomersScreenState extends State<AddJmsCustomersScreen> {
  TextEditingController _namaPemohonController = TextEditingController(); //untuk input
  TextEditingController _sekolahController = TextEditingController();
  final String _statusValue = "Pending"; // untuk status default
  String? _userId; // Untuk menyimpan id_user

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await sessionManager.getSession();
    setState(() {
      _userId = sessionManager.id_user;
    });
  }


  Future<void> addJms() async {
    if (_namaPemohonController.text.isEmpty || _sekolahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID tidak ditemukan')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Uri uri = Uri.parse('http://192.168.42.183/informasi/createJms.php');

      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['id_user'] = _userId! // Menambahkan id_user
        ..fields['nama_pemohon'] = _namaPemohonController.text
        ..fields['sekolah'] = _sekolahController.text
        ..fields['status'] = _statusValue; // set status

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Server response: $responseBody");

      if (response.statusCode == 200) {
        try {
          ModelAddJms data = modelAddJmsFromJson(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          if (data.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AddPenilaianCustomersScreen()),
                  (route) => false,
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to parse response: $e')),
          );
        }
      } else {
        throw Exception('Failed to upload data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
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
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Color(0xFF8B4513),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40, left: 50),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25, right: 50),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(),
            Positioned(
              top: 120.0,
              left: 40.0,
              right: 40.0,
              child: AppBar(
                elevation: 12,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                primary: false,
                title: Text(
                  "Add Jaksa Masuk Sekolah",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    width: 450,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Nama Pemohon",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      controller: _namaPemohonController,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 450,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Sekolah",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      controller: _sekolahController,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        addJms();
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
