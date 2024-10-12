import 'package:budgetwise_one/models/budget_history.dart';
import '/models/budget.dart';
import '/models/expense.dart';

abstract class BudgetRepository {
  Future<void> setBudget(String userId, double maximumAmount, DateTime date);
  Future<void> addExpense(String userId, double cost, String description, DateTime date);
  Future<List<Expense>> getUserExpenses(String userId);
  Future<Budget> getBudgetDetails(String userId);
  Future<List<BudgetHistory>> getBudgetHistory(String userId);

}
