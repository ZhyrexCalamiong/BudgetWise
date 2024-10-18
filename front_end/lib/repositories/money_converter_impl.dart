import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budgetwise_one/repositories/money_converter.dart';

class MoneyConverter implements MoneyConverterRepository {
  final String baseUrl = 'http://localhost:8000/api';

  @override
  Future<double> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/convert').replace(queryParameters: {
        'from': from,
        'to': to,
        'amount': amount.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['convertedAmount']);
    } else {
      throw Exception('Failed to convert currency');
    }
  }
}
