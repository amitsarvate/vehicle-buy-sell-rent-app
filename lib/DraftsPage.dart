import 'package:flutter/material.dart';
import 'LocalDatabase.dart';
import 'SellPost.dart';

class DraftsPage extends StatefulWidget{

  @override
  _DraftsPageState createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage>{

  LocalDatabase localDatabase = LocalDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffe23636),
        title: const Text('Drafts', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<SellPost>>(
        future: localDatabase.fetchSellPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drafts available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];

              return ListTile(
                title: Text(post.model ?? ''),
                subtitle: Text(
                    '${post.make} - ${post.year} - \$${post.price} - ${post.description}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await localDatabase.deleteSellPost(post.id!);
                    setState(() {});
                  },
                ),
                onTap: () {
                  Navigator.pop(context, post);
                },
              );
            },
          );
        },
      ),
    );
  }
  }