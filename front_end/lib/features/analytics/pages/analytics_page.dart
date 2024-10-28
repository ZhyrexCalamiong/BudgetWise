import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _futureRates;
  late TabController _tabController;

  // Cryptocurrency state
  late ScrollController _scrollController;
  List<dynamic> _coins = [];
  int _currentPageCoins = 1;
  bool _isLoadingMoreCoins = false;
  bool _isFirstLoadCoins = true;

  // Exchange Rates state
  late ScrollController _scrollControllerRates;
  List<dynamic> _exchangeRates = [];
  int _currentPageRates = 1;
  bool _isLoadingMoreRates = false;
  bool _isFirstLoadRates = true;

  @override
  void initState() {
    super.initState();
    _futureRates = ExchangeRateService().fetchExchangeRates(page: 1);
    _tabController = TabController(length: 2, vsync: this);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollCoins);

    _scrollControllerRates = ScrollController();
    _scrollControllerRates.addListener(_onScrollRates);

    _fetchCoins();
    _fetchExchangeRates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _scrollControllerRates.dispose();
    super.dispose();
  }

  void _onScrollCoins() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMoreCoins) {
      _loadMoreCoins();
    }
  }

  void _onScrollRates() {
    if (_scrollControllerRates.position.pixels ==
            _scrollControllerRates.position.maxScrollExtent &&
        !_isLoadingMoreRates) {
      _loadMoreExchangeRates();
    }
  }

  Future<void> _fetchCoins({int page = 1}) async {
    setState(() {
      _isLoadingMoreCoins = true;
    });

    try {
      const String baseUrl = 'https://api.coingecko.com/api/v3';
      final response = await http.get(Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=40&page=$page&sparkline=false'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _coins.addAll(data);
          _isLoadingMoreCoins = false;
          _isFirstLoadCoins = false;
        });
      } else {
        throw Exception('Failed to load top coins: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoadingMoreCoins = false;
      });
      print('Error: $e');
    }
  }

  void _loadMoreCoins() {
    _currentPageCoins++;
    _fetchCoins(page: _currentPageCoins);
  }

  Future<void> _fetchExchangeRates({int page = 1}) async {
    setState(() {
      _isLoadingMoreRates = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/PHP'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _exchangeRates = data['rates']
              .entries
              .map((entry) => {
                    'currency': entry.key,
                    'rate': entry.value,
                  })
              .toList();
          _isLoadingMoreRates = false;
          _isFirstLoadRates = false;
        });
      } else {
        throw Exception(
            'Failed to load exchange rates: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _isLoadingMoreRates = false;
      });
      print('Error: $e');
    }
  }

  void _loadMoreExchangeRates() {
    _currentPageRates++;
    _fetchExchangeRates(page: _currentPageRates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8BBE6D),
          tabs: [
            _buildTab('Cryptocurrency', 0),
            _buildTab('PHP Exchange Rates', 1),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Cryptocurrency Prices Tab with Pagination
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

  // Cryptocurrency Tab with Key Metrics and Charts
  Widget _buildCryptoTab() {
    return Column(
      children: [
        _buildKeyMetrics(), // Add key metrics at the top
        Expanded(
          child: _isFirstLoadCoins
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF8BBE6D)),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: _coins.length + 1, // Add 1 for loading indicator
                    itemBuilder: (context, index) {
                      if (index == _coins.length) {
                        return _isLoadingMoreCoins
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                coin['image'],
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coin['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '\$${coin['current_price']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Market Cap: \$${coin['market_cap']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '24h: ${coin['price_change_percentage_24h']}%',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 8,
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
        ),
      ],
    );
  }

  // Key Metrics Section
  Widget _buildKeyMetrics() {
    double totalMarketCap =
        _coins.fold(0, (sum, coin) => sum + coin['market_cap']);
    double totalVolume =
        _coins.fold(0, (sum, coin) => sum + coin['total_volume']);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: _buildMetricCard('Total Market Cap',
                  '\$${totalMarketCap.toStringAsFixed(2)}')),
          const SizedBox(width: 8),
          Expanded(
              child: _buildMetricCard(
                  'Total Volume', '\$${totalVolume.toStringAsFixed(2)}')),
        ],
      ),
    );
  }

  // Key Metric Card Widget
  Widget _buildMetricCard(String title, String value) {
    return Card(
      color: const Color(0xFF2C2C2C),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 12), // Smaller title font size
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14), // Smaller value font size
            ),
          ],
        ),
      ),
    );
  }

  // Exchange Rates Tab
  Widget _buildExchangeRatesTab() {
    return _isFirstLoadRates
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BBE6D)),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              controller: _scrollControllerRates,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount:
                  _exchangeRates.length + 1, // Add 1 for loading indicator
              itemBuilder: (context, index) {
                if (index == _exchangeRates.length) {
                  return _isLoadingMoreRates
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF8BBE6D)),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                final rate = _exchangeRates[index];
                return Card(
                  color: const Color(0xFF1F1F1F),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(
                      '${rate['currency']}: ${rate['rate'].toStringAsFixed(4)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class ExchangeRateService {
  Future<Map<String, dynamic>> fetchExchangeRates({int page = 1}) async {
    final response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/PHP'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load exchange rates: ${response.reasonPhrase}');
    }
  }
}
