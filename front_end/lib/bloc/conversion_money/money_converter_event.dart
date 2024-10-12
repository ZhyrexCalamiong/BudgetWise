import 'package:equatable/equatable.dart';

abstract class MoneyConverterEvent extends Equatable {
  const MoneyConverterEvent();

  @override
  List<Object> get props => [];
}

class ConvertCurrencyEvent extends MoneyConverterEvent {
  final String from;
  final String to;
  final double amount;

  const ConvertCurrencyEvent({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object> get props => [from, to, amount];
}
