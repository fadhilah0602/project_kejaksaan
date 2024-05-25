import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/model_jms.dart';
import 'list_jms_customers.dart';

class EditJmsRejectedScreen extends StatefulWidget {
  final ModelJms jms;

  const EditJmsRejectedScreen({Key? key, required this.jms})
      : super(key: key);

  @override
  State<EditJmsRejectedScreen> createState() => _EditJmsRejectedScreenState();
}

class _EditJmsRejectedScreenState extends State<EditJmsRejectedScreen> {
  TextEditingController _namaPemohonController = TextEditingController(); //untuk input
  TextEditingController _sekolahController = TextEditingController();
  late TextEditingController _statusController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.jms.data.isNotEmpty) {
      _namaPemohonController.text = widget.jms.data.first.nama_pemohon;
      _sekolahController.text = widget.jms.data.first.sekolah;
      _statusController = TextEditingController(text: widget.jms.data[0].status);
    }
  }

  Future<void> saveChanges(String newNamaPemohon, String newSekolah) async {
    if (newNamaPemohon.isEmpty ||
        newSekolah.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    Uri uri = Uri.parse('http://192.168.42.183/informasi/updateJms.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_jms'] = widget.jms.data.first.id_jms
      ..fields['nama_pemohon'] = newNamaPemohon
      ..fields['sekolah'] = newSekolah;

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
            MaterialPageRoute(builder: (context) => ListJmsCustomersScreen()),
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

  Future<void> deleteJms() async {
    Uri uri = Uri.parse('http://192.168.42.183/informasi/deleteJms.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_jms'] = widget.jms.data.first.id_jms;

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);
        print("Response Body: $responseBody");

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));

        bool isSuccess = data['isSuccess'] ?? false;
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListJmsCustomersScreen()),
          );
        }
      } else {
        throw Exception('Failed to delete data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
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
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      controller: _sekolahController,
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
                      controller: _statusController,
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            // Fungsi untuk tombol pertama
                            saveChanges(_namaPemohonController.text, _sekolahController.text);
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF8B4513),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            // Panggil fungsi deleteJms untuk menghapus data
                            deleteJms();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF8B4513),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Hapus',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
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
