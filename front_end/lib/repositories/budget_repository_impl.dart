import 'package:budgetwise_one/models/Transaction.dart';
import 'package:budgetwise_one/models/budget.dart';
import 'package:budgetwise_one/models/budget_history.dart';
import 'package:budgetwise_one/models/expense.dart';
import 'package:budgetwise_one/repositories/budget_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BudgetService implements BudgetRepository {
  final String baseUrl = 'http://localhost:8000/api';

  @override
  Future<void> setBudget(
      String userId, double maximumAmount, DateTime date) async {
    // Updated to include date
    final response = await http.post(
      Uri.parse('$baseUrl/set-budget'),
      body: jsonEncode({
        'userId': userId,
        'maximumAmount': maximumAmount,
        'date': date.toIso8601String(), // Sending the date to the API
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Request: ${jsonEncode({
          'userId': userId,
          'maximumAmount': maximumAmount,
          'date': date.toIso8601String()
        })}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to set budget');
    }
  }

  @override
  Future<void> addExpense(
      String userId, double cost, String description, DateTime date) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-expense'),
      body: jsonEncode({
        'userId': userId,
        'cost': cost,
        'description': description,
        'date': date.toIso8601String(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add expense');
    }
  }

  @override
  Future<Budget> getBudgetDetails(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/budget/$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Budget(
        userId: userId,
        maximumAmount: data['maximumAmount'].toDouble(),
        amountSpent: data['amountSpent'].toDouble(),
        date: DateTime.now(), // You may not need this if not used
      );
    } else {
      throw Exception('Failed to retrieve budget details');
    }
  }

  @override
  Future<List<Expense>> getUserExpenses(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user-expenses/$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> expensesJson = responseBody['data'];

      return expensesJson.map((json) => Expense.fromJson(json)).toList();
    } else {
      throw Exception('Failed to retrieve expenses');
    }
  }

  @override
  Future<List<BudgetHistory>> getBudgetHistory(String userId) async {
    final url = Uri.parse('$baseUrl/user-budget-history/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        return data.map((history) => BudgetHistory.fromJson(history)).toList();
      } else {
        throw Exception('Failed to load budget history');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
