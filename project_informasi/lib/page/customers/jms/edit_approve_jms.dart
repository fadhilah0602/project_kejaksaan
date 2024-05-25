import 'package:flutter/material.dart';

import '../../../models/model_jms.dart';

class EditJmsApproveScreen extends StatefulWidget {
  final ModelJms jms;

  const EditJmsApproveScreen({Key? key, required this.jms})
      : super(key: key);

  @override
  State<EditJmsApproveScreen> createState() => _EditJmsApproveScreenState();
}

class _EditJmsApproveScreenState extends State<EditJmsApproveScreen> {
  late TextEditingController _namapemohonController; //ambil value
  late TextEditingController _sekolahController;
  late TextEditingController _statusController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _namapemohonController =
        TextEditingController(text: widget.jms.data[0].nama_pemohon);
    _sekolahController =
        TextEditingController(text: widget.jms.data[0].sekolah);
    _statusController =
        TextEditingController(text: widget.jms.data[0].status);
  }

  @override
  void dispose() {
    _namapemohonController.dispose();
    _sekolahController.dispose();
    _statusController.dispose();
    super.dispose();
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
          ],
        ),
      ),
    );
  }
}
