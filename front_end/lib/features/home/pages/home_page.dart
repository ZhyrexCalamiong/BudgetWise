import 'package:budgetwise_one/features/analytics/services/coingecko_service.dart';
import 'package:budgetwise_one/features/navigations/bottom_navigation.dart';
import 'package:budgetwise_one/features/notifications/notification_page.dart';
import 'package:flutter/material.dart';
import '../../analytics/pages/analytics_page.dart';
import '../../wallet/pages/wallet_page.dart';
import '../../profile/pages/profile_page.dart';
// import '../../features/notifications/notification_page.dart'; // Updated import statement

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
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CoinGeckoService _coinGeckoService =
      CoinGeckoService(); // Create an instance of CoinGeckoService
  List<dynamic> _topCoins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopCoins();
  }

  Future<void> _fetchTopCoins() async {
    try {
      final coins = await _coinGeckoService.fetchTopCoins();
      setState(() {
        _topCoins = coins;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Handle error, maybe show an error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align contents to the top
            children: [
              const SizedBox(height: 20), // Add space at the top
              Card(
                color: const Color(0xFF1E1E1E), // Card color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                elevation: 4, // Shadow effect
                child: const Padding(
                  padding: EdgeInsets.all(35.0), // Padding inside the card
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
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the buttons
                children: [
                  _buildIconButton(Icons.add, 'Add'),
                  const SizedBox(width: 20), // Space between buttons
                  _buildIconButton(Icons.shopping_cart, 'Buy'),
                  const SizedBox(width: 20), // Space between buttons
                  _buildIconButton(Icons.transform, 'Convert'),
                ],
              ),
              const SizedBox(height: 20), // Space between buttons and My Assets
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align My Assets to the left
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'My Assets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Smaller text size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 20), // Space between My Assets and Coin List

              // Box for Crypto Currency Market Value
              Card(
                color: const Color(0xFF1E1E1E), // Card color for coin list
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                elevation: 4, // Shadow effect
                child: Padding(
                  padding: const EdgeInsets.all(
                      15.0), // Reduced padding inside the card
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align content to the start
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Crypto Currency Market',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle view all action
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 10), // Space between title and coin list

                      // Loading indicator or coin list
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _topCoins.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No coins found',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _topCoins.length > 5
                                      ? 5
                                      : _topCoins
                                          .length, // Limit to top 5 coins
                                  itemBuilder: (context, index) {
                                    final coin = _topCoins[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFF1E1E1E),
                                        child: Image.network(
                                          coin['image'],
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      title: Text(
                                        coin['name'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '\$${coin['current_price'].toStringAsFixed(2)}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: Text(
                                        '${coin['price_change_percentage_24h'].toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          color:
                                              coin['price_change_percentage_24h'] >=
                                                      0
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFF1E1E1E),
          child: Icon(icon, color: Colors.white), // White icons for consistency
        ),
        const SizedBox(height: 5), // Space between icon and label
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
