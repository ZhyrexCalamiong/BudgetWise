// lib/main.dart

import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_bloc.dart';
import 'package:budgetwise_one/features/intro/onboarding_screen.dart';
import 'package:budgetwise_one/features/intro/splash_screen.dart';
import 'package:budgetwise_one/pages/login_page.dart';
import 'package:budgetwise_one/pages/signup_page.dart';
import 'package:budgetwise_one/repositories/budget_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/home/pages/home_page.dart';
// import 'screens/splash_screen.dart'; // Import the splash screen
// import 'screens/onboarding_screen.dart'; // Import the onboarding screen

void main() {
  runApp(
    BlocProvider(
      create: (context) => FinancialWalleBloc(BudgetService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudgetWise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) =>const SignupPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
        '/onboarding': (context) =>
            const OnboardingScreen(), // Add onboarding route
      },
    );
  }
}
