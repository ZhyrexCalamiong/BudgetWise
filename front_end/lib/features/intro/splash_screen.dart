// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'B',
                style: TextStyle(color: Color(0xFFA4C87C)), // Light green
              ),
              TextSpan(
                text: 'udget',
                style: TextStyle(color: Colors.white), // White text for 'udget'
              ),
              TextSpan(
                text: 'W',
                style: TextStyle(color: Color(0xFFA4C87C)), // Light green
              ),
              TextSpan(
                text: 'ise',
                style: TextStyle(color: Colors.white), // White text for 'ise'
              ),
            ],
          ),
        ),
      ),
    );
  }
}
