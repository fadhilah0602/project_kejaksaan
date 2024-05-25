import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:project_informasi/page/admin/homeAdmin_screen.dart';
import '../../../models/model_jms.dart';

class EditJmsAdmin extends StatefulWidget {
  final ModelJms jms;

  const EditJmsAdmin({Key? key, required this.jms})
      : super(key: key);

  @override
  State<EditJmsAdmin> createState() => _EditJmsAdminState();
}

class _EditJmsAdminState extends State<EditJmsAdmin> {
  late TextEditingController _namapemohonController; //ambil value
  late TextEditingController _sekolahController;
  String _statusValue = ''; // inputan

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _namapemohonController =
        TextEditingController(text: widget.jms.data[0].nama_pemohon);
    _sekolahController =
        TextEditingController(text: widget.jms.data[0].sekolah);
    _statusValue = widget.jms.data.first.status;
  }

  @override
  void dispose() {
    _namapemohonController.dispose();
    _sekolahController.dispose();
    super.dispose();
  }

  Future<void> saveChanges(String newNamaPemohon, String newSekolah, newStatus, ) async {
    if (newNamaPemohon.isEmpty ||
        newSekolah.isEmpty ||
        newStatus.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    Uri uri = Uri.parse('http://192.168.42.183/informasi/updateAdminJms.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_jms'] = widget.jms.data.first.id_jms
      ..fields['nama_pemohon'] = newNamaPemohon  // Menggunakan nilai baru
      ..fields['sekolah'] = newSekolah  // Menggunakan nilai baru
      ..fields['status'] = newStatus;  // Menggunakan nilai baru

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);
        print(
            "Response Body: $responseBody"); // Log the full response body for debugging

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));

        // Safely check for 'is_success' with a default value of false if not found
        bool isSuccess = data['isSuccess'] ?? false;
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeAdminScreen()),
          );
        }
      } else {
        throw Exception(
            'Failed to update data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        var isLoading =
        false; // Ensure isLoading is set to false in finally block
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
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
                  "Edit Jaksa Masuk Sekolah",
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
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      controller: _namapemohonController,
                      enabled: false,
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
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      controller: _sekolahController,
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 450,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Status ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      value: _statusValue.isNotEmpty ? _statusValue : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          _statusValue = newValue!;
                        });
                      },
                      items: <String>['Pending', 'Approved', 'Rejected']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // child: DropdownButtonFormField<String>(
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     contentPadding:
                    //     EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    //   ),
                    //   value: _statusValue,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _statusValue = value!;
                    //     });
                    //   },
                    //   items: [
                    //     DropdownMenuItem<String>(
                    //       value: 'Pending',
                    //       child: Text('Pending'),
                    //     ),
                    //     DropdownMenuItem<String>(
                    //       value: 'Approved',
                    //       child: Text('Approved'),
                    //     ),
                    //     DropdownMenuItem<String>(
                    //       value: 'Rejected',
                    //       child: Text('Rejected'),
                    //     ),
                    //   ],
                    // ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        saveChanges(_namapemohonController.text, _sekolahController.text,_statusValue);
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
                                'Edit ',
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

