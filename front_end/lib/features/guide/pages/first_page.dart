import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Use a Container to apply the gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // Start the gradient at the top
            end: Alignment.bottomCenter, // End the gradient at the bottom
            colors: [
              Color(0xFF0D1F14), // Dark green (top)
              Color(0xFF2F4F36), // Mid-tone green
              Color(0xFF8BBE6D), // Light green (bottom)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/home_image.png',
                height: 400,
              ),
              const SizedBox(height: 20), // Spacing between image and text
              const Text(
                "In Home Screen, we have our digital currency\nwhich we can input any amount and manage the money\nby either click the 'Add' and 'Buy' buttons:\n\n - In the Add Button lets u add money \n - Buy Button spends the money while keeping track of it",
                style: TextStyle(
                  fontSize: 14, // Font size of the text
                  color: Colors.white, // Change to white for better contrast
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
