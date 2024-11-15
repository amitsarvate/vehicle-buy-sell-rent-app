import 'package:flutter/material.dart';
import 'SellPostListPage.dart';
import 'ProfilePage.dart';
import 'main.dart';
import 'SellCarPage.dart';

class Main extends StatefulWidget {
  final String? userEmail;

  Main({Key? key, this.userEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Main> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widgets for each bottom navigation item
    final widgetOptions = [
      SellPostListPage(), // Display SellPostListPage for Home
      SellCarPage(), // Placeholder for Add page
      //Center(child: Text(widget.userEmail ?? 'Guest Mode', style: TextStyle(fontSize: 24))), // Profile page
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page',style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (context) => HomePage(title: "AutoHub",),
                )
            );
          },
        ),
        backgroundColor: Color(0xffe23636),
      ),
      body: widgetOptions[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffe23636),
        onTap: _onItemTapped,
      ),
    );
  }
}
