import 'package:flutter/material.dart';
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
