import 'package:flutter/material.dart';
import '../viewmodels/media_viewmodel.dart'; // Import ViewModel

class MediaControls extends StatelessWidget {
  // SỬA: Đổi kiểu dữ liệu từ MediaController sang MediaViewModel
  final MediaViewModel controller; 
  final bool isFull;

  const MediaControls({
    super.key,
    required this.controller,
    this.isFull = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isFull)
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white70),
            onPressed: () {},
          ),
        
        // Nút Previous
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 30),
          onPressed: controller.previousSong, // Gọi hàm từ ViewModel
        ),

        // Nút Play/Pause
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(
              controller.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: controller.togglePlay,
          ),
        ),

        // Nút Next
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 30),
          onPressed: controller.nextSong,
        ),

        if (!isFull)
           IconButton(
            icon: const Icon(Icons.menu, color: Colors.white70),
            onPressed: () {},
          ),
      ],
    );
  }
}