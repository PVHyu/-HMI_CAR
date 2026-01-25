import 'package:latlong2/latlong.dart';

class RouteModel {
  final LatLng origin;
  final LatLng destination;
  final List<LatLng> waypoints;
  final double distanceInMeters;
  final int durationInSeconds;
  final String routeName;

  RouteModel({
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.distanceInMeters,
    required this.durationInSeconds,
    this.routeName = 'Route',
  });

  // Format distance (VD: 500 m hoặc 2.5 km)
  String get formattedDistance {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  // Format duration (VD: 1 giờ 30 phút hoặc 15 phút)
  String get formattedDuration {
    final hours = durationInSeconds ~/ 3600;
    final minutes = (durationInSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours giờ $minutes phút';
    } else {
      // Nếu dưới 1 phút thì làm tròn lên 1 phút cho UX tốt hơn
      return '${minutes < 1 ? 1 : minutes} phút';
    }
  }

  // --- MOCK LOGIC: GIẢ LẬP TÍNH TOÁN ĐƯỜNG ĐI ---
  
  // Tính toán route giả lập (Do chưa có API thật)
  // Sử dụng thuật toán tạo điểm trung gian để vẽ đường gấp khúc (giả lập đường phố)
  static RouteModel calculateSimpleRoute(LatLng origin, LatLng destination) {
    const distance = Distance();
    final double straightDistance = distance.as(LengthUnit.Meter, origin, destination);

    // Tính toán đường đi thực tế (giả định dài hơn đường chim bay ~40%)
    final realDistanceInMeters = straightDistance * 1.4;

    // Giả sử tốc độ trung bình 40 km/h trong thành phố
    // 40 km/h = 40000 m / 3600 s ≈ 11.11 m/s
    final speedMetersPerSecond = 40000 / 3600; 
    final durationInSeconds = (realDistanceInMeters / speedMetersPerSecond).round();

    // Tạo waypoints mô phỏng đường đi theo lưới (Ziczac) thay vì đường thẳng
    final waypoints = _generateRealisticWaypoints(origin, destination);

    return RouteModel(
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      distanceInMeters: realDistanceInMeters,
      durationInSeconds: durationInSeconds,
    );
  }

  static List<LatLng> _generateRealisticWaypoints(LatLng start, LatLng end) {
    final List<LatLng> waypoints = [start];
    const int steps = 10; // Tăng số bước để đường mượt hơn một chút

    final double latDiff = end.latitude - start.latitude;
    final double lngDiff = end.longitude - start.longitude;

    for (int i = 1; i <= steps; i++) {
      final double t = i / steps;

      // Giả lập đi theo đường vuông góc (Manhattan-like movement)
      if (i.isOdd) {
        // Di chuyển theo kinh độ (Ngang)
        waypoints.add(LatLng(
          start.latitude + latDiff * (t - 0.1), // Giữ vĩ độ cũ một chút
          start.longitude + lngDiff * t,
        ));
      } else {
        // Di chuyển theo vĩ độ (Dọc)
        waypoints.add(LatLng(
          start.latitude + latDiff * t,
          start.longitude + lngDiff * (t - 0.1), // Giữ kinh độ cũ một chút
        ));
      }
    }

    waypoints.add(end);

    // Làm mượt các góc nhọn
    return _smoothWaypoints(waypoints);
  }

  // Thuật toán làm mịn đường (Smoothing) đơn giản
  static List<LatLng> _smoothWaypoints(List<LatLng> points) {
    if (points.length < 3) return points;

    final List<LatLng> smoothed = [points.first];

    for (int i = 1; i < points.length - 1; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final next = points[i + 1];

      // Tạo 2 điểm trung gian để bo tròn góc
      // Điểm 1: Giữa prev và curr
      smoothed.add(LatLng(
        (prev.latitude + curr.latitude) / 2,
        (prev.longitude + curr.longitude) / 2,
      ));
      
      // Điểm 2: Chính là curr (hoặc bỏ qua để cắt góc)
      smoothed.add(curr); 

      // Điểm 3: Giữa curr và next
       smoothed.add(LatLng(
        (curr.latitude + next.latitude) / 2,
        (curr.longitude + next.longitude) / 2,
      ));
    }

    smoothed.add(points.last);
    return smoothed;
  }
}