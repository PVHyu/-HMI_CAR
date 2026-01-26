import 'package:flutter/material.dart';
import 'package:hmi/features/main_screen.dart';

class CarHMIApp extends StatelessWidget {
  const CarHMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false),
      home: const MainScreen(),
    );
  }
}
