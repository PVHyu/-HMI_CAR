import 'dart:async';
import 'package:flutter/material.dart';
import '../models/song.dart';
import '../../home_app/services/media_data_service.dart';

class MediaController extends ChangeNotifier {
  // --- STATE CƠ BẢN ---
  List<Song> playlist = [];
  int currentIndex = 0;
  bool isPlaying = false;
  bool isFullScreen = false;
  Duration currentPosition = Duration.zero;
  Timer? _timer;
  bool isLoading = true; // Trạng thái đang tải dữ liệu

  // --- STATE MỚI: REPEAT ---
  bool isRepeatOne = false; // Trạng thái lặp lại 1 bài

  // Getter an toàn để tránh lỗi khi list rỗng
  Song get currentSong {
    if (playlist.isEmpty) {
      return const Song(
          id: '0',
          title: 'Đang tải...',
          artist: '',
          color: Colors.grey,
          duration: Duration.zero);
    }
    return playlist[currentIndex];
  }

  // Constructor
  MediaController() {
    _initData();
  }

  // Hàm khởi tạo dữ liệu (Async)
  Future<void> _initData() async {
    isLoading = true;
    notifyListeners();

    // Gọi Service để lấy dữ liệu từ JSON
    // Đảm bảo bạn đã tạo file MediaDataService như hướng dẫn trước
    playlist = await MediaDataService.loadSongs();

    isLoading = false;
    notifyListeners();
  }

  // --- CÁC HÀNH ĐỘNG (ACTIONS) ---

  void toggleViewMode() {
    isFullScreen = !isFullScreen;
    notifyListeners();
  }

  // Hàm bật/tắt chế độ lặp lại (MỚI)
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
        // Hết bài thì gọi hàm nextSong
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

  // Cập nhật logic Next Song để xử lý Repeat (ĐÃ SỬA)
  void nextSong() {
    if (playlist.isEmpty) return;

    // 1. Nếu đang bật chế độ lặp 1 bài -> Replay bài hiện tại
    if (isRepeatOne) {
      currentPosition = Duration.zero;
      if (isPlaying) _play(); // Đảm bảo timer chạy lại từ đầu
      notifyListeners();
      return; // Kết thúc hàm, không chuyển index
    }

    // 2. Logic cũ: Chuyển sang bài tiếp theo (Vòng tròn)
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

  void seekTo(double seconds) {
    currentPosition = Duration(seconds: seconds.toInt());
    notifyListeners();
  }

  void playSongAtIndex(int index) {
    currentIndex = index;
    currentPosition = Duration.zero;
    _play();
    notifyListeners();
  }
}
