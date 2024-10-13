import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsScreen> {
  late Future<List<dynamic>> _futureCoins;

  @override
  void initState() {
    super.initState();
    _futureCoins = fetchTopCoins();
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
        title: const Text('Analytics'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cryptocurrency Prices by Market Cap',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder<List<dynamic>>(
                  future: _futureCoins,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final coin = snapshot.data![index];
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                coin['image'],
                                height: 30,
                                width: 30,
                              ),
                              title: Text(
                                coin['name'],
                                style: const TextStyle(fontSize: 12),
                              ),
                              subtitle: Text(
                                'Price: \$${coin['current_price']}',
                                style: const TextStyle(fontSize: 10),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Market Cap: \$${coin['market_cap']}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    '24h Change: ${coin['price_change_percentage_24h']}%',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Philippine Peso Exchange Rates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Content will go here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
