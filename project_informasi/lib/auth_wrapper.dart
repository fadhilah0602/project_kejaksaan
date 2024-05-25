import 'package:flutter/material.dart';
import 'package:project_informasi/page/admin/homeAdmin_screen.dart';
import 'package:project_informasi/page/customers/home_screen.dart';
import 'package:project_informasi/page/login_screen.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return LoginScreen();
    } else if (user.role == 'Admin') {
      return HomeAdminScreen();
    } else {
      return HomeScreen();
    }
  }
}
