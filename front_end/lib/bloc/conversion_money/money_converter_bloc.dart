import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/bloc/conversion_money/money_converter_event.dart';
import 'package:budgetwise_one/bloc/conversion_money/money_converter_state.dart';
import 'package:budgetwise_one/repositories/money_converter.dart';

class MoneyConverterBloc
    extends Bloc<MoneyConverterEvent, MoneyConverterState> {
  final MoneyConverterRepository _moneyConverterRepository;

  MoneyConverterBloc(this._moneyConverterRepository)
      : super(MoneyConverterInitial()) {
    on<ConvertCurrencyEvent>((event, emit) async {
      if (event.amount <= 0) {
        emit(const MoneyConverterError("Amount must be greater than 0."));
        return;
      }

      try {
        emit(MoneyConverterLoading());
        final convertedAmount = await _moneyConverterRepository.convertCurrency(
          from: event.from,
          to: event.to,
          amount: event.amount,
        );
        emit(MoneyConverterSuccess(convertedAmount: convertedAmount));
      } catch (e) {
        emit(const MoneyConverterError("Failed to convert currency."));
      }
    });
  }
}
