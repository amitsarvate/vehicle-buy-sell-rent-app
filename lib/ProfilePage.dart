import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is logged in
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: Text('No user is currently logged in.\n Sign up or Sign in below')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Email: ${user.email}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Log the user out
                  await FirebaseAuth.instance.signOut();

                  // Optionally, navigate to a login screen or show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged out successfully!')),
                  );

                  // You can navigate to a login screen if needed:
                  //Navigator.pushReplacementNamed(context, 'HomePage');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(title: "AutoHub",),
                      )
                  );
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}