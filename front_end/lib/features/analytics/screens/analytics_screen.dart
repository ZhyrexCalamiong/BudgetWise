import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: Container(), // Placeholder for symmetry
        actions: [
          // Notification icon on the right
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bar chart section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Bar Chart Image Placeholder
                    SizedBox(
                      height: 200, // Height of the image
                      child: Image.asset('assets/images/bar_chart.png'),
                    ),
                    const SizedBox(height: 16),
                    // Weekday labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun'
                      ].map((day) => Text(day)).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Expense Bucket donut chart section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Title row with dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Expense Bucket',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Placeholder for dropdown menu
                        GestureDetector(
                          onTap: () {
                            //logic of dropdown here
                          },
                          child: const Row(
                            children: [
                              Text('Weekly'),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Placeholder for the Donut Chart
                    SizedBox(
                      height: 200, // Height of the image
                      child: Image.asset(
                          'assets/images/pie_chart.png'), // Placeholder for actual chart
                    ),
                    const SizedBox(height: 16),
                    // Legend section
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 4,
                      children: [
                        // Legend items
                        legendItem(Colors.cyan, 'Item 1'),
                        legendItem(Colors.blue, 'Item 2'),
                        legendItem(Colors.orange, 'Item 3'),
                        legendItem(Colors.indigo, 'Item 4'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for legend items
  Widget legendItem(Color color, String label) {
    return Row(
      children: [
        // Color dot
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        // Label text
        Text(label),
      ],
    );
  }
}
