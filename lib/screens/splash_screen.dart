import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalkulator_sains/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a2e),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF4e54c8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text('🧮', style: TextStyle(fontSize: 40))),
            ),
            SizedBox(height: 20),
            Text(
              'Kalkulator Sains',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'by Hadi & Reza',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[800],
                color: Color(0xFF4e54c8),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
