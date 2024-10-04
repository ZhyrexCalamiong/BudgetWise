import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/intro1.png',
              height: 200,
            ),
            const SizedBox(height: 20), // Spacing between image and text
            const Text(
              "Welcome to BudgetWise", // Text below the image
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
