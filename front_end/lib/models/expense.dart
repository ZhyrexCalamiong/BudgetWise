class Expense {
  final String user;
  final String description;
  final double cost;
  final DateTime date;

  Expense({
    required this.user,
    required this.description,
    required this.cost,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      user: json['user'] is Map ? json['user']['_id'] ?? '' : json['user'] ?? '',
      description: json['description'] ?? '',
      cost: json['cost']?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
    );
  }
}