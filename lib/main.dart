import 'package:flutter/material.dart';
import 'package:tabetect/styles/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabetect',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.system, // Automatically switches based on system setting
      home: Scaffold(
        appBar: AppBar(title: const Text('Tabetect')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Press Me'),
          ),
        ),
      ),
    );
  }
}
