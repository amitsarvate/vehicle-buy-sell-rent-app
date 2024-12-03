import 'package:flutter/material.dart';

class BuyerContactedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe23636),
        title: const Text(
          'Buyer Contacted',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Buyer Contacted',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe23636), // Red button color
                foregroundColor: Colors.white, // White text color
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Square button
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text(
                'Return',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
