import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/intro3.png',
              height: 200,
            ),
            const SizedBox(height: 20), // Spacing between image and text
            const Text(
              "Convert Money to different currencies", // Text below the image
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
