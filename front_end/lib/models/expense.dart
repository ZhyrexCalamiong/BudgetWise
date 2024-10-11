class Expense {
  final String userId;
  final double cost;
  final String description;
  final DateTime date;

  Expense({
    required this.userId,
    required this.cost,
    required this.description,
    required this.date,
  });

  // Factory method to create an Expense instance from JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      userId: json['userId'],
      cost: json['cost'],
      description: json['description'],
      date: DateTime.parse(json['date']), // Ensure date is parsed correctly
    );
  }

  // Method to convert an Expense instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cost': cost,
      'description': description,
      'date': date.toIso8601String(), // Convert date to ISO 8601 string
    };
  }
}
