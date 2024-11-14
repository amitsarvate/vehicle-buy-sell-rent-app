import 'package:flutter/material.dart';

class BuyRentCarPage extends StatefulWidget{

  @override
  _BuyRentCarPageState createState() => _BuyRentCarPageState();

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

class _BuyRentCarPageState extends State<BuyRentCarPage>{
  final TextEditingController modelController = TextEditingController();
  final TextEditingController minYearController = TextEditingController();
  final TextEditingController maxYearController = TextEditingController();
  final TextEditingController minPriceController  = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  Models? _selectedModel;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
            'Buy / Rent Car',
            style: TextStyle(
              color: Colors.white
            ),
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
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
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
                  print('Search button pressed');
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
                  'Search',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

            ],
          ),
      ),
    );
  }


}
