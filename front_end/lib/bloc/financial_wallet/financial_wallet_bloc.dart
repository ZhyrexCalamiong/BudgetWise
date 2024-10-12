import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_event.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_state.dart';
import 'package:budgetwise_one/models/Transaction.dart';
import 'package:budgetwise_one/models/budget_history.dart';
import 'package:budgetwise_one/models/expense.dart';
import 'package:budgetwise_one/repositories/budget_repository_impl.dart';

class FinancialWalletBloc
    extends Bloc<FinancialWalletEvent, FinancialWalletState> {
  final BudgetService _budgetRepository;

  FinancialWalletBloc(this._budgetRepository) : super(FinancialWalletInitial()) {
    on<SetFinancialWallettEvent>((event, emit) async {
      emit(FinancialWalletLoading());
      try {
        await _budgetRepository.setBudget(
            event.userId, event.maximumAmount, event.date);
        emit(FinancialWalletSuccess());
      } catch (error) {
        emit(FinancialWalletFailure(error.toString()));
      }
    });

    on<AddFinancialWalletEvent>((event, emit) async {
      emit(FinancialWalletInitial());
      try {
        await _budgetRepository.addExpense(
            event.userId, event.cost, event.description, event.date);
        emit(FinancialWalletSuccess());
      } catch (error) {
        emit(FinancialWalletFailure(error.toString()));
      }
    });

    on<GetFinancialWalletDetailsEvent>((event, emit) async {
      emit(FinancialWalletLoading());
      try {
        await _budgetRepository.getBudgetDetails(event.userId);
        emit(FinancialWalletSuccess());
      } catch (error) {
        emit(FinancialWalletFailure(error.toString()));
      }
    });

    on<GetBalanceFinancialWalletEvent>((event, emit) async {
      emit(FinancialWalletInitial());
      try {
        final budget = await _budgetRepository
            .getBudgetDetails(event.userId);
        emit(FinancialGetUserBalanceSuccess(
            budget.maximumAmount, budget.amountSpent));
      } catch (error) {
        emit(FinancialWalletFailure(error.toString()));
      }
    });

    on<GetUserFinancialWalletEvent>((event, emit) async {
      emit(FinancialWalletLoading());
      try {
        List<Expense> expenses =
            await _budgetRepository.getUserExpenses(event.userId);
        emit(FinancialGetUserExpensesSuccess(expenses));
      } catch (error) {
        emit(FinancialWalletFailure(error.toString()));
      }
    });

    on<GetBudgetHistoryEvent>((event, emit) async {
      emit(FinancialWalletLoading());
      try {
        List<BudgetHistory> history =
            await _budgetRepository.getBudgetHistory(event.userId);
        emit(FinancialGetBudgetHistorySuccess(history));
      } catch (error) {
        emit(FinancialWalletFailure(error.toString()));
      }
    });
  }
}
