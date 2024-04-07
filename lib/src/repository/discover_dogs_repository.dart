import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task/model/dog.dart';
import 'package:http/http.dart' as http;

class DiscoverDogsRepository {
  Future<List<Dog>> getRandomDogs() async {
    try {
      final String apiKey = dotenv.env['API_KEY'] ?? "";
      final response = await http.get(Uri.parse('https://api.thedogapi.com/v1/images/search?limit=10&api_key=$apiKey'));
      if (response.statusCode == 200) {
        final body = response.body;
        final dogs = (jsonDecode(body) as List).map((data) => Dog.fromJson(jsonEncode(data))).toList();
        return dogs;
      } else {
        throw Exception('Failed to load dogs');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
