import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_dev_final_project/SingInForm.dart';
import 'main.dart';
import 'package:mobile_dev_final_project/UserModel.dart';
import 'User.dart';
Future<localUser?> fetchAndPrintUser() async {
  User? user = FirebaseAuth.instance.currentUser;

  UserModel userModel = UserModel();
  if (user != null) {
    // Await the result of the asynchronous function
    localUser? localuser = await userModel.getUserById(user.uid);
    print(user.uid);

    if (localuser != null) {
      print(localuser.toMap());
      return localuser;
    } else {
      print("No user found 1");
      return null;

    }
  } else {
    print("No user found");
    return null;
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    fetchAndPrintUser() ;




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
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Sign In page
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (context) => SignInForm(),
                        )
                    );
                  },
                  child: Text('Sign In / Sign up'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffe23636),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
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
                child: Text('Logout',style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}