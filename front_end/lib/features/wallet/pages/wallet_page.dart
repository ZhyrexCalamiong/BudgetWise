import 'package:budgetwise_one/features/wallet/screens/add_funds_crypto_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/add_funds_fiat_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/convert_crypto_screen.dart';
import 'package:budgetwise_one/features/wallet/screens/convert_fiat_currency.dart';
import 'package:flutter/material.dart';
import '../../transactions/view_all_transactions/view_all_transaction.dart'; // Import the new page

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D), // Background color
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
                    color: Colors.white, // Text color
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Tab Bar
              const TabBar(
                indicatorColor: Color(0xFF8BBE6D),
                labelColor: Color(0xFF8BBE6D), // Active tab text color
                unselectedLabelColor: Colors.grey, // Inactive tab text color
                tabs: [
                  Tab(text: 'Fiat Currency'),
                  Tab(text: 'Cryptocurrency'),
                ],
              ),
              const SizedBox(
                  height: 20), // Increased space between Tab and Card
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTabContent(context, true), // Fiat
                    _buildTabContent(context, false), // Crypto
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, bool isFiat) {
    double balance = 0.0;
    double totalSpent = 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card to display balance and total spent
        Container(
          width: double.infinity, // Make it take the full width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1E1E1E), // Card background color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.account_balance_wallet,
                          size: 30, color: Colors.white),
                      const SizedBox(height: 5),
                      const Text(
                        'Current Balance',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        '₱$balance', // Display balance for Fiat
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.money_off,
                          size: 30, color: Colors.white),
                      const SizedBox(height: 5),
                      const Text(
                        'Total Money Spent',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        '₱$totalSpent', // Display total spent for Fiat
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(Icons.add, 'Add', () {
              if (isFiat) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFundsFiatScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFundsCryptoScreen(),
                  ),
                );
              }
            }),
            _buildActionButton(Icons.swap_horiz, 'Convert', () {
              if (isFiat) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConvertCurrencyFiatScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConvertCurrencyCryptoScreen(),
                  ),
                );
              }
            }),
          ],
        ),
        const SizedBox(height: 24),
        const SizedBox(height: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAllTransactions(),
                        ),
                      );
                    },
                    child: const Text('View all',
                        style: TextStyle(
                            color: Color(0xFF8BBE6D))), // Button text color
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 4, // Example item count
                  itemBuilder: (context, index) {
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
                            Text(
                              'Transaction #$index',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '₱${(index + 1) * 100}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFF1E1E1E), // Black background color
            padding: const EdgeInsets.all(20), // Increased padding
            shadowColor: Colors.black,
          ),
          child:
              Icon(icon, color: Colors.white, size: 36), // Increased icon size
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white, // White text color
            fontSize: 16, // Slightly bigger font size
          ),
        ),
      ],
    );
  }
}
