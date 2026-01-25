import 'package:flutter/material.dart';
import '../../media_app/viewmodels/media_viewmodel.dart';

class MediaCard extends StatelessWidget {
  final MediaViewModel viewModel = MediaViewModel();
  
  final VoidCallback? onTap;

  MediaCard({super.key, this.onTap});

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

 @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final song = viewModel.currentSong;

        return GestureDetector(
          onTap: onTap,
          child: Container(                     
            padding: const EdgeInsets.all(20),
            
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20), 
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                
                Container(
                 width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: song.color,
                    borderRadius: BorderRadius.circular(20), 
                    boxShadow: [
                      BoxShadow(
                        color: song.color.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.music_note, color: Colors.white, size: 60)
                  ),
                ),

                const SizedBox(height: 15), 

                Text(
                  song.title,
                  textAlign: TextAlign.center, 
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 5),
                
                Text(
                  song.artist,
                  textAlign: TextAlign.center, 
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const Spacer(),

                Row(
                  children: [
                    Text(
                      _formatDuration(viewModel.currentPosition.inSeconds),
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: viewModel.currentPosition.inSeconds
                              .toDouble()
                              .clamp(0.0, viewModel.totalDuration),
                          max: viewModel.totalDuration > 0 ? viewModel.totalDuration : 1.0,
                          activeColor: Colors.cyanAccent,
                          inactiveColor: Colors.white24,
                          onChanged: (v) => viewModel.seek(v),
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(viewModel.totalDuration.toInt()),
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      iconSize: 35,
                      onPressed: viewModel.prevSong,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.cyanAccent.withOpacity(0.2),
                      ),
                      child: IconButton(
                        icon: Icon(
                          viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.cyanAccent,
                        ),
                        iconSize: 45,
                        onPressed: viewModel.togglePlay,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      iconSize: 35,
                      onPressed: viewModel.nextSong,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}