import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/food_center.dart';
import '../screens/food_center_detail_screen.dart';

class FoodCenterCard extends StatelessWidget {
  final FoodCenter center;
  final double? distance;

  const FoodCenterCard({
    Key? key,
    required this.center,
    this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FoodCenterDetailScreen(center: center),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          center.type,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (center.isVerified)
                    const Icon(Icons.verified, color: Colors.blue, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      center.address,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              if (distance != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.directions_walk, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${distance!.toStringAsFixed(1)} km away',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
              if (center.operatingHours != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      center.operatingHours!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatusChip(),
                  const Spacer(),
                  if (center.phone != null)
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () => _makePhoneCall(center.phone!),
                    ),
                  IconButton(
                    icon: const Icon(Icons.directions, color: Colors.blue),
                    onPressed: () => _openMaps(center.latitude, center.longitude),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (center.type.toLowerCase()) {
      case 'government canteen':
        icon = Icons.restaurant;
        color = Colors.orange;
        break;
      case 'ngo':
        icon = Icons.volunteer_activism;
        color = Colors.purple;
        break;
      case 'community kitchen':
        icon = Icons.soup_kitchen;
        color = Colors.green;
        break;
      case 'religious institution':
        icon = Icons.temple_hindu;
        color = Colors.blue;
        break;
      case 'food bank':
        icon = Icons.store;
        color = Colors.red;
        break;
      default:
        icon = Icons.fastfood;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: center.isAvailable ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        center.isAvailable ? 'Available' : 'Unavailable',
        style: TextStyle(
          color: center.isAvailable ? Colors.green[700] : Colors.red[700],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openMaps(double lat, double lon) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
