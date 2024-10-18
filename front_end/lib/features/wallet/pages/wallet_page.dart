import 'dart:convert';
import 'package:budgetwise_one/authservice/authService.dart';
import 'package:budgetwise_one/features/wallet/pages/crypto_wallet_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/withdraw_funds_screen.dart';
import 'package:budgetwise_one/models/Transaction.dart';
import 'package:budgetwise_one/models/budget_history.dart';
import 'package:budgetwise_one/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/features/wallet/screens/add_funds_fiat_screen.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_bloc.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_event.dart';
import 'package:budgetwise_one/bloc/financial_wallet/financial_wallet_state.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double balance = 0.0;
  double totalSpent = 0.0;
  String? userId;
  List<BudgetHistory> budgetHistory = [];
  List<Expense> expenses = [];
  List<BudgetExpenseHistory> combinedTransactions = [];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _combineAndSortTransactions() {
    combinedTransactions = [
      ...expenses.map((expense) => BudgetExpenseHistory(
            description: expense.description,
            date: expense.date,
            amount: expense.cost,
            type: 'expense',
          )),
      ...budgetHistory.map((budgetHistory) => BudgetExpenseHistory(
            description: budgetHistory.reason,
            date: budgetHistory.changeDate,
            amount: budgetHistory.newMaximumAmount,
            type: 'budget',
          )),
    ];
    combinedTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _loadUserId() async {
    String? id = await AuthService.getCurrentUserId();
    setState(() {
      userId = id;
    });
    if (userId != null) {
      context
          .read<FinancialWalletBloc>()
          .add(GetBalanceFinancialWalletEvent(userId!));
      context
          .read<FinancialWalletBloc>()
          .add(GetUserFinancialWalletEvent(userId!));
      context.read<FinancialWalletBloc>().add(GetBudgetHistoryEvent(userId!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID is null")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              TabBar(
                indicatorColor: const Color(0xFF8BBE6D),
                labelColor: const Color(0xFF8BBE6D),
                unselectedLabelColor: Colors.grey,
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                tabs: const [
                  Tab(text: 'Fiat Currency'),
                  Tab(text: 'Crypto'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<FinancialWalletBloc, FinancialWalletState>(
                  listener: (context, state) {
                    if (state is FinancialGetUserBalanceSuccess) {
                      setState(() {
                        balance = state.maximumAmount;
                        totalSpent = state.amountSpent;
                      });
                    } else if (state is FinancialGetBudgetHistorySuccess) {
                      setState(() {
                        budgetHistory = state.budgetHistory;
                        _combineAndSortTransactions();
                      });
                    } else if (state is FinancialGetUserExpensesSuccess) {
                      setState(() {
                        expenses = state.transactions;
                        _combineAndSortTransactions();
                      });
                    } else if (state is FinancialWalletFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FinancialWalletInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildTabContent(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_selectedTabIndex == 0) ...[
          _buildBalanceCard(balance, totalSpent),
          const SizedBox(height: 20),
          _buildActionButtons(context),
          const SizedBox(height: 20),
          _buildRecentTransactionsSection(context),
        ],
        if (_selectedTabIndex == 1) ...[
          const WalletScreen(),
        ],
      ],
    );
  }

  Widget _buildBalanceCard(double balance, double totalSpent) {
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          Icons.add,
          'Add Funds',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFundsFiatScreen(),
              ),
            );
          },
          Icons.add,
        ),
        _buildActionButton(
          Icons.remove,
          'Withdraw',
          () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WithdrawScreen(),
              ),
            );
            if (result == true) {
              _loadUserId();
            }
          },
          Icons.arrow_downward,
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed,
      IconData buttonIcon) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), // Makes the button round
        padding: const EdgeInsets.all(20), // Adds padding for larger size
        backgroundColor: const Color(0xFF1E1E1E), // Matches card background
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(buttonIcon,
              size: 24, color: const Color(0xFF8BBE6D)), // Highlight color
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF8BBE6D)), // Highlight color
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context) {
    return Expanded(
      child: combinedTransactions.isEmpty
          ? const Center(
              child: Text(
                'No recent transactions.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: combinedTransactions.length,
              itemBuilder: (context, index) {
                final transaction = combinedTransactions[index];
                return _buildTransactionItem(transaction);
              },
            ),
    );
  }

  Widget _buildTransactionItem(BudgetExpenseHistory transaction) {
    return ListTile(
      title: Text(
        transaction.description,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        '${transaction.type.capitalize()} - ${_formatDate(transaction.date)}',
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        '${transaction.type == 'expense' ? '-' : '+'} ₱${transaction.amount}',
        style: TextStyle(
          color: transaction.type == 'expense'
              ? Colors.red
              : const Color(0xFF8BBE6D),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // You can format the date as per your requirements
    // For example: 'Oct 13, 2024'
    return "${_getMonth(date.month)} ${date.day}, ${date.year}";
  }

  String _getMonth(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
