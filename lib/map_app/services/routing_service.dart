import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route.dart';

class RoutingService {
  // Sử dụng HTTPS để tránh lỗi bảo mật trên Android/iOS
  static const String _osrmBaseUrl = 'https://router.project-osrm.org';
  
  static Future<RouteModel?> calculateRoute({
    required LatLng origin,
    required LatLng destination,
    bool alternatives = false,
    bool steps = true,
  }) async {
    try {
      // Build OSRM URL
      // Lưu ý: Server OSRM miễn phí công cộng có giới hạn request.
      // Nếu app thực tế, nên tự host OSRM hoặc dùng Google Maps/Mapbox API.
      final url = Uri.parse(
        '$_osrmBaseUrl/route/v1/driving/'
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?alternatives=$alternatives'
        '&steps=$steps'
        '&geometries=geojson'
        '&overview=full'
        '&annotations=false', // Tắt annotations để response nhẹ hơn
      );

      print('🔍 Requesting route from OSRM...');

      final response = await http.get(url).timeout(
        const Duration(seconds: 5), // Giảm timeout xuống 5s để fallback nhanh hơn
        onTimeout: () {
          throw Exception('OSRM request timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['code'] == 'Ok' && data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          return _parseOSRMRoute(data['routes'][0], origin, destination);
        } else {
          print('❌ OSRM Error Code: ${data['code']}');
          // Fallback
          return RouteModel.calculateSimpleRoute(origin, destination);
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        // Fallback
        return RouteModel.calculateSimpleRoute(origin, destination);
      }
    } catch (e) {
      print('⚠️ Routing Service Error: $e');
      print('🔄 Switching to Offline Routing (Simple Mode)');
      
      // Fallback: Sử dụng thuật toán local nếu mất mạng hoặc API lỗi
      return RouteModel.calculateSimpleRoute(origin, destination);
    }
  }

  /// Parse OSRM response thành RouteModel
  static RouteModel _parseOSRMRoute(
    Map<String, dynamic> route,
    LatLng origin,
    LatLng destination,
  ) {
    // Extract waypoints từ geometry
    final geometry = route['geometry']['coordinates'] as List;
    
    // Sử dụng 'num' sau đó toDouble() để an toàn hơn khi parse JSON
    final waypoints = geometry.map<LatLng>((coord) {
      final lat = (coord[1] as num).toDouble();
      final lng = (coord[0] as num).toDouble();
      return LatLng(lat, lng);
    }).toList();

    // Distance (meters) và duration (seconds)
    final distance = (route['distance'] as num).toDouble();
    final duration = (route['duration'] as num).toInt();

    print('✅ OSRM Route found:');
    print('   Distance: ${(distance / 1000).toStringAsFixed(2)} km');
    print('   Duration: ${(duration / 60).toStringAsFixed(0)} min');

    return RouteModel(
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      distanceInMeters: distance,
      durationInSeconds: duration,
      routeName: 'Đường đi tối ưu',
    );
  }
}