import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.orange],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Balance",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₱120,000.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallet Address",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "0x1C93216321683D732164218...",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Action Buttons (Send, Receive, Buy, Convert)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Send Button
                Column(
                  children: [
                    Icon(Icons.send, color: Colors.orange, size: 40),
                    SizedBox(height: 8),
                    Text("Send"),
                  ],
                ),
                // Receive Button
                Column(
                  children: [
                    Icon(Icons.call_received, color: Colors.orange, size: 40),
                    SizedBox(height: 8),
                    Text("Receive"),
                  ],
                ),
                // Buy Button
                Column(
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.orange, size: 40),
                    SizedBox(height: 8),
                    Text("Buy"),
                  ],
                ),
                // Convert Button
                Column(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.orange, size: 40),
                    SizedBox(height: 8),
                    Text("Convert"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),

            // My Assets section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Assets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "view all",
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Asset List
            // Bitcoin Asset Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Bitcoin Icon
                    Icon(Icons.currency_bitcoin,
                        color: Colors.orange, size: 40),
                    SizedBox(width: 16),
                    // Bitcoin Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bitcoin",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "12.8317132 BTC",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "32,134.10 USD",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Additional asset cards can go here
          ],
        ),
      ),
    );
  }
}
