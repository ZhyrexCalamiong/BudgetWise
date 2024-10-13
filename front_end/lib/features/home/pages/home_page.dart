import 'package:budgetwise_one/bloc/conversion_money/money_converter_bloc.dart';
import 'package:budgetwise_one/features/analytics/pages/analytics_page.dart';
import 'package:budgetwise_one/features/home/screens/currency_converter_screen.dart';
import 'package:budgetwise_one/features/navigations/bottom_navigation.dart';
import 'package:budgetwise_one/features/profile/pages/profile_page.dart';
import 'package:budgetwise_one/features/wallet/pages/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetWise',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildPages() {
    return [
      // Landing page layout
      Scaffold(
        body: Container(
          color: const Color(0xFF0D0D0D),
          child: Center(
            // Use Center widget for centering content
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the Column
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30), // Reduced space
                  const Text(
                    'Welcome to BudgetWise',
                    style: TextStyle(
                      color: Color(0xFF8BBE6D), // Updated highlight color
                      fontSize: 24, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced space
                  const Text(
                    'Your all-in-one solution for personal finance management',
                    style: TextStyle(
                        color: Colors.white, fontSize: 14), // Reduced font size
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20), // Reduced space
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Reduced padding
                    child: Column(
                      children: [
                        _featureCard(
                          title: 'Currency Converter',
                          icon: Icons.currency_exchange,
                          description:
                              'Easily convert currencies with real-time exchange rates.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CurrencyConverterScreen(),
                              ),
                            );
                          },
                        ),
                        _featureCard(
                          title: 'Analytics',
                          icon: Icons.bar_chart,
                          description:
                              'Get insights into your spending and saving habits.',
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                        _featureCard(
                          title: 'Wallet',
                          icon: Icons.account_balance_wallet,
                          description:
                              'Manage your funds and track expenses easily.',
                          onTap: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                        ),
                        _featureCard(
                          title: 'Profile',
                          icon: Icons.person,
                          description:
                              'Update your personal information and preferences.',
                          onTap: () {
                            setState(() {
                              _selectedIndex = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const AnalyticsScreen(),
      WalletScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _featureCard({
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Further reduced padding
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF8BBE6D), // Updated highlight color
                size: 30, // Reduced icon size
              ),
              const SizedBox(width: 8), // Reduced space
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF8BBE6D), // Updated highlight color
                      fontSize: 14, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced space
                  Text(
                    description,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12), // Reduced font size
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPages()[_selectedIndex],
      bottomNavigationBar: _selectedIndex != 0
          ? BottomNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )
          : null,
    );
  }
}