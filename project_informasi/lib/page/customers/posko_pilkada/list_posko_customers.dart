import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/model_posko.dart';
import '../../../models/model_user.dart';
import '../../../utils/session_manager.dart';
import '../../customers/aboutus_screen.dart';
import '../../customers/profile_screen.dart';
import '../../login_screen.dart';
import '../home_screen.dart';
import 'add_posko_customers.dart';
import 'edit_approve_posko.dart';
import 'edit_reject_posko.dart';

class ListPoskoCustomersScreen extends StatefulWidget {
  const ListPoskoCustomersScreen({super.key});

  @override
  State<ListPoskoCustomersScreen> createState() => _ListPoskoCustomersScreenState();
}

class _ListPoskoCustomersScreenState extends State<ListPoskoCustomersScreen> {
  late List<Posko> _poskoCustomersList = [];
  late List<Posko> _filteredPoskoCustomersList = [];
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
      _fetchPoskoCustomers(sessionManager.id_user!);
    } else {
      print('Log Session tidak ditemukan!');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataSession();
  }

  Future<void> _fetchPoskoCustomers(String idUser) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.42.183/informasi/poskoCustomers.php?id_user=$idUser'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);

        // Log JSON yang diterima
        print('Parsed JSON: $parsed');

        if (parsed is Map<String, dynamic> && parsed.containsKey('data') && parsed['data'] is List) {
          final dataList = parsed['data'] as List;

          setState(() {
            _poskoCustomersList = dataList.map((x) => Posko.fromJson(x)).toList();
            _filteredPoskoCustomersList = _poskoCustomersList;
            _isLoading = false;
          });
        } else {
          throw Exception('Invalid JSON structure');
        }
      } else {
        throw Exception('Failed to load posko pilkada');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _filterPoskoList(String query) {
    setState(() {
      _filteredPoskoCustomersList = _poskoCustomersList
          .where((posko) =>
      posko.nama_pelapor.toLowerCase().contains(query.toLowerCase()) ||
          posko.status.toLowerCase().contains(query.toLowerCase()))
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
                onChanged: _filterPoskoList,
                decoration: InputDecoration(
                  labelText: 'View Posko Pilkada',
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
                        itemCount: _filteredPoskoCustomersList.length,
                        itemBuilder: (context, index) {
                          final posko = _filteredPoskoCustomersList[index];
                          return Card(
                            child: ListTile(
                              title: Text(posko.nama_pelapor),
                              subtitle: Text(posko.status),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (posko.status == 'Approved') {
                                        ModelPosko modelPosko = ModelPosko(
                                          isSuccess: true,
                                          message: "Success",
                                          data: [posko],
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditPoskoApproveScreen(
                                                posko: modelPosko),
                                          ),
                                        );
                                      } else {
                                        ModelPosko modelPosko = ModelPosko(
                                          isSuccess: true,
                                          message: "Success",
                                          data: [posko],
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditPoskoRejectedScreen(
                                                posko: modelPosko),
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
              builder: (context) => AddPoskoCustomersScreen(),
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
