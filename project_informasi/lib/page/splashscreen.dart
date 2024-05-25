import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding_screen1.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => OnboardingScreen1()));
    });
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFD2B48C),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/jaksa1.png',
                // width: 10, // Ganti dengan ukuran yang diinginkan
                // height: 10, // Ganti dengan ukuran yang diinginkan
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
