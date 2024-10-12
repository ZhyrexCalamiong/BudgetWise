import 'package:budgetwise_one/models/budget_history.dart';
import 'package:budgetwise_one/models/expense.dart';
import 'package:equatable/equatable.dart';

abstract class FinancialWalletState extends Equatable {
  @override
  List<Object> get props => [];
}

class FinancialWalletInitial extends FinancialWalletState {}

class FinancialWalletLoading extends FinancialWalletState {}

class FinancialWalletSuccess extends FinancialWalletState {}

class FinancialGetUserExpensesSuccess extends FinancialWalletState {
  final List<Expense> transactions; 

  FinancialGetUserExpensesSuccess(this.transactions);
}

// class FinancialGetTransactionsSuccess extends FinancialWalletState {
//   final List<transaction> transactions; 

//   FinancialGetTransactionsSuccess(this.transactions);
// }



class FinancialGetUserBalanceSuccess extends FinancialWalletState {
  final double maximumAmount;
  final double amountSpent;

  FinancialGetUserBalanceSuccess(this.maximumAmount,this.amountSpent);

  @override
  List<Object> get props => [maximumAmount,amountSpent];
}



class FinancialWalletFailure extends FinancialWalletState {
  final String error;

  FinancialWalletFailure(this.error);

  @override
  List<Object> get props => [error];
}

class FinancialGetBudgetHistorySuccess extends FinancialWalletState {
  final List<BudgetHistory> budgetHistory;

  FinancialGetBudgetHistorySuccess(this.budgetHistory);
}
