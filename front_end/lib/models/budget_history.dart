class BudgetHistory {
  final String user;
  final double oldMaximumAmount;
  final double newMaximumAmount;
  final DateTime changeDate;
  final String reason;

  BudgetHistory({
    required this.user,
    required this.oldMaximumAmount,
    required this.newMaximumAmount,
    required this.changeDate,
    required this.reason,
  });

  factory BudgetHistory.fromJson(Map<String, dynamic> json) {
    return BudgetHistory(
      user: json['user'] is Map ? json['user']['_id'] ?? '' : json['user'] ?? '',
      oldMaximumAmount: json['oldMaximumAmount']?.toDouble() ?? 0.0,
      newMaximumAmount: json['newMaximumAmount']?.toDouble() ?? 0.0,
      changeDate: DateTime.tryParse(json['changeDate']) ?? DateTime.now(),
      reason: json['reason'] ?? '',
    );
  }
}