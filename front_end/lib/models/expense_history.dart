class ExpenseHistory {
  final String id; // The unique identifier for the ExpenseHistory document
  final String user; // User ID
  final String expenseId; // Expense ID
  final double oldCost; // Old cost of the expense
  final double newCost; // New cost of the expense
  final String oldDescription; // Old description of the expense
  final String newDescription; // New description of the expense
  final DateTime changeDate; // Date of the change
  final String reason; // Reason for the change

  ExpenseHistory({
    required this.id,
    required this.user,
    required this.expenseId,
    required this.oldCost,
    required this.newCost,
    required this.oldDescription,
    required this.newDescription,
    required this.changeDate,
    required this.reason,
  });

  // Factory method to create an instance from a JSON object
  factory ExpenseHistory.fromJson(Map<String, dynamic> json) {
    return ExpenseHistory(
      id: json['_id'] as String,
      user: json['user'] as String,
      expenseId: json['expenseId'] as String,
      oldCost: (json['oldCost'] as num).toDouble(),
      newCost: (json['newCost'] as num).toDouble(),
      oldDescription: json['oldDescription'] as String,
      newDescription: json['newDescription'] as String,
      changeDate: DateTime.parse(json['changeDate']),
      reason: json['reason'] as String,
    );
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'expenseId': expenseId,
      'oldCost': oldCost,
      'newCost': newCost,
      'oldDescription': oldDescription,
      'newDescription': newDescription,
      'changeDate': changeDate.toIso8601String(),
      'reason': reason,
    };
  }
}
