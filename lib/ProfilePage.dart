import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_dev_final_project/SingInForm.dart';
import 'package:mobile_dev_final_project/SingUpForm.dart';
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,  // Size of the avatar
                  backgroundColor: Colors.grey[200],  // Background color
                  child: Icon(
                    Icons.person,  // Default icon if no image
                    size: 50,
                    color: Colors.grey[800],  // Icon color
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'No user is currently logged in.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                // Sign Up and Sign In buttons
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Sign Up page
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (context) => SignUpForm(),
                        )
                    );
                  },
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Sign In page
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (context) => SignInForm(),
                        )
                    );
                  },
                  child: Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
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

              // Profile picture (CircleAvatar)
              CircleAvatar(
                radius: 50,  // Size of the avatar (make it 50 for example)
                backgroundColor: Colors.grey[200],  // Background color
                child: Icon(
                  Icons.person,  // Default icon if no image
                  size: 50,
                  color: Colors.grey[800],  // Icon color
                ),
              ),
              SizedBox(height: 20),  // Space between avatar and email

              // Email text
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