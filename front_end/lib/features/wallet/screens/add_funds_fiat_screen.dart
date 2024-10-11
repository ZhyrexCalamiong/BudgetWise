import 'package:budgetwise_one/authservice/authService.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_state.dart';
import 'package:budgetwise_one/features/wallet/pages/wallet_page.dart';
import 'package:budgetwise_one/repositories/budget_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_event.dart';

class AddFundsFiatScreen extends StatefulWidget {
  const AddFundsFiatScreen({super.key});

  @override
  State<AddFundsFiatScreen> createState() => _AddFundsFiatScreenState();
}

class _AddFundsFiatScreenState extends State<AddFundsFiatScreen> {
  late FinancialWalleBloc financialWalletBloc;
  final TextEditingController _maximumAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    financialWalletBloc = FinancialWalleBloc(BudgetService());
  }

  @override
  void dispose() {
    _maximumAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => financialWalletBloc,
      child: BlocConsumer<FinancialWalleBloc, FinancialWalletState>(
        listener: (context, state) {
          if (state is FinancialWalletLoading) {
            // Show loading indicator or message if needed
          } else if (state is FinancialWalletSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Success: Budget added')),
            );
          } else if (state is FinancialWalletFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF0D0D0D),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFF121212),
              centerTitle: true,
              title: const Text(
                'Add Fiat Funds',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Maximum Amount Input Field
                  _buildTextField(
                    labelText: 'Set Budget',
                    controller: _maximumAmountController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Set Budget Button
                  ElevatedButton(
                    onPressed: () async {
                      double? maximumAmount = double.tryParse(_maximumAmountController.text);
                      if (maximumAmount != null) {
                        String? userId = await AuthService.getCurrentUserId();
                        if (userId != null) {
                          // Get the current date
                          DateTime date = DateTime.now();
                          context.read<FinancialWalleBloc>().add(SetFinancialWallettEvent(userId, maximumAmount, date));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: User ID not found')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error: Invalid budget amount')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BBE6D),
                    ),
                    child: const Text('Set Budget'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8BBE6D)),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
