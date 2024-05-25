import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_informasi/page/customers/pidana_korupsi/list_korupsi_customers.dart';
import '../../../models/model_jms.dart';
import '../../../models/model_korupsi.dart';
import '../../../models/model_pengaduan.dart';
import '../../../utils/session_manager.dart';

class EditKorupsiRejectedScreen extends StatefulWidget {
  final ModelKorupsi korupsi;

  const EditKorupsiRejectedScreen({Key? key, required this.korupsi})
      : super(key: key);

  @override
  State<EditKorupsiRejectedScreen> createState() => _EditKorupsiRejectedScreenState();
}

class _EditKorupsiRejectedScreenState extends State<EditKorupsiRejectedScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaPelaporController = TextEditingController(); //untuk input
  TextEditingController _noHpController = TextEditingController();
  TextEditingController _ktpController = TextEditingController();
  TextEditingController _uraianController = TextEditingController();
  String _ktpPdfPath = '';
  TextEditingController _laporanController = TextEditingController();
  String _laporanPdfPath = '';
  // String? _userId;

  @override
  void initState() {
    super.initState();
    // _loadUserId();
    _laporanController.text = widget.korupsi.data.first.laporan ?? '';
    _namaPelaporController.text = widget.korupsi.data.first.nama_pelapor ?? '';
    _ktpController.text = widget.korupsi.data.first.ktp ?? '';
    _noHpController.text = widget.korupsi.data.first.no_hp ?? '';
    _uraianController.text = widget.korupsi.data.first.uraian ?? '';

  }

  // Future<void> _loadUserId() async {
  //   await sessionManager.getSession();
  //   setState(() {
  //     _userId = sessionManager.id_user;
  //   });
  // }
  // bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.pengaduan.data.isNotEmpty) {
  //     _namaPelaporController.text = widget.pengaduan.data.first.nama_pelapor;
  //     _noHpController.text = widget.pengaduan.data.first.no_hp;
  //     _ktpController.text = widget.pengaduan.data.first.ktp;
  //     _ktpPdfPath = widget.pengaduan.data.first.ktp_pdf;
  //     _laporanController.text = widget.pengaduan.data.first.laporan;
  //     _laporanPdfPath = widget.pengaduan.data.first.laporan_pdf;
  //     _statusController = TextEditingController(text: widget.pengaduan.data[0].status);
  //   }
  // }

  Future<void> selectFileLaporan() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _laporanPdfPath = result.files.single.path!;
      });
    }
  }

  Future<void> selectFileKtp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _ktpPdfPath = result.files.single.path!;
      });
    }
  }

  Future<void> _updatePengaduan() async {
    if (_formKey.currentState!.validate()) {
      try {
        Uri uri = Uri.parse('http://192.168.42.183/informasi/editKorupsi.php');

        http.MultipartRequest request = http.MultipartRequest('POST', uri)
          ..fields['id_korupsi'] = widget.korupsi.data.first.id_korupsi
          ..fields['id_user'] = widget.korupsi.data.first.id_user
          ..fields['laporan'] = _laporanController.text
          ..fields['uraian'] = _uraianController.text
          ..fields['nama_pelapor'] = _namaPelaporController.text
          ..fields['ktp'] = _ktpController.text
          ..fields['no_hp'] = _noHpController.text
          ..fields['status'] = widget.korupsi.data.first.status; // Set the status field

        if (_laporanPdfPath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'laporan_pdf',
              _laporanPdfPath,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }

        if (_ktpPdfPath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'ktp_pdf',
              _ktpPdfPath,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }

        http.StreamedResponse response = await request.send();
        String responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil diubah')),
          );
          // Navigator.pop(context, true); // Mengirim hasil kembali ke halaman sebelumnya
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListKorupsiCustomersScreen()),
          );
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  // Future<void> saveChanges() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       Uri uri = Uri.parse('http://192.168.42.183/informasi/editPengaduan.php');
  //
  //       http.MultipartRequest request = http.MultipartRequest('POST', uri)
  //         ..fields['id_pengaduan'] = widget.pengaduan.data.first.id_pengaduan
  //         ..fields['id_user'] = widget.pengaduan.data.first.id_user
  //         ..fields['laporan'] = _laporanController.text
  //         ..fields['nama_pelapor'] = _namaPelaporController.text
  //         ..fields['ktp'] = _ktpController.text
  //         ..fields['no_hp'] = _noHpController.text
  //         ..fields['status'] = widget.pengaduan.data.first.status; // Set the status field
  //
  //       if (_laporanPdfPath.isNotEmpty) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             'laporan_pdf',
  //             _laporanPdfPath,
  //             contentType: MediaType('application', 'pdf'),
  //           ),
  //         );
  //       }
  //
  //       if (_ktpPdfPath.isNotEmpty) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             'ktp_pdf',
  //             _ktpPdfPath,
  //             contentType: MediaType('application', 'pdf'),
  //           ),
  //         );
  //       }
  //
  //       http.StreamedResponse response = await request.send();
  //       String responseBody = await response.stream.bytesToString();
  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Data Berhasil Diubah')),
  //         );
  //         Navigator.pop(context, true); // Mengirim hasil kembali ke halaman sebelumnya
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  void dispose() {
    _laporanController.dispose();
    _namaPelaporController.dispose();
    _ktpController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  Future<void> deleteJms() async {
    Uri uri = Uri.parse('http://192.168.42.183/informasi/deleteKorupsi.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_korupsi'] = widget.korupsi.data.first.id_korupsi;

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
            MaterialPageRoute(builder: (context) => ListKorupsiCustomersScreen()),
          );
        }
      } else {
        throw Exception('Failed to delete data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
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
                  "Edit Pidana Korupsi",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: Form(
                  key: _formKey,
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
                          controller: _namaPelaporController,
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
                          controller: _noHpController,
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
                            hintText: "KTP",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          controller: _ktpController,
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
                            hintText: "Uraian",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          controller: _uraianController,
                        ),
                      ),
                      SizedBox(height: 16,),
                      Container(
                        width: 450,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: selectFileKtp,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Pilih File Ktp",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_rounded),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _ktpPdfPath.isNotEmpty
                                        ? _ktpPdfPath.split('/').last
                                        : 'Pilih File Ktp',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            hintText: "Laporan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                          controller: _laporanController,
                        ),
                      ),
                      SizedBox(height: 16,),
                      Container(
                        width: 450,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: selectFileLaporan,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Pilih File Laporan",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_rounded),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _laporanPdfPath.isNotEmpty
                                        ? _laporanPdfPath.split('/').last
                                        : 'Pilih File Laporan',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Container(
                      //   width: 450,
                      //   padding: EdgeInsets.symmetric(horizontal: 20),
                      //   child: TextField(
                      //     style: TextStyle(
                      //       fontFamily: 'Mulish',
                      //     ),
                      //     decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.white,
                      //       hintText: "Name",
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         borderSide: BorderSide.none,
                      //       ),
                      //       contentPadding:
                      //       EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      //     ),
                      //     controller: s,
                      //     enabled: false,
                      //   ),
                      // ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            child: InkWell(
                              onTap: () {
                                // Fungsi untuk tombol pertama
                                _updatePengaduan();
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
                )
            ),
          ],
        ),
      ),
    );
  }
}
