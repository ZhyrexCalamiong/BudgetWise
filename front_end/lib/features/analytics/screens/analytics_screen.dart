import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF121212), // AppBar color
        centerTitle: true,
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Container(), // Placeholder for symmetry
        actions: [
          // Notification icon on the right
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Text(
          'No content available',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
