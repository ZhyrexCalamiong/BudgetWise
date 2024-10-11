class BudgetHistory {
  final String user;  // This will store the userId from the backend
  final double oldMaximumAmount;  // Previous max budget
  final double newMaximumAmount;  // Updated max budget
  final DateTime changeDate;  // Date when the budget changed
  final String reason;  // Reason for the change

  BudgetHistory({
    required this.user,
    required this.oldMaximumAmount,
    required this.newMaximumAmount,
    required this.changeDate,
    required this.reason,
  });

  // Factory method to parse JSON data from the backend
  factory BudgetHistory.fromJson(Map<String, dynamic> json) {
    return BudgetHistory(
      user: json['user'],  // Parsing user ID
      oldMaximumAmount: json['oldMaximumAmount'].toDouble(),  // Ensure number is parsed correctly
      newMaximumAmount: json['newMaximumAmount'].toDouble(),
      changeDate: DateTime.parse(json['changeDate']),  // Parse date from string
      reason: json['reason'],  // Get the reason for budget change
    );
  }

  // Method to convert Dart object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'oldMaximumAmount': oldMaximumAmount,
      'newMaximumAmount': newMaximumAmount,
      'changeDate': changeDate.toIso8601String(),  // Format date as ISO string
      'reason': reason,
    };
  }
}
