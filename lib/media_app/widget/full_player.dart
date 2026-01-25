import 'package:flutter/material.dart';
import 'dart:ui'; // Cần cho BackdropFilter, ImageFilter
import '../viewmodels/media_viewmodel.dart';
import '../../home_app/core/utils/format_time.dart';
import 'media_controls.dart';
import 'rotating_vinyl.dart';

class FullPlayer extends StatelessWidget {
  final MediaViewModel viewModel;

  const FullPlayer({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final song = viewModel.currentSong;

    return Scaffold(
      backgroundColor: Colors.transparent, // Để nền trong suốt để thấy background phía sau
      body: Stack(
        children: [
          // --- LỚP 1: HÌNH NỀN GRADIENT VÀ BLUR (HIỆU ỨNG KÍNH MÀU) ---
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Tăng độ mờ lên một chút cho ảo
                child: Container(
                  // SỬA: Dùng LinearGradient thay vì màu đen đơn thuần
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        // Dùng màu bài hát và đen mờ giống như bên SplitPlayer
                        song.color.withOpacity(0.6), 
                        Colors.black.withOpacity(0.8), 
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- LỚP 2: NỘI DUNG CHÍNH (Không đổi) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                const Spacer(), // Đẩy đĩa xuống giữa

                // --- ĐĨA QUAY ---
                Center(
                  child: RotatingVinyl(
                    albumColor: song.color,
                    isPlaying: viewModel.isPlaying, 
                    size: 250, // Tăng kích thước đĩa lên một chút cho chế độ full
                  ),
                ),
                // ----------------

                const Spacer(), // Đẩy thông tin xuống dưới

                // --- THÔNG TIN BÀI HÁT ---
                Text(
                  song.title,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  song.artist,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // --- SLIDER (THANH TRƯỢT) ---
                Row(
                  children: [
                    Text(
                      TimeUtils.formatDuration(viewModel.currentPosition),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Expanded(
                      child: Slider(
                        max: song.duration.inSeconds > 0
                            ? song.duration.inSeconds.toDouble()
                            : 1.0,
                        value: viewModel.currentPosition.inSeconds
                            .toDouble()
                            .clamp(0, song.duration.inSeconds > 0 
                                ? song.duration.inSeconds.toDouble() 
                                : 1.0),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                        onChanged: viewModel.seekTo, 
                      ),
                    ),
                    Text(
                      TimeUtils.formatDuration(song.duration),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // --- CÁC NÚT ĐIỀU KHIỂN ---
                Row(
                  children: [
                    // 1. Nút Repeat (Trái)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            viewModel.isRepeatOne 
                                ? Icons.repeat_one
                                : Icons.repeat,
                            color: viewModel.isRepeatOne
                                ? Colors.white
                                : Colors.white70,
                          ),
                          onPressed: () {
                            viewModel.toggleRepeat(); 
                          },
                        ),
                      ),
                    ),

                    // 2. Media Controls (Giữa)
                    MediaControls(controller: viewModel, isFull: true),

                    // 3. Nút Exit Fullscreen (Phải)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.fullscreen_exit,
                              color: Colors.white, size: 35),
                          onPressed: viewModel.toggleViewMode, 
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}