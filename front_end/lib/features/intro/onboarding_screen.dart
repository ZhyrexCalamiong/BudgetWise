import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Apply the gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1F14), // Dark green (top)
              Color(0xFF2F4F36), // Mid-tone green
              Color(0xFF8BBE6D), // Light green (bottom)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300, // Constraint the Stack height
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 60,
                      child: Container(
                        width: 200,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFF3A4E44), // Dark card background color (USD card)
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Center(
                          child: Text(
                            'PHP\n8,750.25',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: Container(
                        width: 160,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFFA4C87C), // Light green card (GBP card)
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Center(
                          child: Text(
                            'BTC\n1.75',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors
                                  .black, // Text color black on light green
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Keep Financial\nUnder Control',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // White for the text
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are here as your digital financial solution.\nLet\'s connect your funds to us!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70, // Light white for subtitle text
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFFA4C87C), // Light green background for the button
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/signup');
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.black, // Black text for the button
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
