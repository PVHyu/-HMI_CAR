import 'package:flutter/material.dart';
import 'dart:ui';
import '../../media/logic/media_controller.dart';
import '../../../core/utils/format_time.dart';
import 'media_controls.dart';
import 'rotating_vinyl.dart'; // <-- IMPORT FILE MỚI TẠO

class FullPlayer extends StatelessWidget {
  final MediaController controller;
  const FullPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final song = controller.currentSong;

    return Stack(
      children: [
        // 1. Nền màu và Blur
        Positioned.fill(child: Container(color: song.color)),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ),

        // 2. Nội dung chính
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            children: [
              const Spacer(), // Đẩy đĩa xuống giữa

              // --- KHU VỰC ĐĨA QUAY ---
              Center(
                child: RotatingVinyl(
                  albumColor: song.color,
                  isPlaying: controller.isPlaying,
                  size: 220, // Kích thước lớn cho chế độ Full
                ),
              ),
              // ------------------------

              const Spacer(), // Đẩy thông tin xuống dưới

              // Thông tin bài hát
              Text(song.title,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text(song.artist,
                  style: const TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 30),

              // Slider và Controls
              Row(
                children: [
                  Text(TimeUtils.formatDuration(controller.currentPosition),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: controller.currentPosition.inSeconds
                          .toDouble()
                          .clamp(0, song.duration.inSeconds.toDouble()),
                      max: song.duration.inSeconds.toDouble(),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      onChanged: controller.seekTo,
                    ),
                  ),
                  Text(TimeUtils.formatDuration(song.duration),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),

              // --- PHẦN CHỈNH SỬA: REPEAT TRÁI - CONTROLS GIỮA - EXIT PHẢI ---
              Row(
                children: [
                  // 1. Cụm bên TRÁI: Nút Repeat
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, // Căn sát lề trái
                      child: IconButton(
                        // Nếu isRepeatOne là true thì hiện icon số 1, ngược lại hiện icon thường
                        icon: Icon(
                          controller.isRepeatOne
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: controller.isRepeatOne
                              ? Colors.white
                              : Colors.white70, // Sáng lên khi bật
                        ),
                        onPressed: () {
                          controller.toggleRepeat(); // <--- Gọi hàm này
                        },
                      ),
                    ),
                  ),
                  // 2. Cụm GIỮA: Media Controls
                  // Play/Pause/Next/Prev sẽ luôn ở chính giữa màn hình
                  MediaControls(controller: controller, isFull: true),

                  // 3. Cụm bên PHẢI: Nút Exit Fullscreen
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight, // Căn sát lề phải
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen_exit,
                            color: Colors.white, size: 35),
                        onPressed: controller.toggleViewMode,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
