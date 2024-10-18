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

  final List<String> _currencies = [
    'USD',
    'EUR',
    'PHP',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR',
    'NZD',
    'RUB',
    'SGD',
    'ZAR',
    'KRW',
    'HKD',
    'SEK',
    'NOK',
    'DKK',
    'MXN',
    'BRL'
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
            elevation: 0,
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
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Amount Input
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF1E1E1E),
                            hintText: 'Enter amount',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _amountToConvert = double.tryParse(value) ?? 0.0;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Currency Selection Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCurrencyDropdown(_fromCurrency, (value) {
                              setState(() {
                                _fromCurrency = value ?? 'USD';
                              });
                            }),
                            const Icon(Icons.swap_horiz, color: Colors.white),
                            _buildCurrencyDropdown(_toCurrency, (value) {
                              setState(() {
                                _toCurrency = value ?? 'EUR';
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Convert Button
                        ElevatedButton(
                          onPressed: () {
                            if (_amountToConvert > 0) {
                              BlocProvider.of<MoneyConverterBloc>(context).add(
                                ConvertCurrencyEvent(
                                  from: _fromCurrency,
                                  to: _toCurrency,
                                  amount: _amountToConvert,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BBE6D),
                            foregroundColor: Colors.black, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 0, // Flat design, no shadow
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.monetization_on,
                                  size: 20.0,
                                  color: Colors.black), // Optional icon
                              SizedBox(width: 8.0),
                              Text('Convert'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Conversion Result
                        Text(
                          convertedResult.isNotEmpty
                              ? 'Converted Amount: $convertedResult $_toCurrency'
                              : 'Enter a valid amount and select currencies',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
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

  // Helper method to build currency dropdown
  Widget _buildCurrencyDropdown(
      String selectedCurrency, Function(String?) onChanged) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF1E1E1E),
          value: selectedCurrency,
          isExpanded: true,
          underline: const SizedBox(),
          items: _currencies.map((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(
                currency,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
