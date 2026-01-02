import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MediaCard extends StatefulWidget {
  final VoidCallback onTap;
  const MediaCard({super.key, required this.onTap});

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  List<Map<String, dynamic>> _songs = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMediaData();
  }

  Future<void> _loadMediaData() async {
    final jsonString =
        await rootBundle.loadString('assets/media_mock_data.json');
    final decoded = json.decode(jsonString);

    setState(() {
      _songs = List<Map<String, dynamic>>.from(decoded['songs']);
      _isLoading = false;
    });
  }

  void _nextSong() {
    if (_songs.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
      _isPlaying = true;
    });
  }

  void _prevSong() {
    if (_songs.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
      _isPlaying = true;
    });
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex));
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loadingCard();

    final song = _songs[_currentIndex];
    final bgColor = _parseColor(song['color']);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor.withOpacity(0.9),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP ICON
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.graphic_eq, color: Colors.white70, size: 24),
              ),

              const Spacer(),

              // TITLE
              Text(
                song['title'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // ARTIST
              Text(
                song['artist'],
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const SizedBox(height: 8),

              // DURATION
              Text(
                _formatDuration(song['duration']),
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),

              const SizedBox(height: 16),

              // CONTROLS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: _prevSong,
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 32),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.25),
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextSong,
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 32),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[900],
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
