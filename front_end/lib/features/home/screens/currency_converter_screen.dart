import 'package:budgetwise_one/bloc/conversion_money/money_converter_bloc.dart';
import 'package:budgetwise_one/bloc/conversion_money/money_converter_state.dart';
import 'package:budgetwise_one/bloc/conversion_money/money_converter_event.dart';
import 'package:budgetwise_one/features/analytics/pages/analytics_page.dart';
import 'package:budgetwise_one/features/navigations/bottom_navigation.dart';
import 'package:budgetwise_one/features/profile/pages/profile_page.dart';
import 'package:budgetwise_one/features/wallet/pages/wallet_page.dart';
import 'package:budgetwise_one/repositories/money_converter_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreen createState() => _CurrencyConverterScreen();
}

class _CurrencyConverterScreen extends State<CurrencyConverterScreen> {
  int _selectedIndex = 0;

  final MoneyConverter _moneyConverter = MoneyConverter();

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _amountToConvert = 0.0;

  // Define a list of available currencies
  final List<String> _currencies = [
    'USD',
    'EUR',
    'PHP',
    'GBP', // British Pound
    'JPY', // Japanese Yen
    'AUD', // Australian Dollar
    'CAD', // Canadian Dollar
    'CHF', // Swiss Franc
    'CNY', // Chinese Yuan
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildPages() {
    return [
      BlocProvider(
        create: (context) => MoneyConverterBloc(_moneyConverter),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Currency Converter'),
            backgroundColor: const Color(0xFF0D0D0D),
          ),
          body: BlocBuilder<MoneyConverterBloc, MoneyConverterState>(
            builder: (context, state) {
              String convertedResult = '';
              if (state is MoneyConverterSuccess) {
                convertedResult = state.convertedAmount.toStringAsFixed(2);
              } else if (state is MoneyConverterError) {
                convertedResult = state.message;
              }

              return Container(
                color: const Color(0xFF0D0D0D),
                child: SizedBox.expand(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          color: const Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // const Text(
                                //   'Currency Converter',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Amount',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _amountToConvert =
                                                double.tryParse(value) ?? 0.0;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    DropdownButton<String>(
                                      dropdownColor: const Color(0xFF1E1E1E),
                                      value: _fromCurrency,
                                      items: _currencies.map((String currency) {
                                        return DropdownMenuItem<String>(
                                          value: currency,
                                          child: Text(
                                            currency,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _fromCurrency = value ?? 'USD';
                                        });
                                      },
                                    ),
                                    const Icon(Icons.swap_horiz,
                                        color: Colors.white),
                                    DropdownButton<String>(
                                      dropdownColor: const Color(0xFF1E1E1E),
                                      value: _toCurrency,
                                      items: _currencies.map((String currency) {
                                        return DropdownMenuItem<String>(
                                          value: currency,
                                          child: Text(
                                            currency,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _toCurrency = value ?? 'EUR';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<MoneyConverterBloc>(context)
                                        .add(
                                      ConvertCurrencyEvent(
                                        from: _fromCurrency,
                                        to: _toCurrency,
                                        amount: _amountToConvert,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF8BBE6D)),
                                  child: const Text('Convert',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black)),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  convertedResult.isNotEmpty
                                      ? 'Converted Amount: $convertedResult $_toCurrency'
                                      : '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      const AnalyticsScreen(),
      WalletScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPages()[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
