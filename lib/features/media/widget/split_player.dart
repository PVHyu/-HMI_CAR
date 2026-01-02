import 'package:flutter/material.dart';
import '../../media/logic/media_controller.dart';
import '../../../core/utils/format_time.dart';
import 'media_controls.dart';
import 'rotating_vinyl.dart';

class SplitPlayer extends StatelessWidget {
  final MediaController controller;
  const SplitPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final song = controller.currentSong;

    return Row(
      children: [
        // CỘT TRÁI: Player
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    song.color.withOpacity(0.6),
                    Colors.black.withOpacity(0.8)
                  ],
                )),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- KHU VỰC ĐĨA QUAY ---
                  Expanded(
                    child: Center(
                      child: RotatingVinyl(
                        albumColor: song.color,
                        isPlaying: controller.isPlaying,
                        size: 250,
                      ),
                    ),
                  ),
                  // ------------------------

                  // Thông tin và điều khiển phía dưới
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(song.artist,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white70)),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text(
                              TimeUtils.formatDuration(
                                  controller.currentPosition),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8)),
                              child: Slider(
                                value: controller.currentPosition.inSeconds
                                    .toDouble()
                                    .clamp(
                                        0, song.duration.inSeconds.toDouble()),
                                max: song.duration.inSeconds.toDouble(),
                                activeColor: Colors.white,
                                inactiveColor: Colors.white24,
                                onChanged: controller.seekTo,
                              ),
                            ),
                          ),
                          Text(TimeUtils.formatDuration(song.duration),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // --- PHẦN CHỈNH SỬA TẠI ĐÂY ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 1. Nút Repeat (Góc trái)
                          IconButton(
                            icon: Icon(
                              controller.isRepeatOne
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              color: controller.isRepeatOne
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                            onPressed: controller.toggleRepeat,
                          ),

                          // 2. Cụm điều khiển (Giữa)
                          // Mẹo: Đặt isFull: true để widget này tự ẩn các nút 2 bên (Shuffle/Expand) cũ đi
                          // giúp ta tránh bị trùng lặp nút.
                          MediaControls(controller: controller, isFull: true),

                          // 3. Nút Fullscreen (Góc phải)
                          IconButton(
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white),
                              onPressed: controller.toggleViewMode),
                        ],
                      )
                      // ------------------------------
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

        // CỘT PHẢI: Playlist (Giữ nguyên)
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFF1E232E),
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(25),
                  child: Row(children: [
                    Icon(Icons.queue_music_rounded, color: Colors.cyanAccent),
                    SizedBox(width: 15),
                    Text("Danh sách phát",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ]),
                ),
                const Divider(height: 1, color: Colors.white12),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: controller.playlist.length,
                    separatorBuilder: (ctx, i) => const Divider(
                        height: 1,
                        color: Colors.white10,
                        indent: 20,
                        endIndent: 20),
                    itemBuilder: (ctx, i) {
                      final item = controller.playlist[i];
                      final isSelected = i == controller.currentIndex;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.music_note_rounded,
                                color: Colors.white)),
                        title: Text(item.title,
                            maxLines: 1,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.cyanAccent
                                    : Colors.white,
                                fontSize: 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        subtitle: Text(item.artist,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14)),
                        trailing: isSelected
                            ? const Icon(Icons.graphic_eq,
                                color: Colors.cyanAccent)
                            : null,
                        onTap: () => controller.playSongAtIndex(i),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
