import 'package:budgetwise_one/features/navigations/bottom_navigation.dart';
import 'package:flutter/material.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../wallet/screens/wallet_screen.dart';
import '../../profile/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wallet App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildPages() {
    return <Widget>[
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _onItemTapped(3);
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xFFEAEAEA),
                  radius: 20,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Hey, User!\n",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Good morning",
                      style: TextStyle(
                        color: Color(0xFF8BBE6D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
            ),
          ],
          backgroundColor: const Color(0xFF121212), // Updated AppBar color
          elevation: 0,
        ),
        body: const HomeScreen(),
      ),
      const AnalyticsScreen(),
      const WalletScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPages()[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Home screen with current balance Card
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust size to content
          children: [
            Card(
              color: const Color(0xFF1E1E1E), // Card color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              elevation: 4, // Shadow effect
              child: const Padding(
                padding: EdgeInsets.all(16.0), // Padding inside the card
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjust size to content
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8), // Space between text
                    Text(
                      'Php 120,000.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between card and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                _buildIconButton(Icons.add, 'Add'),
                const SizedBox(width: 20), // Space between buttons
                _buildIconButton(Icons.shopping_cart, 'Buy'),
                const SizedBox(width: 20), // Space between buttons
                _buildIconButton(Icons.transform, 'Convert'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build individual icon buttons with circular backgrounds
  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Background color for the circle
            shape: BoxShape.circle, // Circular shape
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0), // Padding inside the circle
          child: Icon(
            icon,
            size: 30,
            color: const Color(0xFF8BBE6D), // Change to desired icon color
          ),
        ),
        const SizedBox(height: 8), // Space between icon and text
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Notification Page
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.white), // Change title text color to white
        ),
        backgroundColor: const Color(0xFF121212), // Updated AppBar color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Optionally, you can add the following line to set all icon colors to white
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          'You don\'t have notifications yet',
          style: TextStyle(
              color: Colors.black), // Optional: Change text color to white
        ),
      ),
    );
  }
}
