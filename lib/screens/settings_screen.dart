import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Theme Mode'),
                  const SizedBox(height: 8),
                  DropdownButton<ThemeMode>(
                    value: themeProvider.themeMode,
                    onChanged: (ThemeMode? newValue) {
                      if (newValue != null) {
                        themeProvider.setThemeMode(newValue);
                      }
                    },
                    items:
                        ThemeMode.values.map((ThemeMode mode) {
                          return DropdownMenuItem<ThemeMode>(
                            value: mode,
                            child: Text(mode.toString().split('.')[1]),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
