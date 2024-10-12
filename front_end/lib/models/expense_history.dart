class ExpenseHistory {
  final String id;
  final String user;
  final String expenseId;
  final double oldCost;
  final double newCost;
  final String oldDescription;
  final String newDescription;
  final DateTime changeDate;
  final String reason;

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
