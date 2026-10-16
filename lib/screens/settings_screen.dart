import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildLanguageSelector(context),
        const Divider(height: 32),
        _buildSettingTile(
          'Notifications',
          'Manage alert preferences',
          Icons.notifications,
          () {},
        ),
        _buildSettingTile(
          'Offline Mode',
          'Download data for offline use',
          Icons.cloud_download,
          () {},
        ),
        _buildSettingTile(
          'Voice Settings',
          'Configure voice commands',
          Icons.mic,
          () {},
        ),
        _buildSettingTile(
          'Report Food Center',
          'Add or update food locations',
          Icons.add_location,
          () {},
        ),
        _buildSettingTile(
          'About',
          'App version and information',
          Icons.info,
          () {},
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.language, color: Colors.green),
                    const SizedBox(width: 12),
                    const Text(
                      'Language',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: languageProvider.languages.entries.map((entry) {
                    final isSelected = languageProvider.currentLocale.languageCode == entry.key;
                    return ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          languageProvider.changeLanguage(entry.key);
                        }
                      },
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
