import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Container đơn giản chứa ảnh
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(20),
        // Ảnh bản đồ nền
        image: const DecorationImage(
          image: NetworkImage(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDKOdw0tSGoRtym6g54fg4ReBCTI7VS3EG5A&s"),
          fit: BoxFit.cover,
          opacity: 1, // Tăng độ rõ lên một chút cho đẹp
        ),
        border: Border.all(color: Colors.white10),
      ),
    );
  }
}
