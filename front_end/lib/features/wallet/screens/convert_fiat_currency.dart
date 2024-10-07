import 'package:flutter/material.dart';

class ConvertCurrencyFiatScreen extends StatelessWidget {
  const ConvertCurrencyFiatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF121212), // AppBar color
        centerTitle: true,
        title: const Text(
          'Convert Fiat Currency',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Convert Fiat Currency Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
