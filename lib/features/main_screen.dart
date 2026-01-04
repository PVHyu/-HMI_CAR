import 'package:flutter/material.dart';
import 'package:hmi/features/phone/models/enums.dart';
import 'package:hmi/features/phone/viewmodels/main_viewmodel.dart';
import 'package:hmi/features/home/home_page.dart';
import 'package:hmi/features/phone/views/phone_page.dart';
import 'package:hmi/features/media/media_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel _viewModel = MainViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }


void _showVolumeControl(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Không che nội dung
      builder: (context) {
        double currentVol = 0.5;

        return Stack(
          children: [
            Positioned(
              left: 100, // Vị trí ngay cạnh Sidebar
              bottom: 30, // Cách đáy 30px
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setStateVol) {
                    return Container(
                      width: 70,  // <--- Thu hẹp chiều ngang
                      height: 320, // <--- Kéo dài chiều cao
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(35), // Bo tròn giống hình viên thuốc
                        border: Border.all(color: Colors.white24),
                        boxShadow: const [
                           BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5))
                        ]
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column( // <--- Dùng Column để xếp dọc
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 1. Số % (Đặt trên cùng cho dễ nhìn)
                          Text(
                            "${(currentVol * 100).toInt()}",
                            style: const TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold, 
                                fontSize: 18
                            ),
                          ),
                          
                          // 2. Nút Cộng (+)
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () => setStateVol(() => currentVol = (currentVol + 0.1).clamp(0.0, 1.0)),
                          ),

                          // 3. Thanh trượt dọc
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: 3, // <--- Xoay -90 độ để dựng đứng thanh trượt
                              child: Slider(
                                value: currentVol,
                                min: 0.0,
                                max: 1.0,
                                activeColor: Colors.blueAccent,
                                inactiveColor: Colors.grey[800],
                                onChanged: (v) => setStateVol(() => currentVol = v),
                              ),
                            ),
                          ),

                          // 4. Nút Trừ (-)
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.grey),
                            onPressed: () => setStateVol(() => currentVol = (currentVol - 0.1).clamp(0.0, 1.0)),
                          ),

                          // Icon loa nhỏ dưới cùng trang trí
                          const Icon(Icons.volume_up, size: 20, color: Colors.white54),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // 1. Dùng Stack để xếp chồng các lớp
    return Stack(
      children: [
        // --- LỚP 1: ẢNH NỀN (Nằm dưới cùng) ---
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // Đã sửa đuôi file thành .jpeg cho đúng với máy bạn
              image: AssetImage("assets/images/starry_sky.jpeg"), 
              fit: BoxFit.cover, 
            ),
          ),
        ),

        // --- LỚP 2: GIAO DIỆN CHÍNH (Nằm đè lên trên) ---
        // Scaffold phải nằm TRONG danh sách children của Stack (sau Container)
        Scaffold(
          backgroundColor: Colors.transparent, // Trong suốt để nhìn thấy nền
          
          body: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return Row(
                children: [
                  _sideMenu(), // Menu bên trái
                  
                  Expanded(
                    child: Container(
                      // Màu nền nội dung pha loãng
                      color:  Color(0xFF0B0F19).withOpacity(0), 
                      child: _buildPage(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ], // <--- Ngoặc đóng của danh sách children nằm ở tận đây mới đúng
    );
  }

  // ===== SIDEBAR =====
  Widget _sideMenu() {
    return Container(
      width: 90,
      color: Colors.black, 
      padding: const EdgeInsets.symmetric(vertical: 30), // Cách lề trên dưới 30px
      child: Column(
      children: [
  const SizedBox(height: 60),
  _menuButton(Icons.directions_car, HmiPage.vehicle),
  const SizedBox(height: 80), // Khoảng cách cố định giữa các nút

   _menuButton(Icons.phone, HmiPage.phone),
  const SizedBox(height: 80),

 _menuButton(Icons.home, HmiPage.home),
  const SizedBox(height: 80),
 _menuButton(Icons.movie, HmiPage.media),

  // Widget này sẽ đẩy mọi thứ bên dưới xuống đáy
  const Spacer(), 
  IconButton(
  iconSize: 32,
  icon: const Icon(Icons.volume_up, color: Colors.grey),
  onPressed: () {
  _showVolumeControl(context); // Gọi hàm hiện popup
  },
  ),
   ],
  ),
   );
 }


  Widget _menuButton(IconData icon, HmiPage page) {
    final active = _viewModel.currentPage == page;
    return IconButton(
      iconSize: 32,
      color: active ? Colors.white : Colors.grey[700],
      onPressed: () => _viewModel.changePage(page),
      icon: Icon(icon),
    );
  }

  // ===== PAGE SWITCH =====
  Widget _buildPage() {
    switch (_viewModel.currentPage) {
      case HmiPage.home:
        return HomePage(onNavigate: (page) => _viewModel.changePage(page));

      case HmiPage.phone:
        return const PhonePage();
      case HmiPage.media:
        return const MediaPage();
      case HmiPage.vehicle:
        return const Center(child: Text("Màn hình Xe", style: TextStyle(color: Colors.white)));
      
      case HmiPage.settings:
        return const Center(child: Text("Cài đặt Âm thanh", style: TextStyle(color: Colors.white)));
    }
  }
}
