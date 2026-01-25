import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import file màn hình chính (nằm cùng thư mục lib/)

void main() {
  runApp(const CarHMIApp());
}

class CarHMIApp extends StatelessWidget {
  const CarHMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt chữ Debug
      title: 'Car HMI System',
      
      // Cấu hình giao diện tối (Dark Mode)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      // Chạy màn hình chính (chứa Map, Phone, Media)
      home: const MainScreen(),
    );
  }
}