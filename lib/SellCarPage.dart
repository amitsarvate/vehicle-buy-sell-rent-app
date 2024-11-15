import 'package:flutter/material.dart';
import 'SellPost.dart';
import 'SellPostModel.dart';
import 'makeAndModelAPIFetch.dart' as MMAPI;
import 'package:dropdown_search/dropdown_search.dart';

class SellCarPage extends StatefulWidget {
  @override
  _SellCarPageState createState() => _SellCarPageState();
}

class _SellCarPageState extends State<SellCarPage> {
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
    Map<String, dynamic> postData = {
      'make': make,
      'model': model,
      'year': year,
      'price': price,
      'description': description,
      'image': image,
    };

    SellPost newPost = SellPost.fromMap(postData);

    try {
      await sellPostModel.insertSellPost(newPost);

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car added to listings successfully!')),
      );
      print(newPost.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add car to listings: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sell Car',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffe23636),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Make Dropdown Search
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
                  backgroundColor: const Color(0xffe23636),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Add to Listings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
