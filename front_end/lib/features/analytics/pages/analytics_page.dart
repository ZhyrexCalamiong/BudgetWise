import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AnalyticsScreen extends StatefulWidget {
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
    final String baseUrl = 'https://api.coingecko.com/api/v3';
    final response = await http.get(Uri.parse(
        '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Number of coins fetched: ${data.length}'); // Debugging line
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
        title: Text('Analytics'),
        centerTitle: true, // Center the title
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: SingleChildScrollView(
        // Wrap the body in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cryptocurrency Prices by Market Cap',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                // Removed border property
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder<List<dynamic>>(
                  future: _futureCoins,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    }

                    // Printing the length of data to ensure it has 20 items
                    print(
                        'Number of coins displayed: ${snapshot.data!.length}');

                    return Container(
                      height: 400, // Increased height for the ListView
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final coin = snapshot.data![index];
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                coin['image'],
                                height: 30, // Further reduced height for icon
                                width: 30, // Further reduced width for icon
                              ),
                              title: Text(
                                coin['name'],
                                style: TextStyle(
                                    fontSize: 12), // Smaller text size
                              ),
                              subtitle: Text(
                                'Price: \$${coin['current_price']}',
                                style: TextStyle(
                                    fontSize: 10), // Smaller text size
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Market Cap: \$${coin['market_cap']}',
                                    style: TextStyle(
                                        fontSize: 10), // Smaller text size
                                  ),
                                  Text(
                                    '24h Change: ${coin['price_change_percentage_24h']}%',
                                    style: TextStyle(
                                        fontSize: 10), // Smaller text size
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
              SizedBox(height: 20), // Space between sections
              Text(
                'Philippine Peso Exchange Rates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 200, // Set a height for the container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('Content will go here'), // Placeholder text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}