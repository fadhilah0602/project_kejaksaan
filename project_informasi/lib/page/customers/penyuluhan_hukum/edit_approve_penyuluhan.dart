import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/model_penyuluhan.dart';
import 'package:http/http.dart' as http;

class EditPenyuluhanApproveScreen extends StatefulWidget {
  final ModelPenyuluhan penyuluhan;

  const EditPenyuluhanApproveScreen({Key? key, required this.penyuluhan})
      : super(key: key);

  @override
  State<EditPenyuluhanApproveScreen> createState() => _EditPenyuluhanApproveScreenState();
}

class _EditPenyuluhanApproveScreenState extends State<EditPenyuluhanApproveScreen> {
  late TextEditingController _namaController; //ambil value
  late TextEditingController _noHpController;
  late TextEditingController _ktpController;
  late TextEditingController _ktpPdfController;
  late TextEditingController _permasalahanController;
  late TextEditingController _permasalahanPdfController;
  late TextEditingController _statusController;
  String? laporanPdfFilePath;
  String? ktpPdfFilePath;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _downloadPdf('laporan');
    _downloadPdf('ktp');
    _namaController =
        TextEditingController(text: widget.penyuluhan.data[0].nama);
    _noHpController =
        TextEditingController(text: widget.penyuluhan.data[0].no_hp);
    _ktpController =
        TextEditingController(text: widget.penyuluhan.data[0].ktp);
    _ktpPdfController =
        TextEditingController(text: widget.penyuluhan.data[0].ktp_pdf);
    _permasalahanController =
        TextEditingController(text: widget.penyuluhan.data[0].permasalahan);
    _permasalahanPdfController =
        TextEditingController(text: widget.penyuluhan.data[0].permasalahan_pdf);
    _statusController =
        TextEditingController(text: widget.penyuluhan.data[0].status);
  }

  Future<void> _downloadPdf(String type) async {
    String pdfUrl;
    if (type == 'laporan') {
      pdfUrl = 'http://192.168.42.183/informasi/${widget.penyuluhan.data[0].permasalahan_pdf}';
    } else {
      pdfUrl = 'http://192.168.42.183/informasi/${widget.penyuluhan.data[0].ktp_pdf}';
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

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _ktpController.dispose();
    _ktpPdfController.dispose();
    _permasalahanController.dispose();
    _permasalahanPdfController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Penyuluhan Hukum",
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
                      'Nama Pelapor  : ' + (widget.penyuluhan.data[0].nama ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'No HP               : ' + (widget.penyuluhan.data[0].no_hp ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5), // Jarak antar teks
                    Text(
                      'KTP                   : ' + (widget.penyuluhan.data[0].ktp ?? 'Loading...'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10), // Jarak antar teks
                    Text(
                      'Laporan            : ' + (widget.penyuluhan.data[0].permasalahan ?? 'Loading...'),
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
            SizedBox(height: 8),
            Text(
              'Laporan PDF',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: laporanPdfFilePath != null
                  ? PDFView(filePath: laporanPdfFilePath!)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 8),
            Text(
              'KTP PDF',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ktpPdfFilePath != null
                  ? PDFView(filePath: ktpPdfFilePath!)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 30),
            Container(
              width: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {

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
                          'Data Tidak Bisa Di Edit ',
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
      //             "Edit Penyuluhan Hukum",
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
      //                   hintText: "Nama Pelapor",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(12),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _namaController,
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
      //                   hintText: "No HP",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _noHpController,
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
      //                   hintText: "KTP",
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
      //                 controller: _ktpPdfController,
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
      //                   hintText: "Permasalahan",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _permasalahanController,
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
      //                   hintText: "Permasalahan PDF",
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(8.0),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                   EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //                 ),
      //                 controller: _permasalahanPdfController,
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
      //                 controller: _statusController,
      //                 enabled: false,
      //               ),
      //             ),
      //             SizedBox(height: 30),
      //             Container(
      //               width: 300,
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: InkWell(
      //                 onTap: () {
      //
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
      //                           'Data Tidak Bisa Di Edit ',
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
