import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
class MapWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final Function(LatLng)? onTap;

  const MapWidget({
    Key? key,
    required this.mapController,
    required this.center,
    this.zoom = 13,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        minZoom: 5, 
        maxZoom: 18,
        // Cập nhật cho flutter_map v6+: Sử dụng interactionOptions
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        onTap: (tapPosition, point) {
          if (onTap != null) {
            onTap!(point);
          }
        },
      ),
      children: [
        // 1. Tile Layer - OpenStreetMap
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.hmi', // Thay bằng package name thật của app
          
          // Tối ưu bộ nhớ và hiệu năng
          maxZoom: 19,
          tileProvider: NetworkTileProvider(),
          keepBuffer: 2, // Giữ 2 hàng gạch xung quanh vùng nhìn thấy
          panBuffer: 1,  // Load trước khi kéo
        ),
        
        // 2. Polylines Layer (Route)
        if (polylines.isNotEmpty)
          PolylineLayer(
            polylines: polylines,
          ),
        
        // 3. Markers Layer
        if (markers.isNotEmpty)
          MarkerLayer(
            markers: markers,
          ),
      ],
    );
  }
}

// ==========================================
// HELPER CLASSES (Dùng chung cho MapScreen)
// ==========================================

class MarkerBuilders {
  // Marker vị trí hiện tại (Hình tròn xanh có viền trắng và bóng đổ)
  static Marker buildCurrentLocationMarker(LatLng position) {
    return Marker(
      key: const Key('current_location'),
      point: position,
      width: 50,
      height: 50,
      // flutter_map v6+ dùng 'child', v5 dùng 'builder'
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.navigation,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  // Marker điểm đến (Pin đỏ truyền thống)
  static Marker buildDestinationMarker(LatLng position, String label) {
    return Marker(
      key: const Key('destination'),
      point: position,
      width: 50,
      height: 50,
      // Căn chỉnh để mũi nhọn của pin nằm đúng vị trí tọa độ
      alignment: Alignment.topCenter, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 24,
            ),
          ),
          // Mũi nhọn giả lập (Tam giác nhỏ)
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: Colors.red,
              width: 10,
              height: 8,
            ),
          ),
        ],
      ),
    );
  }

  // Marker tùy chỉnh (Dùng cho các địa điểm tìm kiếm được)
  static Marker buildCustomMarker(
    LatLng position,
    IconData icon,
    Color color,
  ) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class PolylineBuilders {
  // Đường đi chính (Màu xanh Google Maps)
  static Polyline buildRoutePolyline(List<LatLng> points) {
    return Polyline(
      points: points,
      color: const Color(0xFF4285F4), 
      strokeWidth: 6.0,
      borderColor: Colors.white,
      borderStrokeWidth: 3.0, // Viền trắng giúp đường nổi bật trên nền bản đồ
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );
  }

  // Đường phụ (Màu xám)
  static Polyline buildAlternativeRoutePolyline(List<LatLng> points) {
    return Polyline(
      points: points,
      color: Colors.grey,
      strokeWidth: 5.0,
      borderColor: Colors.white,
      borderStrokeWidth: 2.0,
    );
  }
}

// Clipper để vẽ hình tam giác nhỏ dưới marker
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}