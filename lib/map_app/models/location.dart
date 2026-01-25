import 'package:latlong2/latlong.dart';

class LocationModel {
  final String id;
  final String name;
  final LatLng position;
  final String? description;
  final String? category;

  LocationModel({
    required this.id,
    required this.name,
    required this.position,
    this.description,
    this.category,
  });

  // Database địa điểm Đà Nẵng (Đã bổ sung đầy đủ hơn)
  static final List<LocationModel> daNangLocations = [
    // --- Office / Education ---
    LocationModel(
      id: 'fpt_complex',
      name: 'FPT Complex',
      position: LatLng(15.9785431, 108.2620534),
      description: 'Tổ hợp FPT Đà Nẵng - Khu đô thị FPT City',
      category: 'Office',
    ),
    LocationModel(
      id: 'dut',
      name: 'Đại học Bách Khoa Đà Nẵng',
      position: LatLng(16.0738, 108.1499),
      description: '54 Nguyễn Lương Bằng, Liên Chiểu',
      category: 'Education',
    ),
    LocationModel(
      id: 'software_park',
      name: 'Công viên Phần mềm Đà Nẵng',
      position: LatLng(16.0798, 108.2196),
      description: '2 Quang Trung, Hải Châu',
      category: 'Office',
    ),

    // --- Landmarks / Bridges ---
    LocationModel(
      id: 'dragon_bridge',
      name: 'Cầu Rồng',
      position: LatLng(16.0608, 108.2279),
      description: 'Cầu biểu tượng phun lửa và nước',
      category: 'Landmark',
    ),
    LocationModel(
      id: 'han_bridge',
      name: 'Cầu Sông Hàn',
      position: LatLng(16.0722, 108.2245),
      description: 'Cầu quay đầu tiên của Việt Nam',
      category: 'Landmark',
    ),
    LocationModel(
      id: 'tran_thi_ly',
      name: 'Cầu Trần Thị Lý',
      position: LatLng(16.0505, 108.2372),
      description: 'Cầu dây văng hình cánh buồm',
      category: 'Landmark',
    ),

    // --- Nature / Tourism ---
    LocationModel(
      id: 'marble_mountains',
      name: 'Ngũ Hành Sơn',
      position: LatLng(16.0013, 108.2625),
      description: 'Quần thể núi đá vôi và hang động',
      category: 'Nature',
    ),
    LocationModel(
      id: 'son_tra',
      name: 'Bán đảo Sơn Trà',
      position: LatLng(16.1050, 108.2703),
      description: 'Khu bảo tồn thiên nhiên',
      category: 'Nature',
    ),
    LocationModel(
      id: 'my_khe',
      name: 'Biển Mỹ Khê',
      position: LatLng(16.0601, 108.2466),
      description: 'Một trong những bãi biển đẹp nhất hành tinh',
      category: 'Nature',
    ),
    LocationModel(
      id: 'linh_ung',
      name: 'Chùa Linh Ứng',
      position: LatLng(16.1061, 108.2770),
      description: 'Tượng Phật Quan Âm cao nhất Việt Nam',
      category: 'Temple',
    ),

    // --- Shopping / Markets ---
    LocationModel(
      id: 'han_market',
      name: 'Chợ Hàn',
      position: LatLng(16.0683, 108.2228),
      description: 'Chợ truyền thống lớn nhất Đà Nẵng',
      category: 'Shopping',
    ),
    LocationModel(
      id: 'con_market',
      name: 'Chợ Cồn',
      position: LatLng(16.0678, 108.2140),
      description: 'Thiên đường ẩm thực đường phố',
      category: 'Shopping',
    ),

    // --- Transport ---
    LocationModel(
      id: 'airport',
      name: 'Sân bay Đà Nẵng',
      position: LatLng(16.0439, 108.1994),
      description: 'Sân bay quốc tế Đà Nẵng',
      category: 'Transport',
    ),
  ];

  /// Hàm tìm kiếm địa điểm theo tên (Hỗ trợ tiếng Việt không dấu)
  static LocationModel? searchByName(String query) {
    if (query.isEmpty) return null;

    // Hàm chuẩn hóa chuỗi: chuyển về chữ thường và bỏ dấu
    String normalize(String str) {
      const withDia = 'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệóòỏõọôốồổỗộơớờởỡợíìỉĩịúùủũụưứừửữựýỳỷỹỵđ';
      const withoutDia = 'aaaaaaaaaaaaaaaaeeeeeeeeeeeooooooooooooooooiiiiiuuuuuuuuuuuyyyyyd';
      
      str = str.toLowerCase().trim();
      for (int i = 0; i < withDia.length; i++) {
        str = str.replaceAll(withDia[i], withoutDia[i]);
      }
      return str;
    }

    final normalizedQuery = normalize(query);

    try {
      // Tìm kiếm tương đối (contains)
      return daNangLocations.firstWhere((location) {
        final normalizedName = normalize(location.name);
        return normalizedName.contains(normalizedQuery);
      });
    } catch (e) {
      return null;
    }
  }

  /// Lọc địa điểm theo danh mục
  static List<LocationModel> getByCategory(String category) {
    return daNangLocations
        .where((loc) => loc.category == category)
        .toList();
  }
}