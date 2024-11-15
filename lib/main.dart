import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:mobile_dev_final_project/BuyRentCarPage.dart';
import 'package:mobile_dev_final_project/SellCarPage.dart';
import 'package:mobile_dev_final_project/firebase_options.dart';
import 'SingInForm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'MainPage.dart';
import 'SingInForm.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Vehicle Buy Rent Sell Applications'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void goToHomePage() async{
    await Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (BuildContext context)  =>Main(userEmail: null)
        )
    );

  }
  @override
  Widget build(BuildContext context) {

    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe23636),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AutoHub',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    goToHomePage();
                  },
                  icon: Icon(Icons.directions_car, color: Colors.white),
                ),
                SizedBox(width: 10),
                if (user == null)
                  TextButton(
                    onPressed: () {
                     // print('Sign In Button Pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInForm(),
                        ),
                      );

                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image with overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://www.wilhitelawfirm.com/wp-content/uploads/2024/10/driving-at-mountain-side.jpg'), // Replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Tint overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust the opacity for the tint
          ),
          // Centered buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user == null)
                  ElevatedButton(
                    onPressed: () {
                      print('Sign in/Sign up Button Pressed');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInForm()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffe23636), // Button color
                      elevation: 5, // Elevation for shadow
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(
                            color: Colors.white, width: 2), // Border color
                      ),
                    ),
                    child: Text(
                      'Sign in/Sign up',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  if (user != null)
                    ElevatedButton(
                      onPressed: () {
                        print('Home Page button Pressed');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Main()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe23636), // Button color
                        elevation: 5, // Elevation for shadow
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: BorderSide(
                              color: Colors.white, width: 2), // Border color
                        ),
                      ),
                    child: Text(
                      'Home Page',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                SizedBox(height: 20), // Space between buttons
              ],
            ),
          ),
        ],
      ),
    );
  }
}
