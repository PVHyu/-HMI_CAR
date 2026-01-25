import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/location.dart';
import '../models/route.dart';
import '../services/routing_service.dart';
import '../services/address_search_service.dart';
import '../widgets/map_widget.dart';
import '../widgets/navigation_controls.dart' as nav;
import '../widgets/keyboard.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Controllers
  final MapController _mapController = MapController();
  
  // Constants (FPT Complex Đà Nẵng)
  static const LatLng _fptComplex = LatLng(15.9785431, 108.2620534);
  
  // State
  LatLng _currentPosition = _fptComplex;
  LocationModel? _startLocation;
  LocationModel? _destination;
  RouteModel? _currentRoute;
  
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  
  // UI State
  bool _showKeyboard = false;
  bool _isSearching = false;
  bool _isShowingRoute = false;
  bool _showStartInput = false; // Hiện ô "Vị trí hiện tại" khi bấm chỉ đường
  
  // Search state
  String _startSearchText = '';
  String _destSearchText = '';
  bool _isEditingStart = false;
  bool _isEditingDest = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    _markers.add(
      MarkerBuilders.buildCurrentLocationMarker(_currentPosition)
    );
    setState(() {});
  }

  // --- KEYBOARD HANDLERS ---
  void _onKeyPress(String key) {
    setState(() {
      if (_isEditingStart) {
        _startSearchText += key;
      } else if (_isEditingDest) {
        _destSearchText += key;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isEditingStart && _startSearchText.isNotEmpty) {
        _startSearchText = _startSearchText.substring(0, _startSearchText.length - 1);
      } else if (_isEditingDest && _destSearchText.isNotEmpty) {
        _destSearchText = _destSearchText.substring(0, _destSearchText.length - 1);
      }
    });
  }

  void _onSpace() {
    setState(() {
      if (_isEditingStart) {
        _startSearchText += ' ';
      } else if (_isEditingDest) {
        _destSearchText += ' ';
      }
    });
  }

  void _onEnter() {
    if (_isEditingStart) {
      _searchStartLocation();
    } else if (_isEditingDest) {
      _searchDestination();
    }
  }

  void _onCloseKeyboard() {
    setState(() {
      _showKeyboard = false;
      _isEditingStart = false;
      _isEditingDest = false;
    });
  }

  // --- SEARCH LOGIC ---

  Future<void> _searchDestination() async {
    final query = _destSearchText.trim();
    if (query.isEmpty) return;

    setState(() {
      _showKeyboard = false;
      _isSearching = true;
      _isEditingDest = false;
    });

    try {
      final location = await _performSearch(query);
      
      if (location != null) {
        _setDestination(location);
      } else {
        _showNoResultDialog('điểm đến');
      }
    } catch (e) {
      print('❌ Search error: $e');
      _showErrorDialog();
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _setDestination(LocationModel location) {
    setState(() {
      _destination = location;
      _destSearchText = location.name;
      _isShowingRoute = false;
      
      // Remove old destination marker
      _markers.removeWhere((m) => m.point != _currentPosition);
      
      // Clear old route
      _polylines.clear();
      _currentRoute = null;
      
      // Add new destination marker
      _markers.add(
        MarkerBuilders.buildDestinationMarker(
          location.position,
          location.name,
        ),
      );
    });

    _mapController.move(location.position, 14);
    print('✅ Destination set: ${location.name}');
  }

  Future<void> _startNavigation() async {
    if (_destination == null) return;

    // Hiện ô nhập vị trí hiện tại
    setState(() {
      _showStartInput = true;
      _startSearchText = 'Vị trí hiện tại';
    });
    
    // Tự động tính đường từ vị trí hiện tại
    await _searchStartLocation();
  }

  Future<void> _searchStartLocation() async {
    final query = _startSearchText.trim();
    
    // Nếu để mặc định "Vị trí hiện tại" thì dùng FPT
    if (query.isEmpty || query == 'Vị trí hiện tại') {
      setState(() {
        _startLocation = LocationModel(
          id: 'current',
          name: 'FPT Complex',
          position: _fptComplex,
          category: 'Current',
        );
        _currentPosition = _fptComplex;
        _startSearchText = 'FPT Complex';
      });
      
      // Cập nhật marker hiện tại
      _updateCurrentLocationMarker(_fptComplex);
      await _calculateAndShowRoute();
      return;
    }

    setState(() {
      _showKeyboard = false;
      _isSearching = true;
      _isEditingStart = false;
    });

    try {
      final location = await _performSearch(query);
      
      if (location != null) {
        setState(() {
          _startLocation = location;
          _currentPosition = location.position;
          _startSearchText = location.name;
        });
        
        _updateCurrentLocationMarker(location.position);
        await _calculateAndShowRoute();
      } else {
        _showNoResultDialog('điểm xuất phát');
      }
    } catch (e) {
      print('❌ Search error: $e');
      _showErrorDialog();
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _updateCurrentLocationMarker(LatLng position) {
    setState(() {
      // Xóa marker cũ (thường là marker đầu tiên hoặc marker màu xanh)
      // Ở đây ta xóa hết và add lại cho chắc chắn, hoặc lọc theo key
      _markers.removeWhere((m) => m.key == const Key('current_location'));
      
      _markers.insert(0, 
        MarkerBuilders.buildCurrentLocationMarker(position)
      );
    });
  }

  Future<void> _calculateAndShowRoute() async {
    if (_destination == null) return;

    setState(() => _isSearching = true);

    try {
      await _calculateRoute();
      
      Future.delayed(const Duration(milliseconds: 500), () {
        _fitBounds();
      });
      
      setState(() => _isShowingRoute = true);
      
      print('🧭 Navigation started from ${_startLocation?.name ?? "FPT"} to ${_destination!.name}');
    } catch (e) {
      print('❌ Navigation error: $e');
      _showErrorDialog();
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<LocationModel?> _performSearch(String query) async {
    // 1. Tìm trong database local trước (Ưu tiên)
    final localLocation = LocationModel.searchByName(query);
    if (localLocation != null) {
      return localLocation;
    }

    // 2. Nếu không thấy thì tìm online (OpenStreetMap)
    print('🔍 Searching address online: $query');
    try {
        final latLng = await AddressSearchService.searchAddress(query);

        if (latLng != null) {
          return LocationModel(
            id: 'search_${DateTime.now().millisecondsSinceEpoch}',
            name: query,
            position: latLng,
            description: 'Kết quả tìm kiếm Online',
            category: 'Search',
          );
        }
    } catch (e) {
        print("Address service error: $e");
    }

    return null;
  }

  Future<void> _calculateRoute() async {
    if (_destination == null) return;

    try {
      // Thử dùng service online trước
      final route = await RoutingService.calculateRoute(
        origin: _currentPosition,
        destination: _destination!.position,
        steps: true,
        alternatives: false,
      );

      if (route != null) {
        setState(() {
          _currentRoute = route;
          _polylines.clear();
          _polylines.add(
            PolylineBuilders.buildRoutePolyline(route.waypoints)
          );
        });
      } else {
        // Fallback: Dùng thuật toán offline (Local)
        _calculateSimpleRoute();
      }
    } catch (e) {
      print('❌ Routing error: $e');
      _calculateSimpleRoute();
    }
  }

  void _calculateSimpleRoute() {
    if (_destination == null) return;

    final route = RouteModel.calculateSimpleRoute(
      _currentPosition,
      _destination!.position,
    );

    setState(() {
      _currentRoute = route;
      _polylines.clear();
      _polylines.add(
        PolylineBuilders.buildRoutePolyline(route.waypoints)
      );
    });
  }

  void _fitBounds() {
    if (_destination == null) return;

    final bounds = LatLngBounds(
      _currentPosition,
      _destination!.position,
    );
    
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(100),
      ),
    );
  }

  void _swapLocations() {
    if (_destination == null || !_showStartInput) return;

    setState(() {
      final tempLocation = _startLocation;
      final tempPosition = _currentPosition;
      final tempText = _startSearchText;
      
      // Swap data
      _startLocation = _destination;
      _currentPosition = _destination!.position;
      _startSearchText = _destSearchText;
      
      _destination = tempLocation ?? LocationModel(
        id: 'temp',
        name: tempText,
        position: tempPosition,
        category: 'Temp',
      );
      _destSearchText = tempText;
      
      // Update markers
      _markers.clear();
      _markers.add(MarkerBuilders.buildCurrentLocationMarker(_currentPosition));
      _markers.add(MarkerBuilders.buildDestinationMarker(_destination!.position, _destination!.name));
      
      // Recalculate route
      if (_isShowingRoute) {
        _calculateRoute();
      }
    });
  }
  
  void _clearAll() {
    setState(() {
      _destination = null;
      _currentRoute = null;
      _destSearchText = '';
      _startSearchText = '';
      _isShowingRoute = false;
      _showStartInput = false;
      _currentPosition = _fptComplex;
      _startLocation = null;
      
      _markers.clear();
      _markers.add(
        MarkerBuilders.buildCurrentLocationMarker(_fptComplex)
      );
      _polylines.clear();
    });
    
    _mapController.move(_fptComplex, 13);
  }

  void _recenterMap() {
    _mapController.move(_currentPosition, 14);
  }

  // --- DIALOGS ---

  void _showNoResultDialog(String locationType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('❌ Không tìm thấy', style: TextStyle(color: Colors.white)),
        content: Text(
          'Không tìm thấy $locationType.\nVui lòng thử lại với địa chỉ khác.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuggestionsDialog();
            },
            child: const Text('Xem gợi ý'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text('⚠️ Lỗi', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Có lỗi xảy ra. Vui lòng kiểm tra kết nối internet.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuggestionsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    '📍 Địa điểm gợi ý',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 1),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: LocationModel.daNangLocations.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[800], height: 1),
                  itemBuilder: (context, index) {
                    final location = LocationModel.daNangLocations[index];
                    return ListTile(
                      leading: Icon(_getCategoryIcon(location.category ?? ''), color: Colors.blue),
                      title: Text(location.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(location.description ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      onTap: () {
                        Navigator.pop(context);
                        if (_isEditingStart) {
                          setState(() => _startSearchText = location.name);
                          _searchStartLocation();
                        } else {
                          setState(() => _destSearchText = location.name);
                          _setDestination(location);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Landmark': return Icons.account_balance;
      case 'Nature': return Icons.terrain;
      case 'Shopping': return Icons.shopping_cart;
      case 'Transport': return Icons.flight;
      case 'Office': return Icons.business;
      case 'Education': return Icons.school; // Đã thêm icon Education
      default: return Icons.location_on;
    }
  }

  // --- UI BUILD ---
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. MAP WIDGET
          MapWidget(
            mapController: _mapController,
            center: _fptComplex,
            zoom: 13,
            markers: _markers,
            polylines: _polylines,
          ),

          // 2. SEARCH BAR(S)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: _showStartInput ? _buildDualSearchBar() : _buildSingleSearchBar(),
          ),

          // 3. INFO PANELS
          if (_destination != null && !_isShowingRoute && !_showStartInput)
            Positioned(
              top: 90,
              left: 20,
              right: 20,
              child: _buildDestinationInfo(),
            ),

          if (_currentRoute != null && _destination != null && _isShowingRoute)
            Positioned(
              top: _showStartInput ? 160 : 90,
              left: 20,
              right: 20,
              child: _buildRouteInfo(),
            ),

          // 4. NAVIGATION CONTROLS
          Positioned(
            bottom: _showKeyboard ? 320 : 30,
            left: 20,
            right: 20,
            child: Center(
              child: nav.NavigationControls(
                onRecenter: _recenterMap,
                onStartNavigation: _showStartInput ? _searchStartLocation : _startNavigation,
                hasRoute: _destination != null,
              ),
            ),
          ),

          // 5. KEYBOARD
          if (_showKeyboard)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              // Giả sử widget Keyboard của bạn tên là Keyboard (hoặc VirtualKeyboardExtended như code cũ)
              child: VirtualKeyboardExtended( 
                onKeyPress: _onKeyPress,
                onBackspace: _onBackspace,
                onSpace: _onSpace,
                onEnter: _onEnter,
                onClose: _onCloseKeyboard,
              ),
            ),

          // 6. LOADING
          if (_isSearching)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.blue),
                    const SizedBox(height: 15),
                    Text(
                      _isShowingRoute ? 'Đang tính đường đi...' : 'Đang tìm kiếm...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  // --- SUB WIDGETS ---
  
  Widget _buildSingleSearchBar() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showKeyboard = true;
          _isEditingDest = true;
          _isEditingStart = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _destSearchText.isEmpty ? 'Tìm kiếm điểm đến...' : _destSearchText,
                style: TextStyle(color: _destSearchText.isEmpty ? Colors.grey : Colors.black, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_destSearchText.isNotEmpty)
              GestureDetector(onTap: _clearAll, child: const Icon(Icons.clear, color: Colors.grey)),
            const SizedBox(width: 5),
            GestureDetector(onTap: _showSuggestionsDialog, child: const Icon(Icons.help_outline, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDualSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          // Start Input
          GestureDetector(
            onTap: () {
               setState(() {
                 _showKeyboard = true;
                 _isEditingStart = true;
                 _isEditingDest = false;
                 if (_startSearchText == 'Vị trí hiện tại') _startSearchText = '';
               });
            },
            child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
               decoration: BoxDecoration(
                 color: _isEditingStart ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                 borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
               ),
               child: Row(
                 children: [
                   const Icon(Icons.my_location, color: Colors.blue, size: 20),
                   const SizedBox(width: 10),
                   Expanded(
                     child: Text(
                       _startSearchText.isEmpty ? 'Vị trí hiện tại' : _startSearchText,
                       style: TextStyle(color: _startSearchText.isEmpty ? Colors.grey : Colors.black),
                     ),
                   ),
                 ],
               ),
            ),
          ),
          const Divider(height: 1),
          // Dest Input
           GestureDetector(
            onTap: () {
               setState(() {
                 _showKeyboard = true;
                 _isEditingDest = true;
                 _isEditingStart = false;
               });
            },
            child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
               decoration: BoxDecoration(
                 color: _isEditingDest ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                 borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
               ),
               child: Row(
                 children: [
                   const Icon(Icons.location_on, color: Colors.red, size: 20),
                   const SizedBox(width: 10),
                   Expanded(
                     child: Text(
                       _destSearchText,
                       style: const TextStyle(color: Colors.black),
                     ),
                   ),
                   GestureDetector(onTap: _clearAll, child: const Icon(Icons.clear, size: 20)),
                 ],
               ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF34A853).withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(_destination!.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF4285F4).withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.navigation, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_destination!.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('${_currentRoute!.formattedDistance} • ${_currentRoute!.formattedDuration}', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HELPER CLASSES (Bổ sung để tránh lỗi)
// ==========================================

class MarkerBuilders {
  static Marker buildCurrentLocationMarker(LatLng point) {
    return Marker(
      key: const Key('current_location'),
      point: point,
      width: 40,
      height: 40,
      // SỬA: Dùng 'child' thay vì 'builder'
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.navigation, color: Colors.blue, size: 28),
        ),
      ),
    );
  }

  static Marker buildDestinationMarker(LatLng point, String name) {
    return Marker(
      key: const Key('destination'),
      point: point,
      width: 40,
      height: 40,
      // SỬA: Dùng 'child' thay vì 'builder'
      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
    );
  }
}
class PolylineBuilders {
  static Polyline buildRoutePolyline(List<LatLng> points) {
    return Polyline(
      points: points,
      strokeWidth: 5.0,
      color: Colors.blueAccent,
      borderColor: Colors.blue[800]!,
      borderStrokeWidth: 2.0,
    );
  }
}