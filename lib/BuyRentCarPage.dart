import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

class Model {
  final String modelName;

  Model(this.modelName);

  @override
  String toString() => modelName;

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(json['Model_Name']);
  }
}

class Make {
  final String makeName;

  Make(this.makeName);

  @override
  String toString() => makeName;

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(json['Make_Name']);
  }
}

Future<Map<String, List<Model>>> fetchMakesAndModels() async {
  final response = await http.get(Uri.parse(
      'https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMake/*?format=json'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> results = jsonData['Results'];

    Map<String, List<Model>> makesAndModels = {};

    for (var item in results) {
      final makeName = item['Make_Name'];
      final model = Model.fromJson(item);

      if (makesAndModels.containsKey(makeName)) {
        makesAndModels[makeName]!.add(model);
      } else {
        makesAndModels[makeName] = [model];
      }
    }

    return makesAndModels;
  } else {
    throw Exception('Failed to fetch makes and models: ${response.statusCode}');
  }
}

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

  Map<String, List<Model>> makesAndModels = {};
  List<String> makes = [];
  String? selectedMake;
  List<Model> models = [];
  Model? selectedModel;

  @override
  void initState() {
    super.initState();
    _loadMakesAndModels();
  }

  Future<void> _loadMakesAndModels() async {
    try {
      final fetchedMakesAndModels = await fetchMakesAndModels();

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
            DropdownSearch<Model>(
              items: models,
              onChanged: (Model? model) {
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