import 'package:equatable/equatable.dart';

abstract class FinancialWalletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetFinancialWallettEvent extends FinancialWalletEvent {
  final String userId;
  final double maximumAmount;
  final DateTime date;


  SetFinancialWallettEvent(this.userId, this.maximumAmount, this.date);

  @override
  List<Object> get props => [userId, maximumAmount];
}

class AddFinancialWalletEvent extends FinancialWalletEvent {
  final String userId;
  final double cost;
  final String description;
  final DateTime date;

  AddFinancialWalletEvent(this.userId, this.cost, this.description, this.date);

  @override
  List<Object> get props => [userId, cost, description, date];
}


class GetBalanceFinancialWalletEvent extends FinancialWalletEvent {
  final String userId;


  GetBalanceFinancialWalletEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetUserFinancialWalletEvent extends FinancialWalletEvent {
  final String userId;

  GetUserFinancialWalletEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetFinancialWalletDetailsEvent extends FinancialWalletEvent {
  final String userId;

  GetFinancialWalletDetailsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetExpensesTransactionsEvent extends FinancialWalletEvent {
  final String userId;

  GetExpensesTransactionsEvent(this.userId);
}

class GetBudgetHistoryEvent extends FinancialWalletEvent {
  final String userId;

  GetBudgetHistoryEvent(this.userId);
}
