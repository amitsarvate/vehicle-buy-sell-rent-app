import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'makeAndModelAPIFetch.dart' as MMAPI;

// Main app widget
class BuyRentCarPage extends StatefulWidget {
  @override
  _BuyRentCarPageState createState() => _BuyRentCarPageState();
}

class _BuyRentCarPageState extends State<BuyRentCarPage> {
  final TextEditingController minYearController = TextEditingController();
  final TextEditingController maxYearController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  Map<String, List<MMAPI.Model>> makesAndModels = {};
  List<String> makes = [];
  String? selectedMake;
  List<MMAPI.Model> models = [];
  MMAPI.Model? selectedModel;

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
        makes = fetchedMakesAndModels.keys.toList();
      });

    } catch (e) {
      print('Failed to load makes and models: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buy / Rent Car',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffe23636),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            makes.isEmpty
                ? const CircularProgressIndicator()
                : DropdownSearch<String>(
              items: makes,
              onChanged: (String? make) {
                setState(() {
                  selectedMake = make;
                  models = makesAndModels[make] ?? [];
                  selectedModel = null;
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Select a manufacturer',
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: const PopupProps.menu(showSearchBox: true),
            ),
            const SizedBox(height: 30),
            // Dropdown for selecting a model
            DropdownSearch<MMAPI.Model>(
              items: models,
              onChanged: (MMAPI.Model? model) {
                setState(() {
                  selectedModel = model;
                });
              },
              enabled: models.isNotEmpty,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Select a model',
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: const PopupProps.menu(showSearchBox: true),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: minYearController,
                    decoration: const InputDecoration(
                      labelText: 'Min Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: maxYearController,
                    decoration: const InputDecoration(
                      labelText: 'Max Year',
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
                  width: 150,
                  child: TextField(
                    controller: minPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: maxPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (selectedMake != null && selectedModel != null) {
                  print('Selected Make: $selectedMake');
                  print('Selected Model: ${selectedModel!.modelName}');
                  print('Min Year: ${minYearController.text}');
                  print('Max Year: ${maxYearController.text}');
                  print('Min Price: ${minPriceController.text}');
                  print('Max Price: ${maxPriceController.text}');
                } else {
                  print('Please select a make and a model');
                }
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}