import 'package:flutter/material.dart';

class PaymentJobCardPage extends StatefulWidget {
  final String amount;
  final String sender;
  final String recipient;
  final String hash;
  final DateTime date;
  final bool isSent;

  const PaymentJobCardPage({
    Key? key,
    required this.amount,
    required this.sender,
    required this.recipient,
    required this.hash,
    required this.date,
    required this.isSent,
  }) : super(key: key);

  @override
  _PaymentJobCardPageState createState() => _PaymentJobCardPageState();
}

class _PaymentJobCardPageState extends State<PaymentJobCardPage> {
  bool _isExpanded = false;

  String shortenAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 4,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.isSent ? 'Sent' : 'Recieved'} ${widget.amount} ETH',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    widget.date.toLocal().toString().split(' ')[0],
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                  'From: ${_isExpanded ? widget.sender : shortenAddress(widget.sender)}'),
              Text(
                  'To: ${_isExpanded ? widget.recipient : shortenAddress(widget.recipient)}'),
              const SizedBox(height: 8),
              Text(
                  'Hash: ${_isExpanded ? widget.hash : shortenAddress(widget.hash)}'),
            ],
          ),
        ),
      ),
    );
  }
}
