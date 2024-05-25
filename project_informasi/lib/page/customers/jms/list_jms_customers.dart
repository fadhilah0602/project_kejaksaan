import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_informasi/page/customers/jms/add_jms_customers.dart';
import '../../../models/model_jms.dart';
import '../../../models/model_user.dart';
import '../../../utils/session_manager.dart';
import '../../customers/aboutus_screen.dart';
import '../../customers/profile_screen.dart';
import '../../login_screen.dart';
import '../home_screen.dart';
import 'edit_approve_jms.dart';
import 'edit_reject_jms.dart';

class ListJmsCustomersScreen extends StatefulWidget {
  const ListJmsCustomersScreen({super.key});

  @override
  State<ListJmsCustomersScreen> createState() => _ListJmsCustomersScreenState();
}

class _ListJmsCustomersScreenState extends State<ListJmsCustomersScreen> {
  late List<Jms> _jmsCustomersList = [];
  late List<Jms> _filteredJmsCustomersList = [];
  bool _isLoading = true;
  bool _hasError = false;

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
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
      _fetchJmsCustomers(sessionManager.id_user!);
    } else {
      print('Log Session tidak ditemukan!');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataSession();
    // _fetchJmsCustomers();
  }

  Future<void> _fetchJmsCustomers(String idUser) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.42.183/informasi/jmsCustomers.php?id_user=$idUser'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);

        // Tambahkan log untuk memastikan tipe data
        print('Parsed JSON: $parsed');
        print('Parsed JSON type: ${parsed.runtimeType}');

        // Pastikan parsed adalah Map dan memiliki kunci 'data' yang merupakan List
        if (parsed is Map<String, dynamic> && parsed.containsKey('data') && parsed['data'] is List) {
          final dataList = parsed['data'] as List;

          setState(() {
            _jmsCustomersList = dataList.map((x) => Jms.fromJson(x)).toList();
            _filteredJmsCustomersList = _jmsCustomersList;
            _isLoading = false;
          });
        } else {
          throw Exception('Invalid JSON structure');
        }
      } else {
        throw Exception('Failed to load pengaduan pegawai');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterJmsList(String query) {
    setState(() {
      _filteredJmsCustomersList = _jmsCustomersList
          .where((jms) =>
      jms.sekolah.toLowerCase().contains(query.toLowerCase()) ||
          jms.status.toLowerCase().contains(query.toLowerCase()))
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
                onChanged: _filterJmsList,
                decoration: InputDecoration(
                  labelText: 'View Jaksa Masuk Sekolah',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Container(
                    width: 450,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 150),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredJmsCustomersList.length,
                        itemBuilder: (context, index) {
                          final jms = _filteredJmsCustomersList[index];
                          return Card(
                            child: ListTile(
                              title: Text(jms.sekolah),
                              subtitle: Text(jms.status),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (jms.status == 'Approved') {
                                        ModelJms modelJms = ModelJms(
                                          isSuccess: true,
                                          message: "Success",
                                          data: [jms],
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditJmsApproveScreen(
                                                jms: modelJms),
                                          ),
                                        );
                                      } else {
                                        ModelJms modelJms = ModelJms(
                                          isSuccess: true,
                                          message: "Success",
                                          data: [jms],
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditJmsRejectedScreen(
                                                jms: modelJms),
                                          ),
                                        );
                                      }
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJmsCustomersScreen(),
            ),
          );
        },
        backgroundColor: Color(0xFF8B4513),
        child: Icon(Icons.add),
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
