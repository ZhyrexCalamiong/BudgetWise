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
  late Future<Map<String, dynamic>> _futureRates;
  late TabController _tabController;

  // Pagination state for Cryptocurrency tab
  late ScrollController _scrollController;
  List<dynamic> _coins = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _futureRates = ExchangeRateService().fetchExchangeRates(page: 1);
    _tabController = TabController(length: 2, vsync: this);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load the first page of coins on init
    _fetchCoins();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener to detect bottom
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreCoins();
    }
  }

  // Fetch first page or subsequent pages of cryptocurrency data
  Future<void> _fetchCoins({int page = 1}) async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      const String baseUrl = 'https://api.coingecko.com/api/v3';
      final response = await http.get(Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=40&page=$page&sparkline=false'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _coins.addAll(data);
          _isLoadingMore = false;
          _isFirstLoad = false;
        });
      } else {
        throw Exception('Failed to load top coins: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      print('Error: $e'); // Log the error for further analysis
      rethrow;
    }
  }

  // Load more coins when the user scrolls to the bottom
  void _loadMoreCoins() {
    _currentPage++;
    _fetchCoins(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Analytics'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8BBE6D),
          tabs: [
            _buildTab('Cryptocurrency', 0),
            _buildTab('Exchange Rates', 1),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Cryptocurrency Prices Tab with Pagination
          _buildCryptoTab(screenWidth),

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

  // Cryptocurrency Tab with Pagination Support
  Widget _buildCryptoTab(double screenWidth) {
    int crossAxisCount = screenWidth > 600
        ? 4
        : 2; // Adjust number of columns based on screen width

    return _isFirstLoad
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BBE6D)),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: screenWidth > 600 ? 2 / 1 : 3 / 2,
                    ),
                    itemCount: _coins.length + 1, // Add 1 for loading indicator
                    itemBuilder: (context, index) {
                      if (index == _coins.length) {
                        // Display loading indicator at the bottom
                        return _isLoadingMore
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF8BBE6D)),
                                ),
                              )
                            : const SizedBox.shrink();
                      }

                      final coin = _coins[index];
                      return Card(
                        color: const Color(0xFF1F1F1F),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                coin['image'],
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                coin['name'],
                                style: TextStyle(
                                    fontSize: screenWidth > 600 ? 16 : 12,
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
                                  color:
                                      coin['price_change_percentage_24h'] >= 0
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
  }

  // Exchange Rates Tab with custom CircularProgressIndicator color
  Widget _buildExchangeRatesTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureRates,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BBE6D)),
            ),
          );
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
