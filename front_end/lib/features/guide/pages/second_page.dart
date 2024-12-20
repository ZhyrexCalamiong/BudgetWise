import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0D0D0D),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/analytic_image.png',
                height: 400,
              ),
              const SizedBox(height: 20), // Spacing between image and text
              const Text(
                "In Analytics Screen, we have the current exchange\n rates of different crypto and also the exchange rate\n of PHP in different currencies", // Text below the image
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
