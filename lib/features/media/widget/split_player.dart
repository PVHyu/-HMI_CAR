import 'package:flutter/material.dart';
import '../viewmodels/media_viewmodel.dart';// Đảm bảo tên file viết thường (snake_case)
import '../../../core/utils/format_time.dart';
import 'media_controls.dart';
import 'rotating_vinyl.dart';

class SplitPlayer extends StatelessWidget {
  final MediaViewModel viewModel;
  
  const SplitPlayer({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final song = viewModel.currentSong;

    return Row(
      children: [
        // CỘT TRÁI: Player
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    song.color.withOpacity(0.5),
                    Colors.black.withOpacity(0.5)
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
                        isPlaying: viewModel.isPlaying,
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

                      // --- SLIDER (THANH TRƯỢT) ---
                      Row(
                        children: [
                          Text(
                              TimeUtils.formatDuration(
                                  viewModel.currentPosition),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8)),
                              child: Slider(
                                max: song.duration.inSeconds > 0
                                    ? song.duration.inSeconds.toDouble()
                                    : 1.0,
                                value: viewModel.currentPosition.inSeconds
                                    .toDouble()
                                    .clamp(
                                        0,
                                        song.duration.inSeconds > 0
                                            ? song.duration.inSeconds.toDouble()
                                            : 1.0),
                                activeColor: Colors.white,
                                inactiveColor: Colors.white24,
                                onChanged: viewModel.seekTo,
                              ),
                            ),
                          ),
                          Text(TimeUtils.formatDuration(song.duration),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // --- CONTROLS ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 1. Nút Repeat (Góc trái)
                          IconButton(
                            icon: Icon(
                              viewModel.isRepeatOne
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              color: viewModel.isRepeatOne
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                            onPressed: viewModel.toggleRepeat,
                          ),

                          // 2. Cụm điều khiển (Giữa)
                          // SỬA 3: Đổi 'viewModel: viewModel' thành 'controller: viewModel' 
                          // (Để khớp với định nghĩa MediaControls bạn dùng bên FullPlayer)
                          MediaControls(controller: viewModel, isFull: true),

                          // 3. Nút Fullscreen (Góc phải)
                          IconButton(
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white),
                              onPressed: viewModel.toggleViewMode),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

        // CỘT PHẢI: Playlist
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
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
                    itemCount: viewModel.playlist.length,
                    separatorBuilder: (ctx, i) => const Divider(
                        height: 1,
                        color: Colors.white10,
                        indent: 20,
                        endIndent: 20),
                    itemBuilder: (ctx, i) {
                      final item = viewModel.playlist[i];
                      final isSelected = i == viewModel.currentIndex;
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
                        onTap: () => viewModel.playSongAtIndex(i),
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