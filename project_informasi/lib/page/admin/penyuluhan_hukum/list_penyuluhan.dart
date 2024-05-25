import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_informasi/models/model_korupsi.dart';
import '../../../models/model_penyuluhan.dart';
import '../../../models/model_user.dart';
import '../../../utils/session_manager.dart';
import '../../customers/aboutus_screen.dart';
import '../../customers/profile_screen.dart';
import '../../login_screen.dart';
import '../homeAdmin_screen.dart';
import 'edit_penyuluhan_admin.dart';

class ListPenyuluhanScreen extends StatefulWidget {
  const ListPenyuluhanScreen({super.key});

  @override
  State<ListPenyuluhanScreen> createState() => _ListPenyuluhanScreenState();
}

class _ListPenyuluhanScreenState extends State<ListPenyuluhanScreen> {
  late List<Penyuluhan> _penyuluhanList;
  late List<Penyuluhan> _filteredPenyuluhanList;
  bool _isLoading = true;

  TextEditingController _searchController = TextEditingController();

  late ModelUsers currentUser;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeAdminScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AboutUsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: currentUser)),
        );
        break;
      case 3:
        sessionManager.clearSession();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
        break;
      default:
    }
  }

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        currentUser = ModelUsers(
          id_user: sessionManager.id_user!,
          nama: sessionManager.nama!,
          email: sessionManager.email!,
          no_telp: sessionManager.no_telp!,
          ktp: sessionManager.ktp!,
          alamat: sessionManager.alamat!,
          role: sessionManager.role!,
        );
      });
    } else {
      print('Log Session tidak ditemukan!');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataSession(); // Panggil fungsi untuk memuat data sesi
    _fetchPenyuluhan();
  }

  Future<void> _fetchPenyuluhan() async {
    final response = await http
        .get(Uri.parse('http://192.168.42.183/informasi/penyuluhan.php'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      setState(() {
        _penyuluhanList =
        List<Penyuluhan>.from(parsed['data'].map((x) => Penyuluhan.fromJson(x)));
        _filteredPenyuluhanList = _penyuluhanList;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load penyuluhan');
    }
  }

  void _filterPenyuluhanList(String query) {
    setState(() {
      _filteredPenyuluhanList = _penyuluhanList
          .where((penyuluhan) =>
      penyuluhan.nama.toLowerCase().contains(query.toLowerCase()) ||
          penyuluhan.status.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD2B48C),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 50),
                    child: Text(
                      "Hi Admin!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 100.0,
              left: 40.0,
              right: 40.0,
              child: TextField(
                controller: _searchController,
                onChanged: _filterPenyuluhanList,
                decoration: InputDecoration(
                  labelText: 'Search Penyuluhan Hukum',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true, // Menambahkan properti filled
                  fillColor: Colors.white, // Menentukan warna latar belakang
                ),
              ),

            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 450,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 150),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredPenyuluhanList.length,
                        itemBuilder: (context, index) {
                          final penyuluhan = _filteredPenyuluhanList[index];
                          return Card(
                            child: ListTile(
                              title: Text(penyuluhan.nama),
                              subtitle: Text(penyuluhan.status),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      ModelPenyuluhan modelPenyuluhan = ModelPenyuluhan(
                                        isSuccess: true,
                                        message: "Success",
                                        data: [penyuluhan],
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPenyuluhanAdmin(
                                              penyuluhan: modelPenyuluhan),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 5, top: 200),
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     itemCount: _filteredPengaduanList.length,
            //     itemBuilder: (context, index) {
            //       final pengaduan = _filteredPengaduanList[index];
            //       return Card(
            //         child: ListTile(
            //           title: Text(pengaduan.nama_pelapor),
            //           subtitle: Text(pengaduan.status),
            //           trailing: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               IconButton(
            //                 onPressed: () {
            //                   ModelPengaduan modelPengaduan = ModelPengaduan(
            //                     isSuccess: true,
            //                     message: "Success",
            //                     data: [pengaduan],
            //                   );
            //
            //                   Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                       builder: (context) => EditPengaduanAdmin(
            //                           pengaduan: modelPengaduan),
            //                     ),
            //                   );
            //                 },
            //                 icon: Icon(Icons.edit),
            //                 color: Colors.blue,
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF8B4513),
        onTap: _onItemTapped,
      ),
    );
  }
}
