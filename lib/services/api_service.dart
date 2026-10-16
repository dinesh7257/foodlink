import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_center.dart';

class ApiService {
  static final ApiService instance = ApiService._init();
  ApiService._init();

  // Replace with your actual API endpoint
  static const String baseUrl = 'https://your-api-endpoint.com/api';

  Future<List<FoodCenter>> fetchFoodCenters() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/food-centers'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => FoodCenter.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> reportFoodCenter(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/report-center'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
