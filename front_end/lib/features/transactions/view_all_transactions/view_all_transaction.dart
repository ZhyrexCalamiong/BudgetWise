import 'package:flutter/material.dart';

class ViewAllTransactions extends StatelessWidget {
  const ViewAllTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        backgroundColor:
            const Color(0xFF1A1A1A), // Set the AppBar background color
        foregroundColor: Colors.white, // Set text and icon color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF0D0D0D), // Set the body background color
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 20, // Example item count for all transactions
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      Colors.grey.shade800, // Transaction item background color
                ),
                child: ListTile(
                  leading: Container(
                    width: 5,
                    height: double.infinity,
                    color: const Color(0xFF8BBE6D),
                  ),
                  title: Text(
                    'Transaction $index',
                    style: const TextStyle(
                        color: Colors.white), // Title text color
                  ),
                  subtitle: const Text(
                    'Details of the transaction',
                    style: TextStyle(color: Colors.grey), // Subtitle color
                  ),
                  trailing: const Text(
                    '₱ 1,000.00',
                    style:
                        TextStyle(color: Colors.white), // Trailing text color
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
