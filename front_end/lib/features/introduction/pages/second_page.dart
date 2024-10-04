import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/intro2.png',
              height: 200,
            ),
            const SizedBox(height: 20), // Spacing between image and text
            const Text(
              "Helps to manage your money", // Text below the image
              style: TextStyle(
                fontSize: 18, // Font size of the text
                color: Colors.black, // Color of the text
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
