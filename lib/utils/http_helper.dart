import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:purrinterest/models/cat.dart';

//This class will handle the HTTP requests
class HttpHelper{
  final String breedsUrl = 'https://api.thecatapi.com/v1/breeds';
  final String randomImageUrl = 'https://api.thecatapi.com/v1/images/search';

  //This method will fetch the list of cats from the API
  Future<List<Cat>> getCats() async {
    final http.Response result = await http.get(Uri.parse(breedsUrl));
    if (result.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonResponse = json.decode(result.body);
      final List<Cat> cats = jsonResponse.map((json) => Cat.fromJson(json)).toList();
      return cats;
    } else {
      throw Exception('Failure to load cats: ${result.statusCode}');
    }
  }

  //This method will fetch a random cat image from the API
  Future<String> getRandomCatImage() async {
    final http.Response result = await http.get(Uri.parse(randomImageUrl));
    if (result.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonResponse = json.decode(result.body);
      return jsonResponse[0]['url'];
    } else {
      throw Exception('Failure to load cat image: ${result.statusCode}');
    }
  }
}