class Transaction {
  final String description;
  final DateTime date;
  final double amount;
  final String type; // "expense" or "budget"

  Transaction({
    required this.description,
    required this.date,
    required this.amount,
    required this.type,
  });
}
