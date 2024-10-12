import 'package:equatable/equatable.dart';

abstract class MoneyConverterState extends Equatable {
  const MoneyConverterState();

  @override
  List<Object> get props => [];
}

class MoneyConverterInitial extends MoneyConverterState {}

class MoneyConverterLoading extends MoneyConverterState {}

class MoneyConverterSuccess extends MoneyConverterState {
  final double convertedAmount;

  const MoneyConverterSuccess({required this.convertedAmount});

  @override
  List<Object> get props => [convertedAmount];
}

class MoneyConverterError extends MoneyConverterState {
  final String message;

  const MoneyConverterError(this.message);

  @override
  List<Object> get props => [message];
}
