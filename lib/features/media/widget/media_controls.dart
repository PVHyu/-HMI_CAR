import 'package:flutter/material.dart';
import '../logic/media_controller.dart';

class MediaControls extends StatelessWidget {
  final MediaController controller;
  final bool isFull;

  const MediaControls(
      {super.key, required this.controller, required this.isFull});

  @override
  Widget build(BuildContext context) {
    // Kích thước icon tùy chỉnh theo chế độ
    double iconSize = isFull ? 45 : 35;
    double playSize = isFull ? 70 : 60;

    return Row(
      // Nếu Full: Căn giữa. Nếu Mini: Căn đều 2 bên
      mainAxisAlignment:
          isFull ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        // Các nút phụ cho Mini Player (Shuffle)
        if (!isFull)
          IconButton(
              icon: const Icon(Icons.shuffle, color: Colors.white70),
              onPressed: () {}),

        // 1. Nút Previous
        IconButton(
            icon:
                Icon(Icons.skip_previous, size: iconSize, color: Colors.white),
            onPressed: controller.previousSong),

        const SizedBox(width: 10),

        // 2. Nút Play/Pause
        GestureDetector(
          onTap: controller.togglePlay,
          child: Icon(
              controller.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: playSize,
              color: Colors.white),
        ),

        const SizedBox(width: 10),

        // 3. Nút Next
        IconButton(
            icon: Icon(Icons.skip_next, size: iconSize, color: Colors.white),
            onPressed: controller.nextSong),

        if (!isFull)
          IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: controller.toggleViewMode),
      ],
    );
  }
}
