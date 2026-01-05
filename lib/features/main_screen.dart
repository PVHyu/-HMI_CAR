import 'package:flutter/material.dart';
import 'package:hmi/features/phone/models/enums.dart';
import 'package:hmi/features/phone/viewmodels/main_viewmodel.dart';
import 'package:hmi/features/home/home_page.dart';
import 'package:hmi/features/phone/views/phone_page.dart';
import 'package:hmi/features/media/media_page.dart';
import 'package:hmi/features/home/views/widgets/volume_popup.dart'; 

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

  // ĐÃ XÓA HÀM _showVolumeControl VÌ ĐÃ TÁCH RA FILE RIÊNG

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // --- LỚP 1: ẢNH NỀN ---
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/starry_sky.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // --- LỚP 2: GIAO DIỆN CHÍNH ---
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return Row(
                children: [
                  _sideMenu(), // Menu bên trái
                  Expanded(
                    child: Container(
                      color: const Color(0xFF0B0F19).withOpacity(0),
                      child: _buildPage(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ===== SIDEBAR =====
  Widget _sideMenu() {
    return Container(
      width: 90,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const SizedBox(height: 60),
          _menuButton(Icons.directions_car, HmiPage.vehicle),
          const SizedBox(height: 80),
          _menuButton(Icons.phone, HmiPage.phone),
          const SizedBox(height: 80),
          _menuButton(Icons.home, HmiPage.home),
          const SizedBox(height: 80),
          _menuButton(Icons.movie, HmiPage.media),

          const Spacer(),
          
          // NÚT VOLUME
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.volume_up, color: Colors.grey),
            onPressed: () {
              showVolumeControl(context); 
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
    }
  }
}