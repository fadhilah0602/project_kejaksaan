import 'package:flutter/material.dart';
import 'package:project_informasi/page/customers/aboutus_screen.dart';
import 'package:project_informasi/page/customers/pengaduan_pegawai/list_pengaduan_customers.dart';
import 'package:project_informasi/page/customers/pengawasan_aliran/list_pengawasan_customers.dart';
import 'package:project_informasi/page/customers/penyuluhan_hukum/list_penyuluhan_customers.dart';
import 'package:project_informasi/page/customers/pidana_korupsi/list_korupsi_customers.dart';
import 'package:project_informasi/page/customers/posko_pilkada/list_posko_customers.dart';
import 'package:project_informasi/page/customers/profile_screen.dart';

import '../../models/model_user.dart';
import '../../utils/session_manager.dart';
import '../login_screen.dart';
import 'jms/list_jms_customers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late ModelUsers currentUser; // Deklarasikan currentUser
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
      // Navigasi ke halaman About Us
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: currentUser)),
        );
        break;
      case 3:
      // Tambahkan logika logout
        setState(() {
          sessionManager.clearSession();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginScreen()),
                (route) => false,
          );
        });
        break;
      default:
    }
  }

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        // Inisialisasikan currentUser dengan data pengguna dari sessionManager
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
  }

  Future<void> _refreshData() async {
    // Simulate a long-running operation
    await Future.delayed(Duration(seconds: 2));

    // Fetch new data or update existing data
    // For example, you can fetch data from an API
    setState(() {
      getDataSession();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getDataSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    double halfWidth = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      backgroundColor: Color(0xFFD2B48C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
                color: Color(0xFF8B4513),
              ),
            ),
          ),
          Positioned(
            top: 80.0,
            left: 40.0,
            right: 40.0,
            child: AppBar(
              elevation: 12,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => FindDoctorPage()));
                  },
                  child: Icon(Icons.search)),
              primary: false,
              title: TextField(
                decoration: InputDecoration(
                    hintText: "Silahkan Isi ",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          SizedBox(height: 50,),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Untuk memastikan kedua card ditempatkan dengan jarak yang sama
                children: [
                  GestureDetector(
                    onTap: () {
                      // Logika ketika card pertama diklik
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListPengaduanCustomersScreen()));
                    },
                    child: Card(
                      child: SizedBox(
                        width: 150, // Atur lebar sesuai kebutuhan Anda
                        height: 135, // Atur tinggi sesuai kebutuhan Anda
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Mengatur jarak secara vertikal dan horizontal
                              child: SizedBox(
                                width: 50, // Lebar gambar
                                height: 50, // Tinggi gambar
                                child: Image.asset('images/neraca.jpg'), // Ganti 'your_image.png' dengan path gambar Anda
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur jarak secara horizontal
                              child: Text(
                                'Pengaduan Pegawai',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logika ketika card kedua diklik
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListKorupsiCustomersScreen()));
                    },
                    child: Card(
                      child: SizedBox(
                        width: 150, // Atur lebar sesuai kebutuhan Anda
                        height: 135, // Atur tinggi sesuai kebutuhan Anda
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Mengatur jarak secara vertikal dan horizontal
                              child: SizedBox(
                                width: 50, // Lebar gambar
                                height: 50, // Tinggi gambar
                                child: Image.asset('images/neraca.jpg'), // Ganti 'your_image.png' dengan path gambar Anda
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur jarak secara horizontal
                              child: Text(
                                'Pidana Korupsi',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Untuk memastikan kedua card ditempatkan dengan jarak yang sama
                children: [
                  GestureDetector(
                    onTap: () {
                      // Logika ketika card pertama diklik
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListJmsCustomersScreen()));
                    },
                    child: Card(
                      child: SizedBox(
                        width: 150, // Atur lebar sesuai kebutuhan Anda
                        height: 135, // Atur tinggi sesuai kebutuhan Anda
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Mengatur jarak secara vertikal dan horizontal
                              child: SizedBox(
                                width: 50, // Lebar gambar
                                height: 50, // Tinggi gambar
                                child: Image.asset('images/neraca.jpg'), // Ganti 'your_image.png' dengan path gambar Anda
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur jarak secara horizontal
                              child: Text(
                                'Jaksa Masuk \nSekolah (JMS)',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logika ketika card kedua diklik
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListPenyuluhanCustomersScreen()));
                    },
                    child: Card(
                      child: SizedBox(
                        width: 150, // Atur lebar sesuai kebutuhan Anda
                        height: 135, // Atur tinggi sesuai kebutuhan Anda
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Mengatur jarak secara vertikal dan horizontal
                              child: SizedBox(
                                width: 50, // Lebar gambar
                                height: 50, // Tinggi gambar
                                child: Image.asset('images/neraca.jpg'), // Ganti 'your_image.png' dengan path gambar Anda
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur jarak secara horizontal
                              child: Text(
                                'Penyuluhan Hukum',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Untuk memastikan kedua card ditempatkan dengan jarak yang sama
                children: [
                  GestureDetector(
                    onTap: () {
                      // Logika ketika card pertama diklik
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListPengawasanCustomersScreen()));
                    },
                    child: Card(
                      child: SizedBox(
                        width: 150, // Atur lebar sesuai kebutuhan Anda
                        height: 135, // Atur tinggi sesuai kebutuhan Anda
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Mengatur jarak secara vertikal dan horizontal
                              child: SizedBox(
                                width: 50, // Lebar gambar
                                height: 50, // Tinggi gambar
                                child: Image.asset('images/neraca.jpg'), // Ganti 'your_image.png' dengan path gambar Anda
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur jarak secara horizontal
                              child: Text(
                                'Pengawasan Aliran\n dan Kepercayaan',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logika ketika card kedua diklik
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListPoskoCustomersScreen()));
                    },
                    child: Card(
                      child: SizedBox(
                        width: 150, // Atur lebar sesuai kebutuhan Anda
                        height: 135, // Atur tinggi sesuai kebutuhan Anda
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Mengatur jarak secara vertikal dan horizontal
                              child: SizedBox(
                                width: 50, // Lebar gambar
                                height: 50, // Tinggi gambar
                                child: Image.asset('images/neraca.jpg'), // Ganti 'your_image.png' dengan path gambar Anda
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur jarak secara horizontal
                              child: Text(
                                'Posko Pilkada',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
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



