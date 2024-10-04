import 'package:flutter/material.dart';

class ViewAllTransactions extends StatelessWidget {
  const ViewAllTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
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
                  color: Colors.grey.shade200,
                ),
                child: ListTile(
                  leading: Container(
                    width: 5,
                    height: double.infinity,
                    color: Colors.orangeAccent,
                  ),
                  title: Text('Transaction $index'),
                  subtitle: const Text('Details of the transaction'),
                  trailing: const Text('₱ 1,000.00'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
