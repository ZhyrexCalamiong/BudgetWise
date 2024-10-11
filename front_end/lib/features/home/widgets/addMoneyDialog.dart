import 'package:flutter/material.dart';

class AddMoneyDialog extends StatelessWidget {
  const AddMoneyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF121212), // Dialog background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add Money',
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
            TextField(
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Makes the button full-width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the Add Money dialog
void showAddMoneyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AddMoneyDialog();
    },
  );
}
