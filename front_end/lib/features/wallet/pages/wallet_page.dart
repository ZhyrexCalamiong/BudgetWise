import 'dart:convert';

import 'package:budgetwise_one/authservice/authService.dart';
import 'package:budgetwise_one/features/wallet/screens/withdraw_funds_screen.dart';
import 'package:budgetwise_one/models/Transaction.dart';
import 'package:budgetwise_one/models/budget_history.dart';
import 'package:budgetwise_one/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/features/wallet/screens/add_funds_crypto_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/add_funds_fiat_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/convert_crypto_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/convert_fiat_currency.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_event.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_state.dart';
import 'package:budgetwise_one/repositories/budget_repository_impl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double balance = 0.0; // Initialize balance
  double totalSpent = 0.0; // Initialize total spent
  String? userId; // Nullable userId to handle async data fetching
  List<BudgetHistory> budgetHistory = []; // Add budgetHistory
  List<Expense> expenses = []; // Add expenses list
  List<Transaction> combinedTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Call the helper function to load userId
  }

  void _combineAndSortTransactions() {
    combinedTransactions = [
      ...expenses.map((expense) => Transaction(
            description: expense.description,
            date: expense.date,
            amount: expense.cost,
            type: 'expense',
          )),
      ...budgetHistory.map((history) => Transaction(
            description: history.reason,
            date: history.changeDate,
            amount: history.newMaximumAmount,
            type: 'budget',
          )),
    ];

    combinedTransactions.sort(
        (a, b) => b.date.compareTo(a.date)); // Sort by date (newest first)
  }

  // Helper function to load the userId asynchronously
  Future<void> _loadUserId() async {
    String? id = await AuthService.getCurrentUserId(); // Await the async call
    print(id); // Check if this prints a String or Map

    setState(() {
      userId = id; // Assign the result to the userId
    });

    // Fetch user's wallet details once the userId is retrieved
    if (userId != null) {
      context
          .read<FinancialWalleBloc>()
          .add(GetBalanceFinancialWalletEvent(userId!));
      context
          .read<FinancialWalleBloc>()
          .add(GetUserFinancialWalletEvent(userId!)); // Fetch expenses

      context
          .read<FinancialWalleBloc>()
          .add(GetBudgetHistoryEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const TabBar(
                indicatorColor: Color(0xFF8BBE6D),
                labelColor: Color(0xFF8BBE6D),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Fiat Currency'),
                  Tab(text: 'Cryptocurrency'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<FinancialWalleBloc, FinancialWalletState>(
                  listener: (context, state) {
                    if (state is FinancialGetUserBalanceSuccess) {
                      setState(() {
                        balance = state
                            .maximumAmount; // Update balance with fetched data
                        totalSpent = state
                            .amountSpent; // Update total spent with fetched data
                      });
                    } else if (state is FinancialGetBudgetHistorySuccess) {
                      // Store budget history to be displayed
                      setState(() {
                        budgetHistory = state.budgetHistory;
                        _combineAndSortTransactions();
                      });
                    } else if (state is FinancialGetUserExpensesSuccess) {
                      // Store expenses to be displayed
                      setState(() {
                        expenses = state.transactions;
                        _combineAndSortTransactions();
                      });
                    } else if (state is FinancialWalletFailure) {
                      // Handle failure state (e.g., show an error message)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FinancialWalletInitial) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Show loading indicator
                    }
                    return _buildTabContent(
                        context, true); // Build content for Fiat
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, bool isFiat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBalanceCard(balance, totalSpent),
        const SizedBox(height: 20),
        _buildActionButtons(context, isFiat),
        const SizedBox(height: 20),
        _buildRecentTransactionsSection(context),
      ],
    );
  }

  Widget _buildBalanceCard(balance, totalSpent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBalanceColumn('Current Balance', '₱$balance'),
          _buildBalanceColumn('Total Money Spent', '₱$totalSpent'),
        ],
      ),
    );
  }

  Widget _buildBalanceColumn(String title, String amount) {
    return Column(
      children: [
        const Icon(Icons.account_balance_wallet, size: 30, color: Colors.white),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.white)),
        Text(
          amount,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isFiat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.add, 'Add Funds', () {
          if (isFiat) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFundsFiatScreen()));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFundsCryptoScreen()));
          }
        }),
        _buildActionButton(Icons.remove, 'Withdraw', () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WithdrawScreen()));
          if (result == true) {
            _loadUserId();
          }
        }),
        _buildActionButton(Icons.swap_horiz, 'Convert', () {
          if (isFiat) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConvertCurrencyFiatScreen()));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConvertCurrencyCryptoScreen()));
          }
        }),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: combinedTransactions.length,
        itemBuilder: (context, index) {
          final transaction = combinedTransactions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF1E1E1E),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.description,
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 5),
                      Text(
                        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    transaction.type == 'expense'
                        ? '-₱${transaction.amount.toString()}'
                        : '+₱${transaction.amount.toString()}',
                    style: TextStyle(
                      color: transaction.type == 'expense'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return const Text(
      'Recent Transactions',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
  return Column(
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
          backgroundColor: const Color(0xFF8BBE6D), // Your button color
        ),
        onPressed: onPressed,
        child: Icon(icon, color: Colors.white),
      ),
      const SizedBox(height: 5),
      Text(label, style: const TextStyle(color: Colors.white)),
    ],
  );
}
