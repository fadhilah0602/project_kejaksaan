import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

String baseUrl = 'http://192.168.42.183/informasi/'; // Base URL dari server

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  PdfViewerScreen({required this.pdfPath, required String pdfUrl});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = true;
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _pdfUrl = baseUrl + widget.pdfPath; // Menggabungkan base URL dengan path relatif
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    // Tambahkan logika untuk memuat PDF dari URL _pdfUrl ke aplikasi Anda
    // Misalnya, Anda dapat menggunakan plugin http atau dio untuk mengunduh PDF
    // Setelah PDF diunduh atau dimuat, atur _isLoading menjadi false
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: _pdfUrl!, // Gunakan URL lengkap sebagai path untuk PDFView
      ),
    );
  }
}

