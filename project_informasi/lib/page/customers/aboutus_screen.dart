import 'package:flutter/material.dart';
import 'package:project_informasi/page/customers/profile_screen.dart';

import '../../models/model_user.dart';
import '../../utils/session_manager.dart';
import '../login_screen.dart';
import 'home_screen.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

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
              title: Text(
                "About Us",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Untuk memastikan kedua card ditempatkan dengan jarak yang sama
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'About Us : \n\nJl. Jaksa Agung R.Soeprapto \nNo.4, Flamboyan Baru,'
                          '\nKec. Padang Bar., Kota Padang,'
                          '\nSumatera Barat,'

                          '\nPhone: 0751-7055530,'
                          '\nEmail: penkumkejatisumbar@gmail.com',
                        style: TextStyle(fontSize: 16.0),
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



