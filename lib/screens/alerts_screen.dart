import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAlertCard(
          context,
          'Emergency Food Distribution',
          'Free meals available at Community Center, 2km away',
          Icons.warning_amber,
          Colors.orange,
          '2 hours ago',
        ),
        _buildAlertCard(
          context,
          'New Food Bank Opened',
          'Amma Canteen now open in your area',
          Icons.info,
          Colors.blue,
          '1 day ago',
        ),
        _buildAlertCard(
          context,
          'Disaster Relief',
          'NGO distributing food packets at Relief Camp',
          Icons.emergency,
          Colors.red,
          '3 days ago',
        ),
      ],
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    String title,
    String message,
    IconData icon,
    Color color,
    String time,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
