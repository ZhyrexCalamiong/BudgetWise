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
            color: Color(0xFF1E1E1E), // Card background color
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
            _buildActionButton(Icons.add, 'Add', Color(0xFF8BBE6D), () {
              _showAmountInputModal(context, isFiat, true, (amount) {
                balance += amount; // Update balance for Fiat
              });
            }),
            _buildActionButton(Icons.swap_horiz, 'Convert', Color(0xFF8BBE6D),
                () {
              _showAmountInputModal(context, isFiat, false, (amount) {
                totalSpent += amount; // Update total spent for Fiat
              });
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
                        color: Colors.white),
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
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey
                              .shade700, // Transaction item background color
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 5,
                            height: double.infinity,
                            color: Color(0xFF8BBE6D),
                          ),
                          title: Text('Transaction $index',
                              style: const TextStyle(
                                  color:
                                      Colors.white)), // Transaction text color
                          subtitle: const Text('Details of the transaction',
                              style: TextStyle(
                                  color: Colors.grey)), // Subtitle color
                          trailing: const Text('₱ 1,000.00',
                              style: TextStyle(
                                  color: Colors.white)), // Trailing text color
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
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor:
                const Color(0xFF121212), // Background color for buttons
            radius: 30,
            child: Icon(icon, size: 30, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Button label color
        ),
      ],
    );
  }

  void _showAmountInputModal(BuildContext context, bool isFiat, bool isAdd,
      Function(double) updateAmount) {
    final TextEditingController amountController = TextEditingController();
    String selectedCurrency = 'PHP'; // Default currency

    // List of currency options
    final List<String> currencyOptions = ['PHP', 'USD', 'JPY'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _AmountInputModal(
          amountController: amountController,
          selectedCurrency: selectedCurrency,
          currencyOptions: currencyOptions,
          onChangedCurrency: (String newCurrency) {
            selectedCurrency = newCurrency; // Update selected currency
          },
          isFiat: isFiat,
          isAdd: isAdd,
          updateAmount: updateAmount,
        );
      },
    );
  }
}

class _AmountInputModal extends StatefulWidget {
  final TextEditingController amountController;
  final String selectedCurrency;
  final List<String> currencyOptions;
  final Function(String) onChangedCurrency;
  final bool isFiat;
  final bool isAdd;
  final Function(double) updateAmount;

  const _AmountInputModal({
    required this.amountController,
    required this.selectedCurrency,
    required this.currencyOptions,
    required this.onChangedCurrency,
    required this.isFiat,
    required this.isAdd,
    required this.updateAmount,
  });

  @override
  __AmountInputModalState createState() => __AmountInputModalState();
}

class __AmountInputModalState extends State<_AmountInputModal> {
  late String selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.selectedCurrency; // Initialize selected currency
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Set a fixed height for the modal
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF0D0D0D), // Background color of modal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${widget.isAdd ? 'Add' : 'Convert'} Amount',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white), // Modal title color
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white), // Text color
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle:
                  const TextStyle(color: Colors.grey), // Label text color
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFF8BBE6D)), // Focused border color
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey), // Unfocused border color
              ),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedCurrency,
            dropdownColor: const Color(0xFF1E1E1E), // Dropdown background color
            items: widget.currencyOptions.map((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency,
                    style: const TextStyle(
                        color: Colors.white)), // Dropdown item text color
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCurrency = newValue!;
                widget.onChangedCurrency(
                    selectedCurrency); // Update selected currency
              });
            },
            decoration: InputDecoration(
              labelText: 'Select Currency',
              labelStyle:
                  const TextStyle(color: Colors.grey), // Label text color
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey), // Unfocused border color
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (widget.amountController.text.isNotEmpty) {
                final amount = double.parse(widget.amountController.text);
                widget.updateAmount(amount); // Update amount in parent
                Navigator.pop(context); // Close modal
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF8BBE6D), // Button background color
            ),
            child: Text(widget.isAdd ? 'Add' : 'Convert',
                style:
                    const TextStyle(color: Colors.black)), // Button text color
          ),
        ],
      ),
    );
  }
}
