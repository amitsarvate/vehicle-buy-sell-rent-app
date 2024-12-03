import 'package:flutter/material.dart';
import 'SellPost.dart';
import 'BuyerContactedScreen.dart';


class CarListingScreen extends StatelessWidget {
  final SellPost sellPost;

  CarListingScreen({required this.sellPost});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe23636),
        title: const Text(
          'Car Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Image Section: Takes 40% of the screen height
          Container(
            height: screenHeight * 0.4, // Set image container height to 40% of screen height
            width: double.infinity, // Full width
            color: Colors.black38, // Black background for padding
            child: FittedBox(
              fit: BoxFit.contain, // Ensures the image is scaled to either width or height
              child: Image.network(
                sellPost.image ?? '', // Display image from SellPost
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 80, color: Colors.grey); // Fallback icon on error
                },
              ),
            ),
          ),

          // Title and Price Section: Display car model and price
          Container(
            width: double.infinity, // Full width
            padding: const EdgeInsets.all(16.0), // Padding for content
            color: Colors.white, // Background color for the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  sellPost.model ?? 'Unknown Model', // Display car model
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Title styling
                ),
                const SizedBox(height: 8), // Space between model and price
                Text(
                  '\$${sellPost.price ?? 'N/A'}', // Display price or 'N/A' if not available
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Price styling
                ),
              ],
            ),
          ),

          // Divider between Title/Price and Description Section
          const Divider(
            color: Colors.grey, // Divider color
            thickness: 1, // Divider thickness
            indent: 16, // Padding on left side of divider
            endIndent: 16, // Padding on right side of divider
          ),

          // Description Section: Display car description
          Expanded(
            child: Container(
              width: double.infinity, // Full width
              padding: const EdgeInsets.all(16.0), // Padding for content
              color: Colors.white, // Background color for the container
              child: Text(
                sellPost.description ?? 'No description provided', // Display description or placeholder
                style: const TextStyle(fontSize: 16), // Styling for the description text
              ),
            ),
          ),

          // Red "Add" Button at the bottom (Square)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding for button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe23636), // Red button color
                foregroundColor: Colors.white, // White text color
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Vertical padding for button
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Square button
                ),
                minimumSize: const Size(double.infinity, 50), // Make button fill full width with some height
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyerContactedScreen(),
                  ),
                );
              },
              child: const Text(
                'Contact Buyer', // Button text
                style: TextStyle(fontSize: 16), // Text style for the button
              ),
            ),
          ),
        ],
      ),
    );
  }
}
