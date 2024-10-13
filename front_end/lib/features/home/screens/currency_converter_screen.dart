import 'package:flutter/material.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Currency Converter'),
        backgroundColor: Color(0xFF0D0D0D),
      ),
      body: Center(
        child: const Text(
          'Currency Converter Coming Soon!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
