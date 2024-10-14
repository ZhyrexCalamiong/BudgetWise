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
  late FinancialWalletBloc financialWalletBloc;
  final TextEditingController _maximumAmountController =
      TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    financialWalletBloc = FinancialWalletBloc(BudgetService());
    _loadUserId(); // Load the user ID
  }

  Future<void> _loadUserId() async {
    userId = await AuthService.getCurrentUserId(); // Fetch user ID
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
      child: BlocConsumer<FinancialWalletBloc, FinancialWalletState>(
        listener: (context, state) {
          if (state is FinancialWalletLoading) {
            // Show loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading...')),
            );
          } else if (state is FinancialWalletSuccess) {
            // Refresh wallet data
            context
                .read<FinancialWalletBloc>()
                .add(GetBalanceFinancialWalletEvent(userId!));
            Navigator.pop(context);
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
              backgroundColor: const Color(0xFF1E1E1E),
              centerTitle: true,
              title: const Text(
                'Add Fiat Funds',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletScreen()),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Section
                    const Text(
                      'Set Your Budget',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Input Field for Budget
                    _buildTextField(
                      labelText: 'Enter Budget Amount',
                      controller: _maximumAmountController,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),
                    // Add Budget Button
                    ElevatedButton(
                      onPressed: () async {
                        double? maximumAmount =
                            double.tryParse(_maximumAmountController.text);
                        if (maximumAmount != null) {
                          String? userId = await AuthService.getCurrentUserId();
                          DateTime date = DateTime.now();
                          context.read<FinancialWalletBloc>().add(
                              SetFinancialWallettEvent(
                                  userId!, maximumAmount, date));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Error: Invalid budget amount')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BBE6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        elevation: 4,
                        shadowColor: const Color(0x80000000),
                      ),
                      child: const Text(
                        'Set Budget',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Show additional info or a suggestion here if needed
                    if (state is FinancialWalletLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF8BBE6D)),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF8BBE6D)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}
