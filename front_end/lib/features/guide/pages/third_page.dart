import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Container(
        // // Use a Container to apply the gradient
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter, // Start the gradient at the top
        //     end: Alignment.bottomCenter, // End the gradient at the bottom
        //     colors: [
        //       Color(0xFF0D1F14), // Dark green (top)
        //       Color(0xFF2F4F36), // Mid-tone green
        //       Color(0xFF8BBE6D), // Light green (bottom)
        //     ],
        //   ),
        // ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Converter Screen Image Here",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Lastly the Converter Screen, Here u can convert your money to different kind of currencies\nby clicking the convert and choosing the currency of your choice", // Text below the image
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
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
