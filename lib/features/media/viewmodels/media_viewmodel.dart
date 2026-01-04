import 'dart:async';
import 'package:flutter/material.dart';
import '../models/song.dart';
import 'package:hmi/services/media_data_service.dart'; 

class MediaViewModel extends ChangeNotifier {
  // --- SINGLETON PATTERN (Thêm đoạn này để đồng bộ hóa) ---
  static final MediaViewModel _instance = MediaViewModel._internal();

  factory MediaViewModel() {
    return _instance;
  }

  MediaViewModel._internal() {
    // Chỉ khởi tạo dữ liệu 1 lần duy nhất khi app chạy
    _initData();
  }
  // --------------------------------------------------------

  // --- STATE ---
  List<Song> playlist = [];
  int currentIndex = 0;
  bool isPlaying = false;
  bool isFullScreen = false;
  Duration currentPosition = Duration.zero;
  Timer? _timer;
  bool isLoading = true; 
  bool isRepeatOne = false;

  // --- GETTERS ---
  List<Song> get songs => playlist; 
  
  double get totalDuration => currentSong.duration.inSeconds.toDouble();

  Song get currentSong {
    if (playlist.isEmpty) {
      return const Song(
          id: '0',
          title: 'Đang tải...',
          artist: '',
          color: Colors.grey,
          duration: Duration.zero);
    }
    if (currentIndex >= playlist.length) return playlist[0];
    return playlist[currentIndex];
  }

  // --- INIT DATA ---
  Future<void> _initData() async {
    isLoading = true;
    notifyListeners();

    try {
      playlist = await MediaDataService.loadSongs();
    } catch (e) {
      print("Lỗi tải nhạc: $e");
      playlist = [
        const Song(id: "1", title: "Lỗi tải dữ liệu", artist: "Kiểm tra Service", duration: Duration(minutes: 1), color: Colors.red),
      ];
    }

    isLoading = false;
    notifyListeners();
  }

  // --- LOGIC ---

  void toggleViewMode() {
    isFullScreen = !isFullScreen;
    notifyListeners();
  }

  void toggleRepeat() {
    isRepeatOne = !isRepeatOne;
    notifyListeners();
  }

  void togglePlay() {
    if (playlist.isEmpty) return;
    if (isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  void _play() {
    isPlaying = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentPosition < currentSong.duration) {
        currentPosition += const Duration(seconds: 1);
        notifyListeners();
      } else {
        nextSong();
      }
    });
    notifyListeners();
  }

  void _pause() {
    isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }

  void nextSong() {
    if (playlist.isEmpty) return;

    if (isRepeatOne) {
      currentPosition = Duration.zero;
      if (isPlaying) _play(); 
      notifyListeners();
      return; 
    }

    currentIndex = (currentIndex + 1) % playlist.length;
    currentPosition = Duration.zero;
    if (isPlaying) _play();
    notifyListeners();
  }

  void previousSong() {
    if (playlist.isEmpty) return;
    currentIndex = currentIndex > 0 ? currentIndex - 1 : playlist.length - 1;
    currentPosition = Duration.zero;
    if (isPlaying) _play();
    notifyListeners();
  }
  
  // Alias
  void prevSong() => previousSong();

  void seekTo(double seconds) {
    currentPosition = Duration(seconds: seconds.toInt());
    notifyListeners();
  }
  
  // Alias
  void seek(double seconds) => seekTo(seconds);

  void playSongAtIndex(int index) {
    currentIndex = index;
    currentPosition = Duration.zero;
    _play();
    notifyListeners();
  }
  
  @override
  void dispose() {
    // Lưu ý: Với Singleton, ta thường không dispose timer trừ khi tắt hẳn app
    // Nhưng cứ giữ để đảm bảo clean code
    _timer?.cancel();
    super.dispose();
  }
}