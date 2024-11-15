import 'package:flutter/material.dart';
import 'package:mobile_dev_final_project/BuyRentCarPage.dart';
import 'SellPost.dart';
import 'SellPostModel.dart';

class SellPostListPage extends StatelessWidget {
  final SellPostModel sellPostModel = SellPostModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe23636),
        title: const Text(
          'Car Listings',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // "Filters" button in the top-right corner of the AppBar

          IconButton(
            icon: const Icon(Icons.filter_list), // Filter icon
            onPressed: () {
              // Navigate to the Filters page when the button is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyRentCarPage(), // Navigate to FiltersPage
                ),
              );
            },
          ),
        ],
      ),


      body: StreamBuilder<List<SellPost>>(
        stream: sellPostModel.getSellsPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No car listings available'));
          } else {
            final sellPosts = snapshot.data!;
            return ListView.builder(
              itemCount: sellPosts.length,
              itemBuilder: (context, index) {
                final sellPost = sellPosts[index];
                return ListTile(
                  leading: Image.network(
                    sellPost.image ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image, size: 60, color: Colors.grey);
                    },
                  ),
                  title: Text(sellPost.model ?? 'Unknown Model'),
                  subtitle: Text('\$${sellPost.price ?? 'N/A'}'),
                  //This button will be to view the listing
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Navigate to a new page with detailed information about the car
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyRentCarPage(), //im routing it to here for now till page is made!!!
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
