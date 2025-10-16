import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';
import 'services/shared_preferences_service.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigurationData>(
      create: (context) => ConfigurationData(SharedPreferencesService()),
      child: MaterialApp(
        title: '2023479046',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const MyHomePage(title: '2023479046'),
      ),
    );
  }
}
