import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class AddressSearchService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  /// Tìm kiếm địa chỉ đơn lẻ (Trả về tọa độ đầu tiên)
  static Future<LatLng?> searchAddress(String address) async {
    if (address.trim().isEmpty) return null;

    try {
      // Logic: Nếu chưa có chữ "Đà Nẵng" thì thêm vào để tìm ưu tiên ở ĐN
      final query = address.toLowerCase().contains('đà nẵng') 
          ? address 
          : '$address, Đà Nẵng, Việt Nam';

      final url = Uri.parse(
        '$_baseUrl/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&limit=1'
        '&addressdetails=1'
        '&countrycodes=vn', // Giới hạn tìm trong VN
      );

      print('🔍 Searching address: $query');

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'CarNavigationApp/1.0', 
          'Accept-Language': 'vi-VN,vi;q=0.9,en;q=0.8', // Ưu tiên tiếng Việt
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Search timeout');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        
        if (results.isNotEmpty) {
          final result = results[0];
          final lat = double.parse(result['lat']);
          final lon = double.parse(result['lon']);
          
          print('✅ Found: ${result['display_name']}');
          print('   Lat: $lat, Lon: $lon');
          
          return LatLng(lat, lon);
        } else {
          print('❌ No results found for: $query');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Search Error: $e');
      return null;
    }
  }

  /// Tìm kiếm nhiều kết quả (Gợi ý/Autocomplete)
  static Future<List<SearchResult>> searchMultiple(String address) async {
    if (address.trim().isEmpty) return [];

    try {
      final query = address.toLowerCase().contains('đà nẵng') 
          ? address 
          : '$address, Đà Nẵng, Việt Nam';

      final url = Uri.parse(
        '$_baseUrl/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&limit=5'
        '&addressdetails=1'
        '&countrycodes=vn',
      );

      final response = await http.get(
        url,
        headers: {
            'User-Agent': 'CarNavigationApp/1.0',
            'Accept-Language': 'vi-VN,vi;q=0.9',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        
        return results.map((json) => SearchResult(
          displayName: json['display_name'] ?? '',
          lat: double.parse(json['lat']),
          lon: double.parse(json['lon']),
          type: json['type'] ?? '',
          importance: (json['importance'] ?? 0.0).toDouble(),
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  /// Reverse geocoding: Tọa độ → Tên địa chỉ
  static Future<String?> reverseGeocode(LatLng position) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/reverse'
        '?lat=${position.latitude}'
        '&lon=${position.longitude}'
        '&format=json'
        '&addressdetails=1'
        '&zoom=18', // Zoom level chi tiết mức đường phố
      );

      final response = await http.get(
        url,
        headers: {
            'User-Agent': 'CarNavigationApp/1.0',
            'Accept-Language': 'vi-VN,vi;q=0.9',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // Trả về tên hiển thị đầy đủ
        return result['display_name'] ?? 'Vị trí không xác định';
      }
      
      return null;
    } catch (e) {
      print('Reverse geocode error: $e');
      return null;
    }
  }
}

/// Model cho kết quả tìm kiếm (Đặt ngoài class Service để global usage)
class SearchResult {
  final String displayName;
  final double lat;
  final double lon;
  final String type;
  final double importance;

  SearchResult({
    required this.displayName,
    required this.lat,
    required this.lon,
    required this.type,
    required this.importance,
  });

  LatLng get position => LatLng(lat, lon);
}