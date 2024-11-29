import 'package:flutter/material.dart';
import 'SellPost.dart';
import 'SellPostModel.dart';
import 'makeAndModelAPIFetch.dart' as MMAPI;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SingInForm.dart';
import 'LocalDatabase.dart';
import 'DraftsPage.dart';
import 'snackbar_helper.dart';
import 'Notifications.dart';

class SellCarPage extends StatefulWidget {
  @override
  _SellCarPageState createState() => _SellCarPageState();
}

class _SellCarPageState extends State<SellCarPage> {

  // Get the current user from Firebase Auth
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  Map<String, List<MMAPI.Model>> makesAndModels = {};
  List<String> makes = [];
  String? selectedMake;
  List<MMAPI.Model> models = [];
  MMAPI.Model? selectedModel;

  SellPostModel sellPostModel = SellPostModel();
  Notifications notification = Notifications();

  @override
  void initState() {
    super.initState();
    _loadMakesAndModels();
  }

  Future<void> _loadMakesAndModels() async {
    try {
      final fetchedMakesAndModels = await MMAPI.fetchMakesAndModels();
      setState(() {
        makesAndModels = fetchedMakesAndModels;
        makes = makesAndModels.keys.toList();
      });
    } catch (e) {
      print('Failed to load makes and models: $e');
    }
  }

  void _handleAddToListings() async {
    if (selectedMake == null ||
        selectedModel == null ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imageController.text.isEmpty) {
        SnackbarHelper.showSnackBar(context, 'Please fill all the fields');
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;

    // Parse inputs
    String make = selectedMake!;
    String model = selectedModel!.modelName;
    int year = int.tryParse(yearController.text) ?? 0;
    int price = int.tryParse(priceController.text) ?? 0;
    String description = descriptionController.text;
    String image = imageController.text;

    // Create a SellPost object
    Map<String, dynamic> postData = {
      'make': make,
      'model': model,
      'year': year,
      'price': price,
      'description': description,
      'image': image,
      'userId':user?.uid,
    };

    SellPost newPost = SellPost.fromMap(postData);

    try {
      await sellPostModel.insertSellPost(newPost);
      notification.sendAddListingNotification(newPost);

      // Clear the input fields after successful addition
      setState(() {
        selectedMake = null;
        selectedModel = null;
        models = [];
      });
      yearController.clear();
      priceController.clear();
      descriptionController.clear();
      imageController.clear();
      SnackbarHelper.showSnackBar(context, 'Car added to listings successfully!');
      print(newPost.toMap());
    } catch (e) {
      SnackbarHelper.showSnackBar(context, 'Failed to add car to listings: $e');
    }
  }

  void _handleSaveAsDraft() async {
    if (selectedMake == null ||
        selectedModel == null ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    // Parse inputs
    String make = selectedMake!;
    String model = selectedModel!.modelName;
    int year = int.tryParse(yearController.text) ?? 0;
    int price = int.tryParse(priceController.text) ?? 0;
    String description = descriptionController.text;
    String image = imageController.text;

    // Create a SellPost object
    // Parse inputs

    // Create a map from the form data
    Map<String, dynamic> postData = {
      'make': make,
      'model': model,
      'year': year,
      'price': price,
      'description': description,
      'image': image,
    };

    // Create a SellPost object from the map
    SellPost draftPost = SellPost.fromMap(postData);

    // Clear the input fields after creating the SellPost object
    try {
      await LocalDatabase.instance.insertSellPost(draftPost);

      // Clear the input fields after successful addition
      setState(() {
        selectedMake = null;
        selectedModel = null;
        models = [];
      });
      yearController.clear();
      priceController.clear();
      descriptionController.clear();
      imageController.clear();

      // Show a success message
      SnackbarHelper.showSnackBar(context, 'Draft saved successfully!');
      print(draftPost.toMap());
    } catch (e) {
      // Show an error message if something goes wrong
      SnackbarHelper.showSnackBar(context, 'Failed to save draft: $e');
    }
  }

  void _useDraft() async {
    final selectedPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DraftsPage()),
    );

    if (selectedPost != null && selectedPost is SellPost) {
      setState(() {
        selectedMake = selectedPost.make;
        models = makesAndModels[selectedMake] ?? [];
        selectedModel = models.firstWhere((model) => model.modelName == selectedPost.model);
        yearController.text = selectedPost.year?.toString() ?? '';
        priceController.text = selectedPost.price?.toString() ?? '';
        descriptionController.text = selectedPost.description ?? '';
        imageController.text = selectedPost.image ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Add')),
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
                  'You must be logged in to add a listing.',
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
        title: const Text(
          'Sell Car',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffe23636),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Make Dropdown Search
              const SizedBox(height: 20),
              DropdownSearch<String>(
                items: makes,
                selectedItem: selectedMake,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Make',
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
                onChanged: (make) {
                  setState(() {
                    selectedMake = make;
                    models = makesAndModels[make] ?? [];
                    selectedModel = null;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Model Dropdown Search
              DropdownSearch<MMAPI.Model>(
                items: models,
                selectedItem: selectedModel,
                itemAsString: (model) => model.modelName,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Model',
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
                onChanged: (model) {
                  setState(() {
                    selectedModel = model;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Year TextField
              TextField(
                controller: yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Price TextField
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Description TextField
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Image URL TextField
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),

              // Add to Listings Button
              ElevatedButton(
                onPressed: _handleAddToListings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: const Text(
                  'Add to Listings',
                  style: TextStyle(color: Colors.red),
                ),
              ),

              const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSaveAsDraft,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffffffff),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              child: const Text(
                'Save as Draft',
                style: TextStyle(color: Colors.red),
              ),
            ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _useDraft,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: const Text(
                  'View Drafts',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
