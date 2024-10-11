class Budget {
  final String userId;
  final double maximumAmount;
  final double amountSpent;
  final DateTime date;


  Budget({
    required this.userId,
    required this.maximumAmount,
    required this.amountSpent,
    required this.date,

  });

  // Factory method to create a Budget instance from JSON
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      userId: json['userId'],
      maximumAmount: json['maximumAmount'],
      amountSpent: json['amountSpent'],
      date: DateTime.parse(json['date']), // Ensure date is parsed correctly

    );
  }

  // Method to convert a Budget instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'maximumAmount': maximumAmount,
      'amountSpent': amountSpent,
      'date': date.toIso8601String(), // Convert date to ISO 8601 string

    };
  }
}
