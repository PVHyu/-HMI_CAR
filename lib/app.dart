import 'package:flutter/material.dart';
import 'main_screen.dart';

class CarHMIApp extends StatelessWidget {
  const CarHMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car HMI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white24,
          thumbColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
