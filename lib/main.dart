import 'package:flutter/material.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const BadmintonAiApp());
}

class BadmintonAiApp extends StatelessWidget {
  const BadmintonAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        // Global font styling can be added here
      ),
      home: const MainLayout(),
    );
  }
}
