import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRateService {
  static const String apiKey =
      'a74e3d49d127265459f3ac49'; // Replace with your actual API key
  static const String baseUrl =
      'https://v6.exchangerate-api.com/v6/$apiKey/latest/PHP';

  // Function to fetch exchange rates
  Future<Map<String, dynamic>> fetchExchangeRates() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['conversion_rates']; // Returns conversion rates map
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
