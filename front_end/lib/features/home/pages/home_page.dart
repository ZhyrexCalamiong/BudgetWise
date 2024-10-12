import 'package:budgetwise_one/features/analytics/services/coingecko_service.dart';
import 'package:budgetwise_one/features/navigations/bottom_navigation.dart';
import 'package:budgetwise_one/features/notifications/notification_page.dart';
import 'package:flutter/material.dart';
import '../../analytics/pages/analytics_page.dart';
import '../../wallet/pages/wallet_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../home/widgets/actionButton.dart';

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
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
        ),
        body: const HomeScreen(),
      ),
      AnalyticsScreen(),
      WalletScreen(),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
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
        _isLoading = false;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.all(35.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildActionButton(
                    icon: Icons.add,
                    label: 'Add',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  BuildActionButton(
                    icon: Icons.shopping_cart,
                    label: 'Buy',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  BuildActionButton(
                    icon: Icons.transform,
                    label: 'Convert',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'My Assets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            onPressed: () {},
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
                      const SizedBox(height: 10),
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
                                      : _topCoins.length,
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
}