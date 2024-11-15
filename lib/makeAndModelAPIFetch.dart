import 'dart:convert';
import 'package:http/http.dart' as http;

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