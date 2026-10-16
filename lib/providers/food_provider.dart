import 'package:flutter/material.dart';
import '../models/food_center.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';

class FoodProvider with ChangeNotifier {
  List<FoodCenter> _foodCenters = [];
  List<FoodCenter> _filteredCenters = [];
  bool _isLoading = false;
  String _selectedType = 'All';

  List<FoodCenter> get foodCenters => _filteredCenters;
  bool get isLoading => _isLoading;
  String get selectedType => _selectedType;

  Future<void> loadFoodCenters() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to fetch from API
      final apiCenters = await ApiService.instance.fetchFoodCenters();
      if (apiCenters.isNotEmpty) {
        // Save to local database
        for (var center in apiCenters) {
          await DatabaseService.instance.insertFoodCenter(center);
        }
        _foodCenters = apiCenters;
      }
    } catch (e) {
      // Fallback to local database
      _foodCenters = await DatabaseService.instance.getAllFoodCenters();
    }

    _filteredCenters = _foodCenters;
    _isLoading = false;
    notifyListeners();
  }

  void filterByType(String type) {
    _selectedType = type;
    if (type == 'All') {
      _filteredCenters = _foodCenters;
    } else {
      _filteredCenters = _foodCenters.where((c) => c.type == type).toList();
    }
    notifyListeners();
  }

  void searchCenters(String query) {
    if (query.isEmpty) {
      _filteredCenters = _foodCenters;
    } else {
      _filteredCenters = _foodCenters.where((center) {
        return center.name.toLowerCase().contains(query.toLowerCase()) ||
               center.address.toLowerCase().contains(query.toLowerCase()) ||
               center.type.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  List<FoodCenter> getNearbyFoodCenters(double userLat, double userLon, double radiusKm) {
    return _foodCenters.where((center) {
      final distance = _calculateDistance(userLat, userLon, center.latitude, center.longitude);
      return distance <= radiusKm;
    }).toList()
      ..sort((a, b) {
        final distA = _calculateDistance(userLat, userLon, a.latitude, a.longitude);
        final distB = _calculateDistance(userLat, userLon, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = (dLat / 2).sin() * (dLat / 2).sin() +
        _toRadians(lat1).cos() * _toRadians(lat2).cos() *
        (dLon / 2).sin() * (dLon / 2).sin();
    final c = 2 * (a.sqrt()).asin();
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * 3.141592653589793 / 180;
  }
}
