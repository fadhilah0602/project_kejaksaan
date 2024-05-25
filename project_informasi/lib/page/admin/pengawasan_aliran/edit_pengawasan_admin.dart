import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:project_informasi/page/admin/homeAdmin_screen.dart';

import '../../../models/model_korupsi.dart';
import '../../../models/model_pengaduan.dart';
import '../../../models/model_pengawasan.dart';

class EditPengawasanAdmin extends StatefulWidget {
  final ModelPengawasan pengawasan;

  const EditPengawasanAdmin({Key? key, required this.pengawasan})
      : super(key: key);

  @override
  State<EditPengawasanAdmin> createState() => _EditPengawasanAdminState();
}

class _EditPengawasanAdminState extends State<EditPengawasanAdmin> {
  late TextEditingController _namapelaporController;
  late TextEditingController _nohpController;
  late TextEditingController _ktpController;
  late TextEditingController _ktp_pdfController;
  late TextEditingController _laporanController;
  late TextEditingController _laporan_pdfController;
  String _statusValue = '';
  // TextEditingController _statusController = TextEditingController();
  String? laporanPdfFilePath;
  String? ktpPdfFilePath;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _downloadPdf('laporan');
    _downloadPdf('ktp');
    _namapelaporController =
        TextEditingController(text: widget.pengawasan.data[0].nama_pelapor);
    _nohpController =
        TextEditingController(text: widget.pengawasan.data[0].no_hp);
    _ktpController = TextEditingController(text: widget.pengawasan.data[0].ktp);
    _ktp_pdfController =
        TextEditingController(text: widget.pengawasan.data[0].ktp_pdf);
    _laporanController =
        TextEditingController(text: widget.pengawasan.data[0].laporan);
    _laporan_pdfController =
        TextEditingController(text: widget.pengawasan.data[0].laporan_pdf);
    _statusValue = widget.pengawasan.data.first.status;
    // _statusValue =
    //     TextEditingController(text: widget.pengaduan.data[0].status);
  }

  @override
  void dispose() {
    _namapelaporController.dispose();
    _nohpController.dispose();
    _ktpController.dispose();
    _ktp_pdfController.dispose();
    _laporan_pdfController.dispose();
    _laporanController.dispose();
    super.dispose();
  }

  Future<void> _downloadPdf(String type) async {
    String pdfUrl;
    if (type == 'laporan') {
      pdfUrl = 'http://192.168.42.183/informasi/${widget.pengawasan.data[0].laporan_pdf}';
    } else {
      pdfUrl = 'http://192.168.42.183/informasi/${widget.pengawasan.data[0].ktp_pdf}';
    }

    // Log the URL for debugging
    print('PDF URL: $pdfUrl');

    try {
      var response = await http.get(Uri.parse(pdfUrl));
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        var dir = await getApplicationDocumentsDirectory();
        var uploadDir = Directory('${dir.path}/uploads');

        if (!await uploadDir.exists()) {
          await uploadDir.create(recursive: true);
        }

        String fileName = pdfUrl.split('/').last;
        File file = File('${uploadDir.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          if (type == 'laporan') {
            laporanPdfFilePath = file.path;
          } else {
            ktpPdfFilePath = file.path;
          }
        });
      } else {
        throw Exception('Failed to download PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  // Future<void> downloadPDF(String fileName) async {
  //   String url = 'http://192.168.42.183/informasi/pengawasan.php?file=$fileName';
  //   try {
  //     var dio = Dio();
  //     var directory = await getApplicationDocumentsDirectory();
  //     String filePath = "${directory.path}/$fileName";
  //     await dio.download(url, filePath);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Download completed: $filePath'))
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error downloading PDF: $e'))
  //     );
  //   }
  // }

  Future<void> saveChanges(String newNamaPelapor, String newNohp, String newKtp, String newKtpPdf, String newLaporan,  String newLaporanPdf, String newStatus) async {
    if (newNamaPelapor.isEmpty ||
        newNohp.isEmpty ||
        newKtp.isEmpty ||
        newLaporan.isEmpty ||
        newLaporanPdf.isEmpty ||
        newStatus.isEmpty ||
        newKtpPdf.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    Uri uri = Uri.parse('http://192.168.42.183/informasi/updateAdminPengawasan.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_pengawasan'] = widget.pengawasan.data.first.id_pengawasan
    ..fields['nama_pelapor'] = newNamaPelapor  // Menggunakan nilai baru
    ..fields['no_hp'] = newNohp  // Menggunakan nilai baru
    ..fields['ktp'] = newKtp  // Menggunakan nilai baru
    ..fields['laporan'] = newLaporan  // Menggunakan nilai baru
    ..fields['laporan_pdf'] = newLaporanPdf  // Menggunakan nilai baru
    ..fields['ktp_pdf'] = newKtpPdf  // Menggunakan nilai baru
    ..fields['status'] = newStatus;

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
      appBar: AppBar(
        title: Text(
          "Edit Pengawasan Aliran",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF8B4513),
      ),
      backgroundColor: Color(0xFFD2B48C),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(20),
              child: Container(
                width: 450,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Pelapor  : ' + (widget.pengawasan.data[0].nama_pelapor ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'No HP               : ' + (widget.pengawasan.data[0].no_hp ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5), // Jarak antar teks
                    Text(
                      'KTP                   : ' + (widget.pengawasan.data[0].ktp ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5), // Jarak antar teks
                    Text(
                      'Laporan            : ' + (widget.pengawasan.data[0].laporan ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Laporan PDF',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: laporanPdfFilePath != null
                  ? PDFView(filePath: laporanPdfFilePath!)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 5),
            Text(
              'KTP PDF',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ktpPdfFilePath != null
                  ? PDFView(filePath: ktpPdfFilePath!)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 5),
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
              //     // DropdownMenuItem<String>(
              //     //   value: 'Pending',
              //     //   child: Text('Pending'),
              //     // ),
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
            SizedBox(height: 12),
            Container(
              width: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  saveChanges(_namapelaporController.text, _nohpController.text,
                      _ktpController.text, _ktp_pdfController.text, _laporanController.text, _laporan_pdfController.text,_statusValue);
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
      // body: SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child: Stack(
      //     children: <Widget>[
      //       Container(
      //         height: MediaQuery
      //             .of(context)
      //             .size
      //             .height * 0.2,
      //         decoration: BoxDecoration(
      //           color: Color(0xFF8B4513),
      //           borderRadius: BorderRadius.only(
      //             bottomLeft: Radius.circular(40),
      //             bottomRight: Radius.circular(40),
      //           ),
      //         ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           crossAxisAlignment: CrossAxisAlignment.end,
      //           children: [
      //             Column(
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(top: 40, left: 50),
      //                   child: Expanded(
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Column(
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(top: 25, right: 50),
      //                 )
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //       Container(),
      //       Positioned(
      //         top: 120.0,
      //         left: 40.0,
      //         right: 40.0,
      //         child: AppBar(
      //           elevation: 12,
      //           backgroundColor: Colors.white,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.all(Radius.circular(12))),
      //           primary: false,
      //           title: Text(
      //             "Edit Pengawasan Aliran",
      //             style: TextStyle(color: Colors.black),
      //           ),
      //         ),
      //       ),
      //       SizedBox(
      //         height: 50,
      //       ),
      //       Center(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             SizedBox(
      //               height: 200,
      //             ),
      //             Container(
      //               width: 450,
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: TextField(
      //                 style: TextStyle(
      //                   fontFamily: 'Mulish',
      //                 ),
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   hintText: "Name",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(12),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _namapelaporController,
      //                 enabled: false,
      //               ),
      //             ),
      //             SizedBox(height: 16),
      //             Container(
      //               width: 450,
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: TextField(
      //                 style: TextStyle(
      //                   fontFamily: 'Mulish',
      //                 ),
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   hintText: "Name",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _nohpController,
      //                 enabled: false,
      //               ),
      //             ),
      //             SizedBox(height: 16),
      //             Container(
      //               width: 450,
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: TextField(
      //                 style: TextStyle(
      //                   fontFamily: 'Mulish',
      //                 ),
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   hintText: "Name",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _ktpController,
      //                 enabled: false,
      //               ),
      //             ),
      //             SizedBox(height: 16),
      //             // Container(
      //             //   width: 450,
      //             //   padding: EdgeInsets.symmetric(horizontal: 20),
      //             //   child: TextField(
      //             //     style: TextStyle(
      //             //       fontFamily: 'Mulish',
      //             //     ),
      //             //     decoration: InputDecoration(
      //             //       filled: true,
      //             //       fillColor: Colors.white,
      //             //       hintText: "KTP PDF",
      //             //       border: OutlineInputBorder(
      //             //         borderRadius: BorderRadius.circular(8.0),
      //             //         borderSide: BorderSide.none,
      //             //       ),
      //             //       contentPadding:
      //             //       EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //             //     ),
      //             //     controller: _ktp_pdfController,
      //             //     enabled: false,
      //             //   ),
      //             // ),
      //             // ElevatedButton(
      //             //   onPressed: () {
      //             //     downloadPDF(_ktp_pdfController.text);
      //             //   },
      //             //   child: Text("Download KTP PDF"),
      //             // ),
      //             // SizedBox(height: 16),
      //             // Container(
      //             //   width: 450,
      //             //   padding: EdgeInsets.symmetric(horizontal: 20),
      //             //   child: TextField(
      //             //     style: TextStyle(
      //             //       fontFamily: 'Mulish',
      //             //     ),
      //             //     decoration: InputDecoration(
      //             //       filled: true,
      //             //       fillColor: Colors.white,
      //             //       hintText: "Name",
      //             //       border: OutlineInputBorder(
      //             //         borderRadius: BorderRadius.circular(8.0),
      //             //         borderSide: BorderSide.none,
      //             //       ),
      //             //       contentPadding:
      //             //       EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //             //     ),
      //             //     controller: _laporanController,
      //             //     enabled: false,
      //             //   ),
      //             // ),
      //             // SizedBox(height: 16),
      //             // Container(
      //             //   width: 450,
      //             //   padding: EdgeInsets.symmetric(horizontal: 20),
      //             //   child: TextField(
      //             //     style: TextStyle(
      //             //       fontFamily: 'Mulish',
      //             //     ),
      //             //     decoration: InputDecoration(
      //             //       filled: true,
      //             //       fillColor: Colors.white,
      //             //       hintText: "Name",
      //             //       border: OutlineInputBorder(
      //             //         borderRadius: BorderRadius.circular(8.0),
      //             //         borderSide: BorderSide.none,
      //             //       ),
      //             //       contentPadding:
      //             //       EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //             //     ),
      //             //     controller: _laporan_pdfController,
      //             //     enabled: false,
      //             //   ),
      //             // ),
      //             SizedBox(height: 16),
      //             Container(
      //               width: 450,
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: DropdownButtonFormField<String>(
      //                 decoration: InputDecoration(
      //                   hintText: 'Status ',
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 value: _statusValue.isNotEmpty ? _statusValue : null,
      //                 onChanged: (String? newValue) {
      //                   setState(() {
      //                     _statusValue = newValue!;
      //                   });
      //                 },
      //                 items: <String>['Pending', 'Approved', 'Rejected']
      //                     .map<DropdownMenuItem<String>>((String value) {
      //                   return DropdownMenuItem<String>(
      //                     value: value,
      //                     child: Text(value),
      //                   );
      //                 }).toList(),
      //               ),
      //               // child: DropdownButtonFormField<String>(
      //               //   decoration: InputDecoration(
      //               //     filled: true,
      //               //     fillColor: Colors.white,
      //               //     border: OutlineInputBorder(
      //               //       borderRadius: BorderRadius.circular(8.0),
      //               //       borderSide: BorderSide.none,
      //               //     ),
      //               //     contentPadding:
      //               //     EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //               //   ),
      //               //   value: _statusValue,
      //               //   onChanged: (value) {
      //               //     setState(() {
      //               //       _statusValue = value!;
      //               //     });
      //               //   },
      //               //   items: [
      //               //     // DropdownMenuItem<String>(
      //               //     //   value: 'Pending',
      //               //     //   child: Text('Pending'),
      //               //     // ),
      //               //     DropdownMenuItem<String>(
      //               //       value: 'Approved',
      //               //       child: Text('Approved'),
      //               //     ),
      //               //     DropdownMenuItem<String>(
      //               //       value: 'Rejected',
      //               //       child: Text('Rejected'),
      //               //     ),
      //               //   ],
      //               // ),
      //             ),
      //             SizedBox(height: 30),
      //             Container(
      //               width: 300,
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: InkWell(
      //                 onTap: () {
      //                   saveChanges(_namapelaporController.text, _nohpController.text,
      //                       _ktpController.text, _ktp_pdfController.text, _laporanController.text, _laporan_pdfController.text,_statusValue);
      //                 },
      //                 child: Container(
      //                   height: 60,
      //                   decoration: BoxDecoration(
      //                     color: Color(0xFF8B4513),
      //                     borderRadius: BorderRadius.circular(20),
      //                   ),
      //                   child: Stack(
      //                     alignment: Alignment.center,
      //                     children: <Widget>[
      //                       Align(
      //                         alignment: Alignment.center,
      //                         child: Text(
      //                           'Edit ',
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                             fontSize: 18,
      //                             fontWeight: FontWeight.bold,
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

