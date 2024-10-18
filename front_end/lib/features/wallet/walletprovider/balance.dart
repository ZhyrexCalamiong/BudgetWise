import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String address;

  const BalanceCard(
      {super.key,
      required this.balance,
      required this.address,
      required MaterialAccentColor backgroundColor,
      required Color textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110, // Reduced height
      width: MediaQuery.of(context).size.width * 0.89,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Container(
              height: 135, // Reduced height to match the card's height
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Flexible(
                  child: Text(
                    'Wallet Address:',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(
                            255, 255, 255, 255)), // Reduced font size
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2), // Reduced space
                Flexible(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 10, // Reduced font size
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8), // Reduced space
                const Flexible(
                  child: Text(
                    'Current Balance:',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white), // Reduced font size
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2), // Reduced space
                Flexible(
                  child: Text(
                    balance,
                    style: const TextStyle(
                      fontSize: 12, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
