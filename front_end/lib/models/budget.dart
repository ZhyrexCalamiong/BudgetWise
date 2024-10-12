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

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      userId: json['userId'],
      maximumAmount: json['maximumAmount'],
      amountSpent: json['amountSpent'],
      date: DateTime.parse(json['date']), 

    );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'maximumAmount': maximumAmount,
      'amountSpent': amountSpent,
      'date': date.toIso8601String(), 

    };
  }
}
