import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tabetect/data/model/food_response.dart';

class ApiService {
  static const String _baseUrl = "www.themealdb.com";
  static const String _path = "/api/json/v1/1/search.php";

  Future<FoodResponse> getFoodDetail(String name) async {
    final uri = Uri.https(_baseUrl, _path, {"s": name.trim()});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return FoodResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load food details from API");
    }
  }
}
