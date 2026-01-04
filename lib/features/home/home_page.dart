import 'package:flutter/material.dart';
import 'package:hmi/features/phone/models/enums.dart';
// Import ViewModel của Phone (Nếu bạn chưa tạo file này ở bài trước thì tạm thời comment dòng này lại)
import 'package:hmi/features/phone/viewmodels/phone_viewmodel.dart'; 
import 'viewmodel/home_view_model.dart';
import 'package:hmi/features/home/views/widgets/home_header.dart';
import 'package:hmi/features/home/views/widgets/home_dashboard.dart';
import 'package:hmi/features/home/views/widgets/climate_bar.dart';

class HomePage extends StatefulWidget {
  final void Function(HmiPage page)? onNavigate;
  final PhoneViewModel? phoneViewModel; // Biến dùng để đồng bộ Phone

  const HomePage({
    super.key, 
    this.onNavigate, 
    this.phoneViewModel
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel _vm = HomeViewModel();

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  // --- HÀM 1: HIỂN THỊ ĐĂNG NHẬP (MỚI) ---
  // Đã đưa vào trong class để tránh lỗi scope
  Future<(String, String)?> _showFakeLogin(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return showDialog<(String, String)>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Text("G", style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(width: 15),
            const Text("Đăng nhập Google", style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Đăng nhập để đồng bộ danh bạ và nhạc của bạn.",
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email hoặc SĐT",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black38,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black38,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text("Huỷ", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx, ("Nguyễn Thị Tâm", "https://i.pravatar.cc/150?img=9"));
            },
            child: const Text("Đăng nhập"),
          ),
        ],
      ),
    );
  }

  // --- HÀM 2: HIỂN THỊ XÁC NHẬN ĐĂNG XUẤT ---
  Future<bool?> _showLogoutConfirm(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Đăng xuất $name?", style: const TextStyle(color: Colors.white)),
        content: const Text("Bạn muốn thoát tài khoản khỏi xe?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Huỷ")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        final s = _vm.state;

        return Opacity(
          opacity: 0.3 + (s.brightness * 0.7),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
            child: Column(
              children: [
                // Header (Đã cập nhật để dùng layout mới)
                HomeHeader(
                  timeText: s.timeText,
                  dateText: s.dateText,
                  isLoggedIn: s.isLoggedIn,
                  userName: s.userName,
                  userAvatar: s.userAvatar,
                  isBluetoothOn: s.isBluetoothOn,
                  onTapAvatar: () async {
                    if (s.isLoggedIn) {
                      // Gọi hàm trong class, không bị lỗi undefined nữa
                      final ok = await _showLogoutConfirm(context, s.userName);
                      if (!mounted) return;
                      if (ok == true) _vm.logout();
                    } else {
                      // Gọi hàm Login mới
                      final result = await _showFakeLogin(context);
                      if (!mounted) return;
                      if (result != null) {
                        _vm.loginMock(
                          userName: result.$1,
                          avatarUrl: result.$2,
                        );
                      }
                    }
                  },
                  onToggleBluetooth: _vm.toggleBluetooth,
                ),
                
                const SizedBox(height: 25),
                
                Expanded(
                  child: HomeDashboard(
                    onGoPhone: () => widget.onNavigate?.call(HmiPage.phone),
                    onGoMedia: () => widget.onNavigate?.call(HmiPage.media),
                    // Truyền ViewModel Phone xuống (nếu có)
                    phoneViewModel: widget.phoneViewModel, 
                  ),
                ),
                
                const SizedBox(height: 25),
                
                ClimateBar(
                  temperature: "27",
                  humidity: "82",
                  windSpeed: "15",
                  rainChance: "40",
                  brightness: s.brightness,
                  acTemp: s.acTemp,
                  onBrightnessChanged: _vm.setBrightness,
                  onAcTempChanged: _vm.setAcTemp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}