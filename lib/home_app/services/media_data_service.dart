import 'dart:convert';
import 'package:flutter/services.dart';
import '../../media_app/models/song.dart';

class MediaDataService {
  // Hàm đọc file JSON
  static Future<Map<String, dynamic>> _loadJson() async {
    final String response =
        await rootBundle.loadString('assets/media_mock_data.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  // Hàm public để lấy danh sách bài hát
  static Future<List<Song>> loadSongs() async {
    try {
      final data = await _loadJson();
      final songsJson = data['songs'] as List;

      return songsJson.map((json) => Song.fromJson(json)).toList();
    } catch (e) {
      // Nếu lỗi (ví dụ file chưa load xong), trả về list rỗng hoặc print lỗi
      // print("Lỗi load nhạc: $e");
      return [];
    }
  }
}
