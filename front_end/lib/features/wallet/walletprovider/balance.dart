import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String address;

  const BalanceCard({super.key, required this.balance, required this.address, required MaterialAccentColor backgroundColor, required Color textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
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
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Flexible(
                  child: Text(
                    'Wallet Address:',
                    style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 255, 255, 255)),
                    overflow: TextOverflow.ellipsis, 
                  ),
                ),
                const SizedBox(height: 4), 
                Flexible(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis, 
                  ),
                ),
                const SizedBox(height: 10),
                const Flexible(
                  child: Text(
                    'Current Balance:',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    overflow: TextOverflow.ellipsis, 
                  ),
                ),
                const SizedBox(height: 4), 
                Flexible(
                  child: Text(
                    balance, 
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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