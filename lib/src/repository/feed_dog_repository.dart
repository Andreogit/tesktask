import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task/model/dog.dart';
import 'package:http/http.dart' as http;

class FeedDogRepository {
  Future<Dog> getRandomDog() async {
    try {
      final String apiKey = dotenv.env['API_KEY'] ?? "";
      final response = await http.get(Uri.parse('https://api.thedogapi.com/v1/images/search?api_key=$apiKey'));
      if (response.statusCode == 200) {
        final body = response.body;
        final Dog dog = Dog.fromJson(jsonEncode((jsonDecode(body) as List)[0]));
        return dog;
      } else {
        throw Exception('Failed to load dogs');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
