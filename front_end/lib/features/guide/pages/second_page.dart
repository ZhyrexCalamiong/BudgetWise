import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

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
                "Analytics Screen Image Here",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Spacing between image and text
              Text(
                "In Analytics Screen, we have the statistics of your spendings\nand the exchange rates of crypto currencies", // Text below the image
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
