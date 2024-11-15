import 'package:flutter/material.dart';
import 'SellPost.dart';
import 'SellPostModel.dart';
import 'LocalDatabase.dart';
import 'DraftsPage.dart';

class SellCarPage extends StatefulWidget{

  @override
  _SellCarPageState createState() => _SellCarPageState();

}

//temporary set of models, can add functionality later
enum Models {
  hyundai('Hyundai'),
  ford('Ford'),
  toyota('Toyota'),
  honda('Honda'),
  chevrolet('Chevrolet'),
  kia('Kia'),
  mazda('Mazda');

  const Models(this.models);
  final String models;
}

class _SellCarPageState extends State<SellCarPage>{
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  Models? _selectedModel;
  SellPostModel sellPostModel = SellPostModel() ;

  void _handleAddToListings() async{
    if (modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imageController.text.isEmpty) {
      // Show an error or return if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    // Parse inputs
    String model = _selectedModel?.models ?? "";
    int year = int.tryParse(yearController.text) ?? 0;
    int price = int.tryParse(priceController.text) ?? 0;
    String description = descriptionController.text??"";
    String image = imageController.text;

    // Create a SellPost object
    // Parse inputs

    // Create a map from the form data
    Map<String, dynamic> postData = {
      'model': model,
      'year': year,
      'price': price,
      'description': description,
      'image': image,
    };

    // Create a SellPost object from the map
    SellPost newPost = SellPost.fromMap(postData);

    // Clear the input fields after creating the SellPost object
    try {
      await sellPostModel.insertSellPost(newPost);

      // Clear the input fields after successful addition
      modelController.clear();
      yearController.clear();
      priceController.clear();
      descriptionController.clear();
      imageController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car added to listings successfully!')),
      );
      print(newPost.toMap());
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add car to listings: $e')),
      );
    }

  }

  void _handleSaveAsDraft() async {
    if (modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imageController.text.isEmpty) {
      // Show an error or return if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    // Parse inputs
    String model = _selectedModel?.models ?? "";
    int year = int.tryParse(yearController.text) ?? 0;
    int price = int.tryParse(priceController.text) ?? 0;
    String description = descriptionController.text ?? "";
    String image = imageController.text;

    // Create a SellPost object
    // Parse inputs

    // Create a map from the form data
    Map<String, dynamic> postData = {
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
      modelController.clear();
      yearController.clear();
      priceController.clear();
      descriptionController.clear();
      imageController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved successfully!')),
      );
      print(draftPost.toMap());
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save draft: $e')),
      );
    }
  }

  void _useDraft() async {
    final selectedPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DraftsPage()),
    );

    if (selectedPost != null && selectedPost is SellPost) {
      setState(() {
        modelController.text = selectedPost.model ?? '';
        yearController.text = selectedPost.year?.toString() ?? '';
        priceController.text = selectedPost.price?.toString() ?? '';
        descriptionController.text = selectedPost.description ?? '';
        imageController.text = selectedPost.image ?? '';
        _selectedModel = Models.values.firstWhere((model) => model.models == selectedPost.model);
      });
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
            'Sell Car',
            style: TextStyle(
                color: Colors.white
            )
        ),
        backgroundColor: const Color(0xffe23636),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownMenu<Models>(
              width: 300,
              controller: modelController,
              requestFocusOnTap: true,
              label: const Text('Models'),
              onSelected: (Models? models) {
                setState(() {
                  _selectedModel = models;
                });
              },
              dropdownMenuEntries: Models.values.map<DropdownMenuEntry<Models>>((Models models) {
                return DropdownMenuEntry<Models>(
                  value: models,
                  label: models.models,
                );
              },
              ).toList(),
            ),
            const SizedBox(height: 30),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: yearController,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _handleAddToListings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe23636), // Button color
                elevation: 5, // Elevation for shadow
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: const BorderSide(color: Colors.white, width: 2), // Border color
                ),
              ),
              child: const Text(
                'Add to Listings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _handleSaveAsDraft();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe23636), // Button color
                elevation: 5, // Elevation for shadow
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: const BorderSide(color: Colors.white, width: 2), // Border color
                ),
              ),
              child: const Text(
                'Save as Draft',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _useDraft,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe23636), // Button color
                elevation: 5, // Elevation for shadow
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: const BorderSide(color: Colors.white, width: 2), // Border color
                ),
              ),
              child: const Text(
                'View Drafts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}