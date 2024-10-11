import 'package:flutter/material.dart';

void showMoneyConverterDialog(BuildContext context) {
  String selectedFromCurrency = 'PHP'; // Default selected currency
  String selectedToCurrency = 'JPY'; // Default selected currency
  TextEditingController amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF121212), // Dialog background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Money Converter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        ),
        content: SizedBox(
          width: 400, // Set the width of the dialog box
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust size to content
            children: [
              // Row for input amount
              Row(
                children: [
                  // SizedBox for dropdown to set a specific width
                  SizedBox(
                    width: 100, // Set width for the dropdown
                    child: DropdownButton<String>(
                      value: selectedFromCurrency,
                      dropdownColor: const Color(0xFF1E1E1E),
                      style: const TextStyle(color: Colors.white),
                      items: <String>[
                        'PHP',
                        'USD',
                        'EUR',
                        'JPY',
                        'GBP',
                        'AUD',
                        'CAD',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedFromCurrency = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between dropdown and text field
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E), // Input background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border
                        ),
                        hintText: 'Input Amount',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'to', // Text label between the two sections
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Row for output amount
              Row(
                children: [
                  // SizedBox for dropdown to set a specific width
                  SizedBox(
                    width: 100, // Set width for the dropdown
                    child: DropdownButton<String>(
                      value: selectedToCurrency,
                      dropdownColor: const Color(0xFF1E1E1E),
                      style: const TextStyle(color: Colors.white),
                      items: <String>[
                        'JPY',
                        'USD',
                        'EUR',
                        'PHP',
                        'GBP',
                        'AUD',
                        'CAD',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedToCurrency = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between dropdown and output text field
                  Expanded(
                    child: TextField(
                      enabled: false, // Disable editing for the output field
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E), // Input background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border
                        ),
                        hintText: 'Total Amount',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Makes the button full-width
                child: ElevatedButton(
                  onPressed: () {
                    // Placeholder for conversion logic
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Convert', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10), // Space between buttons
              SizedBox(
                width: double.infinity, // Makes the button full-width
                child: ElevatedButton(
                  onPressed: () {
                    // Placeholder for confirmation logic
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BBE6D), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
