abstract class MoneyConverterRepository {
  Future<double> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });
}
