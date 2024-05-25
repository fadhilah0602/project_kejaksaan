import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:project_informasi/page/admin/homeAdmin_screen.dart';

import '../../../models/model_pengaduan.dart';
import '../pdf_viewer_screen.dart';

class EditPengaduanAdmin extends StatefulWidget {
  final ModelPengaduan pengaduan;

  const EditPengaduanAdmin({Key? key, required this.pengaduan})
      : super(key: key);

  @override
  State<EditPengaduanAdmin> createState() => _EditPengaduanAdminState();
}

class _EditPengaduanAdminState extends State<EditPengaduanAdmin> {

  late TextEditingController _namapelaporController;
  late TextEditingController _nohpController;
  late TextEditingController _ktpController;
  late TextEditingController _ktp_pdfController;
  late TextEditingController _laporanController;
  late TextEditingController _laporan_pdfController;
  String _statusValue = '';
  // TextEditingController _statusController = TextEditingController();

  bool isLoading = false;

  String? laporanPdfFilePath;
  String? ktpPdfFilePath;

  // @override
  // void initState() {
  //   super.initState();
  //   _downloadPdf('laporan');
  //   _downloadPdf('ktp');
  // }

  @override
  void initState() {
    super.initState();
    _downloadPdf('laporan');
    _downloadPdf('ktp');
    _namapelaporController =
        TextEditingController(text: widget.pengaduan.data[0].nama_pelapor);
    _nohpController =
        TextEditingController(text: widget.pengaduan.data[0].no_hp);
    _ktpController = TextEditingController(text: widget.pengaduan.data[0].ktp);
    _ktp_pdfController =
        TextEditingController(text: widget.pengaduan.data[0].ktp_pdf);
    _laporanController =
        TextEditingController(text: widget.pengaduan.data[0].laporan);
    _laporan_pdfController =
        TextEditingController(text: widget.pengaduan.data[0].laporan_pdf);
    _statusValue = widget.pengaduan.data.first.status;
    // _statusValue =
    //     TextEditingController(text: widget.pengaduan.data[0].status);
  }

  // void _viewKtpPdf(BuildContext context) {
  //   if (ktpPdfFilePath != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PdfViewerScreen(pdfUrl: '', pdfPath: ktpPdfFilePath!),
  //       ),
  //     );
  //   } else {
  //     // Periksa apakah unduhan PDF telah selesai atau tidak
  //     if (isLoading) {
  //       // Jika unduhan PDF sedang berlangsung, tampilkan pesan bahwa unduhan masih dalam proses
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Sedang mengunduh KTP PDF...')),
  //       );
  //     } else {
  //       // Jika unduhan PDF gagal atau belum dimulai, tampilkan pesan bahwa KTP PDF belum diunduh
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('KTP PDF belum diunduh')),
  //       );
  //     }
  //   }
  // }



  Future<void> _downloadPdf(String type) async {
    String pdfUrl;
    if (type == 'laporan') {
      pdfUrl = 'http://192.168.42.183/informasi/${widget.pengaduan.data[0].laporan_pdf}';
    } else {
      pdfUrl = 'http://192.168.42.183/informasi/${widget.pengaduan.data[0].ktp_pdf}';
    }

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

  @override
  void dispose() {
    _namapelaporController.dispose();
    _nohpController.dispose();
    _ktpController.dispose();
    _ktp_pdfController.dispose();
    _laporan_pdfController.dispose();
    _laporanController.dispose();
    _statusValue.isNotEmpty;
    super.dispose();
  }

  void _viewPdf(BuildContext context, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl, pdfPath: '',),
      ),
    );
  }

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

    Uri uri = Uri.parse('http://192.168.42.183/informasi/updateAdminPengaduan.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_pengaduan'] = widget.pengaduan.data.first.id_pengaduan
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

  // Future<void> downloadPDF(String fileName) async {
  //   String baseUrl = 'http://192.168.42.183/informasi/';
  //   String pdfUrl = baseUrl + fileName; // URL lengkap untuk mengunduh PDF
  //   try {
  //     var dio = Dio();
  //     var directory = await getApplicationDocumentsDirectory();
  //     String filePath = "${directory.path}/$fileName";
  //     await dio.download(pdfUrl, filePath);
  //     _viewPdf(context, filePath); // Tampilkan PDF menggunakan PdfViewerScreen
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error downloading PDF: $e')),
  //     );
  //   }
  // }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Pengaduan Pegawai",
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
                        'Nama Pelapor  : ' + (widget.pengaduan.data[0].nama_pelapor ?? 'Loading...'),
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'No HP               : ' + (widget.pengaduan.data[0].no_hp ?? 'Loading...'),
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5), // Jarak antar teks
                      Text(
                        'KTP                   : ' + (widget.pengaduan.data[0].ktp ?? 'Loading...'),
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5), // Jarak antar teks
                      Text(
                        'Laporan            : ' + (widget.pengaduan.data[0].laporan ?? 'Loading...'),
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
        // backgroundColor: Color(0xFFD2B48C),
        // body: SingleChildScrollView(
        //   // padding: const EdgeInsets.all(16.0),
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
        //             "Edit Pengaduan Pegawai",
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
        //             ElevatedButton(
        //               onPressed: () {
        //                 _downloadPdf('laporan_pdf');
        //               },
        //               child: Text("View KTP PDF"),
        //             ),
        //
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
        //                   hintText: "KTP PDF",
        //                   border: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(8.0),
        //                     borderSide: BorderSide.none,
        //                   ),
        //                   contentPadding:
        //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        //                 ),
        //                 controller: _ktp_pdfController,
        //                 enabled: false,
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             Text(
        //               'KTP PDF',
        //               style: TextStyle(
        //                 fontFamily: 'Jost',
        //                 fontSize: 20,
        //                 color: Colors.orange,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             // Card(
        //             //   child: ktpPdfFilePath != null
        //             //       ? PDFView(filePath: ktpPdfFilePath!)
        //             //       : Center(child: CircularProgressIndicator()),
        //             // ),
        //             // ElevatedButton(
        //             //   onPressed: () {
        //             //     downloadPDF(_ktp_pdfController.text);
        //             //   },
        //             //   child: Text("Download KTP PDF"),
        //             // ),
        //             SizedBox(height: 16),
        //             // Container(
        //             //   width: 300,
        //             //   padding: EdgeInsets.symmetric(horizontal: 20),
        //             //   child: InkWell(
        //             //     onTap: () {
        //             //       saveChanges(_namapelaporController.text, _nohpController.text,
        //             //           _ktpController.text, _ktp_pdfController.text, _laporanController.text, _laporan_pdfController.text,_statusValue);
        //             //     },
        //             //     child: Container(
        //             //       height: 60,
        //             //       decoration: BoxDecoration(
        //             //         color: Color(0xFF8B4513),
        //             //         borderRadius: BorderRadius.circular(20),
        //             //       ),
        //             //       child: Stack(
        //             //         alignment: Alignment.center,
        //             //         children: <Widget>[
        //             //           Align(
        //             //             alignment: Alignment.center,
        //             //             child: Text(
        //             //               'Edit ',
        //             //               textAlign: TextAlign.center,
        //             //               style: TextStyle(
        //             //                 fontSize: 18,
        //             //                 fontWeight: FontWeight.bold,
        //             //                 color: Colors.white,
        //             //               ),
        //             //             ),
        //             //           ),
        //             //         ],
        //             //       ),
        //             //     ),
        //             //   ),
        //             // ),
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
        //                 controller: _laporanController,
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
        //                 controller: _laporan_pdfController,
        //                 enabled: false,
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             // Card(
        //             //   child: laporanPdfFilePath != null
        //             //       ? PDFView(filePath: laporanPdfFilePath!)
        //             //       : Center(child: CircularProgressIndicator()),
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
        //               //     DropdownMenuItem<String>(
        //               //       value: ' ',
        //               //       child: Text(' '),
        //               //     ),
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

