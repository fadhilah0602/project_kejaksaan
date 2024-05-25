import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../../../models/model_addJms.dart';
import '../../../utils/session_manager.dart';
import '../penilaian/add_penilaian_customers.dart';

class AddPoskoCustomersScreen extends StatefulWidget {
  const AddPoskoCustomersScreen({Key? key}) : super(key: key);

  @override
  State<AddPoskoCustomersScreen> createState() => _AddPoskoCustomersScreenState();
}

class _AddPoskoCustomersScreenState extends State<AddPoskoCustomersScreen> {
  TextEditingController _namaPelaporController = TextEditingController(); //untuk input
  TextEditingController _noHpController = TextEditingController();
  TextEditingController _ktpController = TextEditingController();
  String _ktpPdfPath = '';
  TextEditingController _laporanController = TextEditingController();
  String _laporanPdfPath = '';
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

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> selectFileKtp() async {
    if (await requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any); // Ubah menjadi FileType.any
      if (result != null && result.files.single.path != null) {
        setState(() {
          _ktpPdfPath = result.files.single.path!;
        });
      } else {
        print("No file selected");
      }
    } else {
      print("Storage permission not granted");
    }
  }
  // Future<void> pickKtpPdf() async {
  //   final params = OpenFileDialogParams(
  //     dialogType: OpenFileDialogType.document,
  //     allowedUtiTypes: ['application/pdf'],
  //   );
  //   final path = await FlutterFileDialog.pickFile(params: params);
  //   setState(() {
  //     _ktpPdfPath = path ?? '';
  //   });
  // }

  Future<void> selectFileLaporanPengaduan() async {
    if (await requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any); // Ubah menjadi FileType.any
      if (result != null && result.files.single.path != null) {
        setState(() {
          _laporanPdfPath = result.files.single.path!;
        });
      } else {
        print("No file selected");
      }
    } else {
      print("Storage permission not granted");
    }
  }


  // Future<void> pickLaporanPdf() async {
  //   final params = OpenFileDialogParams(
  //     dialogType: OpenFileDialogType.document,
  //     allowedUtiTypes: ['application/pdf'],
  //   );
  //   final path = await FlutterFileDialog.pickFile(params: params);
  //   setState(() {
  //     _laporanPdfPath = path ?? '';
  //   });
  // }

  Future<void> addPengaduan() async {
    if (_namaPelaporController.text.isEmpty ||
        _noHpController.text.isEmpty ||
        _ktpController.text.isEmpty ||
        _ktpPdfPath.isEmpty ||
        _laporanPdfPath.isEmpty ||
        _laporanController.text.isEmpty) {
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
      Uri uri = Uri.parse('http://192.168.42.183/informasi/addPosko.php');

      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['id_user'] = _userId!
        ..fields['nama_pelapor'] = _namaPelaporController.text
        ..fields['no_hp'] = _noHpController.text
        ..fields['ktp'] = _ktpController.text
        ..fields['laporan'] = _laporanController.text
        ..fields['status'] = _statusValue;

      if (_laporanPdfPath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'laporan_pdf',
            _laporanPdfPath,
            contentType: MediaType('application', 'pdf'), // Ubah tipe konten sesuai dengan PDF
          ),
        );
      }

      if (_ktpPdfPath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ktp_pdf',
            _ktpPdfPath,
            contentType: MediaType('application', 'pdf'), // Ubah tipe konten sesuai dengan PDF
          ),
        );
      }

      // request.files.add(await http.MultipartFile.fromPath('ktp_pdf', _ktpPdfPath));
      // request.files.add(await http.MultipartFile.fromPath('laporan_pdf', _laporanPdfPath));

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPenilaianCustomersScreen()),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memproses respon: $e')),
          );
        }
      } else {
        throw Exception('Gagal mengunggah data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  // Future<void> addPengaduan() async {
  //   if (_namaPelaporController.text.isEmpty ||
  //       _noHpController.text.isEmpty ||
  //       _ktpController.text.isEmpty ||
  //       _ktpPdfPath.isEmpty ||
  //       _laporanPdfPath.isEmpty ||
  //       _laporanController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Semua field harus diisi')),
  //     );
  //     return;
  //   }
  //
  //   if (_userId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('User ID tidak ditemukan')),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     Uri uri = Uri.parse('http://192.168.43.38/informasi/addPengaduan.php');
  //
  //     http.MultipartRequest request = http.MultipartRequest('POST', uri)
  //       ..fields['id_user'] = _userId! // Menambahkan id_user
  //       ..fields['nama_pelapor'] = _namaPelaporController.text
  //       ..fields['no_hp'] = _noHpController.text
  //       ..fields['ktp'] = _ktpController.text
  //       ..fields['laporan'] = _laporanController.text
  //       ..fields['status'] = _statusValue; // set status
  //
  //     // Menambahkan file PDF untuk KTP dan laporan
  //     request.files.add(await http.MultipartFile.fromPath('ktp_pdf', _ktpPdfPath));
  //     request.files.add(await http.MultipartFile.fromPath('laporan_pdf', _laporanPdfPath));
  //
  //     http.StreamedResponse response = await request.send();
  //     String responseBody = await response.stream.bytesToString();
  //     print("Server response: $responseBody");
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         ModelAddJms data = modelAddJmsFromJson(responseBody);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('${data.message}')),
  //         );
  //         if (data.isSuccess) {
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => AddPenilaianCustomersScreen()),
  //                 (route) => false,
  //           );
  //         }
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to parse response: $e')),
  //         );
  //       }
  //     } else {
  //       throw Exception('Failed to upload data, status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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
                  "Add Posko Pilkada",
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
                        hintText: "Nama Pelapor",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                        hintText: "No HP",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      onTap: selectFileLaporanPengaduan,
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

                  SizedBox(height: 30),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        addPengaduan();
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
