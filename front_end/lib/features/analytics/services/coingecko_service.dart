import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinGeckoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<dynamic>> fetchTopCoins() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load top coins');
    }
  }
}
