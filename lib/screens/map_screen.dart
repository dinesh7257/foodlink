import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Consumer2<FoodProvider, LocationProvider>(
      builder: (context, foodProvider, locationProvider, child) {
        final position = locationProvider.currentPosition;
        final initialPosition = position != null
            ? LatLng(position.latitude, position.longitude)
            : const LatLng(13.0827, 80.2707); // Default: Chennai

        _updateMarkers(foodProvider.foodCenters, position);

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 12,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
          },
        );
      },
    );
  }

  void _updateMarkers(List centers, position) {
    _markers = centers.map((center) {
      return Marker(
        markerId: MarkerId(center.id),
        position: LatLng(center.latitude, center.longitude),
        infoWindow: InfoWindow(
          title: center.name,
          snippet: center.type,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          center.isAvailable ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();
  }
}
