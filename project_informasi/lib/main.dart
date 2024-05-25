import 'package:flutter/material.dart';
import 'package:project_informasi/auth_wrapper.dart';
import 'package:project_informasi/page/admin/pengaduan_pegawai/list_pengaduan.dart';
import 'package:project_informasi/page/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:project_informasi/page/login_screen.dart';
import 'package:project_informasi/auth_service.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Splashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

