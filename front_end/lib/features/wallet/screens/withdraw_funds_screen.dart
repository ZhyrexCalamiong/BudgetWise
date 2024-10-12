import 'package:budgetwise_one/features/wallet/pages/wallet_page.dart';
import 'package:budgetwise_one/repositories/budget_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_event.dart';
import 'package:budgetwise_one/authservice/authService.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? id = await AuthService.getCurrentUserId();
    setState(() {
      userId = id;
    });
  }

  void _withdraw() {
    if (userId != null) {
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      String description = _descriptionController.text;
      if (amount > 0) {
        DateTime now = DateTime.now();
        context.read<FinancialWalletBloc>().add(
              AddFinancialWalletEvent(userId!, amount, description, now),
            );

        context
            .read<FinancialWalletBloc>()
            .add(GetUserFinancialWalletEvent(userId!));

        _amountController.clear();
        _descriptionController.clear();
        Navigator.pop(context); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid amount greater than 0.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Withdraw Amount',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _amountController,
              hintText: 'Amount',
              labelText: 'Enter Amount to Withdraw',
              isNumber: true,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _descriptionController,
              hintText: 'Description',
              labelText: 'Description (Optional)',
              isNumber: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BBE6D),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Withdraw',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required bool isNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
