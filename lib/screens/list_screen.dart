import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/food_center_card.dart';
import '../widgets/filter_chips.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search food centers...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              Provider.of<FoodProvider>(context, listen: false).searchCenters(value);
            },
          ),
        ),
        const FilterChips(),
        Expanded(
          child: Consumer2<FoodProvider, LocationProvider>(
            builder: (context, foodProvider, locationProvider, child) {
              if (foodProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final centers = locationProvider.currentPosition != null
                  ? foodProvider.getNearbyFoodCenters(
                      locationProvider.currentPosition!.latitude,
                      locationProvider.currentPosition!.longitude,
                      50, // 50 km radius
                    )
                  : foodProvider.foodCenters;

              if (centers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No food centers found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: centers.length,
                itemBuilder: (context, index) {
                  final center = centers[index];
                  final distance = locationProvider.currentPosition != null
                      ? _calculateDistance(
                          locationProvider.currentPosition!.latitude,
                          locationProvider.currentPosition!.longitude,
                          center.latitude,
                          center.longitude,
                        )
                      : null;
                  return FoodCenterCard(
                    center: center,
                    distance: distance,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
