import 'dart:ui';

class Song {
  final String id;
  final String title;
  final String artist;
  final Color color;
  final Duration duration;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.color,
    required this.duration,
  });

  // Factory tạo từ JSON
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      // Chuyển chuỗi hex "0xFF..." thành số nguyên rồi thành Color
      color: Color(int.parse(json['color'])),
      // JSON lưu giây (int), chuyển thành Duration
      duration: Duration(seconds: json['duration'] as int),
    );
  }
}
