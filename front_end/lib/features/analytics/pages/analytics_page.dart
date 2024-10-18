import 'package:budgetwise_one/features/analytics/services/exchange_rate_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _futureCoins;
  late Future<Map<String, dynamic>> _futureRates;
  late TabController _tabController; // Late initialization for TabController

  @override
  void initState() {
    super.initState();
    _futureCoins = fetchTopCoins();
    _futureRates = ExchangeRateService().fetchExchangeRates();
    _tabController = TabController(length: 2, vsync: this); // Initialize here
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose to avoid memory leaks
    super.dispose();
  }

  Future<List<dynamic>> fetchTopCoins() async {
    const String baseUrl = 'https://api.coingecko.com/api/v3';
    final response = await http.get(Uri.parse(
        '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load top coins');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Analytics'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController, // Use initialized TabController
          indicatorColor: const Color(0xFF8BBE6D), // Set the highlight color
          tabs: [
            _buildTab('Cryptocurrency', 0),
            _buildTab('Exchange Rates', 1),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Use initialized TabController
        children: [
          // Cryptocurrency Prices Tab
          _buildCryptoTab(),

          // Exchange Rates Tab
          _buildExchangeRatesTab(),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          color: _tabController.index == index
              ? const Color(0xFF8BBE6D)
              : Colors.white,
        ),
      ),
    );
  }

  Widget _buildCryptoTab() {
    return FutureBuilder<List<dynamic>>(
      future: _futureCoins,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0), // Padding for the whole grid
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Enable scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final coin = snapshot.data![index];
                    return Card(
                      color: const Color(0xFF1F1F1F),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Reduced padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              coin['image'],
                              height: 25, // Reduced image height
                              width: 25, // Reduced image width
                            ),
                            const SizedBox(
                                height: 6), // Reduced space between elements
                            Text(
                              coin['name'],
                              style: const TextStyle(
                                  fontSize: 12, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '\$${coin['current_price']}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.green),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Market Cap: \$${coin['market_cap']}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              '24h: ${coin['price_change_percentage_24h']}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: coin['price_change_percentage_24h'] >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExchangeRatesTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureRates,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final rates = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: rates.entries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final entry = rates.entries.elementAt(index);
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
