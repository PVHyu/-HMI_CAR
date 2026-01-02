import 'package:flutter/material.dart';
import 'package:hmi/features/phone/models/enums.dart';
import 'viewmodel/home_view_model.dart';
import 'package:hmi/features/home/views/widgets/home_header.dart';
import 'package:hmi/features/home/views/widgets/home_dashboard.dart';
import 'package:hmi/features/home/views/widgets/climate_bar.dart';

class HomePage extends StatefulWidget {
  final void Function(HmiPage page)? onNavigate;
  const HomePage({super.key, this.onNavigate});
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
                HomeHeader(
                  timeText: s.timeText,
                  dateText: s.dateText,
                  isLoggedIn: s.isLoggedIn,
                  userName: s.userName,
                  userAvatar: s.userAvatar,
                  isBluetoothOn: s.isBluetoothOn,
                  onTapAvatar: () async {
                    // View xử lý dialog, xong gọi VM (tránh context trong VM)
                    if (s.isLoggedIn) {
                      final ok = await _showLogoutConfirm(context, s.userName);
                      if (!mounted) return;
                      if (ok == true) _vm.logout();
                    } else {
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

Future<bool?> _showLogoutConfirm(BuildContext context, String name) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title:
          Text("Đăng xuất $name?", style: const TextStyle(color: Colors.white)),
      content: const Text("Bạn muốn thoát tài khoản khỏi xe?",
          style: TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Huỷ")),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text("Đăng xuất",
              style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    ),
  );
}

// Trả về (userName, avatarUrl)
Future<(String, String)?> _showFakeLogin(BuildContext context) async {
  // bạn giữ dialog như cũ, chỉ đổi: sau await phải mounted check.
  // để ngắn, mình chỉ trả về mock:
  return ("Nguyễn Thị Tâm", "https://i.pravatar.cc/150?img=9");
}
